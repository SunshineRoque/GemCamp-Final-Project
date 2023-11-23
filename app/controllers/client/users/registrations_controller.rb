class Client::Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_client_user!
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :save_promoter_cookie, only: [:new]

  def new
    super
  end

  def edit
    @user = current_client_user
  end

  def create
    super do |resource|
      # Assign the value of the promoter cookie to parent_id

      promoter = User.find_by_email(cookies[:promoter])

      if promoter
        resource.parent = promoter
        resource.save
      end
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :parent_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :username, :image])
  end

  private

  def save_promoter_cookie
    if params[:promoter].present?
      cookies[:promoter] = params[:promoter]
    end
  end

end
