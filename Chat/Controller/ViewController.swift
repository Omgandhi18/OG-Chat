//
//  ViewController.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var tblChats: UITableView!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblChats.delegate = self
        tblChats.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
        
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "Hello World"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatViewStory") as! ChatViewController
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNewChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newChatStory") as! NewChatVC
        vc.completion = {[weak self] result in
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    
    }
    private func createNewConversation(result: [String:String]){
        
        guard let email = result["email"] else{
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatViewStory") as! ChatViewController
        vc.title = result["name"]
        vc.otherUserEmail = email
        vc.isNewCoversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
