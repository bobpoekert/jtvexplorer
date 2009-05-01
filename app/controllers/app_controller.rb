class AppController < ApplicationController
  before_filter :default_serialization_method
  
  def rate_limit_status
    if request.method == :post
      @query = "/application/rate_limit_status.#{@serialization_method}"
      if params[:check_type] == "app"
        @result = justintv_oauth_two_legged_get(@query)
      else
        @result = justintv_get(@query)
      end
    end
  end
  
end