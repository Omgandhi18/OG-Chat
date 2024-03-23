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
    @IBOutlet weak var headerTblView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    
    var data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOptions.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        createTableHeader()
       
        // Do any additional setup after loading the view.
    }
    func createTableHeader(){
        //TODO: Customize the header
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        lblEmail.text = email
        let safeEmail = DatabaseManager.safeEmail(email: email)

        let fileAddress = safeEmail + "_profile_picture.png"
        let path = "images/"+fileAddress
        
        StorageManager.shared.downloadURL(for: path, completion: {result in
            switch result{
            case .success(let url):
                URLSession.shared.dataTask(with: url,completionHandler: {data,_,error in
                    guard let data = data, error == nil else{
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.imgProfile.image = image
                    }
                }).resume()
                
            
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        tblOptions.tableHeaderView = headerTblView
        tblOptions.reloadData()
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
