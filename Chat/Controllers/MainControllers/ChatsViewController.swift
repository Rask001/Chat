//
//  ChatsViewController.swift
//  Chat
//
//  Created by Антон on 12.04.2022.
//  главный экран с чатом

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class ChatsViewController: MessagesViewController {

	
	
	//MARK: - Properties
	private var messages: [MMessage] = []  //необходимо подписать вашу модель под протокол MessageType
	private var messageListener: ListenerRegistration?
	private let user: MUser
	private let chat: MChat
	
	
	//MARK: - Init
	init(user: MUser, chat: MChat) {
		self.user = user
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
		title = chat.friendUserName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		messageListener?.remove()
	}
	
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
			layout.textMessageSizeCalculator.outgoingAvatarSize = .zero //убрать расстояние отсутствуюшей аватарки отправителя (для собеседника использовать свойство incomingAvatarSize)
		}
		messagesCollectionView.backgroundColor = .mainWhite()
		configureMessageInputBar()
		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
			switch result {
				
			case .success(let message):
				self.insertNewMessage(message: message)
			case .failure(let error):
				self.showAlert(title: "error", message: error.localizedDescription)
			}
		})
	}
	
	private func insertNewMessage(message: MMessage) {
		guard !messages.contains(message) else { return } //проверка на отсутствие в нашем текущем массиве новых сообщений
		messages.append(message)
		messages.sort()
		scrollToLastMessage(message: message)
	}

	//скроллим до последнего сообщения вниз
	func scrollToLastMessage(message: MMessage) {
	let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
	let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
	messagesCollectionView.reloadData()
	if shouldScrollToBottom {
		DispatchQueue.main.async {
			self.messagesCollectionView.scrollToBottom(animated: true)
		}
	}
}
}

//MARK: - Extension
//MARK: - MessagesDataSource
//Обзятельные методы
extension ChatsViewController: MessagesDataSource {
	
	func currentSender() -> SenderType { //возвращает наши данные (данные отправителя)
		return Sender(senderId: user.id, displayName: user.username)
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.item]  //если не подписать модель под протокол MessageType, будет ошибка в данном методе
	}
	
	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
	 return	messages.count
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}
	
	//устанавливаем дату между сообщениями в диалоге
	func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		if indexPath.item % 10 == 0 {
		return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
															attributes: [
																NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
																NSAttributedString.Key.foregroundColor: UIColor.darkGray])
		}else{
			return nil
		}
	}
}

private func sendPhoto(image: UIImage) {
	
}


//MARK: - MessagesLayoutDelegate
extension ChatsViewController: MessagesLayoutDelegate {
	func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return CGSize(width: 0, height: 8)
	}
	
	//интервал между датой и сообщениями
	func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		if (indexPath.item) % 10 == 0 {
			return 30
		} else {
			return 0
		}
	}
}


//MARK: - MessagesDisplayDelegate
extension ChatsViewController: MessagesDisplayDelegate {
	//красим фон сообщения
	func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.8137198091, green: 0.7213935256, blue: 0.953623116, alpha: 1) // подкапотная булевая функция определяющая кто отправил сообщение.
	}
	
	//красим текст сообщения
	func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white // подкапотная булевая функция определяющая кто отправил сообщение.
	}
	
	//настраиваем отоброжение аватарок в чате
	func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		isFromCurrentSender(message: message) ? (avatarView.isHidden = true) : (avatarView.isHidden = false)
	}
	
	//настраиваем стиль сообщений, в MessageStyle можно посмотреть различные кейсы
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		return .bubble
	}
	
		//после необходимых настроек создаем приватную функцию ниже viewDidLoad для отображений сообщений на экране "insertNewMessage"
}

extension ChatsViewController: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let message = MMessage(user: user, content: text)
		FirestoreService.shared.sentMessage(chat: chat,
																				message: message) { result in
			switch result {
				
			case .success():
				self.messagesCollectionView.scrollToLastItem() //скролл к нижнему сообщению при отправке
			case .failure(let error):
				self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		}
		inputBar.inputTextView.text = ""
	}
	
//	func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
//		<#code#>
//	}
//
//	func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
//		<#code#>
//	}
//
//	func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
//		<#code#>
//	}
}



// MARK: - ConfigureMessageInputBar
//делаем кастомный текстфилд инструментами библиотеки MessageKit
extension ChatsViewController {
	func configureSendButton() {
		messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
		messageInputBar.sendButton.applyGradients(cornerRadius: 10)
		messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
		messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
		messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
		messageInputBar.middleContentViewPadding.right = -38
	}
	
	func configureMessageInputBar() {
		messageInputBar.isTranslucent = true
		messageInputBar.separatorLine.isHidden = true
		messageInputBar.backgroundView.backgroundColor = .mainWhite()
		messageInputBar.inputTextView.backgroundColor = .white
		messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
		messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
		messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
		messageInputBar.inputTextView.placeholderLabel.text = "Message"
		messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
		messageInputBar.inputTextView.layer.borderWidth = 0.2
		messageInputBar.inputTextView.layer.cornerRadius = 18.0
		messageInputBar.inputTextView.layer.masksToBounds = true
		messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
		
		
		messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		messageInputBar.layer.shadowRadius = 5
		messageInputBar.layer.shadowOpacity = 0.3
		messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
		
		configureSendButton()
		configureCameraIcon()
	}
	
	func configureCameraIcon() {
		let cameraItem = InputBarButtonItem(type: .system)
		cameraItem.tintColor = #colorLiteral(red: 0.8137198091, green: 0.7213935256, blue: 0.953623116, alpha: 1)
		let cameraImage = UIImage(systemName: "camera")!
		cameraItem.image = cameraImage
		cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
		cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
		
		messageInputBar.leftStackView.alignment = .center
		messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
		messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
	}
	@objc private func cameraButtonPressed() {
		let picker = UIImagePickerController()
		picker.delegate = self
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		} else {
			picker.sourceType = .photoLibrary
		}
		present(picker, animated: true, completion: nil)
	}
	
}

extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		sendPhoto(image: image)
	}
}

// MARK: - UIScrollView проверка где находться сообщение
extension UIScrollView {
	
		var isAtBottom: Bool {
				return contentOffset.y >= verticalOffsetForBottom
		}
		
		var verticalOffsetForBottom: CGFloat {
			let scrollViewHeight = bounds.height
			let scrollContentSizeHeight = contentSize.height
			let bottomInset = contentInset.bottom
			let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
			return scrollViewBottomOffset
		}
}
