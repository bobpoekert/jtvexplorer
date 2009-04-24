class OauthController < ApplicationController
  def authorize
    request_token = OAuth::RequestToken.new(JTV_CONSUMER, session[:request_token], session[:request_token_secret])
    @access_token = request_token.get_access_token
    session[:oauth_token] = @access_token.token
    session[:oauth_secret] = @access_token.secret
    
    flash[:notice] = "You are now logged in via OAuth to Justin.tv"
    
    redirect_to "/"
  end
end