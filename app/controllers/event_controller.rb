class EventController < ApplicationController
  before_filter :check_for_oauth, :only => [ :update, :create, :destroy ]
  before_filter :default_serialization_method
  
  def show
    if request.method == :post
      @query = "/event/show/#{params[:id]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end

  def create
    if request.method == :post
      @query = "/event/create.#{@serialization_method}"
      params[:event].delete_if {|k,v| v.blank? }

      @result = justintv_oauth_post(@query, params[:event])
    end
  end
  
  def update
    if request.method == :post
      @query = "/event/update/#{params[:id]}.#{@serialization_method}"
      params[:event].delete_if {|k,v| v.blank? }
            
      @result = justintv_oauth_post(@query, params[:event])
    end
  end
  
  def destroy
    if request.method == :post
      @query = "/event/destroy/#{params[:id]}.#{@serialization_method}"
      @result = justintv_oauth_post(@query, { })
    end
  end
end