//
//  ProfileVC.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import FirebaseAuth
class ProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
   
    

    @IBOutlet weak var tblOptions: UITableView!
    
    var data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOptions.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginStory") as! LoginVC
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        catch{
            print("Failed to logout")
        }
    }

}
