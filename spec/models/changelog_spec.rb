require 'rails_helper'

RSpec.describe Changelog, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:content) }
  end

  describe ".markdown_to_html" do
    it "converts markdown to HTML" do
      markdown = "* Item 1\n* Item 2"
      html = Changelog.markdown_to_html(markdown)
      expect(html).to include("<li>Item 1</li>")
      expect(html).to include("<li>Item 2</li>")
    end
  end
end
