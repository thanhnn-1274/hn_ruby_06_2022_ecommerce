require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it {should belong_to(:user)}
    it {should belong_to(:book)}
  end

  describe "validates" do
    context "validate presence" do
      it {should validate_presence_of :content}
      it {should validate_presence_of :rate}
    end
    context "validate length of content" do
      it {should validate_length_of(:content).is_at_least(Settings.comment.content_min_length).is_at_most(Settings.comment.content_max_length)}
    end
  end

  describe "scope" do
    let!(:book){FactoryBot.create :book}
    let!(:comment1){FactoryBot.create :comment, book_id: book.id}
    let!(:comment2){FactoryBot.create :comment}

    context "comment by book id" do
      it { (Comment.by_book_id(book.id)).should eq ([comment1]) }
    end

    context "latest comment" do
      it { (Comment.latest_comment).should eq ([comment2, comment1]) }
    end
  end
end
