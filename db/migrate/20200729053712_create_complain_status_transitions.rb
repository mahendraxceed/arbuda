class CreateComplainStatusTransitions < ActiveRecord::Migration[6.0]
  def change
    create_table :complain_status_transitions do |t|
      t.references  :complain, references: :complains, index: true, foreign_key: true
      t.string      :namespace, :limit => 50
      t.string      :event, :limit => 50
      t.string      :from, :limit => 50
      t.string      :to, :limit => 50, null: false
      t.string      :change_description, null: false
      t.text        :comment, :limit => 1000
      t.datetime    :created_at, null: false
    end
  end
end
