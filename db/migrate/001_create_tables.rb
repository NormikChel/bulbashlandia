Sequel.migration do
  change do
    create_table(:cities) do
      primary_key :id
      String  :name,        null: false, size: 100
      String  :name_be,     size: 100
      String  :name_latn,   size: 100
      String  :name_en,     size: 100
      String  :name_uk,     size: 100
      String  :slug,        null: false, unique: true, size: 80
      String  :region,      null: false, size: 100
      String  :region_be,   size: 100
      String  :region_latn, size: 100
      String  :region_en,   size: 100
      String  :region_uk,   size: 100
      Text    :description
      Text    :description_be
      Text    :description_latn
      Text    :description_en
      Text    :description_uk
      String  :photo_url,   size: 255
      Integer :population
      Integer :founded
      Float   :area
      Float   :lat
      Float   :lon
      TrueClass :capital,   default: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index :slug, unique: true
      index :region
      index :capital
    end

    create_table(:articles) do
      primary_key :id
      String  :title,       null: false, size: 200
      String  :title_be,    size: 200
      String  :title_latn,  size: 200
      String  :title_en,    size: 200
      String  :title_uk,    size: 200
      String  :slug,        null: false, unique: true, size: 120
      Text    :body
      Text    :body_be
      Text    :body_latn
      Text    :body_en
      Text    :body_uk
      String  :excerpt,     size: 500
      String  :category,    null: false, size: 50
      String  :cover_url,   size: 255
      TrueClass :published, default: true
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index :slug, unique: true
      index :category
      index :published
    end
  end
end