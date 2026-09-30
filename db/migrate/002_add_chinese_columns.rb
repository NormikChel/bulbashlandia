Sequel.migration do
  change do
    alter_table(:cities) do
      add_column :name_zh_hans,   String, size: 100 if DB.schema(:cities).map(&:first).exclude?(:name_zh_hans)
      add_column :name_zh_hant,   String, size: 100 if DB.schema(:cities).map(&:first).exclude?(:name_zh_hant)
      add_column :region_zh_hans, String, size: 100 if DB.schema(:cities).map(&:first).exclude?(:region_zh_hans)
      add_column :region_zh_hant, String, size: 100 if DB.schema(:cities).map(&:first).exclude?(:region_zh_hant)
      add_column :description_zh_hans, Text if DB.schema(:cities).map(&:first).exclude?(:description_zh_hans)
      add_column :description_zh_hant, Text if DB.schema(:cities).map(&:first).exclude?(:description_zh_hant)
    end

    alter_table(:articles) do
      add_column :title_zh_hans, String, size: 200 if DB.schema(:articles).map(&:first).exclude?(:title_zh_hans)
      add_column :title_zh_hant, String, size: 200 if DB.schema(:articles).map(&:first).exclude?(:title_zh_hant)
      add_column :body_zh_hans,  Text if DB.schema(:articles).map(&:first).exclude?(:body_zh_hans)
      add_column :body_zh_hant,  Text if DB.schema(:articles).map(&:first).exclude?(:body_zh_hant)
    end
  end
end