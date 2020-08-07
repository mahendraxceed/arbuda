class CreateComplains < ActiveRecord::Migration[6.0]
  def change
    create_table :complains do |t|
      t.references :customer, references: :customers, index: true, foreign_key: true
      t.integer    :ticketid, null: false
      t.string     :person_called, :limit => 100
      t.references :assigned_to,  index: true, null: true, foreign_key:  { to_table: :users }
      # t.belongs_to :assigned_to, :class_name => 'User', index: true, unsigned: true
      t.string     :subject, :limit => 100, null: false
      t.text       :description, null: false
      t.string     :priority, null: false, :limit => 50
      t.datetime   :due_by, null: false
      t.string     :category, :limit => 50, null: false
      t.string     :status, :limit => 50, null: false
      t.text       :comment, :limit => 1000
      t.string     :updated_from_ip, :limit => 50, null: false
      t.belongs_to :created_by, :class_name => 'User', index: true, null: false, unsigned: true
      t.belongs_to :updated_by, :class_name => 'User', index: false, null: false, unsigned: true
      t.timestamps
    end

  end
end
