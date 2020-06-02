class Account < ApplicationRecord
  validates_presence_of :name, :balance

  validates_presence_of :access_token
  validates_uniqueness_of :access_token, case_sensitive: true

  before_validation :set_token, on: :create

  def withdraw(value)
    new_balance = balance - value
    self.update(balance: new_balance)
  end

  def deposit(value)
    new_balance = balance + value
    self.update(balance: new_balance)
  end

  def has_balance?(value)
    balance > value
  end

  private

  def set_token
    self.access_token = self.generate_token
  end

  def generate_token
    return rand(36**20).to_s(36) if self.new_record? and self.access_token.nil?
  end

end