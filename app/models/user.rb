class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  enum role: { client: 0, admin: 1 }
  mount_uploader :image, ImageUploader
  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  belongs_to :member_level, optional: true
  has_many :users, class_name: 'User', foreign_key: 'parent_id'
  has_many :addresses
  has_many :tickets
  has_many :winners
  has_many :orders
  has_many :news_tickers
  before_create :set_member_level_id
  validate :validate_address_limit, on: :create
  after_create :increment_parent_children_members
  # after_create :update_member_level_if_required
  #
  # def update_member_level_if_required
  #   return unless member_level.level == 'basic'
  #   basic_1_level = MemberLevel.find_by(level: :basic_1)
  #
  #   if basic_1_level.present?
  #     if children_members >= basic_1_level.required_members
  #       update_columns(member_level_id: basic_1_level.id, coins: coins + basic_1_level.coins)
  #       end
  #   end
  # end
  #

  private

  def validate_address_limit
    errors.add(:base, 'Exceeded maximum address limit') if addresses.count >= 5
  end

  def increment_parent_children_members
    if parent
      parent.increment!(:children_members)
    end
  end

  def set_member_level_id
    default_member_level = MemberLevel.find_by(id: 1)
    self.member_level_id = default_member_level.id
  end
end
