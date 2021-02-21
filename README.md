# タスク管理アプリ『MyDailyLife』  
  
![MyDailyLife-top](https://user-images.githubusercontent.com/72852271/105488294-bb5ad580-5cf4-11eb-83c4-c8f70031b7e2.gif)  
　
　
# :link:App URL  
  
### Heroku(git:mainブランチ)　**https://my-daily-life.herokuapp.com/**  
### AWS(git:masterブランチ)　**http://ec2-54-168-75-205.ap-northeast-1.compute.amazonaws.com/**  (※NOT!https)
　
  
# :pencil:サービス概要
### MyDailyLifeは大きく分けて「タスク(＋コメント)」と「メモ」をユーザー毎に作成・管理できるアプリです。
  
## メインサービス :dizzy:  
### ・タスク管理機能  
タスクは「食事関連」と「その他」の2種類のカテゴリーに分けて管理されます。  
「食事関連」はシンプルに管理できるようにあらかじめ用意されている「朝食」「昼食」など7種類のタグのみ、「その他」は各ユーザーが自由にタグを作成して管理できるようになっています。  
どちらもタグ以外の条件でも検索でき、日付・言葉などで目当てのタスクを探し出すことが可能です。  
基本的には既に起きた出来事を後から記録していくことをイメージして作った機能になります。  
  
**【主な導入技術】  
・タスク内のリンク自動検出(rinku)  
・「その他」タグの作成・編集・削除(Ajax)  
・タスク・タグの検索(Ransack)  
・ページネーション (kaminari)**  
　
#### - タスク機能イメージ(ページネーション 、検索)  
![タスク機能紹介](https://user-images.githubusercontent.com/72852271/105574662-52816500-5da9-11eb-9990-9302320d5f0a.gif)  
　
#### - その他タグ機能・タスク作成イメージ(Ajax、リンク自動検出)  
![その他タスク紹介](https://user-images.githubusercontent.com/72852271/105574931-14854080-5dab-11eb-90c2-b6dbcc70beac.gif)  
　
  
  
### ・コメント機能  
タスク毎に詳細ページにコメント欄が付いていて、コメント・画像を投稿できます。  
このコメント機能は本サービスの特徴的な機能で、コメントを投稿した日時がわかるようになっているため、時間経過で変化した事や後から補足した内容が何時のものなのかわかりやすく記録できるようになっています。  
使う機会は限られている機能かもしれませんが、役立つ場面がきっとあると思います。  
元々はLINEで自分一人だけのグループを作り、気に入った動画や、後でみたい記事などをとりあえずメモのように投稿していたところから発想を得て作った機能です。(Slackの自分へのダイレクトメッセージをメモとして活用する事と似ているかもしれません。)  
  
**【主な導入技術】  
・コメント内のリンク自動検出(rinku)  
・コメントの作成・編集・削除(Ajax)  
・コメント(画像)の投稿・削除(Active Storage、Ajax、AWS S3)  
・コメント(画像)の拡大(原寸大)表示機能(lightbox2)**  
  
#### - コメント機能イメージ  
![コメント機能紹介](https://user-images.githubusercontent.com/72852271/105575249-92e2e200-5dad-11eb-9498-990c0eb24c2f.gif)  
　
　
  
### ・メモ管理機能  
タスクと似た機能ですが、「タイトル」と「詳細」だけのシンプルな記録機能となっており、ユーザーページから利用できます。  
こちらは既に起きた出来事を記録すると言うよりは、名前の通り「メモ」として覚えておきたい事柄を書き留めておくことを想定しています。  
  
**【主な導入技術】  
・メモ内のリンク自動検出(rinku)  
・メモの作成・編集・削除(Ajax)  
・メモの検索(Ransack)  
・ページネーション (kaminari)**  
  
#### - メモ機能イメージ  
![メモ機能紹介](https://user-images.githubusercontent.com/72852271/105577188-50280680-5dbb-11eb-8f6a-b3b1e71c275d.gif)  
　
　
  
##  製作者のお気に入り機能 :two_hearts:  
### ・テストユーザーログイン  
ワンクリックでテストユーザーとしてログインできる機能は珍しくないかと思いますが、  
MyDailyLifeではテストユーザーがログイン中に作成したタスクやタグなどがログアウト時に全て自動的に削除されるようになっています。(セッションタイムアウトとなった場合でも削除されます。)  
またユーザー情報や一部デフォルトで用意されているタスクなどは編集・削除ができないようにしています。  
  
この機能は以下の理由で実装しました。  
1.本アプリをお試しいただく時の条件がいつでも同じになるようにするため  
2.ユーザーがテストログインした時に他のユーザーの使用した痕跡を見ることがないようにするため  
3.テストログインして、機能を試すために作ったタスクなどの痕跡をわざわざ削除する手間を省くため  
　
###  ・二重ログイン防止機能(自作)、セッションタイムアウト機能(自作。ページ遷移のタイミングで計測)  
アプリ製作の中盤〜終盤に二重ログイン防止機能とセッションタイムアウト機能を追加したいと、deviseやsorceryの導入を試みるも既にログイン機能が出来上がっているからか(ログイン機能実装済みでも導入する方法なども調べて試しましたが)、上手く動作してくれず、実装したい機能は前述の2つのみなのでそれっぽい機能を自作してみようと試行錯誤して実装したので、Gem導入よりは機能として不完全かと思いますがお気に入りの機能のひとつです。  
　
  
### ・お問い合わせフォーム(Ajax、Action Mailer、slack-api)  
全ページに共通して右下にお問い合わせボタンが表示されます。  
クリックすると、お問い合わせフォームがモーダル 表示されるようになっていて、Ajaxで送信されます。  
お問い合わせ内容はメールで送信されるとともに、Slackにお問い合わせがあったことを自動的に通知してくれます。  
  
#### - お問い合わせイメージ  
![お問い合わせ機能紹介](https://user-images.githubusercontent.com/72852271/105577500-6b941100-5dbd-11eb-968d-d843e20fa19e.gif)  
　
　
  
## その他の機能・導入技術 :speech_balloon:  
**・カレンダー機能(simple-calendar)  
・ページトップに戻るボタン(Ajax)  
・Topページのスライダー(swiper)  
・adminユーザーのみアクセス可能なユーザー管理・利用履歴確認画面  
・初期データの作成(seed-fu)  
・Herokuに自動テスト＆自動デプロイ（Circleci）  
・AWSにデプロイ(Capistrano)  
・テスト(Rspec、Capybara、factory_bot)  
・コードチェック(rubocop)  
・データベース(Heroku：postgreSQL、開発環境・テスト環境・AWS：MySQL)  
・デプロイ(Nginx、puma)**  
　
#### - その他のページイメージ(カレンダー(月別・日別)、ユーザー管理画面、利用履歴確認画面)  
![その他紹介](https://user-images.githubusercontent.com/72852271/105578269-3ccc6980-5dc2-11eb-8452-1aa2518ae483.gif)  
　
　
  
#  :earth_asia:開発環境  
・OS：macOS Catalina  
・使用言語・フレームワーク：Ruby 2.5.8、Rails 5.2.4.4(Slim)、jQuery、HTML、CSS   
・データベース：MySQL 8.0.22 (+ データ確認用：Table Plus)  
・エディター：Visual Studio Code  
・バージョン管理：Git 2.24.3 (+ 確認用：Sourcetree)  
Table PlusとSourcetreeはどちらも主に登録内容の確認のために用いました。    
  
## ER図  
![erd](https://user-images.githubusercontent.com/72852271/105577795-11944b00-5dbf-11eb-8ae4-8816612a378a.jpg)  
　
　
  
#  :bulb:作る上で意識した事  
  
**・"Done is better than perfect."**  
プログラミングを独学し始めて一番自分に言い聞かせている言葉です。  
未経験の素人のため、細かいところまで完璧にすること・完璧に理解してから進めることよりも、まずは自分が構想したアプリケーションを０から形にして「とりあえず公開して使ってもらえる状態のもの」にすることを優先して進めました。  
そのためRailsのバージョンがRails5だったり、一部最新・現在主流とされている技術でないものを使用していたりします。  
ただし「自分が使いたいタスク管理アプリ」として想定した機能は全て実装しました。 　
　
  
**・まずは自己満足なアプリを作る**  
出発点が「自分が使いたいタスク管理アプリを作る」だったので、食事・その他タスクとメモという似たような機能なのにわざわざ分けたりコメント機能を作ってみたりなど、特に機能については自分が求めているものを盛り込むことを重視して、世の中のニーズに応えるというよりはユーザーとして自分が満足できるものを目指しました。  
一通り完成した後、家族に試用してもらい、フィードバックを反映してUIなどの改善を行いました。  
　
  
**・使いやすさ**  
タスク管理アプリ作成はRailsの学習教材としても使われているほどありふれた題材で、MyDailyLifeもベースはそれらを参考にしています。  
そのためデザインを含め、パッと興味を引けるオリジナリティーがあるかは自信がありませんが、ページネーションや検索機能、画像拡大機能など、モダンなwebページに当たり前のようにある機能は盛り込むようにし、  
タグやコメント(画像含む)などの作成・編集・削除、お問い合わせをAjaxにしてページ遷移を減らし、  
素人なりになるべくモダンなwebページのような使い勝手を目指しました。  
　
  
**・テストコードを書いてみる**  
正直なところテストについての理解はとても浅いです。  
モデル・結合テストなどの使い分けを理解するよりもとりあえずテストを書こう！と思い、本アプリのテストはほぼ全てSystem Specに記述しています。  
Rspec、Capybara、factory_botを用いて、タスクなどの作成、編集、削除、検索機能など基本的な挙動についてのテストはなるべく書いてみるようにしました。  
　
　
  
### なぜタスク管理アプリなのか  
MyDailyLifeは日々の食事内容を記録するものが欲しいという思いから構想を練って作ったポートフォリオ用webアプリです。  
タスク管理アプリはポートフォリオとしてありふれた題材かもしれないですが、食事内容を記録できるアプリを探してみるとカロリーなどを細かく管理するダイエット用のアプリが多くシンプルに食べたもの・書きたいことを記録できるものは少なかったので、自分が使いたい機能を盛り込んでタスク管理アプリを作ってみようと思い立ち開発しました。  
  
タスク管理アプリとしてMyDailyLifeで特徴的な機能はコメント機能かと思いますが、  
コメントは食後や薬の服用後の時間経過での変化をタスクに紐付けて手軽に記録していけたら便利だと思い実装してみた機能になります。  
　
 
### 今後の改善点  
・タグ毎に背景色を選べるようにする。  
・ログインユーザーはアプリのテーマカラーを選べるようにする。  
・ときどき想定外の挙動をするAjaxの原因を解明し改修する。  
(※Topページの写真は全て自分で撮影したものです。万が一の転用防止のため低画質にしています。）
  
