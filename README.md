# Lightning Web コンポーネント(LWC)でいいね！ボタンを作成してみた。  
* 他の人が作成したレコードに「👍いいね！」できればいいなーと思い、今回LWCでいいね！ボタンを作成してみました！  
* 入力したデータに「いいね！」がされるとモチベーションが上がりユーザーのデータ入力の促進になるかも！？📝  

# イメージ  
![画面イメージ](/docs/screen_image.png)  
| いいね！なし（0件） | いいね！あり（1件）|  
| --- | --- |  
| ![いいね！なし（0件）](/docs/no_like.png) | ![いいね！あり（1件）](/docs/one_like.png) |  

| 複数ユーザーがいいね！を押した時のアイコン表示 | アイコンの表示件数を制限（画像はプログラムにて3件に制限） |  
| --- | --- |  
| ![複数いいね！](/docs/multiple_likes.png) | ![アイコンの表示制限](/docs/icon_display_restrictions.png) |  

| いいね！を押したユーザーの一覧画面へのリンク（画像はプログラムにて3件に制限） | いいね！を押したユーザーの一覧画面 |  
| --- | --- |  
| ![複数いいね！](/docs/openlikeButtonWhoClicked.png) | ![アイコンの表示制限](/docs/openlikeButtonWhoClickedModal.png) |  

# 準備と前提条件  
## カスタムオブジェクト作成
| 表示ラベル | API 参照名 |  
| --- | --- |  
| いいね | Like__c |  

## 項目作成
| 表示ラベル | API 参照名 | データ型 | 詳細 |  
| --- | --- | --- | --- |  
| いいね名 | `Name` | 自動採番 | ■表示形式</br>`like-{00000000}` |  
| User | `User_Id__c` | 参照関係(ユーザー) | ■子リレーション名</br>`User_Ids` |  
| Target_Id_String | `Target_Id_String__c` | テキスト(255) | - |  
| Target_Record_Url | `Target_Record_Url__c` | 数式 (テキスト) | ■数式</br>`HYPERLINK(LEFT($Api.Partner_Server_URL_350 ,FIND("/services/Soap/", $Api.Partner_Server_URL_350))& Target_Id_String__c, "レコードへ遷移")` |  

## いいね！ボタン（likebuttonコンポーネント）の配置  
配置手順は下記2つ  
* Lightning アプリケーションビルダー  
  * 設定 → ユーザーインターフェース → Lightning アプリケーションビルダー  
    * 配置したいレコードページを編集してlikebuttonコンポーネントをお好みの場所に配置。  
* 配置したいオブジェクトの「Lightning レコードページ」  
  * 設定 → オブジェクトマネージャー → 配置したいオブジェクト選択 → Lightning レコードページ  
    * 対象のレコードページを編集してlikebuttonコンポーネントをお好みの場所に配置。  

※下記画像は、**取引先オブジェクト**のLightning レコードページの画面右側にlikebuttonコンポーネントを配置しています。  
![イメージ](/docs/lightning_application_builder.png)  

# 機能と特徴  
## いいね！ボタン（likebuttonコンポーネント）
* ユーザーは、レコードごとに「いいね！」をすることができます。  
  * いいね！を押したユーザーの件数とアイコンがボタン下部に表示されます。  
* 「いいね！」ボタン押下後は、「いいね！済み」ボタンに切り替わります。  
  * 「いいね！済み」ボタンを押下すると、いいねを取り消すことができ、ボタンは再度「いいね！」に切り替わります。  
* 画面に表示されるアイコンの件数の制限をしています。  
  * アイコンの表示件数が多いと画面を占領してしまうため。  
  * 初期設定は、**10件**にしています。  
> [!NOTE]
> 下記Apexクラスでアイコンの表示件数を制御しています。  
> ※件数を変更したい場合は、数字を変更してください。  
> ■*LikeButtonController.cls*  
> ```
> private static Integer MAX_DISPLAY_ICON = 10;
> ```

## いいねオブジェクト・いいねレコード
![イメージ](/docs/like_record.png)  
* ユーザーが「いいね！」をするとプログラムにより、上記画像のようにいいねレコードが作成されます。  
  * いいね名：`Name`  
    * 自動採番型のため自動で設定されます。  
  * User：`User_Id__c`  
    * いいね！を押したユーザーのID（参照項目）が設定されます。  
  * Target_Id_String：`Target_Id_String__c`  
    * ユーザーがいいね！を押したレコードのID（テキスト項目）が設定されます。  
  * Target_Record_Url：`Target_Record_Url__c`  
    * いいね！を押したレコードのIDをテキストで保持しているため、対象のレコードへ遷移するためのリンクを便利機能として数式で作成しています。  
* いいね！の取り消し及び「いいね！済み」ボタンを押下するとプログラムにより、いいねレコードが削除されます。  

> [!NOTE]  
> ●Target_Id_String：`Target_Id_String__c`  
> いいね！ボタン（likebuttonコンポーネント）が、どのオブジェクトのレコードページに配置されても良いように、
> リレーション項目ではなく、テキスト項目でレコードIDを保持しています。  

> [!CAUTION]
>  **いいね！されるレコードは容易に削除されることはないだろう**という考えのため、今回のアーキテクチャ（テキスト項目でレコードIDを保持）にしています！  
> 万が一、いいね！を押したレコード自体が削除された場合、いいねレコードが宙ぶらりんの状態になってしまいます😥  
> ※上記のようなデータをメンテナンスするプログラムは、今回用意できておりません🙇‍♂️  
> 必要な場合は、作成をお願い致します🙇‍♂️  


# ER図
![ER図](/docs/er_diagram.png)  

# ディレクトリ構成
```
force-app
└─main
    └─default
        ├─classes
        │      LikeButtonController.cls
        │      LikeButtonController.cls-meta.xml
        │      LikeButtonControllerTest.cls
        │      LikeButtonControllerTest.cls-meta.xml
        │
        └─lwc
            ├─likeButton
            │      likeButton.html
            │      likeButton.js
            │      likeButton.js-meta.xml
            │
            └─likeButtonWhoClickedModal
                    likeButtonWhoClickedModal.html
                    likeButtonWhoClickedModal.js
                    likeButtonWhoClickedModal.js-meta.xml
```
