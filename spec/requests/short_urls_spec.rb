require 'rails_helper'

RSpec.describe "ShortUrls", type: :request do
  before(:each) do
  	@original_url = "http://stackoverflow.com"
  	@is_custom_url = true
  	@short_uid = "sof"

  	@short_url = ShortUrl.create(
      original_url: @original_url,
      is_custom_url: @is_custom_url,
      short_uid: @short_uid
    )
  end
  
  describe "GET /generate_short_url" do
    it "Should redirect to original_url" do
      get "#{ENV['APP_PROTOCOL']}://#{ENV['SHORTENER_DOMAIN']}/#{@short_url.short_uid}"
	  assert_response :redirect
	  assert_redirected_to @short_url.original_url
    end
  end
end
