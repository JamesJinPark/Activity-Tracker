class AddFitbitAuthorizedToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :fitbit_authorized, :boolean
  end
end
