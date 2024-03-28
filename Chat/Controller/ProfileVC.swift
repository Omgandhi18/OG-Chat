//
//  ProfileVC.swift
//  Chat
//
//  Created by Om Gandhi on 21/03/24.
//

import UIKit
import FirebaseAuth
import SDWebImage
class ProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
   
    

    @IBOutlet weak var btnEditProfilePic: UIButton!
    @IBOutlet weak var tblOptions: UITableView!
    @IBOutlet weak var headerTblView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var data = ["Help","Log Out"]
    var images = [UIImage(systemName: "questionmark.circle.fill"), UIImage(systemName: "power.circle.fill")]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOptions.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        
       
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        createTableHeader()
    }
    func createTableHeader(){
        //TODO: Customize the header
        guard let email = UserDefaults.standard.value(forKey: "email") as? String, let name =  UserDefaults.standard.value(forKey: "name") as? String else{
            return
        }
        lblEmail.text = email
        lblName.text = name
        let safeEmail = DatabaseManager.safeEmail(email: email)

        let fileAddress = safeEmail + "_profile_picture.png"
        let path = "images/"+fileAddress
        
        StorageManager.shared.downloadURL(for: path, completion: {[weak self]result in
            switch result{
            case .success(let url):
                self?.imgProfile.sd_setImage(with: url)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
        imgProfile.makeViewBorderWithCurve(radius: imgProfile.frame.size.height/2, bcolor: .gray,bwidth: 1)
        btnEditProfilePic.makeButtonRounded()
        tblOptions.tableHeaderView = headerTblView
        tblOptions.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.imageView?.image = images[indexPath.row]
        cell.imageView?.tintColor = UIColor.button
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowTitle = data[indexPath.row]
        if rowTitle == "Log Out"{
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "name")
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

    @IBAction func btnProfilePic(_ sender: Any) {
        presentPhotoActionSheet()
    }
}
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Select an option to pick your profile picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
        }))
        actionSheet.setTint(color: .button)
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
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let data = image.pngData() else{
            return
        }
        
        self.imgProfile.image = image
        let chatUser = ChatAppUser(name: lblName.text ?? "", email: lblEmail.text ?? "", profilePicUrl: "")
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
