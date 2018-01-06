require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  before(:each) do
  	@original_url = "http://google.com"
  	@original_url2 = "http://twitter.com"
  	@original_url3 = "http://facebook.com"
  	@original_url4 = "http://linkedin.com"
  	@wrong_original_url = "google.com"
  	@short_uid = "twt"
  	@short_uid2 = "fb"
  	@short_uid3 = "li"
  	@is_custom_url = true
  end

  context "Create Default Url" do
  	before(:each) do
  	  @short_url = ShortUrl.create(
        original_url: @original_url
      )
    end

    it "Should create short default url" do
      expect(@short_url.errors.messages.size.should).to eq(0)
      expect(@short_url.short_uid).not_to eq(nil)
      expect(@short_url.is_custom_url).to eq(false)
    end

    it "Should not create default url with wrong url" do
      @short_url = ShortUrl.create(
        original_url: @wrong_original_url
      )
      expect(@short_url.errors.messages.size).to eq(1)
      expect(@short_url.errors.messages[:original_url]).to eq(["should start with http:// or https://"])
    end

    it "Should not create default url with same url" do
      @short_url = ShortUrl.create(
        original_url: @original_url
      )
      @existing_url = ShortUrl.where(original_url: @original_url, is_custom_url: false)
      expect(@short_url.errors.messages.size).to eq(1)
      expect(@short_url.errors.messages[:original_url]).to eq(["has been shorten before to: #{@existing_url.last.get_short_url}"])
    end
  end

  context "Create Custom Url" do
  	before(:each) do
  	  @short_url = ShortUrl.create(
        original_url: @original_url2,
        is_custom_url: @is_custom_url,
        short_uid: @short_uid
      )
  	end

    it "Should create short custom url" do
      expect(@short_url.errors.messages.size.should).to eq(0)
      expect(@short_url.original_url).to eq(@original_url2)
      expect(@short_url.short_uid).to eq(@short_uid)
      expect(@short_url.is_custom_url).to eq(@is_custom_url)
    end

    it "Should not create custom url with same short_uid" do
      @short_url = ShortUrl.create(
        original_url: @original_url3,
        is_custom_url: @is_custom_url,
        short_uid: @short_uid
      )
      expect(@short_url.errors.messages.size).to eq(1)
      expect(@short_url.errors.messages[:short_uid]).to eq(["has already been taken"])
    end

    it "Should create custom url with existing original_url" do
      @short_url = ShortUrl.create(
        original_url: @original_url2,
        is_custom_url: @is_custom_url,
        short_uid: @short_uid2
      )
      expect(@short_url.errors.messages.size).to eq(0)
      expect(@short_url.original_url).to eq(@original_url2)
      expect(@short_url.short_uid).to eq(@short_uid2)
      expect(@short_url.is_custom_url).to eq(@is_custom_url)
    end
  end

  context "Short Url" do
  	before(:each) do
  	  @short_url = ShortUrl.create(
        original_url: @original_url4,
        is_custom_url: @is_custom_url,
        short_uid: @short_uid3
      )
    end

    it "Should get shorten url" do
      @shorten_url = @short_url.get_short_url
      expect(@shorten_url).to eq("#{ENV["APP_PROTOCOL"]}://#{ENV["SHORTENER_DOMAIN"]}/li")
    end
  end
end
