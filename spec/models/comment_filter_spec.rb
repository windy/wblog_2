require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'sensitive words filtering' do
    # 在测试前设置敏感词列表
    before(:each) do
      stub_const("SENSITIVE_WORDS", ["test_word", "bad_word", "offensive"])
    end

    # 测试包含敏感词的评论会被正确过滤
    it "filters comments containing sensitive words" do
      comment = build(:comment, content: "This comment contains a test_word that should be filtered")
      comment.save
      expect(comment.content).to eq("This comment contains a ** that should be filtered")
    end

    # 测试不包含敏感词的评论内容保持不变
    it "doesn't change comments without sensitive words" do
      original_content = "This is a normal comment without any sensitive content"
      comment = build(:comment, content: original_content)
      comment.save
      expect(comment.content).to eq(original_content)
    end

    # 测试大小写不同的敏感词也能被正确过滤
    it "filters sensitive words regardless of case" do
      comment = build(:comment, content: "This contains TEST_WORD and Bad_Word with different cases")
      comment.save
      expect(comment.content).to eq("This contains ** and ** with different cases")
    end

    # 测试包含多个敏感词的评论能全部被过滤
    it "filters multiple sensitive words in a single comment" do
      comment = build(:comment, content: "This comment has test_word and bad_word and offensive words")
      comment.save
      expect(comment.content).to eq("This comment has ** and ** and ** words")
    end

    # 测试敏感词位于评论开头或结尾的情况
    it "filters sensitive words at the beginning or end of comment" do
      comment = build(:comment, content: "test_word is at the beginning and the end is bad_word")
      comment.save
      expect(comment.content).to eq("** is at the beginning and the end is **")
    end

    # 测试敏感词列表为空的情况
    it "doesn't change content when sensitive word list is empty" do
      stub_const("SENSITIVE_WORDS", [])
      original_content = "This content contains test_word which is no longer a sensitive word"
      comment = build(:comment, content: original_content)
      comment.save
      expect(comment.content).to eq(original_content)
    end

    # 测试敏感词被包含在其他单词中的情况
    it "doesn't filter when sensitive word is part of another word" do
      stub_const("SENSITIVE_WORDS", ["bad"])
      comment = build(:comment, content: "This word 'badge' should not be filtered")
      comment.save
      # "bad" 是 "badge" 的一部分，但我们期望正则表达式仅匹配完整单词
      expect(comment.content).to eq("This word 'badge' should not be filtered")
    end
  end
end