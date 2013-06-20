class CreateTodoLists < ActiveRecord::Migration
  def change
    create_table :todolists do |t|
      t.string :title
      t.integer :user_id
    end
  end
end