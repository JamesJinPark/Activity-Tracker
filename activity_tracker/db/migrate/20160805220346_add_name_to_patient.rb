class AddNameToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :name, :string
  end
end
