class AddFitbitAccessTokenToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :fitbit_access_token, :string
  end
end
