require 'markdown'
class Changelog < ApplicationRecord
  validates :version, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  validates :released_at, presence: true

  scope :active, -> { where(active: true) }
  scope :by_release_date, -> { order(released_at: :desc) }

  def formatted_description
    self.class.render_html(description)
  end

  def self.render_html(content)
    rd = CodeHTML.new
    md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
    md.render(content)
  end
end
