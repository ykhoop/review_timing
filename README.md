# review_timing

### ■ サービス概要
***
学習内容をすぐに忘れてしまう、学習内容を効率よく覚えたいと考えている人に  
記憶への定着作業である復習の効率化を提供する  
復習タイミング可視化サービスです。

### ■ メインのターゲットユーザー
***
学習を効率化したい、学習内容の記憶への定着を無駄なく行いたいと考えている人
主には、学習時間をあまり確保できないと考えられる社会人
学習対象は資格試験を想定  

### ■ ユーザーが抱える課題
***
学習や読書を行っても内容をすぐに忘れてしまう。記憶に定着しない。  
時間の無駄なく、効率よく復習したい。

### ■ 解決方法
***
学習した日時を登録すれば、次回以降の効率よく復習できる日時を自動で表示する。  
表示する日時は、エビングハウスの忘却曲線やカナダのウォータールー大学が発表した[『Curve of Forgetting(忘却曲線)』](https://uwaterloo.ca/campus-wellness/curve-forgetting)という研究結果を元に算出する。  
表示された日時で復習することで、記憶定着の効率化を図る。

### ■ 実装予定の機能
***
* 一般ユーザー
  * ユーザーがサインアップすることができる
  * ユーザーがログインすることができる
  * ユーザーが学習内容を登録、編集、削除することができる
  * ユーザーが学習内容を学習した日時を登録、編集、削除することができる
  * ユーザーの次回復習予定日時が自動で決定される
  * ユーザーが次回復習予定日時を学習内容一覧で参照できる
  * ユーザー自身でも任意で次回復習予定日時を登録、編集、削除することができる
  * ユーザーが学習内容を復習した日時を登録、編集、削除することができる
  * ユーザーが学習期限日時を登録、編集、削除することができる
  * ユーザーは復習予定日時が到来したタイミングでリマインドメールを受け取ることができる
  * ユーザーは復習予定日時が到来したタイミングでリマインドのLINE通知を受け取ることができる
  * （ユーザーは復習予定日時が到来したタイミングでブラウザプッシュ通知を受け取ることができる）
  * （ユーザーは復習予定日時をGoogleカレンダーに登録できる）

* 管理ユーザー
  * ユーザーの検索、一覧、詳細、登録、編集、削除
  * 一般ユーザーの学習内容の登録件数の一覧表示
  * 管理ユーザーが次回復習予定日時を自動決定する期間デフォルト値を設定できる

### ■ なぜこのサービスを作りたいのか
***
学習や読書をした時、当日は内容を覚えているが、時間が経つとすっかり内容を忘れてしまっている、という経験をしている。同じような経験のある人は多いように思う。  
復習して覚えたいと思うが、復習のタイミングが遅くなると、もう一度一から学習し直さないといけないほど忘れてしまっている時がある。  
こういったことをできるだけなくしたい、また復習の時間をできるだけ短縮したい、という思いから開発する。

### ■ スケジュール
***
1. 企画（アイデア企画・技術調査）：2/19〆切 　
2. 設計（README作成・画面遷移図作成・ER図作成）： 3/2 〆切
3. メイン機能実装：3/3 - 3/26
4. MVPリリース：4/9
5. 本リリース：4/16

### ■ 画面遷移図
***
Figma:  
https://www.figma.com/file/ras7E1fDWebodv09yrNomi/review_timing?node-id=0%3A1&t=gI0KeiudXL9L2Op3-1
