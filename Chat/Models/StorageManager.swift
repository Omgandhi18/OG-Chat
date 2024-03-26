//
//  StorageManager.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()
    private var storage = Storage.storage().reference()
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    public func uploadProfilePic(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata,error in
            guard error == nil else{
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: {url,error in
                guard let url = url else{
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("downloadURl: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    public enum StorageErrors: Error{
        case failedToUpload
        case failedToGetDownloadURL
    }
    public func downloadURL(for path: String, completion:  @escaping (Result<URL,Error>)-> Void){
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
    
    public func uploadMessagePic(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("messageImages/\(fileName)").putData(data, metadata: nil, completion: {metadata,error in
            guard error == nil else{
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("messageImages/\(fileName)").downloadURL(completion: {url,error in
                guard let url = url else{
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("downloadURl: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
}
