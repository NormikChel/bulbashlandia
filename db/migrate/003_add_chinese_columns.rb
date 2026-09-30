Sequel.migration do
  up do
    # Проверяем текущие колонки в таблице cities
    city_columns = self[:cities].columns
    alter_table(:cities) do
      add_column :name_zh_hans,        String, size: 100 unless city_columns.include?(:name_zh_hans)
      add_column :name_zh_hant,        String, size: 100 unless city_columns.include?(:name_zh_hant)
      add_column :region_zh_hans,      String, size: 100 unless city_columns.include?(:region_zh_hans)
      add_column :region_zh_hant,      String, size: 100 unless city_columns.include?(:region_zh_hant)
      add_column :description_zh_hans, Text unless city_columns.include?(:description_zh_hans)
      add_column :description_zh_hant, Text unless city_columns.include?(:description_zh_hant)
    end

    # Проверяем текущие колонки в таблице articles
    article_columns = self[:articles].columns
    alter_table(:articles) do
      add_column :title_zh_hans, String, size: 200 unless article_columns.include?(:title_zh_hans)
      add_column :title_zh_hant, String, size: 200 unless article_columns.include?(:title_zh_hant)
      add_column :body_zh_hans,  Text unless article_columns.include?(:body_zh_hans)
      add_column :body_zh_hant,  Text unless article_columns.include?(:body_zh_hant)
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