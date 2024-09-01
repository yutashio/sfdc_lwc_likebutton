import { LightningElement, api, wire } from 'lwc';
import LikeButtonWhoClickedModal from "c/likeButtonWhoClickedModal";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from "@salesforce/user/Id";
import init from '@salesforce/apex/LikeButtonController.init';
import onClickLike from '@salesforce/apex/LikeButtonController.onClickLike';
import onClickCancelLike from '@salesforce/apex/LikeButtonController.onClickCancelLike';
import openlikeButtonWhoClickedModal from '@salesforce/apex/LikeButtonController.openlikeButtonWhoClickedModal';

export default class LikeButton extends LightningElement {

	//レコードID
	@api recordId;
	//いいね件数
	likeCount;
	//ボタン切り替え用
	alreadyLiked = false;
	//スピナー表示用
	spinner = false;
	//ログイン中ユーザID
	loginUserId = userId;
	//ユーザーアイコンの表示制御用
	overLimit = false;

	connectedCallback(){
		this.spinner = true;

		init({recordId: this.recordId, userId: this.loginUserId})
		.then(result => {
			this.likeCount = result.totalLikeCount;
			this.alreadyLiked = result.alreadyLiked;
			this.likeList = result.displayLikeResult;
			this.overLimit = result.overLimit;
			this.spinner = false;
		})
		.catch(error => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'エラーが発生しました。',
					message: error.body.message,
					variant: 'error',
					mode: 'sticky'
				})
			);
			this.spinner = false;
		});
	}

	onClickLikeButton() {
		this.spinner = true;

		onClickLike({recordId: this.recordId, userId: this.loginUserId})
		.then(result => {
			this.likeCount = result.totalLikeCount;
			this.alreadyLiked = result.alreadyLiked;
			this.likeList = result.displayLikeResult;
			this.overLimit = result.overLimit;
			this.spinner = false;
		})
		.catch(error => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'エラーが発生しました。',
					message: error.body.message,
					variant: 'error',
					mode: 'pester'
				})
			);
			this.spinner = false;
		});
	}

	onClickCancelLikeButton() {
		this.spinner = true;

		onClickCancelLike({recordId: this.recordId, userId: this.loginUserId})
		.then(result => {
			this.likeCount = result.totalLikeCount;
			this.alreadyLiked = result.alreadyLiked;
			this.likeList = result.displayLikeResult;
			this.overLimit = result.overLimit;
			this.spinner = false;
		})
		.catch(error => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'エラーが発生しました。',
					message: error.body.message,
					variant: 'error',
					mode: 'pester'
				})
			);
			this.spinner = false;
		});
	}

	async openlikeButtonWhoClickedModalButton() {
		await openlikeButtonWhoClickedModal({recordId: this.recordId})
		.then(result => {
			LikeButtonWhoClickedModal.open({
				size: "small",
				label: "いいね！と言っているユーザー",
				record: result.displayLikeResult
			});
		})
		.catch(error => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'エラーが発生しました。',
					message: error.body.message,
					variant: 'error',
					mode: 'pester'
				})
			);
		});
	}
}