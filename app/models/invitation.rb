# frozen_string_literal: true

# Invitation requested before sign-up
class Invitation < ApplicationRecord
  before_create :generate_code
  before_create :set_expiration_date

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  def accept
    self.accepted_at = DateTime.now
    self.expires_at = 1.week.from_now
    save
  end

  def use
    self.used_at = DateTime.now
    save
  end

  private

  def generate_code
    self.code = [*'A'..'Z', *'a'..'z', *0..9].sample(8).join
  end

  def set_expiration_date
    self.expires_at = 1.year.from_now
  end
end
