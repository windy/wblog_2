# 初始化敏感词过滤系统
# 加载配置文件并设置用于整个应用的敏感词列表

require 'yaml'

# 定义加载敏感词的方法
def load_sensitive_words
  config_file = Rails.root.join('config', 'ss.yml')
  
  begin
    if File.exist?(config_file)
      config = YAML.load_file(config_file)
      # 从配置中读取敏感词列表，如果不存在则使用空数组
      config['sensitive_words'] || []
    else
      Rails.logger.warn "敏感词配置文件不存在: #{config_file}"
      []
    end
  rescue => e
    Rails.logger.error "加载敏感词配置文件时出错: #{e.message}"
    []
  end
end

# 初始化全局变量存储敏感词列表
SENSITIVE_WORDS = load_sensitive_words

# 在开发环境中支持配置文件热更新
if Rails.env.development?
  ActiveSupport::Reloader.to_prepare do
    # 重新加载应用时刷新敏感词列表
    SENSITIVE_WORDS.replace(load_sensitive_words)
    Rails.logger.debug "敏感词列表已重新加载，当前包含 #{SENSITIVE_WORDS.size} 个词"
  end
end

Rails.logger.info "敏感词过滤系统已初始化，当前包含 #{SENSITIVE_WORDS.size} 个敏感词"