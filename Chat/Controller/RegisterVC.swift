//
//  RegisterVC.swift
//  Chat
//
//  Created by Om Gandhi on 20/03/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnAddProfilePic: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private let spinner = JGProgressHUD(style: .dark)
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
        //TODO: Insert validations
        
        spinner.show(in: view)
        DatabaseManager.shared.userExists(with: txtEmail.text ?? "", completion: {[weak self] exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else{
                //TODO: Insert Alert 
                print("user already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.txtEmail.text ?? "", password: strongSelf.txtPass.text ?? "",completion: {authResult, error in
                guard  authResult != nil, error == nil else{
                    print("Error creating user")
                    return
                }
                let chatUser = ChatAppUser(name: self?.txtName.text ?? "", email: self?.txtEmail.text ?? "", profilePicUrl: "")
                DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                    if success
                    {
                        guard let image = strongSelf.imgProfile.image,let data = image.pngData() else{
                            return
                        }
                        let fileName = chatUser.profilePicFileName
                        StorageManager.shared.uploadProfilePic(with: data, fileName: fileName, completion: {result in
                            switch (result)
                            {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage Manager error \(error)")
                            }
                        })
                    }
                })
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
