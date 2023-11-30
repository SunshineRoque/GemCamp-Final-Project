class Admin::MemberLevelsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @member_levels = MemberLevel.all.page(params[:page]).per(8)
  end

  def new
    @member_level = MemberLevel.new
  end


  def create
    @member_level = MemberLevel.new(member_level_params)

    if @member_level.coins.to_i > 0 && @member_level.required_members.to_i > 0
      if @member_level.save
        flash[:notice] = t('member_level_created_successfully')
        redirect_to admin_member_levels_path
      else
        flash.now[:alert] = t('member_level_create_failed')
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = t('the_number')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @member_level.update(member_level_params)
      flash[:notice] = t('member_level_updated_successfully')
      redirect_to admin_member_levels_path
    else
      flash.now[:alert] = t('member_level_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @member_level.destroy
      @member_level.destroy
      flash[:notice] = t('member_level_destroyed_successfully')
    else
      flash[:alert] = t('cant_delete')
    end
    redirect_to admin_member_levels_path
  end

  private

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end

  def member_level_params
    params.require(:member_level).permit(
      :level,
      :required_members,
      :coins)
  end
end
