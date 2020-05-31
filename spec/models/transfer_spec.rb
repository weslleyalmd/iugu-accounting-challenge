require 'rails_helper'

RSpec.describe Transfer, type: :model do
  it { should validate_presence_of(:amount) }  
end
