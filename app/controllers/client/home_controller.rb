class Client::HomeController < ApplicationController
  def index
    @user = current_client_user
    @banners = Banner.where("online_at <= ? AND offline_at > ? AND status = ?", Time.current, Time.current, 'active')
    @news_tickers = NewsTicker.where("status = ?",'active').limit(5)
    @winners = Winner.where(state: 'published').order(created_at: :desc).limit(5)
    @items = Item.where("status = ? AND state = ?",'active', 'starting').order(created_at: :desc).limit(8)
  end
end
