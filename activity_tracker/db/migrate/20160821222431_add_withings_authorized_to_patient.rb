class AddWithingsAuthorizedToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :withings_authorized, :boolean
  end
end
