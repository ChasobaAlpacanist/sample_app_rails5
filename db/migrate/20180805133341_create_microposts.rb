class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true
      #referencesでuser_idのカラムを作成する
      #foreign_keyは外部キー制約。外部キーとは他のテーブル（この場合はUser）との関連性を持たせる。

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
