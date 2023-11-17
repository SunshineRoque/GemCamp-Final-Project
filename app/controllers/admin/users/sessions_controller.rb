# frozen_string_literal: true

class Admin::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :check_user_role, only: [:create]

  private

  def check_user_role
    user = User.find_by(email: params[:admin_user][:email])

    if user && user.admin? && user.valid_password?(params[:admin_user][:password])
      # Use Devise's sign_in method to sign in the user
      sign_in(user, scope: :user)
    else
      flash[:alert] = "Invalid email, password, or you are not an admin."
      redirect_to new_admin_user_session_path
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    admin_root_path # Change this to the desired path
  end
end
