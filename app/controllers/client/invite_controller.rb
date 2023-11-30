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

    @member_level = MemberLevel.all
  end

  def update_member_level_basic_1
    @user = current_client_user
    basic_1_level = MemberLevel.find_by(level: :basic_1)
    if @user && basic_1_level.present?
      @user.member_level = basic_1_level
      @user.coins = @user.coins + basic_1_level.coins

      if @user.save
        flash[:notice] = t('claimed_reward')
      end
    end

    redirect_to client_invite_index_path
  end

  def update_member_level_standard
    @user = current_client_user
    standard_level = MemberLevel.find_by(level: :standard)
    if @user && standard_level.present?
      @user.member_level = standard_level
      @user.coins = @user.coins + standard_level.coins

      if @user.save
        flash[:notice] = t('claimed_reward')
      end
      redirect_to client_invite_index_path
    end
  end

  def update_member_level_premium
    @user = current_client_user
    premium_level = MemberLevel.find_by(level: :premium)
    if @user && premium_level.present?
      @user.member_level = premium_level
      @user.coins = @user.coins + premium_level.coins

      if @user.save
        flash[:notice] = t('claimed_reward')
      end
      redirect_to client_invite_index_path
    end
  end

  def update_member_level_silver
    @user = current_client_user
    silver_level = MemberLevel.find_by(level: :silver)
    if @user && silver_level.present?
      @user.member_level = silver_level
      @user.coins = @user.coins + silver_level.coins

      if @user.save
        flash[:notice] = t('claimed_reward')
      end
      redirect_to client_invite_index_path
    end
  end

  def update_member_level_gold
    @user = current_client_user
    gold_level = MemberLevel.find_by(level: :gold)
    if @user && gold_level.present?
      @user.member_level = gold_level
      @user.coins = @user.coins + gold_level.coins

      if @user.save
        flash[:notice] = t('claimed_reward')
      end
      redirect_to client_invite_index_path
    end
  end


end