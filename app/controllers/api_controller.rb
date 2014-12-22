class ApiController < ApplicationController
  before_filter :token_auth
  respond_to :json

  def products
    respond_with Product.all
  end

  def check_in
    user = ApiKey.get_user(@token)
    product_item = ProductItem.check_in(params[:code],user.id)
    product_item.save! #TODO: check
    respond_with product_item
  end

  def check_out

  end

  private

  def token_auth
    restrict_access || render_unauthorized
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      @token = token
      ApiKey.exists?(access_token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end
end
