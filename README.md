# RestaurantSearcher
Creating Restaurant App on MVC, Programmatically with Storyboard Using Swift 5.0+. Restaurant sample app can be built by Xcode 14.0 or later. Compatible with iOS 16.0+

### 作者
ティダーピョー

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
- 検索したレストラン一覧：一番近いメートルでソートして表示する。
- 電話アプリ連携：飲食店の電話番号を電話アプリに連携する(apiでお店の電話番号がないですが)
- 地図表示：Rangeを選択しないで検索したら300m以内のお店を表示する。好きなお店をタップするとお店の詳しい情報を表示する。

### 画面一覧
- 検索画面 ：条件を指定してレストランを検索する。
- ジャンル画面：genreのapiからのデータを表示する。
- エリア画面：large_areのapiからのデータを表示する。
- 画像のカルーセル：300m以内のデータをapiからfetchして画像のカルーセルで表示して、タップするとお店の詳しい情報を表示する。
- 一覧画面 ：検索結果の飲食店を一覧表示する。
- Maps画面：検索結果の飲食店をpinの代わりお店の画像で表示する。

### 使用しているAPI,SDK,ライブラリなど
- ホットペッパーグルメサーチAPI
- Alamofire

# Output
<div style="display: flex; justify-content: center;">
  <div style="display: flex;">
    <img width="352" alt="1" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/1c8edfa5-0790-4983-aff5-05d9530bcd70">
    <img width="352" alt="2" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/9cc0c4be-330c-48a5-ae32-eaf1453ac0a4">
  </div>
  <div style="display: flex;">
    <img width="352" alt="3" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/2dd8b4fe-3565-4d2f-a666-7258944fa29c">
    <img width="352" alt="4" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/15441d28-1e3a-429e-8cea-b73dc0762125">
  </div>
  
  <div style="display: flex;">
    <img width="352" alt="5" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/127971e1-73f8-46f0-9f12-f503b136b969">
    <img width="352" alt="6" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/56dbfebb-3e32-4ded-aa45-5041c5a4e0a6">
  </div>

  <div style="display: flex;">
    <img width="356" alt="7" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/57828158-d6bb-4846-9394-0c5c53324c45">
    <img width="356" alt="8" src="https://github.com/ThidarPhyo/RestaurantSearcher/assets/46513687/2a94633e-a68b-4e91-8753-25ade34c2bba">
  </div>
</div>


