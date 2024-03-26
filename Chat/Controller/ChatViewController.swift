//
//  ChatViewController.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
struct Message: MessageType{
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    
}
extension MessageKind{
    var messageKindString: String{
        switch self{
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link"
        case .custom(_):
            return "custom"
        }
    }
}
struct Sender: SenderType{
   public var photoURL: String
   public var senderId: String
   public var displayName: String
    
}
struct Media: MediaItem{
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
   private var messages = [Message]()
    private var selfSender: Sender?{
        guard let email = UserDefaults.standard.value(forKey: "email") as? String
        else{
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        return Sender(photoURL: "", senderId: safeEmail, displayName: "Me")
    }
    public var isNewCoversation = false
    public var otherUserEmail = String()
    public var conversationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        if let conversationID = conversationID{
            listenForMessages(id: conversationID,shouldScrollToBottom: true)
        }
        setupInputButton()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    private func setupInputButton(){
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.onTouchUpInside{[weak self]_ in
            self?.presentInputActionSheet()
            
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    private func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "Attach media", message: "What would you like to attach?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default,handler: {[weak self] _ in
            self?.presentPhotoInputActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default,handler: {[weak self] _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default,handler: {[weak self] _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: {[weak self] _ in
            
        }))
        present(actionSheet, animated: true)
    }
    private func presentPhotoInputActionSheet(){
        let actionSheet = UIAlertController(title: "Attach Photo", message: "From?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,handler: {[weak self] _ in
           let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default,handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
             picker.delegate = self
             picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    private func listenForMessages(id: String,shouldScrollToBottom: Bool){
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: {[weak self] result in
            switch result{
            case .success(let messages):
                guard !messages.isEmpty else{
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom{
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
                
                
            case . failure(let error):
                print("failed to get messages \(error)")
            }
        })
    }
    
    
    func currentSender() -> any MessageKit.SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("Self sender is nil, email should be cached")
//        return Sender(photoURL: "", senderId: "12", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else{
            return
        }
        switch message.kind{
        case .photo(let media):
            guard let imageURl = media.url else{
                return
            }
            imageView.sd_setImage(with: imageURl)
        default: break
        }
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageID = createMessageID() else{
            return
        }
        let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
        if isNewCoversation{
            
            DatabaseManager.shared.createNewConversation(with: otherUserEmail,name: self.title ?? "User", firstMesssage: message, completion: {[weak self] success in
                if success{
                    print("message sent")
                    self?.isNewCoversation = false
                    inputBar.inputTextView.text = ""
                }
                else{
                    print("failed to send")
                }
                
            })
        }
        else{
            guard let conversationID = conversationID,let name = self.title else{
                return
            }
            
            DatabaseManager.shared.sendMessage(to: conversationID,otherUserEmail: otherUserEmail,name: name ,newMessage: message, completion: {success in
                if success{
                    print("message sent")
                    inputBar.inputTextView.text = ""
                }
                else{
                    print("failed to send")
                }
            })
        }
    }
    private func createMessageID() -> String? {
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email")
               else{
            return nil
        }
        let safeCurrentEmail = DatabaseManager.safeEmail(email: currentUserEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        let newID = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        return newID
    }
    
    

}
extension ChatViewController: MessageCellDelegate{
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else{
            return
        }
        
        let message = messages[indexPath.section]
        switch message.kind{
        case .photo(let media):
            guard let imageURl = media.url else{
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoViewStory") as! PhotoViewController
            vc.url = imageURl
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
}
extension ChatViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
        let imageData = image.pngData(),
        let messageID = createMessageID(),
        let conversationID = conversationID,
        let name = self.title,
        let selfSender = selfSender else{
            return
        }
        let fileName = "photo_message_" + messageID.replacingOccurrences(of: " ", with: "_") + ".png"
        StorageManager.shared.uploadMessagePic(with: imageData, fileName: fileName, completion: {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(let urlString):
                print("Uploaded message photo: \(urlString)")
                guard let url = URL(string: urlString),
                      let placeholder = UIImage(systemName: "plus") else{
                    return
                }
                let media = Media(url: url,image: image,placeholderImage: placeholder, size: .zero)
                let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .photo(media))
                
                DatabaseManager.shared.sendMessage(to: conversationID, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: {success in
                    if success{
                        print("sent photo message")
                    }
                    else{
                        print("failed to send photo message")
                    }
                })
            case .failure(let error):
                print("message photo upload error: \(error)")
            }
        })
    }
}
