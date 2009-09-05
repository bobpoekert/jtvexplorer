require 'multipart'

class StreamController < ApplicationController
  before_filter :default_serialization_method

  def list
    p = { "offset" => params[:offset], "limit" => params[:limit] }.to_params

    if request.method == :post
      if (params[:login] != "") # view just the channel?
        @query = "/stream/list.#{@serialization_method}?channel=#{params[:login]}"
      elsif (params[:category] == "(ALL)") # all?
        @query = "/stream/list.#{@serialization_method}?#{p}"
      else # a specific category
        @query = "/stream/list.#{@serialization_method}?category=#{params[:category]}&#{p}"
      end
      @result = justintv_get(@query)
    end
  end
end