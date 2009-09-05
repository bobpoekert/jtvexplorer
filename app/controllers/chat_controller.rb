require 'multipart'

class ChatController < ApplicationController
  before_filter :default_serialization_method
  before_filter :check_for_oauth

  def send_message
    if request.method == :post
      @query = "/chat/send_message.#{@serialization_method}"
      @result = justintv_oauth_post(@query, "message" => params[:message])
    end
  end
end