class AddTokenKeyToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :withings_token_key, :string
  end
end
