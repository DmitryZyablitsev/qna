class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :commentable, polymorphic: true
      t.string :body, null: false, limit: 100

      t.timestamps
    end
  end
end
