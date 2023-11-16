class Ticket < ApplicationRecord
  belongs_to :item
  belongs_to :user, optional: true
  before_create :check_item_state
  before_create :set_batch_count
  before_create :generate_serial_number
  after_create :subtract_coin



  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :refund_coin
    end
  end

  private

  def subtract_coin
    user = User.find(user_id)
    if user.coins >= 1
      user.update(coins: user.coins - 1)
    else
      errors.add(:base, "Not enough coins to create a ticket")
      throw(:abort)
    end
  end

  def refund_coin
    user = User.find(user_id)
    user.update(coins: user.coins + 1)
  end

  def generate_serial_number
    number_count = format('%04d', item.tickets.count + 1)
    date_prefix = Time.current.strftime('%y%m%d')
    self.serial_number = "#{date_prefix}-#{item.id}-#{item.batch_count}-#{number_count}"
  end

  def set_batch_count
    return unless item

    self.batch_count = item.batch_count
  end

  def check_item_state
    if item&.cancelled?
      errors.add(:base, "Cannot create a ticket for a cancelled item")
      throw(:abort)
    end
  end
end
