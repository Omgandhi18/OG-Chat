//
//  ChatViewController.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

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
        return Sender(photoURL: "", senderId: email, displayName: "Joe Smith")
    }
    public var isNewCoversation = false
    public var otherUserEmail = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    func currentSender() -> any MessageKit.SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("Self sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "12", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageID = createMessageID() else{
            return
        }
        if isNewCoversation{
            let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMesssage: message, completion: {[weak self] success in
                if success{
                    print("message sent")
                }
                else{
                    print("failed to send")
                }
                
            })
        }
        else{
            
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
