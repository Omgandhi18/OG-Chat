//
//  ViewController.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import SDWebImage
struct Conversations{
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}
struct LatestMessage{
    let date: String
    let text: String
    let isRead: Bool
}
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var tblChats: UITableView!
    
    private let spinner = JGProgressHUD(style: .dark)
    private var conversations = [Conversations]()
    private var loginObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblChats.delegate = self
        tblChats.dataSource = self
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main, using: {[weak self]_ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.startListeningforConversation()
        })

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        startListeningforConversation()
        
        
    }
    private func startListeningforConversation(){
        guard let email = UserDefaults.standard.string(forKey: "email") else{
            return
        }
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
    
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: {[weak self] result in
            switch result{
            case .success(let conversations):
                guard !conversations.isEmpty else{
                    return
                }
                self?.conversations = conversations
                DispatchQueue.main.async {
                    self?.tblChats.reloadData()
                }
            case .failure(let error):
                print("failed to get convos\(error)")
            }
            
        })
    }
    func validateAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginStory") as! LoginVC
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    func fetchChats(){
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationsCell
        cell.lblName.text = model.name
        cell.lblMsg.text = model.latestMessage.text
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: {result in
            switch result{
            case .success(let url):
                DispatchQueue.main.async {
                    cell.imgUser.sd_setImage(with: url)
                }
                
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]
        openConversation(model)
        
    }
    func openConversation(_ model: Conversations){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatViewStory") as! ChatViewController
        vc.title = model.name
        vc.otherUserEmail = model.otherUserEmail
        vc.conversationID = model.id
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            DatabaseManager.shared.deleteConversation(conversationID: conversationId , completion: {[weak self]success in
                if success{
                    self?.conversations.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                }
                
                    
            })
            
            tableView.endUpdates()
        }
    }
    
    @IBAction func btnNewChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newChatStory") as! NewChatVC
        vc.completion = {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            let currentConversations = strongSelf.conversations
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(email: result.email)
            }){
                strongSelf.openConversation(targetConversation)
            }
            else{
                self?.createNewConversation(result: result)
            }
            
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
         
    
    }
    private func createNewConversation(result: SearchResults){
        let name = result.name
        let email = DatabaseManager.safeEmail(email: result.email)
        
        DatabaseManager.shared.conversationExists(with: email, completion: {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result{
            case .success(let conversationID):
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "chatViewStory") as! ChatViewController
                vc.title = name
                vc.conversationID = conversationID
                vc.otherUserEmail = email
                vc.isNewCoversation = false
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "chatViewStory") as! ChatViewController
                vc.title = name
                vc.otherUserEmail = email
                vc.isNewCoversation = true
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
    }
}
