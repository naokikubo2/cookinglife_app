# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  User.create!(
    name: "ゲスト",
    email: "email@guest.com",
    password: "0000guest",
    image: File.open("./db/fixtures/users/guest.jpg"),
    location_id: 1_850_147,
    address: '東京',
    latitude: 35.7090259,
    longitude: 139.7319925
  )

  2.upto(8) do |n|
    User.create!(
      name: "user#{n}",
      email: "email#{n}@com",
      password: n.to_s * 6,
      image: File.open("./db/fixtures/users/user#{n}.jpg"),
      location_id: 1_850_147,
      address: '東京',
      latitude: 35.7090259 + 0.001 * n,
      longitude: 139.7319925 + 0.001 * n
    )
  end
  9.upto(14) do |n|
    User.create!(
      name: "user#{n}",
      email: "email#{n}@com",
      password: n.to_s * 6,
      location_id: 1_850_147,
      address: '東京',
      latitude: 35.7090259 + 0.001 * n,
      longitude: 139.7319925 + 0.001 * n
    )
  end
  weather = [["clear sky", "01d"], ["few clouds", "02d"]]
  food = ["焼き菓子", "パン", "カレーライス", "シチュー", "春巻きなど", "お米", "アクアパッツァ", "幕内弁当", "焼肉", "ラーメン",
          "ステーキ", "豚カツ", "たこ焼き", "鶏肉のココナッツミルク煮", "鶏肉の甘煮", "ケンタッキーフライドチキン", "ホルモン焼肉", "麻婆豆腐", "サラダ", "火鍋",
          "カルボナーラうどん", "黒豆納豆ラーメン", "渡蟹のパスタ", "ナポリタン風焼きそば", "ハマトラ季節麺", "ハンバーガー","さわら", "牛カツ", "二郎汁なし", "豚山汁なし",
          "バターチキンカレー", "焼きとうもろこし", "いくら丼", "帆立の刺身", "エビのスープカレー", "イカのパスタ","親子丼", "焼き餃子", "煮込みハンバーグ", "厚切りの焼肉",
          "馬肉鍋", "九州とんこつラーメン"]
  time = ["morning", "lunch", "dinner", "snack"]
  tag = ["スイーツ", "パン", "米", "スープ", "エスニック", "米", "魚", "弁当", "肉", "麺",
         "肉", "肉", "粉物", "スープ", "肉", "肉", "肉", "中華", "野菜", "鍋",
         "麺", "麺", "麺", "麺", "麺", "ファストフード", "魚", "肉", "麺", "麺",
         "米", "野菜", "海鮮", "海鮮", "スープ", "麺", "米", "中華", "肉", "肉", "鍋", "麺"]
  1.upto(12) do |n|
    srand(n+1)
    FoodRecord.create!(
      user_id: 1,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  13.upto(30) do |n|
    srand(n+2)
    FoodRecord.create!(
      user_id: 1,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpeg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  31.upto(33) do |n|
    srand(n+3)
    FoodRecord.create!(
      user_id: 2,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpeg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  34.upto(36) do |n|
    srand(n+4)
    FoodRecord.create!(
      user_id: 3,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpeg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  37.upto(39) do |n|
    srand(n+5)
    FoodRecord.create!(
      user_id: 4,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpeg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  40.upto(42) do |n|
    srand(n+6)
    FoodRecord.create!(
      user_id: 5,
      food_name: "#{food[n-1]}",
      image: File.open("./db/fixtures/foods/food#{n}.jpeg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1],
      food_timing: time[rand(0..3)]
    ).tap do |f|
      f.tag_list.add tag[n-1]
      f.save
    end
  end

  # user1 は全ユーザをフォロし、他ユーザはuser1をフォロー
  2.upto(14) do |n|
    srand(n)
    Relationship.create!(
      user_id: 1,
      follow_id: n
    )
  end

  2.upto(14) do |n|
    srand(n)
    Relationship.create!(
      user_id: n,
      follow_id: 1
    )
  end
end

require "csv"

CSV.foreach('db/csv/cities.csv') do |row|
  City.create(
    name: row[0],
    location_id: row[1],
    lon: row[2],
    lat: row[3]
  )
end
