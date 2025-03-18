class ArchivesController < ApplicationController
  def index
    # 获取所有标签供过滤使用
    @labels = Label.all

    # 初始化查询对象
    query = Post.order(created_at: :desc)

    # 处理标题搜索
    if (@q = params[:q]).present?
      query = query.where('title like ?', "%#{@q}%")
      @q_size = query.size
    end

    # 处理时间过滤
    @time_filter = params[:time_filter]
    if @time_filter.present?
      case @time_filter
      when '1m'
        query = query.where('created_at >= ?', 1.month.ago)
      when '3m'
        query = query.where('created_at >= ?', 3.months.ago)
      when '3y'
        query = query.where('created_at >= ?', 3.years.ago)
      end
    end

    # 处理标签过滤
    @selected_label_ids = params[:label_ids]
    if @selected_label_ids.present? && !@selected_label_ids.empty?
      label_ids = [*@selected_label_ids].reject(&:blank?)
      if label_ids.any?
        # 使用关联查询，通过join筛选具有指定标签的文章
        query = query.joins(:labels).where(labels: { id: label_ids }).distinct
      end
    end

    # 分页查询结果
    @posts = query.page(params[:page])
  end
end