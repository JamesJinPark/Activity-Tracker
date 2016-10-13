class AddFitbitRefreshTokenToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :fitbit_refresh_token, :string
  end
end
