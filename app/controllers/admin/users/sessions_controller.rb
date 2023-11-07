# frozen_string_literal: true

class Admin::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :check_user_role, only: [:create]

  private

  def check_user_role
    user = User.find_by(email: params[:admin_user][:email])

    if user && user.admin?
      sign_in(user, scope: :user) # Manually sign in the user
    else
      flash[:alert] = "This login is only for admin."
      redirect_to new_admin_user_session_path
    end
  end
end
