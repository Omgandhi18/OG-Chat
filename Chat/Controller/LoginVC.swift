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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        spinner.show(in: view)
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
            print("Logged In \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        })
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "registerStory") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
