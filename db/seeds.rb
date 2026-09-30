require 'sequel'

# 1. Сначала соединение с БД
DB_PATH = File.expand_path('database.sqlite3', __dir__)
DB = Sequel.sqlite(DB_PATH)
Sequel::Model.db = DB

# 2. Миграции — на случай, если БД ещё не готова (например, на Render)
Sequel.extension :migration
MIGRATIONS_PATH = File.expand_path('migrate', __dir__)
Sequel::Migrator.run(DB, MIGRATIONS_PATH) if Dir.exist?(MIGRATIONS_PATH)

# 3. Только теперь грузим модели
require_relative '../models/city'
require_relative '../models/article'

# 4. Чистим перед заливкой, чтобы можно было запускать много раз
DB[:cities].delete
DB[:articles].delete

cities = [
  {
    name: 'Минск', name_be: 'Мінск', name_latn: 'Minsk', name_en: 'Minsk', name_uk: 'Мінськ',
    name_zh_hans: '明斯克', name_zh_hant: '明斯克',
    slug: 'minsk',
    region: 'Минская область', region_be: 'Мінская вобласць', region_latn: 'Minskaja voblasć',
    region_en: 'Minsk Region', region_uk: 'Мінська область',
    region_zh_hans: '明斯克州', region_zh_hant: '明斯克州',
    description: 'Столица Беларуси, крупнейший город страны и её политический, экономический и культурный центр. Здесь находятся Национальная библиотека, Большой театр оперы и балета, старый город с Троицким предместьем.',
    description_be: 'Сталіца Беларусі, найбуйнейшы горад краіны і яе палітычны, эканамічны і культурны цэнтр.',
    description_latn: 'Stalica Biełarusi, najbułniejšy horad krainy i jaje palityčny, ekanamičny i kulturny centr.',
    description_en: 'The capital of Belarus, the largest city in the country and its political, economic and cultural centre.',
    description_uk: 'Столиця Білорусі, найбільше місто країни та її політичний, економічний і культурний центр.',
    description_zh_hans: '白俄罗斯的首都，全国最大的城市，也是政治、经济和文化中心。这里有国家图书馆、大剧院和保留完好的老城区。',
    description_zh_hant: '白俄羅斯的首都，全國最大的城市，也是政治、經濟和文化中心。這裡有國家圖書館、大劇院和保留完好的老城區。',
    population: 1_992_000, founded: 1067, area: 348.0, lat: 53.9045, lon: 27.5615, capital: true
  },
  {
    name: 'Гомель', name_be: 'Гомель', name_latn: 'Homiel', name_en: 'Gomel', name_uk: 'Гомель',
    name_zh_hans: '戈梅利', name_zh_hant: '戈梅利',
    slug: 'gomel',
    region: 'Гомельская область', region_be: 'Гомельская вобласць', region_latn: 'Homielskaja voblasć',
    region_en: 'Gomel Region', region_uk: 'Гомельська область',
    region_zh_hans: '戈梅利州', region_zh_hant: '戈梅利州',
    description: 'Второй по величине город страны, крупный промышленный и культурный центр на юго-востоке Беларуси. Известен дворцово-парковым ансамблем Румянцевых и Паскевичей.',
    description_be: 'Другі па велічыні горад краіны, буйны прамысловы і культурны цэнтр на паўднёвым усходзе Беларусі.',
    description_latn: 'Druhi pa vieličyni horad krainy, bujny pra myslovy i kulturny centr na paŭdniovym uschodzie Biełarusi.',
    description_en: 'The second-largest city, a major industrial and cultural centre in the south-east of Belarus.',
    description_uk: 'Друге за величиною місто країни, великий промисловий і культурний центр на південному сході Білорусі.',
    description_zh_hans: '白俄罗斯第二大城市，东南部重要的工业和文化中心，以鲁缅采夫和帕斯克维奇宫苑建筑群闻名。',
    description_zh_hant: '白俄羅斯第二大城市，東南部重要的工業和文化中心，以魯緬采夫和帕斯克維奇宮苑建築群聞名。',
    population: 510_000, founded: 1142, area: 135.0, lat: 52.4345, lon: 30.9754, capital: false
  },
  {
    name: 'Могилёв', name_be: 'Магілёў', name_latn: 'Mahilioŭ', name_en: 'Mogilev', name_uk: 'Могилів',
    name_zh_hans: '莫吉廖夫', name_zh_hant: '莫吉廖夫',
    slug: 'mogilev',
    region: 'Могилёвская область', region_be: 'Магілёўская вобласць', region_latn: 'Mahilioŭskaja voblasć',
    region_en: 'Mogilev Region', region_uk: 'Могилівська область',
    region_zh_hans: '莫吉廖夫州', region_zh_hant: '莫吉廖夫州',
    description: 'Крупный город на востоке Беларуси, известный своими купеческими домами XVIII—XIX веков и ратушей.',
    description_be: 'Буйны горад на ўсходзе Беларусі, вядомы сваімі купецкімі дамамі XVIII—XIX стагоддзяў і ратушай.',
    description_latn: 'Bujny horad na ŭschodzie Biełarusi, viadomy svaimi kupeckimi damami XVIII—XIX stahodździaŭ.',
    description_en: 'A large city in eastern Belarus, known for its merchant houses of the 18th–19th centuries.',
    description_uk: 'Велике місто на сході Білорусі, відоме своїми купецькими будинками XVIII—XIX століть.',
    description_zh_hans: '白俄罗斯东部的大城市，以十八至十九世纪的商人之家和市政厅闻名。',
    description_zh_hant: '白俄羅斯東部的大城市，以十八至十九世紀的商人之家和市政廳聞名。',
    population: 357_000, founded: 1267, area: 118.0, lat: 53.9006, lon: 30.3319, capital: false
  },
  {
    name: 'Витебск', name_be: 'Віцебск', name_latn: 'Viciebsk', name_en: 'Vitebsk', name_uk: 'Вітебськ',
    name_zh_hans: '维捷布斯克', name_zh_hant: '維捷布斯克',
    slug: 'vitebsk',
    region: 'Витебская область', region_be: 'Віцебская вобласць', region_latn: 'Viciebskaja voblasć',
    region_en: 'Vitebsk Region', region_uk: 'Вітебська область',
    region_zh_hans: '维捷布斯克州', region_zh_hant: '維捷布斯克州',
    description: 'Город на северо-востоке Беларуси, родина Марка Шагала. Здесь ежегодно проходит международный фестиваль искусств «Славянский базар».',
    description_be: 'Горад на паўночным усходзе Беларусі, радзіма Марка Шагала.',
    description_latn: 'Horad na paŭnočnym uschodzie Biełarusi, radzima Marka Šahała.',
    description_en: 'A city in the north-east of Belarus, the birthplace of Marc Chagall.',
    description_uk: 'Місто на північному сході Білорусі, батьківщина Марка Шагала.',
    description_zh_hans: '白俄罗斯东北部城市，马克·夏加尔的故乡。每年在这里举办“斯拉夫集市”国际艺术节。',
    description_zh_hant: '白俄羅斯東北部城市，馬克·夏加爾的故鄉。每年在這裡舉辦「斯拉夫集市」國際藝術節。',
    population: 360_000, founded: 974, area: 124.0, lat: 55.1904, lon: 30.2049, capital: false
  },
  {
    name: 'Гродно', name_be: 'Гродна', name_latn: 'Hrodna', name_en: 'Grodno', name_uk: 'Гродно',
    name_zh_hans: '格罗德诺', name_zh_hant: '格羅德諾',
    slug: 'grodno',
    region: 'Гродненская область', region_be: 'Гродзенская вобласць', region_latn: 'Hrodzienskaja voblasć',
    region_en: 'Grodno Region', region_uk: 'Гродненська область',
    region_zh_hans: '格罗德诺州', region_zh_hant: '格羅德諾州',
    description: 'Один из старейших и красивейших городов Беларуси, с хорошо сохранившимся историческим центром и Старым замком.',
    description_be: 'Адзін з найстарэйшых і прыгажэйшых гарадоў Беларусі.',
    description_latn: 'Adzin z najstarejšych i pryhažejšych haradoŭ Biełarusi.',
    description_en: 'One of the oldest and most beautiful cities of Belarus, with a well-preserved historic centre.',
    description_uk: 'Одне з найстаріших і найкрасивіших міст Білорусі.',
    description_zh_hans: '白俄罗斯最古老、最美丽的城市之一，保留了完好的历史中心和古老城堡。',
    description_zh_hant: '白俄羅斯最古老、最美麗的城市之一，保留了完好的歷史中心和古老城堡。',
    population: 356_000, founded: 1128, area: 142.0, lat: 53.6667, lon: 23.8167, capital: false
  },
  {
    name: 'Брест', name_be: 'Брэст', name_latn: 'Brest', name_en: 'Brest', name_uk: 'Берестя',
    name_zh_hans: '布列斯特', name_zh_hant: '布列斯特',
    slug: 'brest',
    region: 'Брестская область', region_be: 'Брэсцкая вобласць', region_latn: 'Brestskaja voblasć',
    region_en: 'Brest Region', region_uk: 'Берестейська область',
    region_zh_hans: '布列斯特州', region_zh_hant: '布列斯特州',
    description: 'Город на западе Беларуси, известный Брестской крепостью — символом героической обороны 1941 года.',
    description_be: 'Горад на захадзе Беларусі, вядомы Брэсцкай крэпасцю.',
    description_latn: 'Horad na zachadzie Biełarusi, viadomy Bresckaj krepasću.',
    description_en: 'A city in western Belarus, known for the Brest Fortress.',
    description_uk: 'Місто на заході Білорусі, відоме Берестейською фортецею.',
    description_zh_hans: '白俄罗斯西部城市，以布列斯特要塞闻名——1941年英雄防御的象征。',
    description_zh_hant: '白俄羅斯西部城市，以布列斯特要塞聞名——1941年英雄防禦的象徵。',
    population: 344_000, founded: 1019, area: 146.0, lat: 52.0976, lon: 23.6878, capital: false
  },
  {
    name: 'Полоцк', name_be: 'Полацк', name_latn: 'Połack', name_en: 'Polotsk', name_uk: 'Полоцьк',
    name_zh_hans: '波洛茨克', name_zh_hant: '波洛茨克',
    slug: 'polotsk',
    region: 'Витебская область', region_be: 'Віцебская вобласць', region_latn: 'Viciebskaja voblasć',
    region_en: 'Vitebsk Region', region_uk: 'Вітебська область',
    region_zh_hans: '维捷布斯克州', region_zh_hant: '維捷布斯克州',
    description: 'Древнейший город Беларуси, центр Полоцкого княжества и родина первопечатника Франциска Скорины.',
    description_be: 'Найстаражытнейшы горад Беларусі, цэнтр Полацкага княства.',
    description_latn: 'Najstarejšy horad Biełarusi, centr Połackaha kniastva.',
    description_en: 'The oldest city of Belarus, the centre of the Principality of Polotsk.',
    description_uk: 'Найдавніше місто Білорусі, центр Полоцького князівства.',
    description_zh_hans: '白俄罗斯最古老的城市，波洛茨克公国的中心，也是印刷先驱弗朗齐斯克·斯科里纳的故乡。',
    description_zh_hant: '白俄羅斯最古老的城市，波洛茨克公國的中心，也是印刷先驅弗朗齊斯克·斯科里納的故鄉。',
    population: 84_000, founded: 862, area: 40.0, lat: 55.4856, lon: 28.7672, capital: false
  },
  {
    name: 'Барановичи', name_be: 'Баранавічы', name_latn: 'Baranavičy', name_en: 'Baranovichi', name_uk: 'Барановичі',
    name_zh_hans: '巴拉诺维奇', name_zh_hant: '巴拉諾維奇',
    slug: 'baranovichi',
    region: 'Брестская область', region_be: 'Брэсцкая вобласць', region_latn: 'Brestskaja voblasć',
    region_en: 'Brest Region', region_uk: 'Берестейська область',
    region_zh_hans: '布列斯特州', region_zh_hant: '布列斯特州',
    description: 'Крупный железнодорожный узел на юго-западе Беларуси, важный промышленный центр.',
    description_be: 'Буйны чыгуначны вузел на паўднёвым захадзе Беларусі.',
    description_latn: 'Bujny čyhunаčny vuzieł na paŭdniovym zachadzie Biełarusi.',
    description_en: 'A major railway hub in the south-west of Belarus.',
    description_uk: 'Великий залізничний вузол на південному заході Білорусі.',
    description_zh_hans: '白俄罗斯西南部的重要铁路枢纽和工业中心。',
    description_zh_hant: '白俄羅斯西南部的重要鐵路樞紐和工業中心。',
    population: 179_000, founded: 1871, area: 84.0, lat: 53.1333, lon: 26.0167, capital: false
  },
  {
    name: 'Борисов', name_be: 'Барысаў', name_latn: 'Barysaŭ', name_en: 'Borisov', name_uk: 'Борисов',
    name_zh_hans: '鲍里索夫', name_zh_hant: '鮑里索夫',
    slug: 'borisov',
    region: 'Минская область', region_be: 'Мінская вобласць', region_latn: 'Minskaja voblasć',
    region_en: 'Minsk Region', region_uk: 'Мінська область',
    region_zh_hans: '明斯克州', region_zh_hant: '明斯克州',
    description: 'Город на реке Березине, известный событиями Отечественной войны 1812 года.',
    description_be: 'Горад на рацэ Бярэзіне, вядомы падзеямі Айчыннай вайны 1812 года.',
    description_latn: 'Horad na race Biarezina, viadomy padziejami vajny 1812 hoda.',
    description_en: 'A city on the Berezina River, known for the events of the 1812 war.',
    description_uk: 'Місто на річці Березина, відоме подіями війни 1812 року.',
    description_zh_hans: '位于别列津纳河畔的城市，以1812年战争的历史事件闻名。',
    description_zh_hant: '位於別列津納河畔的城市，以1812年戰爭的歷史事件聞名。',
    population: 143_000, founded: 1102, area: 46.0, lat: 54.2279, lon: 28.5056, capital: false
  },
  {
    name: 'Пинск', name_be: 'Пінск', name_latn: 'Pinsk', name_en: 'Pinsk', name_uk: 'Пінськ',
    name_zh_hans: '平斯克', name_zh_hant: '平斯克',
    slug: 'pinsk',
    region: 'Брестская область', region_be: 'Брэсцкая вобласць', region_latn: 'Brestskaja voblasć',
    region_en: 'Brest Region', region_uk: 'Берестейська область',
    region_zh_hans: '布列斯特州', region_zh_hant: '布列斯特州',
    description: 'Старинный город на Полесье, крупный центр Полесского региона.',
    description_be: 'Старажытны горад на Палессі, буйны цэнтр Палескага рэгіёна.',
    description_latn: 'Staražytny horad na Palessi, bujny centr Palieskaha rehijona.',
    description_en: 'An ancient city in Polesia.',
    description_uk: 'Старовинне місто на Поліссі.',
    description_zh_hans: '波列西耶地区的古老城市，该地区的重要中心。',
    description_zh_hant: '波列西耶地區的古老城市，該地區的重要中心。',
    population: 126_000, founded: 1097, area: 46.0, lat: 52.1220, lon: 26.0950, capital: false
  },
  {
    name: 'Орша', name_be: 'Орша', name_latn: 'Orša', name_en: 'Orsha', name_uk: 'Орша',
    name_zh_hans: '奥尔沙', name_zh_hant: '奧爾沙',
    slug: 'orsha',
    region: 'Витебская область', region_be: 'Віцебская вобласць', region_latn: 'Viciebskaja voblasć',
    region_en: 'Vitebsk Region', region_uk: 'Вітебська область',
    region_zh_hans: '维捷布斯克州', region_zh_hant: '維捷布斯克州',
    description: 'Город на Днепре, известный с XIII века.',
    description_be: 'Горад на Дняпры, вядомы з XIII стагоддзя.',
    description_latn: 'Horad na Dniapry, viadomy z XIII stahodździa.',
    description_en: 'A city on the Dnieper, known since the 13th century.',
    description_uk: 'Місто на Дніпрі, відоме з XIII століття.',
    description_zh_hans: '第聂伯河畔的城市，自十三世纪起就有记载。',
    description_zh_hant: '第聶伯河畔的城市，自十三世紀起就有記載。',
    population: 108_000, founded: 1067, area: 42.0, lat: 54.5081, lon: 30.4175, capital: false
  },
  {
    name: 'Мозырь', name_be: 'Мазыр', name_latn: 'Mazyr', name_en: 'Mozyr', name_uk: 'Мозир',
    name_zh_hans: '莫济里', name_zh_hant: '莫濟里',
    slug: 'mozyr',
    region: 'Гомельская область', region_be: 'Гомельская вобласць', region_latn: 'Homielskaja voblasć',
    region_en: 'Gomel Region', region_uk: 'Гомельська область',
    region_zh_hans: '戈梅利州', region_zh_hant: '戈梅利州',
    description: 'Город на Припяти, центр нефтепереработки.',
    description_be: 'Горад на Прыпяці, цэнтр нафтаперапрацоўкі.',
    description_latn: 'Horad na Prypiaci, centr naftapierapracoŭki.',
    description_en: 'A city on the Pripyat River, a centre of oil refining.',
    description_uk: 'Місто на Прип\'яті, центр нафтопереробки.',
    description_zh_hans: '普里皮亚季河畔的城市，石油加工中心。',
    description_zh_hant: '普里皮亞季河畔的城市，石油加工中心。',
    population: 105_000, founded: 1155, area: 44.0, lat: 52.0490, lon: 29.2690, capital: false
  },
  {
    name: 'Солигорск', name_be: 'Салігорск', name_latn: 'Salihorsk', name_en: 'Soligorsk', name_uk: 'Солігорськ',
    name_zh_hans: '索利戈尔斯克', name_zh_hant: '索利戈爾斯克',
    slug: 'soligorsk',
    region: 'Минская область', region_be: 'Мінская вобласць', region_latn: 'Minskaja voblasć',
    region_en: 'Minsk Region', region_uk: 'Мінська область',
    region_zh_hans: '明斯克州', region_zh_hant: '明斯克州',
    description: 'Молодой город, выросший вокруг калийного комбината.',
    description_be: 'Малады горад, які вырас вакол калійнага камбіната.',
    description_latn: 'Małady horad, jaki vyras vakoł kalijnaha kombinata.',
    description_en: 'A young city that grew around the potash plant.',
    description_uk: 'Молоде місто, що виросло навколо калійного комбінату.',
    description_zh_hans: '围绕钾肥厂发展起来的年轻城市，钾盐开采中心。',
    description_zh_hant: '圍繞鉀肥廠發展起來的年輕城市，鉀鹽開採中心。',
    population: 106_000, founded: 1958, area: 15.0, lat: 52.7869, lon: 27.5411, capital: false
  },
  {
    name: 'Новополоцк', name_be: 'Наваполацк', name_latn: 'Navapołack', name_en: 'Novopolotsk', name_uk: 'Новополоцьк',
    name_zh_hans: '新波洛茨克', name_zh_hant: '新波洛茨克',
    slug: 'novopolotsk',
    region: 'Витебская область', region_be: 'Віцебская вобласць', region_latn: 'Viciebskaja voblasć',
    region_en: 'Vitebsk Region', region_uk: 'Вітебська область',
    region_zh_hans: '维捷布斯克州', region_zh_hant: '維捷布斯克州',
    description: 'Город нефтехимиков, построенный в 1958 году рядом с Полоцком.',
    description_be: 'Горад нафтахімікаў, пабудаваны ў 1958 годзе побач з Полацкам.',
    description_latn: 'Horad naftachmikaŭ, pabudavany ŭ 1958 hodzie pobač z Połackam.',
    description_en: 'A city of petrochemists built in 1958 next to Polotsk.',
    description_uk: 'Місто нафтохіміків, збудоване 1958 року поряд з Полоцьком.',
    description_zh_hans: '石油化工城市，1958年在波洛茨克附近建成。',
    description_zh_hant: '石油化工城市，1958年在波洛茨克附近建成。',
    population: 98_000, founded: 1958, area: 24.0, lat: 55.5311, lon: 28.6500, capital: false
  },
  {
    name: 'Лида', name_be: 'Ліда', name_latn: 'Lida', name_en: 'Lida', name_uk: 'Ліда',
    name_zh_hans: '利达', name_zh_hant: '利達',
    slug: 'lida',
    region: 'Гродненская область', region_be: 'Гродзенская вобласць', region_latn: 'Hrodzienskaja voblasć',
    region_en: 'Grodno Region', region_uk: 'Гродненська область',
    region_zh_hans: '格罗德诺州', region_zh_hant: '格羅德諾州',
    description: 'Город на западе Беларуси с хорошо сохранившимся замком XIV века.',
    description_be: 'Горад на захадзе Беларусі з добра захаваным замкам XIV стагоддзя.',
    description_latn: 'Horad na zachadzie Biełarusi z dobra zachavanym zamkam XIV stahodździa.',
    description_en: 'A city in western Belarus with a well-preserved 14th-century castle.',
    description_uk: 'Місто на заході Білорусі з добре збереженим замком XIV століття.',
    description_zh_hans: '白俄罗斯西部城市，保留了完好的十四世纪城堡。',
    description_zh_hant: '白俄羅斯西部城市，保留了完好的十四世紀城堡。',
    population: 102_000, founded: 1323, area: 22.0, lat: 53.8875, lon: 25.3000, capital: false
  }
]

