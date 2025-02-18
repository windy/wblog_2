class ChangesController < ApplicationController
  def index
    changelog_path = Rails.root.join('changelog.md')
    
    if File.exist?(changelog_path)
      markdown_content = File.read(changelog_path)
      markdown = Redcarpet::Markdown.new(
        CodeHTML.new(hard_wrap: true),
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true
      )
      @rendered_content = markdown.render(markdown_content)
    else
      @rendered_content = t('changelog.not_found')
    end
  end
end