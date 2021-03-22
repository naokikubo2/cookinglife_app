[![CircleCI](https://circleci.com/gh/naokikubo2/cookinglife_app.svg?style=svg)](https://circleci.com/gh/naokikubo2/cookinglife_app)

# README

# CookingLife ー総合料理サポートアプリー

<img alt="アプリ概要" style="text-align: center;" src="https://user-images.githubusercontent.com/26429361/111942321-6978d500-8b16-11eb-9dca-7fd0df418a75.png">

# 作成経緯とアプリ概要
実家暮らしの私は、母親から毎日のように「今日何が食べたい？」と聞かれます。
しかし、適当に回答しても却下されてしまうので難しいという課題がありました。また、友人にも話を聞いてみると、同じ悩みを持った方が多いことが分かりました。
そこで開発したCookingLifeアプリは、過去に記録した料理から、今日食べたいと思いそうな料理をレコメンドしてくれます。つまり、「今日何が食べたい？」と聞かれた時に、アプリを見れば「今日はこれが食べたい」と的確に即答することが可能です。

毎日使用するアプリですので、モバイルファーストなデザインにし、料理画像をアップロードするだけでも多くの情報が記録できるよう設計しています。

また、料理を作る側の方にもメリットがあるよう、お裾分け機能を実装しています。ご近所同士で、本アプリを通してお裾分け連絡を取り合うことで、お裾分け料理詳細・待ち合わせ場所・日時を共有した上で、「もらう側」と「あげる側」がマッチングすることができます。

![アプリ説明](https://user-images.githubusercontent.com/26429361/111942305-6251c700-8b16-11eb-9a14-c3bd9b8f109e.jpeg)

# 使用例・解説

## TOPページ/レコメンド

<div style="text-align: center;">
  <img alt="レコメンド説明" src="https://user-images.githubusercontent.com/26429361/111975479-00a85180-8b44-11eb-9cda-d2361163068a.jpeg">
</div><br/>

## 料理記録(画像アップロード)
### 料理画像を解析
  - 料理以外はアップロード不可
  - タグを自動入力
- 天気情報は料理登録時に自動保存

![foodrecord登録](https://user-images.githubusercontent.com/26429361/111947679-456ec100-8b21-11eb-9f8f-3691ff04d1d9.gif)

### 詳細情報は、後から任意で入力可能
- グラフ表示

![foodrecord編集](https://user-images.githubusercontent.com/26429361/111947690-4acc0b80-8b21-11eb-8d65-20cbabe22d97.gif)


## 料理検索

![検索](https://user-images.githubusercontent.com/26429361/111944274-9f1fbd00-8b1a-11eb-8012-ad8e1a5dfbf9.gif)

## 料理お裾分け
### お裾分け料理の登録

![foodshare登録](https://user-images.githubusercontent.com/26429361/111975181-a5765f00-8b43-11eb-8498-82c8a6e30e38.gif)

### お裾分け料理の受け取り希望

![foodshare受け取り希望](https://user-images.githubusercontent.com/26429361/111941998-ba3bfe00-8b15-11eb-83bc-3fbd9ee93942.gif)


# ER図
rails-ERDを使用して出力

<img width="1016" alt="ER図" src="https://user-images.githubusercontent.com/26429361/111942330-6d0c5c00-8b16-11eb-95ba-812fd5e66dec.png">

# 制作期間
- 2020年11/26〜2021年3/19 (約4ヶ月)
- 設計書作成〜開発完了の期間
- 適宜改修予定
- AWSにデプロイ予定

# 開発手法
- プルリクを使った開発
- issue管理
- RSpecによるテスト駆動開発
- CircleCIによるpush時の自動テスト

## フロントエンド
- HTML
- SCSS
- webpacker
- bootstrap4
- Javascript

## バックエンド
- Ruby 2.6.6
- Ruby on Rails 6.0.3

## インフラ・開発環境
- Docker/docker-compose
- RSpec
- selenium
- capybara
- factory_bot
- CircleCI
- rubocop
- webmock

# ライブラリ
## タグ
- acts-as-taggable-on
## 検索
- ransack
## 画像アップロード
  - carrierwave (画像アップロード)
  - mini_magick (画像整形)
## デザイン
  - font-awesome
  - kaminari(ページネーション)
  - chart.js(グラフ表示)
  - drawer.js(横スライドメニュー表示)
  - datetimepicker(日時のカレンダー入力フォーム)

# 外部API
- OpenWeatherMap API (天気情報)
- Google Cloud Vision API (画像解析)
- Maps JavaScript API (GoogleMapを動的に使用)
- Geocoding API (住所・緯度経度の変換)
- Distance Matrix API (徒歩にかかる時間と距離表示)

# 機能一覧

## 料理記録機能
### 料理記録機能
- 画像アップロード
  - 画像を歪めずに正方形に整形
  - 画像プレビュー表示
### 料理画像解析機能
  - 料理画像プレビュー時に、画像解析
    - 料理かどうかの識別 ⇨ 料理以外の画像は投稿制限
    - タグを自動入力 ex) ラーメン画像ならば、「麺」というタグを自動入力
### 天気情報の取得
  - 画像保存時に自動的に居住地域の現在の天気を記録する
<hr/>

## 料理レコメンド・検索機能
### 独自アルゴリズムによるレコメンド
  - レコメンドの条件
    - 前日食べた料理の傾向(オイリーか手間がかかったか)と最も異なる料理
    - 前日食べた料理の主食が麺ならば麺以外の料理
    - 最近1週間の料理からは選ばない
- 天気情報を活用したレコメンド
  - 居住地域の現在の気温と最も近い日に食べた料理をレコメンド
<hr/>

## 料理お裾分け機能
- お裾分け募集機能
  - お裾分けされたい人を募集
  - 友達(相互フォローユーザ)の間でのみ使用可能
- お裾分け受け取り希望機能
  - お裾分け募集中の料理に対して、お裾分けを希望する(Ajax使用)
- GoogleMapの活用
  - 居住地域や、お裾分け待ち合わせ場所の表示
  - ピンを立てることによる、場所の指定
- 自宅から待ち合わせ場所への移動で徒歩でかかる時間と、距離を表示
- 「募集中」「お裾分け前」「完了」のラベルを表示
- お裾分け直前の料理(あげる方も、もらう方も)をTODOリストで表示
<hr/>

## 共通機能・その他
### レコメンド機能
- 前日の料理の傾向から分析した今日の料理のレコメンド
- 天気情報を用いた今日の料理のレコメンド
### ユーザー関連
- フォロー機能・友達機能
  - 相互フォロー状態を「友達」と判定する機能
- ゲストログイン機能
  - ポートフォリオ閲覧者用に、ワンクリックでログインできる機能
### いいね機能
- Ajaxで実装
### コメント機能
- Ajaxで実装

# アピールポイント
## テスト
- テストを136件作成
- 正常系、異常系、境界値分析の観点で作成
- 外部APIはモックを適宜作成し対応
- modelテスト、requestテスト、systemテストを作成
- CircleCIのテスト結果を、READMEのバッジで表示

## 実用性
- 毎日の使用を想定している
  - 1枚の画像を登録するだけで、「タグ」「天気情報」「日付」を自動保存
  - モバイルファーストデザイン
- 「今日何食べたい？」の返答に困るという課題に対し、独自アルゴリズムによるレコメンド・天気によるレコメンド・検索機能で多角的に解決

## QiitaやTwitterによる外部発信
- Qiita9件執筆、LGMT5件、ストック5件 <br/>
  https://qiita.com/engineer_ikuzou
- Twitterで毎日の積み上げを発信<br/>
  https://twitter.com/@engineer_ikuzou

# 苦労した点
- 画像アップロード時のライブラリ「MiniMagick」のエラーで、ローカルのテストを通過できるが、CircleCI上のテストを通過できない問題に直面
  ⇨ CircleCI上との環境差異を特定し、試行錯誤の末、circleci.ymlの変更で解決
  ⇨ qiita記事にまとめたところ1LGTMを獲得(自身のエラー解決方法を共有し、人の役に立てた)
下記参照。
https://qiita.com/engineer_ikuzou/items/ca419c6ec8369571279f

- テスト時、Goolge Cloud Vision API(画像情報を送信すると関連するタグが返るAPI)のモックを作成
### 概要
料理画像としてアップロードする画像を選択直後、Controllerから、Google Cloud Vision APIを呼び出し、画像に写った物体の名前をタグとして得る機能を追加した。しかしテスト時にエラーが発生。
### エラー詳細
Google::Cloud::Visionのモジュールを用いて、APIと通信している。このモジュールをwebmock(ライブラリ)でスタブ化すると、送信時の問題は解決できる。
しかし、受信時に、タグを受け取る際のメソッドもGoogle::Cloud::Visionのモジュールに記述されているためエラーとなる。
### 試み①APIへの知識が不足しているため、まずはインターネット記事を漁り、知識を深めつつ公式ドキュメントや参考になりそうな記事を探した。
Google Cloud Vision APIをモック化してテストしている記事がなく、失敗
### 試み②モジュールを読み解き、Googleモジュールのスタブ化を試みた
Google::Cloud::Vision.image_annotator(画像を送信する機能) の返却値をmockにするという方針
⇨responseとして受け取るjsonのタイプがやや特殊であることがわかった。(https://cloud.google.com/vision/docs/request参照)
responseを読み込むために、Googleモジュールが必須。しかし、Googleモジュールはスタブ化しており使用不可
### 試み③  ⇨  解決
controllerの中に、外部APIと連携する処理をメソッド化。メソッドのスタブを作成して対応。

### 学び
- Google Cloud Vision APIの複雑な処理をブラックボックス化せず理解して利用することができた。
- 参考になる記事が全く見つからない状況でも、自力で解決方法を考え模索することができた。
