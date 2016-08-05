class AddMrnToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :mrn, :integer
  end
end
