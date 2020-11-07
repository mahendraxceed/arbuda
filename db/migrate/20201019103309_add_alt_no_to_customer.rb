class AddAltNoToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers,  :alt_mobile, :string
    add_column :customers, :due_amount, :integer
    add_column :customers, :due_date, :date
  end
end
