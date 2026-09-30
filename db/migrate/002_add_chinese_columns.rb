Sequel.migration do
  up do
    unless db[:cities].columns.include?(:name_zh_hans)
      alter_table(:cities) do
        add_column :name_zh_hans,        String, size: 100
        add_column :name_zh_hant,        String, size: 100
        add_column :region_zh_hans,      String, size: 100
        add_column :region_zh_hant,      String, size: 100
        add_column :description_zh_hans, Text
        add_column :description_zh_hant, Text
      end
    end

    unless db[:articles].columns.include?(:title_zh_hans)
      alter_table(:articles) do
        add_column :title_zh_hans, String, size: 200
        add_column :title_zh_hant, String, size: 200
        add_column :body_zh_hans,  Text
        add_column :body_zh_hant,  Text
      end
    end
  end

  down do
    alter_table(:cities) do
      drop_column :name_zh_hans
      drop_column :name_zh_hant
      drop_column :region_zh_hans
      drop_column :region_zh_hant
      drop_column :description_zh_hans
      drop_column :description_zh_hant
    end

    alter_table(:articles) do
      drop_column :title_zh_hans
      drop_column :title_zh_hant
      drop_column :body_zh_hans
      drop_column :body_zh_hant
    end
  end
end