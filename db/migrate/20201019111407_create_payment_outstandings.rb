class CreatePaymentOutstandings < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_outstandings do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :amount
      t.date :due_date
      t.string :status

      t.timestamps
    end
  end
end
