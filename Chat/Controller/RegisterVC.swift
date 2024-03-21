//
//  RegisterVC.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnAddProfilePic: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.makeViewCurve(radius: imgProfile.frame.size.height/2)
        btnAddProfilePic.makeButtonRounded()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnProfilePic(_ sender: Any) {
        presentPhotoActionSheet()
        
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        DatabaseManager.shared.userExists(with: txtEmail.text ?? "", completion: {exists in
            guard !exists else{
                //TODO: Insert Alert 
                print("user already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: self.txtEmail.text ?? "", password: self.txtPass.text ?? "",completion: {[weak self] authResult, error in
                guard let strongSelf = self else{
                    return
                }
                guard let result = authResult, error == nil else{
                    print("Error creating user")
                    return
                }
                DatabaseManager.shared.insertUser(with: ChatAppUser(name: self?.txtName.text ?? "", email: self?.txtEmail.text ?? "", profilePicUrl: ""))
                strongSelf.navigationController?.dismiss(animated: true)
            })
        })
        
       
    }
    

}
extension RegisterVC: UIImagePickerControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Select an option to pick your profile picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        self.imgProfile.image = image
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
