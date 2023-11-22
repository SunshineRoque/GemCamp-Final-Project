class Order < ApplicationRecord
  validates :coin, presence: true, if: :deposit_genre?
  validates :amount, presence: true, if: :deposit_genre?
  validates :amount, numericality: { greater_than: 0 }, if: -> { deposit_genre? && amount.present? }
  validates :offer, presence: true, if: :deposit_genre?
  belongs_to :offer, optional: true
  belongs_to :user
  after_create :generate_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :paid, to: :cancelled, guard: :enough_coins?, after: :paid_to_cancelled
      transitions from: [:pending, :submitted], to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :submitted_to_paid
    end
  end

  private

  def deposit_genre?
    genre == 'deposit'
  end

  def generate_serial_number
    number_count = format('%04d', user.orders.count + 1)
    date_prefix = Time.current.strftime('%y%m%d')
    update(serial_number: "#{date_prefix}-#{id}-#{user_id}-#{number_count}")
  end

  def increase_user_coins
    return unless user
    user.update(coins: user.coins + coin)
  end

  def decrease_user_coins
    return unless user
    user.update(coins: user.coins - coin)
  end

  def increase_user_total_deposit
    return unless user
    user.update(total_deposit: user.total_deposit + amount)
  end

  def decrease_user_total_deposit
    return unless user
    user.update(total_deposit: user.total_deposit - amount)
  end

  def enough_coins?
    user = User.find_by(id: user_id)
    return true if user&.coin >= coin
    errors.add(:base, 'User does not have enough coins.')
    false
  end

  def submitted_to_paid
    if genre != 'deduct'
      increase_user_coins
    else
      decrease_user_coins
    end

    if genre == 'deposit'
      increase_user_total_deposit
    end
  end

  def paid_to_cancelled
    if genre != 'deduct'
      decrease_user_coins_with_guard
    else
      increase_user_coins
    end

    if genre == 'deposit'
      decrease_user_total_deposit
    end
  end

end
