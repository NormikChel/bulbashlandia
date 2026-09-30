Sequel.migration do
  change do
    alter_table(:cities) do
      add_column :name_zh_hans,        String, size: 100 unless DB[:cities].columns.include?(:name_zh_hans)
      add_column :name_zh_hant,        String, size: 100 unless DB[:cities].columns.include?(:name_zh_hant)
      add_column :region_zh_hans,      String, size: 100 unless DB[:cities].columns.include?(:region_zh_hans)
      add_column :region_zh_hant,      String, size: 100 unless DB[:cities].columns.include?(:region_zh_hant)
      add_column :description_zh_hans, Text             unless DB[:cities].columns.include?(:description_zh_hans)
      add_column :description_zh_hant, Text             unless DB[:cities].columns.include?(:description_zh_hant)
    end

    alter_table(:articles) do
      add_column :title_zh_hans, String, size: 200 unless DB[:articles].columns.include?(:title_zh_hans)
      add_column :title_zh_hant, String, size: 200 unless DB[:articles].columns.include?(:title_zh_hant)
      add_column :body_zh_hans,  Text             unless DB[:articles].columns.include?(:body_zh_hans)
      add_column :body_zh_hant,  Text             unless DB[:articles].columns.include?(:body_zh_hant)
    end
  end
end