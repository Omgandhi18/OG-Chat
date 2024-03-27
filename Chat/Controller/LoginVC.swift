//
//  LoginVC.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginVC: UIViewController {
//MARK: Outlets
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    private let spinner = JGProgressHUD(style: .dark)
    private var loginObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main, using: {[weak self]_ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.navigationController?.dismiss(animated: true)
        })
        
    }
    deinit{
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        spinner.show(in: view)
        //TODO: Insert validations
        
        FirebaseAuth.Auth.auth().signIn(withEmail: txtEmail.text ?? "", password: txtPass.text ?? "",completion: {[weak self] authResult,error in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult, error == nil else{
                print("Failed to log in")
                return
            }
            let user = result.user
            let safeEmail = DatabaseManager.safeEmail(email: strongSelf.txtEmail.text ?? "")
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: {result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String:Any],
                    let name = userData["user_name"] else{
                        return
                    }
                    UserDefaults.standard.set(name, forKey: "name")
                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
            UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
            
            print("Logged In \(user)")
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            strongSelf.navigationController?.dismiss(animated: true)
        })
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "registerStory") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension Notification.Name{
    static let didLoginNotification = Notification.Name("didLogInNotification")
}
