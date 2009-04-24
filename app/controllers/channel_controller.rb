require 'multipart'

class ChannelController < ApplicationController
  before_filter :check_for_oauth, :only => [ :update ]
  before_filter :default_serialization_method
  
  def show
    if request.method == :post
      @query = "/channel/show/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
  
  def update
    if request.method == :post
      @query = "/channel/update.#{@serialization_method}"
      params[:channel].delete_if {|k,v| v.blank? }

      if params[:picture].blank?
        @result = justintv_oauth_post(@query, params[:channel])
      else
        # format the picture data
        data, headers = Multipart::Post.prepare_query params[:channel].merge(:picture => params[:picture])
        @result = justintv_oauth_post(@query, data, headers)
      end
    end
  end
  
  def fans
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/channel/fans/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)
    end
  end
  
  def clips
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/channel/clips/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)
    end
  end
  
  def archives
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/channel/archives/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)      
    end
  end

  def events
    if request.method == :post
      p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params
      @query = "/channel/events/#{params[:login]}.#{@serialization_method}?#{p}"
      @result = justintv_get(@query)      
    end
  end
  
  def embed
    if request.method == :post
      p = { }
      p[:volume] = params[:volume] unless params[:volume].blank?
      p[:height] = params[:height] unless params[:height].blank?
      p[:width] = params[:width] unless params[:width].blank?

      @query = "/channel/embed/#{params[:login]}.#{@serialization_method}?#{p.to_params}"
      @result = justintv_get(@query)      
    end
  end
end