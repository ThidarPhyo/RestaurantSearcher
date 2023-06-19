# 簡易仕様書
Creating Restaurant App on MVC, Programmatically with Storyboard Using Swift 5.0+. Restaurant sample app can be built by Xcode 14.0 or later. Compatible with iOS 16.0+

### アプリ名
RestaurantSearcher

### 作者
ティダーピョー

#### コンセプト
- 美味しそうな画像で店舗を選べる。
- レストラン検索画面：近くの飲食店の画像を表示し、美味しそうに感じた画像で検索が出来る機能を実装。
- 地図上での表示：検索結果を地図上に表示しますが、結果もピン表示ではなく、画像でユーザに選びやすいようにしました。

#### こだわったポイント
- 飲食店の検索条件を豊富に選択できるようにしました。
- 料理のジャンル: ユーザーは、和食、洋食、中華、イタリアンなど、さまざまな料理ジャンルから選択できます。個々のジャンルをさらに細分化して、ラーメン、ベジタリアンなど、より具体的な料理に絞り込むこともできます。
- エリア検索機能: ユーザーは検索バーにエリア名（例: 東京、神奈川）を選択することで、そのエリアに関連する飲食店を検索できます。
- 現在地から300メートル以内の検索結果を、Image Carousel（画像のカルーセル）で表示し、タップすると店舗の詳細なリストが表示されるようにします。
- Maps画面で画像 , 店名, 営業時間をAnotationで表示しました。タップしたら飲食店の詳しい情報を表示しました。

####  デザイン面でこだわったポイント
- 検索結果一覧をCardViewとして表示し、各データを見やすくしました。
- カードのデザインには、情報を整理しやすくするための適切なマージン、パディング、フォントサイズ、色彩を使用しました。
- カード内には、店舗の画像、名称、営業時間などの情報を含め、わかりやすく表示しました。
- 画像のカルーセルは自動的に切り替えることも、Manualで切り替えることもできるようにしました。
- Maps画面の検索結果はピンの代わりにお店の画像で場所を表示しました。
- 見やすさを考えて、Tab barのサイズをデフォルトのサイズから少し大きくしました。タップしたときもアイコンにAnimationを利用してタップしたことがわかりやすいようにしました。

### 該当プロジェクトのリポジトリ URL（GitHub,GitLab など Git ホスティングサービスを利用されている場合）
https://github.com/ThidarPhyo/RestaurantSearcher

## 開発環境
### 開発環境
Xcode 14.3.1

### 開発言語
Swift 5.1

## 動作対象端末・OS
### 動作対象OS
iOS 16.0

## 開発期間
14日間

## アプリケーション機能

### 機能一覧
- レストラン検索：ホットペッパーグルメサーチAPIを使用して、現在地周辺の飲食店を検索する。
- レストラン情報取得：ホットペッパーグルメサーチAPIを使用して、飲食店の詳細情報を取得する。お店の画像をタップしたらpopupで画像を表示する。
- 検索したレストラン一覧表示：距離を昇順でソートして表示する。
- 地図表示：Rangeを指定して飲食店を検索できる。Rangeを指定しないで検索したら300m以内のお店を表示する。検索結果はピンの代わりに画像で表示され、好きなお店をタップするとお店の詳しい情報を表示する。
- 近くの飲食店を画像で選ぶ機能：ホットペッパーグルメサーチAPIを使用して、300m以内のお店データの画像を検索し、カルーセル表示する。

### 画面一覧
- 検索画面 ：条件を指定してレストランを検索する。
- ジャンル画面：genreのapiからのデータを表示する。
- エリア画面：large_areaのapiからのデータを表示する。
- 一覧画面 ：検索結果の飲食店を一覧表示する。
- Maps画面：検索結果の飲食店をpinの代わりお店の画像で表示する。
- 飲食店の詳細画面：飲食店の詳細情報を表示する。
- launch画面：起動時の画面。アニメーションをつけました。

### 使用しているAPI,SDK,ライブラリなど
- ホットペッパーグルメサーチAPI
- Alamofire
- SwiftyGif

### アドバイスして欲しいポイント
- MapsのAnnotation表示の見た目、Rangeを選択するためDropdownかPickerか知りたいです。
- Search tab bar のViewをScroll Viewでしたら良いか知りたいです。

### 自己評価
Map関連が未経験で思ったよりも実装に時間がかかりました。
さらに使いやすさを考えると以下の２つの機能を追加したかったです。
・現在地からお店までのルート検索
・多言語対応
今後も努力を重ねて、より満足度の高い結果を提供できるように取り組んでいきます。

# Output
<div style="display: flex; justify-content: center;">
  <div style="display: flex;">
    <img width="200" alt="1" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/1c8edfa5-0790-4983-aff5-05d9530bcd70">
    <img width="200" alt="2" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/9cc0c4be-330c-48a5-ae32-eaf1453ac0a4">
    <img width="200" alt="3" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/2dd8b4fe-3565-4d2f-a666-7258944fa29c">
    <img width="200" alt="4" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/15441d28-1e3a-429e-8cea-b73dc0762125">
  </div>
  
  <div style="display: flex;">
    <img width="200" alt="5" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/127971e1-73f8-46f0-9f12-f503b136b969">
    <img width="200" alt="6" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/56dbfebb-3e32-4ded-aa45-5041c5a4e0a6">
    <img width="200" alt="7" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/57828158-d6bb-4846-9394-0c5c53324c45">
    <img width="200" alt="8" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/2a94633e-a68b-4e91-8753-25ade34c2bba">
</div>


