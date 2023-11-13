class Client::InviteController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_client_user!

  def index
    @user = current_client_user
    qr_code = RQRCode::QRCode.new("client.com:3000/client/sign_up?promoter=#{current_client_user.email}") # Replace the URL with the content you want in the QR code

    @svg = qr_code.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 11,
      standalone: true
    )

  end
end

