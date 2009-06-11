require 'multipart'

class ChatController < ApplicationController
  #before_filter :check_for_oauth, :only => []
  before_filter :default_serialization_method

  def rooms
	if request.method == :post
      @query = "/chat/rooms/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
    
  def chatters
	if request.method == :post
      @query = "/chat/chatters/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end


  def bans
	if request.method == :post
      @query = "/chat/bans/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
  
  def status
	if request.method == :post
      @query = "/chat/status/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
  
  def moderators
	if request.method == :post
      @query = "/chat/moderators/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
  
  def global_stats
	if request.method == :post
      @query = "/chat/global_stats/#{params[:login]}.#{@serialization_method}"
      @result = justintv_get(@query)
    end
  end
end