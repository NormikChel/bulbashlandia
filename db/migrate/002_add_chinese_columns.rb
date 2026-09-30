Sequel.migration do
  change do
    alter_table(:cities) do
      add_column :name_zh_hans,        String, size: 100
      add_column :name_zh_hant,        String, size: 100
      add_column :region_zh_hans,      String, size: 100
      add_column :region_zh_hant,      String, size: 100
      add_column :description_zh_hans, String, text: true
      add_column :description_zh_hant, String, text: true
    end

    alter_table(:articles) do
      add_column :title_zh_hans, String, size: 200
      add_column :title_zh_hant, String, size: 200
      add_column :body_zh_hans,  String, text: true
      add_column :body_zh_hant,  String, text: true
    end
  end
end