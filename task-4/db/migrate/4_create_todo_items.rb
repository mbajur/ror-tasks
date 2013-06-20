class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todoitems do |t|
      t.string :title
      t.text :description
      t.datetime :date_due
      t.integer :todolist_id
    end
  end
end
