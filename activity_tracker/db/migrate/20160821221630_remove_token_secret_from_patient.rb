class RemoveTokenSecretFromPatient < ActiveRecord::Migration[5.0]
  def change
    remove_column :patients, :token_secret
  end
end
