class AddChallanToComplainStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :complain_status_transitions, :challan_no, :string, after: :comment
    add_column :complain_status_transitions, :receiver_name, :string, after: :comment
  end
end
