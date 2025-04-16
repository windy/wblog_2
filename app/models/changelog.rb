class Changelog < ApplicationRecord
  validates :date, presence: true
  validates :category, presence: true
  validates :content, presence: true

  default_scope -> { order(date: :desc) }

  def self.markdown_to_html(content)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(content)
  end
end
