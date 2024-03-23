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

