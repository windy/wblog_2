module TemplateHelper
  def safe_render(partial_name, locals = {})
    content = render(partial_name, locals)
    content.respond_to?(:force_encoding) ? content.force_encoding('UTF-8') : content
  end
end
