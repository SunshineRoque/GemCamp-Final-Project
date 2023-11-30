class MemberLevel < ApplicationRecord
  validates :level, presence: true, uniqueness: true
  validates :required_members, presence: true
  validates :coins, presence: true
  enum level: { basic: 0, basic_1: 1, standard: 2, premium: 3, silver: 4, gold: 5  }
  has_many :users, dependent: :restrict_with_error
end
