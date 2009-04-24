require 'multipart'

class UserController < ApplicationController
  before_filter :check_for_oauth, :only => [ :update ]
  before_filter :default_serialization_method
  
  def show
    if request.method == :post
      @query = "/user/show/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
  
  def update
    if request.method == :post
      @query = "/user/update.#{@serialization_method}"
      params[:user].delete_if {|k,v| v.blank? }

      if params[:picture].blank?
        @result = justintv_oauth_post(@query, params[:user])
      else
        # format the picture data
        data, headers = Multipart::Post.prepare_query params[:user].merge(:picture => params[:picture])
        @result = justintv_oauth_post(@query, data, headers)
      end
    end
  end
  
  def friends
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/user/friends/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)
    end
  end
  
  def favorites
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/user/favorites/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)
    end
  end
  
  def events
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/user/events/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)      
    end
  end
end
