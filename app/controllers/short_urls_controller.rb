class ShortUrlsController < ApplicationController

  def new
  	@short_url = ShortUrl.new
  end

  def create
    @short_url = ShortUrl.new(short_url_params)
    if @short_url.save
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Your short url successfully generated" }
        format.js
      end
    else
      flash[:warning] = "Failed to generate short url"
      flash[:error] = @short_url.errors.full_messages
      redirect_to root_path
    end
  end

  def generate_short_url
    @short_url = ShortUrl.find_by(short_uid: params[:short_uid])
    if @short_url
      redirect_to @short_url.original_url
    else
     raise NoMethodError.new("undefined web app route")
   end
  end

  private

  def short_url_params
  	params.require(:short_url).permit(:original_url, :short_uid, :is_custom_url)
  end
end
