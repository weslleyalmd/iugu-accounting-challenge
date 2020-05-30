class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :destination_account_id
      t.integer :amount

      t.timestamps
    end
  end
end
