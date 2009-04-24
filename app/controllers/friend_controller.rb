class FriendController < ApplicationController
  before_filter :check_for_oauth
  before_filter :default_serialization_method

  def create
    if request.method == :post
      @query = "/friend/create/#{params[:login]}.#{@serialization_method}"
      @result = justintv_oauth_post(@query, {})
    end
  end
  
  def destroy
    if request.method == :post
      @query = "/friend/destroy/#{params[:login]}.#{@serialization_method}"
      @result = justintv_oauth_post(@query, {})
    end
  end
end