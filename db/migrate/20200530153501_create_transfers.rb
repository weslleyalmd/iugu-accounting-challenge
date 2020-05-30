class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.references :account, null: false, foreign_key: true
      t.string :destination_account_id
      t.string :amount

      t.timestamps
    end
  end
end
