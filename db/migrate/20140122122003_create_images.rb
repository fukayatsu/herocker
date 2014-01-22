class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :extname
      t.string :original_filename
      t.binary :content
      t.string :content_type
      t.integer :size
      t.boolean :protected, default: false

      t.timestamps
    end

    add_index :images, :name
    add_index :images, :protected
  end
end
