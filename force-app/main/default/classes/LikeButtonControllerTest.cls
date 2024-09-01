@isTest
public with sharing class LikeButtonControllerTest {

	/**
	 * ■正常パターン
	 * 「いいね！」ボタンを押下ケース
	 */
	@isTest
	public static void onClickLikeTest(){

		//ユーザーを1件作成
		List<User> users = createUser('システム管理者', 1);
		insert users;

		//取引先を1件作成
		List<Account> accounts = createAccount(1);
		insert accounts;

		Test.startTest();
			LikeButtonController.LikeResult ls = LikeButtonController.onClickLike(accounts.get(0).Id, users.get(0).Id);
		Test.stopTest();

		System.assertEquals(1, ls.totalLikeCount);
		System.assertEquals(1, ls.displayLikeResult.size());
		System.assertEquals(false, ls.overLimit);
	}

	/**
	 * ■正常パターン
	 * 「いいね！済み」ボタンを押下ケース
	 */
	@isTest
	public static void onClickCancelLikeTest(){
		Profile prof = [Select Id from Profile Where Name = 'システム管理者'];

		//ユーザーを1件作成
		List<User> users = createUser('システム管理者', 1);
		insert users;

		//取引先を1件作成
		List<Account> accounts = createAccount(1);
		insert accounts;

		Test.startTest();
			LikeButtonController.LikeResult ls = LikeButtonController.onClickLike(accounts.get(0).Id, users.get(0).Id);
			LikeButtonController.LikeResult lsDel = LikeButtonController.onClickCancelLike(accounts.get(0).Id, users.get(0).Id);
		Test.stopTest();

		System.assertEquals(0, lsDel.totalLikeCount);
		System.assertEquals(0, lsDel.displayLikeResult.size());
		System.assertEquals(false, lsDel.overLimit);
	}

	/**
	 * ■正常パターン
	 * アイコンの画面表示制限件確認。
	 * 制限件数内ケース、10件いいね！
	 * （ロジック側の定数で制限を10件に設定にしている）
	 */
	@isTest
	public static void iconDisplayTest01(){

		//ユーザーを10件作成
		List<User> users = createUser('システム管理者', 10);
		insert users;

		//取引先を1件作成
		List<Account> accounts = createAccount(1);
		insert accounts;

		Test.startTest();
			List<LikeButtonController.LikeResult> result = new List<LikeButtonController.LikeResult>();
			for(Integer k = 0; k <= 9; k++){
				result.add(LikeButtonController.onClickLike(accounts.get(0).Id, users.get(k).Id));
			}
		Test.stopTest();

		System.assertEquals(10, result.get(9).totalLikeCount);
		System.assertEquals(10, result.get(9).displayLikeResult.size());
		System.assertEquals(false, result.get(9).overLimit);
	}

	/**
	 * ■正常パターン
	 * アイコンの画面表示制限件確認。
	 * 制限件数オーバー、11件いいね！
	 * （ロジック側の定数で制限を10件に設定にしている）
	 */
	@isTest
	public static void iconDisplayTest02(){

		//ユーザーを11件作成
		List<User> users = createUser('システム管理者', 11);
		insert users;

		//取引先を1件作成
		List<Account> accounts = createAccount(1);
		insert accounts;

		Test.startTest();
			List<LikeButtonController.LikeResult> result = new List<LikeButtonController.LikeResult>();
			for(Integer k = 0; k <= 10; k++){
				result.add(LikeButtonController.onClickLike(accounts.get(0).Id, users.get(k).Id));
			}
		Test.stopTest();

		System.assertEquals(11, result.get(10).totalLikeCount);
		System.assertEquals(10, result.get(10).displayLikeResult.size());
		System.assertEquals(true, result.get(10).overLimit);
	}

	/**
	 * ■正常パターン
	 * モーダル「いいね！と言っているユーザー」表示ケース
	 */
	@isTest
	public static void openlikeButtonWhoClickedModalTest(){
		Profile prof = [Select Id from Profile Where Name = 'システム管理者'];

		//ユーザーを20件作成
		List<User> users = createUser('システム管理者', 20);
		insert users;

		//取引先を1件作成
		List<Account> accounts = createAccount(1);
		insert accounts;

		Test.startTest();
			List<LikeButtonController.LikeResult> result = new List<LikeButtonController.LikeResult>();
			for(Integer k = 0; k <= 19; k++){
				LikeButtonController.onClickLike(accounts.get(0).Id, users.get(k).Id);
			}
			result.add(LikeButtonController.openlikeButtonWhoClickedModal(accounts.get(0).Id));
		Test.stopTest();

		System.assertEquals(20, result.get(0).displayLikeResult.size());
	}


	/**
	 * ■異常パターン
	 * 「いいね！」ボタンを2回押下したケース
	 */
	@isTest
	public static void likePressTwiceTest(){

			//ユーザーを1件作成
			List<User> users = createUser('システム管理者', 1);
			insert users;

			//取引先を1件作成
			List<Account> accounts = createAccount(1);
			insert accounts;

			Test.startTest();
			try {
				LikeButtonController.LikeResult ls01 = LikeButtonController.onClickLike(accounts.get(0).Id, users.get(0).Id);
				LikeButtonController.LikeResult ls02 = LikeButtonController.onClickLike(accounts.get(0).Id, users.get(0).Id);
			} catch (Exception e) {
				System.assertEquals('既に「いいね！済み」です。', e.getMessage());
			}
			Test.stopTest();
	}


	/**
	 * ■異常パターン
	 * 「いいね！済み」ボタンを2回押下したケース
	 */
	@isTest
	public static void CancelLikePressTwiceTest(){

			//ユーザーを1件作成
			List<User> users = createUser('システム管理者', 1);
			insert users;

			//取引先を1件作成
			List<Account> accounts = createAccount(1);
			insert accounts;

			Test.startTest();
			try {
				LikeButtonController.LikeResult ls = LikeButtonController.onClickLike(accounts.get(0).Id, users.get(0).Id);
				LikeButtonController.LikeResult lsDel01 = LikeButtonController.onClickCancelLike(accounts.get(0).Id, users.get(0).Id);
				LikeButtonController.LikeResult lsDel02 = LikeButtonController.onClickCancelLike(accounts.get(0).Id, users.get(0).Id);
			} catch (Exception e) {
				System.assertEquals('「いいね！」の記録がありません。', e.getMessage());
			}
			Test.stopTest();
	}


	//ユーザーデータ作成
	static List<User> createUser(String profileName, Integer num){
		Profile prof = [Select Id from Profile Where Name = 'システム管理者'];

		List<User> userList = new List<User>();
		for (Integer i = 1; i <= num; i++) {
			userList.add(new User(
				LastName = 'Asan',
				Alias = 'AsanUser',
				Email = 'asan@test.com',
				EmailEncodingKey = 'ISO-2022-JP',
				UserName = 'asan'+i+'@test.com',
				ProfileId = prof.Id,
				LanguageLocaleKey = 'ja',
				LocaleSidKey = 'ja_JP',
				TimeZoneSidKey = 'Asia/Tokyo'
			));
		}
		return userList;
	}

	//取引先データ作成
	static List<Account> createAccount(Integer num){
		List<Account> accList = new List<Account>();
		for (Integer j = 1; j <= num; j++) {
			accList.add(new Account(
				Name = 'test'+j
			));
		}
		return accList;
	}
}