class CreatePerformanceData < ActiveRecord::Migration[6.0]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'
    create_table :performance_data do |t|
      t.references :user, null: false, foreign_key: true
      t.hstore :data

      t.timestamps
    end
  end
end
