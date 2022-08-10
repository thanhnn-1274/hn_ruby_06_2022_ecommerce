require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
  end

  describe "validates" do
    context "when field name" do
      subject{FactoryBot.build(:category)}
      it {should validate_presence_of(:name)}
      it {should validate_length_of(:name).is_at_most(Settings.max_name_length)}
      it {should validate_uniqueness_of(:name).case_insensitive}
    end
  end

  describe "scope" do
    let(:category){FactoryBot.create :category}
    let!(:category1){FactoryBot.create :category, name: "B"}
    let!(:category2){FactoryBot.create :category, name: "C"}
    let!(:category3){FactoryBot.create :category, name: "A"}

    it "category asc name" do
      expect(Category.asc_category_name).to eq([category3, category1, category2])
    end

    it "latest category" do
      expect(Category.latest_category).to eq([category3, category2, category1])
    end
  end
end
