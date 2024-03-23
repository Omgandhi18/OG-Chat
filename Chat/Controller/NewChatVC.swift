//
//  NewChatVC.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import JGProgressHUD

class NewChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    private let spinner = JGProgressHUD(style: .dark)
    private var users = [[String:String]]()
    private var results = [[String:String]]()
    private var hasFetched = false
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
        self.searchUsers(query: text)
    }
    func searchUsers(query: String){
        if hasFetched{
            filterUsers(with: query)
        }
        else{
            DatabaseManager.shared.getAllUsers(completion: {[weak self] result in
                switch result{
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }
    }
    func filterUsers(with term: String){
        guard hasFetched else{
            return
        }
        self.spinner.dismiss()
        let results: [[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() as? String else{
            return false
             }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    func updateUI(){
        if results.isEmpty{
            //TODO: Show No results label
        }
        else{
            //TODO: Show Tableview
            tblUsers.reloadData()
        }
    }
    
}
