//
//  ChatViewController.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import MessageKit

struct Message: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
}
struct Sender: SenderType{
    var photoURL: String
    
    var senderId: String
    
    var displayName: String
    
}
class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
   private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")
    override func viewDidLoad() {
        super.viewDidLoad()
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World")))
        messages.append(Message(sender: selfSender, messageId: "2", sentDate: Date(), kind: .text("Hello World 1")))
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
    }
    
    func currentSender() -> any MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    

}
