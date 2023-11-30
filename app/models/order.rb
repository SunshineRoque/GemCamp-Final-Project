class Order < ApplicationRecord
  validates :coin, presence: true
  validates :remarks, presence: true,  if: -> { deposit? && member_level? }
  validates :amount, presence: true, if: :deposit?
  validates :amount, numericality: { greater_than: 0 }, if: -> { deposit? && amount.present? }
  validates :offer, presence: true, if: :deposit?
  belongs_to :offer, optional: true
  belongs_to :user
  after_create :generate_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :paid, to: :cancelled, guard: :enough_coins_to_cancel_increase?, after: :paid_to_cancelled
      transitions from: [:pending, :submitted], to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :enough_coins_to_deduct?, after: :submitted_to_paid
    end
  end

  private

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

  def enough_coins_to_cancel_increase?
    return true if deduct? || (user&.coins.to_i >= coin)

    errors.add(:base, 'User does not have enough coins.')
    false
  end

  def enough_coins_to_deduct?
    return true if !deduct? || (deduct? && user.coins >= coin)
    errors.add(:base, 'User does not have enough coins.')
    false
  end

  def submitted_to_paid
    if !deduct?
      increase_user_coins
    else
      decrease_user_coins
    end

    if deposit?
      increase_user_total_deposit
    end
  end

  def paid_to_cancelled
    if !deduct?
      decrease_user_coins
    else
      increase_user_coins
    end

    if deposit?
      decrease_user_total_deposit
    end
  end

end
