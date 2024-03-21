//
//  NewChatVC.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import JGProgressHUD

class NewChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    
    @IBOutlet weak var tblUsers: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        title = "New Chat"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(dismissSelf))
        tblUsers.delegate = self
        tblUsers.dataSource = self
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    @objc func dismissSelf(){
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "Hello User"
        return cell
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
