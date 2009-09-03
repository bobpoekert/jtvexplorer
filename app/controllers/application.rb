# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'net/http'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8129a5e29649e4c3519e4f21122b749a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def justintv_get(path)
    @req_method = 'GET'
    Net::HTTP.start(API_HOST, API_PORT) { |http|
      http.get("#{API_PATH}#{path}")
    }
  end
  
  def justintv_oauth_get(path)
    @req_method = 'GET'
    get_conn.get("#{API_PATH}#{@query}")
  end
  
  def justintv_oauth_two_legged_get(path)
    @req_method = 'GET'
    get_conn(false).post("#{API_PATH}#{@query}")
  end
  
  def justintv_oauth_post(path, post_params, headers={})
    @req_method = 'POST'
    get_conn.post("#{API_PATH}#{@query}", post_params, headers)
  end
  
  def justintv_oauth_two_legged_post(path, post_params, headers={})
    @req_method = 'POST'
    get_conn(false).post("#{API_PATH}#{@query}", post_params, headers)
  end
  
  private
  
  def check_for_oauth
    unless session[:oauth_token] and session[:oauth_secret]
      @request_token = JTV_CONSUMER.get_request_token
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
      @oauth = false
    else
      logger.info "oauth token: #{session[:oauth_token]}"
      logger.info "oauth secret: #{session[:oauth_secret]}"
      @oauth = true
    end
    true
  end
  
  def get_conn(use_oauth_tokens=true)
    if use_oauth_tokens
      OAuth::AccessToken.new JTV_CONSUMER, session[:oauth_token], session[:oauth_secret]
    else
      OAuth::AccessToken.new JTV_CONSUMER
    end
  end
  
  def default_serialization_method
    @serialization_method = params[:serialization_method] || "xml"
  end
end
