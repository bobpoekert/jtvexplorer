class AccountController < ApplicationController
  before_filter :check_for_oauth, :only => [ :fme_config ]

  def fme_config
    if request.method == :post
      @query = "/account/fme_config.xml"
      response = justintv_oauth_get(@query)
      headers["Content-Type"] = response.content_type
      headers["Content-Disposition"] = "attachment; filename=my_config.xml"
    
      render :text => response.body, :layout => false
    end
  end
  
end