class AddTokenSecretToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :withings_token_secret, :string
  end
end
