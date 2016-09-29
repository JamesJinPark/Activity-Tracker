class AddMovesToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :moves_id, :integer
    add_column :patients, :moves_authorized, :boolean
    add_column :patients, :moves_access_token, :string
    add_column :patients, :moves_refresh_token, :string
  end
end
