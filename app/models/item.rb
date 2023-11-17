class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :batch_count, presence: true
  validates :offline_at, presence: true
  enum status: { active: 0, inactive: 1 }
  mount_uploader :image, ImageUploader
  has_many :winners
  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
  has_many :tickets, dependent: :restrict_with_error
  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], guard: :before_start, to: :starting, after: :after_start
      transitions from: :paused, to: :starting, after: :after_start
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, guard: :can_end?, to: :ended, after: :after_end
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, after: :cancel_tickets
    end
  end

  def cancel_tickets
    tickets.update_all(state: 'cancelled') if tickets.present?
  end

  private

  def before_start
    unless quantity.to_i.positive? && Time.current < offline_at && status == 'active'
      return false
    end
    true
  end

  def after_start
    self.quantity -= 1
    self.batch_count += 1
    save!
  end

  def can_end?
    unless tickets.where(batch_count: self.batch_count).count >= self.minimum_tickets
      p "The minimum tickets of this Item is not yet full"
      return false
    end
    true
  end

  def after_end
    # Call method to pick a winner and update ticket states
    pick_winner_and_update_tickets
  end

  def pick_winner_and_update_tickets
    # Get the winning ticket and update states
    winning_ticket = tickets.pending.sample
    return unless winning_ticket

    winning_ticket.win!
    update_other_tickets(winning_ticket)
    create_winner_record(winning_ticket)
  end

  def update_other_tickets(winning_ticket)
    # Update other tickets in the current batch
    tickets.where.not(id: winning_ticket.id).update_all(state: 'lost')
  end

  def create_winner_record(winning_ticket)
    # Insert the winning ticket into the Winner model
    Winner.create(item: self, ticket: winning_ticket, user: winning_ticket.user)
  end
end
