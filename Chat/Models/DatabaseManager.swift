//
//  DatabaseManager.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import Foundation
import FirebaseDatabase
import MessageKit
import AVFoundation
import CoreLocation

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
        let safeEmail = DatabaseManager.safeEmail(email: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    public func getDataFor(path: String,completion: @escaping (Result<Any,Error>) -> Void){
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
}
extension DatabaseManager{
    public func createNewConversation(with otherUserEmail: String,name: String, firstMesssage: Message,completion: @escaping(Bool) -> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String else{
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
                "name": currentName,
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
                      let date = ChatViewController.dateFormatter.date(from: dateString) else{
                    return nil
                }
                var kind: MessageKind?
                if type == "photo"{
                    guard let imageUrl = URL(string: content),
                          let placeholder = UIImage(systemName: "plus") else{
                        return nil
                    }
                    
                    let media = Media(url: imageUrl,image: nil,placeholderImage: placeholder, size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                }
                else if type == "video"{
                    guard let videoUrl = URL(string: content),
                          let placeholder = UIImage(systemName: "play.rectangle.fill") else{
                        return nil
                    }
                    
                    let media = Media(url: videoUrl,image: nil,placeholderImage: placeholder, size: CGSize(width: 300, height: 300))
                    kind = .video(media)
                }
                else if type == "location"{
                    let locationComponents = content.components(separatedBy: ",")
                    guard let longitude = Double(locationComponents[0]) as? Double,
                          let latitude = Double(locationComponents[1]) else{
                        return nil
                    }
                    let location = Location(location: CLLocation(latitude: latitude, longitude: longitude), size:  CGSize(width: 300, height: 300))
                    kind = .location(location)

                }
                else{
                    kind = .text(content)
                }
                guard let finalKind = kind else{
                    return nil
                }
                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageID, sentDate: date, kind: finalKind)
            })
            completion(.success(messagesArray))
        })
    }
    public func sendMessage(to conversation: String,otherUserEmail: String,name: String ,newMessage: Message,completion: @escaping(Bool) -> Void)
    {
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            completion(false)
            return
        }
        let currentEmail = DatabaseManager.safeEmail(email: myEmail)
        
        self.database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: {[weak self] snapshot in
            guard let strongSelf = self else{
                return
            }
            guard var currentMessages = snapshot.value as? [[String:Any]] else{
                completion(false)
                return
            }
            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var message = ""
            switch newMessage.kind{
                
            case .text(let messageText):
                message = messageText
                break
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString{
                    message = targetUrlString
                }
                break
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString{
                    message = targetUrlString
                }
                break
            case .location(let locationData):
                let location = locationData.location
                message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
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
            let newMessageEntry: [String:Any] = [
                "id":newMessage.messageId,
                "type":newMessage.kind.messageKindString,
                "content":message,
                "date":dateString,
                "sender_email":currentUserEmail,
                "is_read":false,
                "name": name
            ]
            currentMessages.append(newMessageEntry)
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                
                guard error == nil else{
                    completion(false)
                    return
                }
                //update latest message for sender
                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                    var databaseEntryConversations = [[String:Any]]()
                    let updatedValue:[String:Any] = [
                        "date": dateString,
                        "message": message,
                        "is_read": false
                    ]
                    if var currentUserConversations = snapshot.value as? [[String: Any]]{
                        
                        var targetConversation: [String:Any]?
                        var position = 0
                        for conversations in currentUserConversations{
                            if let currentId = conversations["id"] as? String, currentId == conversation{
                                targetConversation = conversations
                                
                                break
                            }
                            position += 1
                        }
                        if var targetConversation = targetConversation{
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        else{
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": DatabaseManager.safeEmail(email: otherUserEmail),
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                        
                    }
                    else{
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email": DatabaseManager.safeEmail(email: otherUserEmail),
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }
                    
                    strongSelf.database.child("\(currentEmail)/conversations").setValue(databaseEntryConversations,withCompletionBlock: {error,_ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        //Update latest message for reciever
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                            var databaseEntryConversations = [[String:Any]]()
                            let updatedValue:[String:Any] = [
                                "date": dateString,
                                "message": message,
                                "is_read": false
                            ]
                            guard let currentName = UserDefaults.standard.string(forKey: "name") else{
                                return
                            }
                            
                            if var otherUserConversations = snapshot.value as? [[String: Any]]{
                                var targetConversation: [String:Any]?
                                var position = 0
                                for conversations in otherUserConversations{
                                    if let currentId = conversations["id"] as? String, currentId == conversation{
                                        targetConversation = conversations
                                        
                                        break
                                    }
                                    position += 1
                                }
                                if var targetConversation = targetConversation{
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else{
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": DatabaseManager.safeEmail(email: currentEmail),
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                                
                            }
                            else{
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": DatabaseManager.safeEmail(email: currentEmail),
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }
                           
                            
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations,withCompletionBlock: {error,_ in
                                guard error == nil else{
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        })
                        
                        
                    })
                })
                
            }
        })
    }
    public func conversationExists(with targetRecipientEmail: String, completion: @escaping(Result<String, Error>) -> Void){
        let safeRecipientEmail = DatabaseManager.safeEmail(email: targetRecipientEmail)
        guard let senderEmail = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        let safeSenderEmail = DatabaseManager.safeEmail(email: senderEmail)
        database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            if let conversation = collection.first(where: {
                guard let targetSender = $0["other_user_email"] as? String else{
                    return false
                }
                return safeSenderEmail == targetSender
            }){
                guard let id = conversation["id"] as? String else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(id))
                return
            }
            
            completion(.failure(DatabaseError.failedToFetch))
            return
            
        })
    }
    public func deleteConversation(conversationID: String, completion: @escaping (Bool) -> Void){
        guard let email = UserDefaults.standard.string(forKey: "email") else{
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let ref = database.child("\(safeEmail)/conversations")
        print("Deleting conversation")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if var conversations = snapshot.value as? [[String: Any]]{
                var positionToRemove = 0
                for convo in conversations{
                    if let id = convo["id"] as? String,
                       id == conversationID{
                        print("Found conversation")
                        break
                    }
                    positionToRemove += 1
                }
                conversations.remove(at: positionToRemove)
                ref.setValue(conversations,withCompletionBlock: {error, _ in
                    guard error == nil else{
                        print("failed to update conversation array")
                        completion(false)
                        return
                    }
                    print("deleted conversation")
                    completion(true)
                })
            }
        })
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

