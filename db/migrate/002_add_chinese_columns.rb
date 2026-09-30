Sequel.migration do
  up do
    # Проверяем и добавляем колонки в таблицу cities
    unless database.schema(:cities).assoc(:name_zh_hans)
      alter_table(:cities) do
        add_column :name_zh_hans,        String, size: 100 unless columns.include?(:name_zh_hans)
        add_column :name_zh_hant,        String, size: 100 unless columns.include?(:name_zh_hant)
        add_column :region_zh_hans,      String, size: 100 unless columns.include?(:region_zh_hans)
        add_column :region_zh_hant,      String, size: 100 unless columns.include?(:region_zh_hant)
        add_column :description_zh_hans, Text unless columns.include?(:description_zh_hans)
        add_column :description_zh_hant, Text unless columns.include?(:description_zh_hant)
      end
    end

    # Проверяем и добавляем колонки в таблицу articles
    unless database.schema(:articles).assoc(:title_zh_hans)
      alter_table(:articles) do
        add_column :title_zh_hans, String, size: 200 unless columns.include?(:title_zh_hans)
        add_column :title_zh_hant, String, size: 200 unless columns.include?(:title_zh_hant)
        add_column :body_zh_hans,  Text unless columns.include?(:body_zh_hans)
        add_column :body_zh_hant,  Text unless columns.include?(:body_zh_hant)
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