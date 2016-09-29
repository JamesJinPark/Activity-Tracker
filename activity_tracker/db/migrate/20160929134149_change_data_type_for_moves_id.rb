class ChangeDataTypeForMovesId < ActiveRecord::Migration[5.0]
  def change
  	change_column(:patients, :moves_id, :string)
  end
end
