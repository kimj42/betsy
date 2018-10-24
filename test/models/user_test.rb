require "test_helper"

# t.string "name"
# t.string "username"
# t.string "email"
# t.boolean "merchant", default: false


describe User do
  describe 'validations' do
    before do
      @user = User.first
    end

    it "must have an email" do
      @user.must_be :valid?
    end

    it "does not accept data without an email" do
      @user.email = nil

      expect(@user.valid?).must_equal false
      expect ( @user.errors.messages ).must_include :email
    end
  end

  describe "relations" do
    before do
      @user = User.first
    end

    it "has many products" do
      expect(@user.products).must_respond_to :each
    end

    it "has many reviews" do
      puts @user.reviews
      expect(@user.reviews).must_respond_to :each
    end
  end
end
