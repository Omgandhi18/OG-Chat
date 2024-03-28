//
//  StartupViewController.swift
//  Chat
//
//  Created by Om Gandhi on 28/03/24.
//

import UIKit
import SDWebImage
class StartupViewController: UIViewController {

    @IBOutlet weak var gifView: SDAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
                    // User Interface is Dark
            let animatedLogo = SDAnimatedImage(named: "LogoGif.gif")
            gifView.image = animatedLogo
            }
        else {
                    // User Interface is Light
            let animatedLogo = SDAnimatedImage(named: "logoLightGif.gif")
            gifView.image = animatedLogo
                    
                }
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                if self.traitCollection.userInterfaceStyle == .light {
                    // Code to execute in light mode
                    let animatedLogo = SDAnimatedImage(named: "logoLightGif.gif")
                    self.gifView.image = animatedLogo
                    print("App switched to light mode")
                } else {
                    // Code to execute in dark mode
                    let animatedLogo = SDAnimatedImage(named: "LogoGif.gif")
                    self.gifView.image = animatedLogo
                    print("App switched to dark mode")
                }
            })
        } else {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // your code here
            let vc = self.storyboard?.instantiateViewController(identifier: "tabBarStory") as! TabBarController
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
