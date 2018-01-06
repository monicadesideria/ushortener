class CreateShortUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :short_urls do |t|
      t.string :original_url
      t.boolean :is_custom_url, default: false
      t.string :short_uid

      t.timestamps
    end
  end
end
