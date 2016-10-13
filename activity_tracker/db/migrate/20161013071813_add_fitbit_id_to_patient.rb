class AddFitbitIdToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :fitbit_id, :string
  end
end
