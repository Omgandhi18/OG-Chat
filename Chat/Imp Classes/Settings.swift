

import UIKit
import SVProgressHUD
import SDWebImage
class Settings: NSObject {
    func showProgress()
    {
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.black)
        SVProgressHUD.setRingThickness(3.0)
        SVProgressHUD.show()
        SVProgressHUD .setDefaultMaskType(SVProgressHUDMaskType.black)
    }

    func showProgressWithStatus(_ status: String)
    {
        SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.7))
        SVProgressHUD.setForegroundColor(UIColor.black)
        SVProgressHUD.setRingThickness(3.0)
        SVProgressHUD.show(withStatus: status)
        SVProgressHUD .setDefaultMaskType(SVProgressHUDMaskType.black)
    }

    func dismissProgress()
    {
        SVProgressHUD.dismiss()
    }
}
