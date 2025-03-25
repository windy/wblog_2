module ApplicationHelper
  # Generate `{controller}-{action}-page` class for body element
  def body_class
    path = controller_path.tr('/_', '-')
    action_name_map = {
      index: 'index',
      new: 'edit',
      edit: 'edit',
      update: 'edit',
      patch: 'edit',
      create: 'edit',
      destory: 'index'
    }
    mapped_action_name = action_name_map[action_name.to_sym] || action_name
    body_class_page =
      if controller.is_a?(HighVoltage::StaticPage) && params.key?(:id) && params[:id] !~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
        id_name = params[:id].tr('_', '-') + '-page'
        format('%s-%s', 'pages', id_name)
      else
        format('%s-%s-page', path, mapped_action_name)
      end

    body_class_page
  end

  # Admin active for helper
  def admin_active_for(controller_name, navbar_name)
    if controller_name.to_s == admin_root_path
      return controller_name.to_s == navbar_name.to_s ? "active" : ""
    end
    navbar_name.to_s.include?(controller_name.to_s) ? 'active' : ''
  end

  def current_path
    request.env['PATH_INFO']
  end

  def flash_class(level)
    case level
    when 'notice', 'success' then 'alert alert-success alert-dismissible'
    when 'info' then 'alert alert-info alert-dismissible'
    when 'warning' then 'alert alert-warning alert-dismissible'
    when 'alert', 'error' then 'alert alert-danger alert-dismissible'
    end
  end

  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M")
  end

  def format_date(time)
    time.strftime("%Y.%m.%d")
  end

  def search_highlight(title, q)
    return title if q.blank?

    title.sub(q, "<em>#{q}</em>")
  end
  
  # Returns the cover image for a post, or a default image if none is attached
  # @param post [Post] the post to get the cover image for
  # @param size [Symbol, Hash] optional variant size (e.g. :medium) or dimensions hash (e.g. { resize_to_limit: [300, 300] })
  # @return [ActiveStorage::Variant, String] the image path or variant
  def post_cover_image(post, size = nil)
    if post.cover_image.attached?
      if size.present?
        if size.is_a?(Symbol)
          # Predefined sizes
          case size
          when :small
            post.cover_image.variant(resize_to_limit: [300, 200])
          when :medium
            post.cover_image.variant(resize_to_limit: [600, 400])
          when :large
            post.cover_image.variant(resize_to_limit: [1200, 800])
          else
            post.cover_image
          end
        else
          # Custom variant options
          post.cover_image.variant(size)
        end
      else
        post.cover_image
      end
    else
      # Return default cover image
      'default_cover.jpg'
    end
  end
end