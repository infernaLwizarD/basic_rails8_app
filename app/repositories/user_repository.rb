module UserRepository
  extend ActiveSupport::Concern

  included do
    scope :default_order, -> { order(:created_at) }
    scope :by_state, lambda { |v|
      case v
      when 'active'
        where(discarded_at: nil, locked_at: nil)
      when 'locked'
        where(discarded_at: nil).where.not(locked_at: nil)
      when 'discarded'
        where.not(discarded_at: nil)
      end
    }
  end
end
