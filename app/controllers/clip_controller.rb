require 'multipart'

class ClipController < ApplicationController
  before_filter :check_for_oauth, :only => [ :create, :update, :destroy ]
  before_filter :default_serialization_method
  
  def show
    if request.method == :post
      @query = "/clip/show/#{params[:id]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end

  def create
    if request.method == :post
      @query = "/clip/create.#{@serialization_method}"
      params[:clip].delete_if {|k,v| v.blank? }

      @result = justintv_oauth_post(@query, params[:clip])
    end
  end
  
  def update
    if request.method == :post
      @query = "/clip/update/#{params[:id]}.#{@serialization_method}"
      params[:clip].delete_if {|k,v| v.blank? }
            
      @result = justintv_oauth_post(@query, params[:clip])
    end
  end
  
  def destroy
    if request.method == :post
      @query = "/clip/destroy/#{params[:id]}.#{@serialization_method}"
      @result = justintv_oauth_post(@query, { })
    end
  end
  
  def embed
    if request.method == :post
      p = { }
      p[:volume] = params[:volume] unless params[:volume].blank?
      p[:height] = params[:height] unless params[:height].blank?
      p[:width] = params[:width] unless params[:width].blank?

      @query = "/clip/embed/#{params[:id]}.#{@serialization_method}?#{p.to_params}"
      @result = justintv_get(@query)      
    end
  end

end
