class AddDobToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :dob, :string
  end
end
