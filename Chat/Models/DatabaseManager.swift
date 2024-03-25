//
//  DatabaseManager.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    public func insertUser(with user: ChatAppUser,completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue(["user_name" : user.name
                                                ],withCompletionBlock: {error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:String]]{
                    let newElement = [
                        "name": user.name,
                        "email":user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                        
                    })
                }
                else{
                    let newCollection:[[String: String]] = [
                        [
                            "name": user.name,
                            "email":user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            return
                        }
                        completion(true)
                        
                    })
                }
            })
           
            
        })
    }
    public func getAllUsers(completion: @escaping (Result<[[String:String]],Error>)->Void){
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String:String]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    public func userExists(with email: String, completion: @escaping ((Bool)-> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? String else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
}
extension DatabaseManager{
    public func createNewConversation(with otherUserEmail: String,name: String, firstMesssage: Message,completion: @escaping(Bool) -> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: currentEmail)
        let ref =  database.child("\(safeEmail)")
       ref.observeSingleEvent(of: .value, with: {
           [weak self] snapshot in
           guard var userNode = snapshot.value as? [String: Any] else {
               completion(false)
               print("user not found")
               return
           }
           let messageDate = firstMesssage.sentDate
           let dateString = ChatViewController.dateFormatter.string(from: messageDate)
           var message = ""
           switch firstMesssage.kind{
               
           case .text(let messageText):
               message = messageText
               break
           case .attributedText(_):
               break
           case .photo(_):
               break
           case .video(_):
               break
           case .location(_):
               break
           case .emoji(_):
               break
           case .audio(_):
               break
           case .contact(_):
               break
           case .linkPreview(_):
               break
           case .custom(_):
               break
           }
           let conversationId = "conversation_\(firstMesssage.messageId)"
           let newConversationData: [String: Any] = [
            "id": conversationId,
            "other_user_email": otherUserEmail,
            "name": name,
            "latest_message": [
                "date": dateString,
                "message": message,
                "is_read": false
            ]
           ]
           let reciepientNewConversationData: [String: Any] = [
            "id": conversationId,
            "other_user_email": safeEmail,
            "name": "Self",
            "latest_message": [
                "date": dateString,
                "message": message,
                "is_read": false
            ]
           ]
           //update reciepeint conversation entry
           self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: {[weak self]snapshot in
               if var conversations = snapshot.value as? [[String: Any]]{
                   conversations.append(reciepientNewConversationData)
                   self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
               }
               else{
                   self?.database.child("\(otherUserEmail)/conversations").setValue([
                    reciepientNewConversationData
                   ])
               }
           })
           //update current user conversation entry
           if var conversations = userNode["conversations"] as? [[String:Any]]{
               conversations.append(newConversationData)
               userNode["conversations"] = conversations
               ref.setValue(userNode,withCompletionBlock: {[weak self] error, _ in
                   guard error == nil else{
                       completion(false)
                       return
                   }
                   self?.finishCreatingConversation(name:name,converationID: conversationId, firstMessage: firstMesssage, completion: completion)
               })

           }
           else{
               userNode["conversations"] = [
                newConversationData
               ]
               ref.setValue(userNode,withCompletionBlock: {[weak self] error, _ in
                   guard error == nil else{
                       completion(false)
                       return
                   }
                   self?.finishCreatingConversation(name:name,converationID: conversationId, firstMessage: firstMesssage, completion: completion)
                   
               })
            }
           
        })
    }
    private func finishCreatingConversation(name: String,converationID: String, firstMessage: Message,completion: @escaping(Bool) -> Void){
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        var message = ""
        switch firstMessage.kind{
            
        case .text(let messageText):
            message = messageText
            break
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        guard let myEmail = UserDefaults.standard.string(forKey: "email") else{
            completion(false)
            return
        }
        let currentUserEmail = DatabaseManager.safeEmail(email: myEmail)
        let collectionMessage: [String:Any] = [
            "id":firstMessage.messageId,
            "type":firstMessage.kind.messageKindString,
            "content":message,
            "date":dateString,
            "sender_email":currentUserEmail,
            "is_read":false,
            "name": name
        ]
        let value: [String:Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        database.child("\(converationID)").setValue(value, withCompletionBlock: {error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    public func getAllConversations(for email: String, completion: @escaping(Result<[Conversations],Error>)-> Void){
        database.child("\(email)/conversations").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let conversationsArray: [Conversations] = value.compactMap({dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else{
                    return nil
                }
                let latestMessageObj = LatestMessage(date: date, text: message, isRead: isRead)
                return Conversations(id: conversationId, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObj)
            })
            completion(.success(conversationsArray))
        })
    }
    public func getAllMessagesForConversation(with id: String, completion: @escaping(Result<[Message],Error>) -> Void){
        database.child("\(id)/messages").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let messagesArray: [Message] = value.compactMap({dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageID = dictionary["id"] as? String,
                      let type = dictionary["type"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString)else{
                    return nil
                }
                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
            })
            completion(.success(messagesArray))
        })
    }
    public func sendMessage(to conversation: String, message: Message,completion: @escaping(Bool) -> Void)
    {
        
    }
}
struct ChatAppUser{
    let name: String
    let email: String
    let profilePicUrl: String
    
    var safeEmail: String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePicFileName: String{
        return "\(safeEmail)_profile_picture.png"
    }
}

