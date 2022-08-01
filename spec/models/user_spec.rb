require "rails_helper"

RSpec.describe User, type: :model do
  describe "enum for role" do
    it {should define_enum_for(:role).with_values(admin: 0, customer: 1)}
  end

  describe "associations" do
    it {should have_many(:orders).dependent(:destroy)}
    it {should have_many(:comments).dependent(:destroy)}
  end

  describe "validates" do
    context "validate presence" do
      it {should validate_presence_of :email}
      it {should validate_presence_of :name}
      it {should validate_presence_of :password}
    end

    context "validate length of name" do
      it {should validate_length_of(:name).is_at_least(Settings.user.name_validates.name_min_length).is_at_most(Settings.user.name_validates.name_max_length)}
    end

    context "validate length of password" do
      it {should validate_length_of(:password).is_at_least(Settings.user.password_validates.password_min_length)}
    end

    context "validate length of address" do
      it {should validate_length_of(:address).is_at_least(Settings.user.address_min_length).is_at_most(Settings.user.address_max_length)}
    end

    context "validate length of phone" do
      it {should validate_length_of(:phone_num).is_at_least(Settings.user.min_phone).is_at_most(Settings.user.max_phone)}
    end

    context "validate unique of email" do
      let!(:user_email1) {FactoryBot.create :user, email: "email1@gmail.com"}
      let!(:user_email2) {FactoryBot.build :user, email: "email1@gmail.com"}
      it { (user_email2.valid?).should eq false }
    end

    context "when email format" do
      it {should allow_value("omgod234@gmail.com").for(:email)}
    end

    context "when email wrong format" do
      it {should_not allow_value("asdasdsa").for(:email)}
    end
  end

  describe "scope" do
    let!(:user1) {FactoryBot.create :user, name: "Tien", role: 0}
    let!(:user2) {FactoryBot.create :user, name: "Dien", phone_num: "0987365423"}
    let!(:user3) {FactoryBot.create :user, name: "Nguyen"}

    it "check scope user asc name" do
      User.asc_name.should eq([user2, user3, user1])
    end

    it "check scope user get all" do
      User.get_all.should eq([user2, user3])
    end

    it "check scope search by name" do
      User.search_by_name("Ti").should eq([user1])
    end

    it "check scope search wrong name" do
      User.search_by_name("Tisdaasdasd").should eq([])
    end

    it "check scope search by phone_num" do
      User.search_by_name("098").should eq([user2])
    end

    it "check scope search wrong phone_num" do
      User.search_by_name("09812").should eq([])
    end
  end

  describe "downcase email" do
    let!(:user_email) {FactoryBot.create :user, email: "DAN123@gmail.com"}
    it "check before save downcase email" do
      user_email.email.should eq("dan123@gmail.com")
    end
  end
end
