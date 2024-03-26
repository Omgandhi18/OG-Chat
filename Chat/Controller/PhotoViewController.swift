//
//  PhotoViewController.swift
//  Chat
//
//  Created by Om Gandhi on 26/03/24.
//

import UIKit
import SDWebImage
class PhotoViewController: UIViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imgView.sd_setImage(with: url)
        // Do any additional setup after loading the view.
    }
    

}
