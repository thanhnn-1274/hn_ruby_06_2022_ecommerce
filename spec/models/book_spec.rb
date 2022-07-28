require "rails_helper"

RSpec.describe Book, type: :model do
  describe "associations" do
    it {should have_many(:order_details).dependent(:nullify)}
    it {should have_many(:comments).dependent(:destroy)}
    it {should belong_to(:author)}
    it {should belong_to(:category).optional(:true)}
  end

  describe "validates" do
    context "when field name" do
      it {should validate_presence_of(:name)}
      it {should validate_length_of(:name).is_at_most(Settings.max_name_book_length)}
    end

    context "when field price" do
      it {should validate_presence_of(:price)}
      it do
        should validate_numericality_of(:price)
          .is_greater_than(Settings.min_book_price_length)
          .is_less_than(Settings.max_book_price_length)
      end
    end

    context "when field description" do
      it {should validate_presence_of(:description)}
      it {should validate_length_of(:description).is_at_most(Settings.max_description_length)}
    end

    context "when field page_num" do
      it {should validate_presence_of(:page_num)}
      it do
        should validate_numericality_of(:page_num)
          .is_greater_than_or_equal_to(Settings.min_page)
          .only_integer
      end
    end

    context "when field quantity" do
      it {should validate_presence_of(:quantity)}
      it do
        should validate_numericality_of(:quantity)
          .is_greater_than_or_equal_to(Settings.min_quantity)
          .only_integer
      end
    end
  end

  describe "scope" do
    let!(:book_1){FactoryBot.create :book, description: "12", name: "Con", view: 50, sold: 10, price: 10}
    let!(:book_2){FactoryBot.create :book, description: "12", name: "An", view: 20, sold: 30, price: 20}
    let!(:book_3){FactoryBot.create :book, description: "12", name: "Ba", view: 30, sold: 20, price: 30}

    it "view desc" do
      Book.view_desc.pluck(:id).should eq([book_1.id, book_3.id, book_2.id])
    end

    it "sort sold asc" do
      Book.sort_sold(:asc).pluck(:id).should eq([book_1.id, book_3.id, book_2.id])
    end

    it "sort sold desc" do
      Book.sort_sold(:desc).pluck(:id).should eq([book_2.id, book_3.id, book_1.id])
    end

    it "sort name" do
      Book.asc_name.pluck(:id).should eq([book_2.id, book_3.id, book_1.id])
    end

    it "sort_price asc" do
      Book.sort_price(:asc).pluck(:id).should eq([book_1.id, book_2.id, book_3.id])
    end

    it "sort_price desc" do
      Book.sort_price(:desc).pluck(:id).should eq([book_3.id, book_2.id, book_1.id])
    end

    it "latest book" do
      Book.latest_book.pluck(:id).should eq([book_3.id, book_2.id, book_1.id])
    end

    context "scope search_by_name"
      it "when search is empty" do
        Book.search_by_name_description("").pluck(:id).should eq(Book.all.pluck(:id))
      end
      it "when seach no match" do
        Book.search_by_name_description("@er@").pluck(:id).should eq([])
      end
      it "when search match" do
        Book.search_by_name_description("n").pluck(:id).count.should eq(2)
      end
    end

  describe "public instance methods" do
    let(:book){FactoryBot.create :book}

    describe "responds to its methods" do
      it {should respond_to :display_image}
      it {should respond_to :update_view}
    end

    describe "#display_image" do
      it "returns true" do
        book.image.attach(io: File.open("spec/fixtures/1.png"), filename: "1.png", content_type: "image/png")
        book.display_image
      end
    end

    describe "#update_view" do
      it "returns book view increment 1" do
        old_view = book.view
        book.update_view
        book.view.should eq(old_view+1)
      end
    end

  end
end
