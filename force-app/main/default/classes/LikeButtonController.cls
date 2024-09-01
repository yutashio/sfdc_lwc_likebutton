public with sharing class LikeButtonController {

	//カスタム例外
	private class CustomException extends Exception {}

	//アイコン表示件数
	private static Integer MAX_DISPLAY_ICON = 10;

	@AuraEnabled
	public static LikeResult init(String recordId, String userId){
		try {
			List<Like__c> likedlist= [SELECT Id, Target_Id_String__c, User_Id__c, User_Id__r.SmallPhotoUrl, User_Id__r.Name FROM Like__c WHERE Target_Id_String__c =: recordId];

			LikeResult likeResult = new LikeResult();
			for(Like__c lk : likedlist){
				if(lk.User_Id__c == userId){
					likeResult.alreadyLiked = true;
					break;
				}else{
					likeResult.alreadyLiked = false;
				}
			}

			List<Like__c> displayLikeResultList = new List<Like__c>();
			if(likedlist.size() > MAX_DISPLAY_ICON){
				for (integer i = 0; i <= MAX_DISPLAY_ICON-1; i++) {
					displayLikeResultList.add(likedlist.get(i));
				}
				likeResult.overLimit = true;
			}else {
				displayLikeResultList.addAll(likedlist);
				likeResult.overLimit = false;
			}

			likeResult.totalLikeCount = likedlist.size();
			likeResult.displayLikeResult = displayLikeResultList;
			return likeResult;
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	@AuraEnabled
	public static LikeResult onClickLike(String recordId, String userId){
		try {
			List<Like__c> alreadyLikedList= [SELECT Id FROM Like__c WHERE Target_Id_String__c =: recordId AND User_Id__c =: userId];
			if(alreadyLikedList.size() > 0){
				throw new CustomException('既に「いいね！済み」です。');
			}else {
				Like__c liked = new Like__c();
				liked.User_Id__c = userId;
				liked.Target_Id_String__c = recordId;
				insert liked;
			}

			LikeResult likeResult = init(recordId, userId);
			return likeResult;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	@AuraEnabled
	public static LikeResult onClickCancelLike(String recordId, String userId){
		try{
			List<Like__c> cancelLikeList= [SELECT Id FROM Like__c WHERE Target_Id_String__c =: recordId AND User_Id__c =: userId];
			if(cancelLikeList.size() == 0){
				throw new CustomException('「いいね！」の記録がありません。');
			}else {
				Like__c delLike = new Like__c();
				delLike.Id = cancelLikeList.get(0).Id;
				delete delLike;
			}

			LikeResult likeResult = init(recordId, userId);
			return likeResult;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	@AuraEnabled
	public static LikeResult openlikeButtonWhoClickedModal(String recordId){
		try {
			List<Like__c> likedlist= [SELECT Id, Target_Id_String__c, User_Id__c, User_Id__r.SmallPhotoUrl, User_Id__r.Name FROM Like__c WHERE Target_Id_String__c =: recordId];

			LikeResult likeResult = new LikeResult();
			likeResult.displayLikeResult = likedlist;
			return likeResult;
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	//ラッパークラス
	public class LikeResult {
		@AuraEnabled
		public Boolean alreadyLiked;
		@AuraEnabled
		public Integer totalLikeCount;
		@AuraEnabled
		public Boolean overLimit;
		@AuraEnabled
		public List<Like__c> displayLikeResult;
		}
}