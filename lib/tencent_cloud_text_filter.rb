require 'tencentcloud-sdk-tms'
require 'base64'

class TencentCloudTextFilter
  def initialize
    @secret_id = ENV['TENCENT_CLOUD_SECRET_ID']
    @secret_key = ENV['TENCENT_CLOUD_SECRET_KEY']
    
    if @secret_id.nil? || @secret_key.nil?
      Rails.logger.error("Tencent Cloud API credentials are not properly configured")
    end
  end

  def filter_text(text)
    return default_response(text) if text.nil? || text.empty?
    
    begin
      # 创建认证对象
      credential = TencentCloud::Common::Credential.new(@secret_id, @secret_key)
      
      # 配置HTTP选项
      http_profile = TencentCloud::Common::HttpProfile.new
      http_profile.endpoint = "tms.tencentcloudapi.com"
      
      # 配置客户端选项
      client_profile = TencentCloud::Common::ClientProfile.new
      client_profile.sign_method = "TC3-HMAC-SHA256"
      client_profile.http_profile = http_profile
      
      # 创建文本安全服务客户端
      client = TencentCloud::Tms::V20201229::Client.new(credential, "ap-guangzhou", client_profile)
      
      # 创建文本内容审核请求
      request = TencentCloud::Tms::V20201229::TextModerationRequest.new
      request.Content = Base64.strict_encode64(text)
      
      # 发送请求并获取响应
      response = client.TextModeration(request)
      
      # 处理响应结果
      return process_response(text, response)
      
    rescue StandardError => e
      Rails.logger.error("Tencent Cloud Text Moderation API error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n")) if Rails.env.development?
      return default_response(text)
    end
  end
  
  private
  
  def process_response(original_text, response)
    # 获取审核建议和敏感词列表
    suggestion = response.Suggestion
    keywords = response.Keywords || []
    
    # 如果需要审核或阻止，说明包含敏感词
    if suggestion == "Block" || suggestion == "Review"
      filtered_content = original_text.dup
      sensitive_word_count = 0
      # 处理每个敏感词
      keywords.each do |keyword|
        if keyword.is_a?(String) && !keyword.empty?
          # 将敏感词替换为等长的星号
          filtered_content = filtered_content.gsub(/#{Regexp.escape(keyword)}/, '*' * keyword.length)
          sensitive_word_count += 1
        end
      end
      
      # 返回过滤结果
      return {
        filtered_content: filtered_content,
        has_sensitive_words: true,
        sensitive_word_count: sensitive_word_count
      }
    else
      # 文本内容正常，无需过滤
      return default_response(original_text)
    end
  end
  
  def default_response(text)
    {
      filtered_content: text,
      has_sensitive_words: false,
      sensitive_word_count: 0
    }
  end
end