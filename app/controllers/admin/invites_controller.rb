class Admin::InvitesController < ApplicationController
  before_action :authenticate_admin_user!
  def index
    @admin_user = current_admin_user
    @user_with_parents = User.where(role: 'client')
                   .where.not(parent_id: nil)
                   .joins(:parent)
                   .includes(:parent)
    if params[:search].present?
      @user_with_parents = @user_with_parents.joins("JOIN users parents ON parents.id = users.parent_id").where("parents.email LIKE :search", search: "%#{params[:search]}%")
    end

    @user_with_parents = @user_with_parents.page(params[:page]).per(6)
  end
end
