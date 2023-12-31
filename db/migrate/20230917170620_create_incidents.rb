class CreateIncidents < ActiveRecord::Migration[7.0]
  def up
    create_table :incidents do |t|
      t.string   :title, null: false
      t.text     :description, null: true
      t.integer  :severity, null: true
      t.integer  :state, default: 0
      t.text     :slack_channel_id, null: false
      t.datetime :resolved_at, null: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :incidents
  end
end