cities.each { |city_data| City.create(city_data) }

puts "✅ Загружено городов: #{City.count}"

articles = [
  {
    title: 'Краткая история Беларуси',
    title_be: 'Кароткая гісторыя Беларусі',
    title_latn: 'Karotkaja historyja Biełarusi',
    title_en: 'A Brief History of Belarus',
    title_uk: 'Коротка історія Білорусі',
    title_zh_hans: '白俄罗斯简史',
    title_zh_hant: '白俄羅斯簡史',
    slug: 'brief-history',
    category: 'history',
    excerpt: 'От Полоцкого княжества до современной Республики Беларусь — основные вехи.',
    body: 'История Беларуси насчитывает более тысячи лет. Полоцкое княжество, Туровское княжество, Великое княжество Литовское, Речь Посполитая, Российская империя, БНР, БССР, Республика Беларусь — вот основные этапы пути.',
    body_be: 'Гісторыя Беларусі налічвае больш за тысячу гадоў. Полацкае княства, Тураўскае княства, Вялікае княства Літоўскае, Рэч Паспалітая, Расійская імперыя, БНР, БССР, Рэспубліка Беларусь — вось асноўныя этапы шляху.',
    body_latn: 'Historyja Biełarusi naličvaje bolš za tysiaču hadoŭ.',
    body_en: 'The history of Belarus spans more than a thousand years: the Principality of Polotsk, the Grand Duchy of Lithuania, the Polish–Lithuanian Commonwealth, the Russian Empire, the BNR, the BSSR and modern Belarus.',
    body_uk: 'Історія Білорусі налічує понад тисячу років. Полоцьке князівство, Туровське князівство, Велике князівство Литовське, Річ Посполита, Російська імперія, БНР, БРСР, Республіка Білорусь.',
    body_zh_hans: '白俄罗斯的历史超过一千年：波洛茨克公国、图罗夫公国、立陶宛大公国、波兰立陶宛联邦、俄罗斯帝国、白俄罗斯人民共和国、白俄罗斯苏维埃社会主义共和国，以及现代的共和国。',
    body_zh_hant: '白俄羅斯的歷史超過一千年：波洛茨克公國、圖羅夫公國、立陶宛大公國、波蘭立陶宛聯邦、俄羅斯帝國、白俄羅斯人民共和國、白俄羅斯蘇維埃社會主義共和國，以及現代的共和國。',
    published: true
  },
  {
    title: 'Белорусская кухня: драники, бабка, колдуны',
    title_be: 'Беларуская кухня: дранікі, бабка, калдуны',
    title_latn: 'Biełaruskaja kuchnia: draniki, babka, kałduny',
    title_en: 'Belarusian Cuisine: Draniki, Babka, Kalduny',
    title_uk: 'Білоруська кухня: драники, бабка, колдуни',
    title_zh_hans: '白俄罗斯美食：土豆饼、巴布卡、科尔敦',
    title_zh_hant: '白俄羅斯美食：馬鈴薯餅、巴布卡、科爾敦',
    slug: 'belarusian-cuisine',
    category: 'cuisine',
    excerpt: 'Главные блюда белорусской кухни — сытные, простые и невероятно вкусные.',
    body: 'Белорусская кухня — это драники, бабка, колдуны, мочанка, холодник. Основу составляют картофель, свинина, грибы, ягоды. Блюда сытные и простые, но при этом удивительно вкусные.',
    body_be: 'Беларуская кухня — гэта дранікі, бабка, калдуны, мачанка, халаднік. Аснову складаюць бульба, свініна, грыбы, ягады.',
    body_latn: 'Biełaruskaja kuchnia — heta draniki, babka, kałduny, mačanka, chaładnik.',
    body_en: 'Belarusian cuisine features draniki, babka, kalduny, machanka and khaladnik, based on potatoes, pork, mushrooms and berries.',
    body_uk: 'Білоруська кухня — це драники, бабка, колдуни, мачанка, холодник.',
    body_zh_hans: '白俄罗斯美食以土豆饼、巴布卡、科尔敦、马昌卡和冷汤为代表，主要以土豆、猪肉、蘑菇和浆果为基础，简单、饱腹却出奇美味。',
    body_zh_hant: '白俄羅斯美食以馬鈴薯餅、巴布卡、科爾敦、馬昌卡和冷湯為代表，主要以馬鈴薯、豬肉、蘑菇和漿果為基礎，簡單、飽腹卻出奇美味。',
    published: true
  },
  {
    title: 'Беловежская пуща — древнейший лес Европы',
    title_be: 'Белавежская пушча — найстаражытнейшы лес Еўропы',
    title_latn: 'Biełaviežskaja pušča — najstarejšy les Jeŭropy',
    title_en: 'Belovezhskaya Pushcha — the Oldest Forest in Europe',
    title_uk: 'Біловезька пуща — найдавніший ліс Європи',
    title_zh_hans: '别洛韦日森林——欧洲最古老的森林',
    title_zh_hant: '別洛韋日森林——歐洲最古老的森林',
    slug: 'belovezhskaya-pushcha',
    category: 'nature',
    excerpt: 'Один из последних первобытных лесов Европы и дом для зубров.',
    body: 'Беловежская пуща — национальный парк на границе Беларуси и Польши. Здесь обитают зубры, волки, рыси и сотни видов птиц. Лес внесён в список Всемирного наследия ЮНЕСКО.',
    body_be: 'Белавежская пушча — нацыянальны парк на мяжы Беларусі і Польшчы. Тут жывуць зубры, ваўкі, рысі і сотні відаў птушак.',
    body_latn: 'Biełaviežskaja pušča — nacyjanalny park na miažy Biełarusi i Polščy.',
    body_en: 'Belovezhskaya Pushcha is a national park on the border of Belarus and Poland. Home to European bison, wolves, lynx and hundreds of bird species. A UNESCO World Heritage Site.',
    body_uk: 'Біловезька пуща — національний парк на кордоні Білорусі та Польщі. Тут живуть зубри, вовки, рисі та сотні видів птахів.',
    body_zh_hans: '别洛韦日森林是位于白俄罗斯与波兰边境的国家公园，欧洲野牛、狼、猞猁和数百种鸟类的家园，被联合国教科文组织列入世界遗产名录。',
    body_zh_hant: '別洛韋日森林是位於白俄羅斯與波蘭邊境的國家公園，歐洲野牛、狼、猞猁和數百種鳥類的家園，被聯合國教科文組織列入世界遺產名錄。',
    published: true
  }
]

articles.each { |article_data| Article.create(article_data) }

puts "✅ Загружено статей: #{Article.count}"