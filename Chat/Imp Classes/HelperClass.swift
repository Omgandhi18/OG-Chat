//
//  HelperClass.swift
//  EcomAppProduct
//
//  Created by Athulya Tech on 14/02/23.
//

import Foundation
import UIKit
//import GoogleSignIn
//import StripePayments
import Alamofire

// MARK: - Common
let AlertTitle                      = "Demo"
let AppDel                          = UIApplication.shared.delegate as? AppDelegate
let deviceID                        = UIDevice.current.identifierForVendor?.uuidString ?? "" // Device Id
let deviceModel                     = UIDevice.current.name
let deviceOSVersion                 = UIDevice.current.systemVersion
let deviceType                      = UIDevice.current.systemName
var appCode                         = ""
var api_key                         = "ef202dc7c88478fd5250d7c20a7d5f7c"
//"ef202dc7c88478fd5250d7c20a7d5f7c"
//"1343dd95b0msh2a5acac6bba3512p129fc7jsn0c9b70762cd5"
var apiHost                         = "v3.football.api-sports.io"
//"v3.football.api-sports.io"
//"api-football-v1.p.rapidapi.com"


//var loginModel                      : Signup?
//var hostSettings                    : HostClass?
//var googleUser                      : GIDGoogleUser?
var GeocodingAPI_Key                = "AIzaSyAUdpCiz6xRmDb2xK95__NG_KFJRtzpXbg"
var DirectionsAPI_Key               = "AIzaSyDTR2bgEBvmjX5yfZxsX5lCvQXifDY-d4M"

//TODO: Create Facebook and Apple users
var device_token                    : String?
var auth_token                      = ""
var hostStoreID                     = ""
var bearer_token                    = ""
var wishlist_count                  = 0
var cart_count                      = 0

//MARK: ALERT MESSAGE :-
enum AlertMsg: String {
    //MARK: Common error messages
    case internetConnection         = "The Internet connection appears to be offline."
    case storenotconfigured         = "Our store is not setup yet. Please reach out to our team for any queries."
    case emailMissing               = "Please enter email address"
    case phoneMissing               = "Please enter phone number"
    case passMissing                = "Please enter password"
    case oldPassMissing             = "Please enter old password"
    case conPassMissing             = "Please enter password again"
    case invalidEmailorPhone        = "Please enter valid email or phone number"
    case invalidEmail               = "Please enter valid email"
    case invalidPhone               = "Please enter valid phone number"
    case failService                = "Something went wrong. Please try again later !!"
    case missingValue               = "Please enter email or phone number"
    case passNotMatch               = "Passwords don't match"
    case oldPassNotMatch            = "Old password don't match"
    case passChanged                = "Password changed successfully"
    case messagemissing             = "Please enter a message."
    case signOut                    = "Are you sure you want to sign out?"
    //MARK: Default error messages
    case error                      = "Error"
    case tryAgainLater              = "Try again later"
    case appNotStart                = "App can't be started"
    case appNotLoad                 = "App can't be loaded, Try again later"
    case somethingWrong             = "Something went wrong. Try again later"
    //MARK: Address error messages
    
    case addressMissing             = "Please enter an address"
    case dateMissing                = "Please select a date"
    case nameMissing                = "Please enter full name"
    case addressLine1Missing        = "Please enter address in address line 1"
    case landmarkMissing            = "Please enter landmark"
    case cityMissing                = "Please enter city name"
    case stateMissing               = "Please enter state name"
    case countryMissing             = "Please enter country name"
    case countryCodeMissing         = "Please enter country code"
    case otherAddressMissing        = "Please enter address name"
    case zipCodeMissing             = "Please enter zipcode"
    case invalidZipCode             = "Please enter valid zip code"
    case invalidSizePhoto           = "Please upload photo of size upto 2 mb."
    case setDefaultAddress          = "Set this as default address?"
    case deleteAddress              = "Delete this address?"
    case addressAdded               = "Address added successfully."
    case addressUpdated             = "Address updated successfully."
    case addressDeleted             = "Address deleted successfully."

    //MARK: Dashboard error messages
    
    case noProducts                 = "No products found"
    
    //MARK: Speech recogition errors
    
    case audioEngineError           = "Audio engine error"
    case notSupported               = "Speech recognition not supported for current locale"
    case notAvailable               = "Speech recognition not available right now"
    case recognitionError           = "Speech recognition error"
    case speechPermissionDenied     = "Please allow microphone access from settings"
    
    //MARK: Camera errors
    case cameraPermissionDenied     = "Please allow camera access from settings"
    
    //MARK: Details error messages
    
    case firstNameMissing           = "Please enter first name"
    case lastNameMissing            = "Please enter last name"
    case dobMissing                 = "Please select date of birth"
    case genderMissing              = "Please select gender"
    case termsNotAgree              = "Please agree to terms and conditions"
    case ageLess                    = "Age is less than 18"
    case otpMissing                 = "Please enter otp"
    case incorrectOtp               = "Incorrect otp, please enter the correct otp"
    case profileUpdated             = "Your profile has been updated successfully."
    case ratingMissing              = "Please give rating"
    
    //MARK: Product error messages
    case cartOutOfStock             = "Some items in cart are out of stock. Please remove them or try again later."
    case emptyWishlist              = "Your wishlist is empty."
    case deleteItemConfirm          = "Do you want to delete this item from cart?"
    case clearWishlist              = "Do you want to delete all items from your wishlist?"
    case deleteMultiItemsCart       = "Do you want to remove all this items from your cart?"
    case removeCartAddWishlist      = "Do you want to move this item from cart to wishlist?"
    case itemInWishRemoveCart       = "Item already in wishlist. Do you want to remove this item from cart?"
    case selectItemToDelete         = "Select any item to remove from cart."
    case addedToWishlist            = "Item added to wishlist"
    case addedToCart                = "Item added to cart"
    case removeFromWishlist         = "Item removed from wishlist"
    case removeFromCart             = "Item removed from cart"
    case WishlistClear              = "Wishlist cleared successfully"
    case MultiItemRemoveCart        = "Multiple items removed from cart"
    
    //MARK: Payment Error messages
    case paymentMethod              = "Please select a payment method"
    case cardHolderName             = "Please enter card holder name."
    case invalidCard                = "Please enter valid/missing card details"
    //MARK: Order messages
    case cancelOrder                = "Are you sure you want to cancel this order?"
    case reOrder                    = "Ordered items added in cart."
    
    //MARK: TIP AMOUNT ERROR MESSAGES
    case Tipamountcheck             = "Your tip amount will be greater than order total. Are you sure you want to continue?"
    
    case ratingsubmitted            = "Rating successfully submitted!!"

}

extension UIImage {
    enum AssetIdentifier: String {
        case logo                   = "logo"
        case HomeLogo               = "HomeLogo"
    }
    convenience init?(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}


//===================================================================
// MARK: - VIEW CONTROLLER =====> FUNCTION
//===================================================================
extension UIViewController: UIPopoverPresentationControllerDelegate{
    //===================================================================
    // MARK: - TABBAR CONTROLLER METHODS
    //===================================================================
//    func setCartTabBarValue(_ cartValue: Int = 0){
//        if cartValue != 0{
//            self.tabBarController?.tabBar.items?[3].badgeValue = String(cartValue)
//        }
//        else{
//            self.tabBarController?.tabBar.items?[3].badgeValue = nil
//        }
//    }
//    func setWishlistTabBarValue(_ wishlistValue: Int = 0){
//        if wishlistValue != 0{
//            self.tabBarController?.tabBar.items?[2].badgeValue = String(wishlistValue)
//        }
//        else{
//            self.tabBarController?.tabBar.items?[2].badgeValue = nil
//        }
//    }
    //===================================================================
    // MARK: - Get Wishlist Cart Count service
    //===================================================================
//    func getCartWishlistCount(){
//        let params = ["AUTH_TOKEN"      : auth_token,
//                      "CUSTOMER_ID"     : loginModel?.data?.customerID ?? 0,
//                      "STORE_ID"        : hostStoreID
//        ] as Dictionary<String,Any>
//        let headers: HTTPHeaders = [
//                .authorization(bearerToken: bearer_token)]
//        callWebServiceToFetchJsonData(strURL: API_URL.GetCartWishlistCount,parameters: params,headers: headers,hideProgress: true){[self] response in
//            if response?["status"] as? String == responseStatus.Success.rawValue{
//                let data = response?["data"] as? AnyObject
//                if data?["WISHLIST_COUNT"] != nil{
//                    wishlist_count = data?["WISHLIST_COUNT"] as? Int ?? 0
//                    setWishlistTabBarValue(data?["WISHLIST_COUNT"] as? Int ?? 0)
//                }
//                if data?["CART_COUNT"] != nil{
//                    cart_count = data?["CART_COUNT"] as? Int ?? 0
//                    setCartTabBarValue(data?["CART_COUNT"] as? Int ?? 0)
//                }
//            }
//        }OnFail: { err in
//            self.showAlert(message: err, inViewController: self, forCancel: "", forOther: "Ok",isSingle: true){btn in
//            } cancelHandler: {}
//        }
//    
//    }
    
    //===================================================================
    // MARK: - ALERTVIEW METHOD - POPUP ALERTVIEW
    //===================================================================
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func showToastAlert(strmsg : String?, preferredStyle: UIAlertController.Style) {
        let message = strmsg
        let alert = UIAlertController(title: nil, message: message, preferredStyle: preferredStyle
        )
        alert.setBackgroundColor(color: .white)
        
        // Set message font and color
        let attributedString = NSAttributedString(
            string: message ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                .foregroundColor: UIColor.button // Set the desired text color
            ]
        )

        alert.setValue(attributedString, forKey: "attributedMessage")
        //alert.setMessage(font: UIFont.systemFont(ofSize: 17,weight: .semibold), color: .ecom_main)
        alert.modalPresentationStyle = .overFullScreen
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
        // duration in seconds
        let duration: Double = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    //===================================================================
    // MARK: - ALERTVIEW  METHOD - CUSTOM ALERTVIEW
    //===================================================================
    
    func showAlert(_ title: String? = "", message msg: String?, inViewController vc: UIViewController?, forCancel cancelString: String?, forOther otherString: String?, isSingle isSingleButton:Bool=false, isDissmiss isDissmissOutside:Bool=false, textAlignment alignment: NSTextAlignment = .left, alertImage image: String? = "eraser.fill",backColor color:UIColor? = .ecom_background,otherButtonColor otherColor: UIColor? = .ecom_buttonColor,cancelButtonColor cancelColor: UIColor? = .red,completionHandler: @escaping (_ btnString: String?) -> Void,cancelHandler: @escaping () -> Void?) {

//        let AlertType = hostSettings?.custAppThemeDetails?.first?.alertType
//        
//        if AlertType == "Custom Dialog" {
//            let Story = UIStoryboard(name: "Main", bundle: nil)
//            let myVC = Story.instantiateViewController(withIdentifier: "AlertStory") as? AlertVC
//            myVC?.providesPresentationContextTransitionStyle = true
//            myVC?.definesPresentationContext = true
//            myVC?.isSingleBtn = isSingleButton  // for single button option
//            myVC?.isDissmissView = isDissmissOutside // for dissmiss view on click outside popup
//            myVC?.stralerttitle = hostSettings?.custAppThemeDetails?.first?.alertTitle ?? "Madira"
//            myVC?.stralertmsg = msg ?? ""
//            myVC?.btncanceltitle = cancelString ?? "Cancel"
//            myVC?.btnothertitle = otherString ?? "OK"
//            myVC?.textAlignment = alignment
//            myVC?.backgroundColor = color ?? .ecom_background!
//            myVC?.otherButtonColor = otherColor ?? .ecom_buttonColor!
//            myVC?.cancelButtonColor = cancelColor ?? .red
//            myVC?.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//    
//            myVC?.onCompletionClose = { [self] in
//                print(self)
//                self.dismiss(animated: true)
//            }
//    
//            myVC?.onCompletionDone = { [self] in
//                print(self)
//                completionHandler(otherString)
//                self.dismiss(animated: true)
//            }
//            myVC?.onCompletionCancel = {
//                print("Cancel button clicked")
//                cancelHandler()
//                self.dismiss(animated: true)
//                // Handle cancel button click
//            }
//            if let myVC = myVC {
//                present(myVC, animated: true)
//            }
//        }
//        else {
//            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
//            
//            if isSingleButton == true {
//                if otherString != nil {
//                    alertController.addAction(UIAlertAction(title: otherString ?? "OK", style: .default, handler: { action in
//                        completionHandler(otherString)
//                    }))
//                }
//            }
//            else{
//                if otherString != nil {
//                    alertController.addAction(UIAlertAction(title: otherString ?? "OK", style: .default, handler: { action in
//                        completionHandler(otherString)
//                    }))
//                }
//                if cancelString != nil {
//                    alertController.addAction(UIAlertAction(title: cancelString ?? "Cancel", style: .default, handler: { action in
//                        cancelHandler()
//                    }))
//                }
//            }
//            
//            DispatchQueue.main.async(execute: {
//                vc?.present(alertController, animated: true)
//            })
//
//        }


    }
    
//    func showCouponOfferPopup(couponName name: String){
//        let Story = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = Story.instantiateViewController(withIdentifier: "CouponPopupStory") as? CouponPopupVC
//        myVC?.providesPresentationContextTransitionStyle = true
//        myVC?.definesPresentationContext = true
//        myVC?.couponName = name
//        myVC?.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//        if let myVC = myVC{
//            present(myVC, animated: true)
//        }
//    }
    
    // MARK: - GET STRING NOT NULL OR EMPTY
    func getNotNullString(string:String?)->String{
            let blankString = ""
            if let strValue = string {
                switch strValue
                {
                case "<nil>","(null)","<null>":
                    return blankString
                default:
                    return strValue
                }
            }
            else
            {
                let optionalString = (string ?? blankString)
                return optionalString
            }
        }
    
    //===================================================================
    // MARK: - UIPOPOVERCONTROLLER DELEGATE METHOD
    //===================================================================
    // MARK: - DROPDOWN LIST POPUP
    func dropDownList(on sender: UIView?, array1: [AnyObject]?, arrowDirection direction: UIPopoverArrowDirection, searchView issearchView: Bool = false, title titletext: String? = "Select Item",arrKeyName keyName:String?="", completion: @escaping (Any?) -> Void) {
//            let Story = UIStoryboard(name: "Main", bundle: nil)
//            let myVC = Story.instantiateViewController(withIdentifier: "ListTable") as? ListTableVC
//            myVC?.modalPresentationStyle = .popover
//            
//            
//            myVC?.preferredContentSize   = issearchView == true ? CGSizeMake(view.frame.size.width , Double(44 * (array1?.count ?? 0) + 142)) : CGSizeMake(view.frame.size.width , Double(44 * (array1?.count ?? 0) + 85))
//            myVC?.arrList1 = array1 ?? []
//            
//            myVC?.titleLabel = titletext ?? "Select Item"
//            myVC?.isSearchView = issearchView
//        myVC?.keyName=keyName ?? ""
//            let popoverVC = myVC?.popoverPresentationController
//            popoverVC?.delegate=self
//    
//            popoverVC?.permittedArrowDirections = direction
//            popoverVC?.sourceView = sender
//            popoverVC?.sourceRect = CGRectMake((sender?.frame.width ?? 0) / 2, sender?.frame.height ?? 0,0,0)
//    
//            if let myVC = myVC {
//                present(myVC, animated: true)
//            }
//    
//            myVC?.onCompletionDone = { dictSelected in
//                completion(dictSelected)
//                self.dismiss(animated: true)
//            }
        }
    
    // MARK: - DROPDOWN MULTI SELECT LIST POPUP
    func dropDownMultiList(on sender: UIView?, array1: [AnyObject]?, arrowDirection direction: UIPopoverArrowDirection, searchView issearchView: Bool = false, title titletext: String? = "Select Item",arrKeyName keyName:String?="",arraySelected selectedArray: [AnyObject]? = [],completion: @escaping ([AnyObject]?) -> Void) {
//            let Story = UIStoryboard(name: "Main", bundle: nil)
//            let myVC = Story.instantiateViewController(withIdentifier: "MultiListTableStory") as? MultiSelectListTableVC
//            myVC?.modalPresentationStyle = .popover
//            
//            
//            myVC?.preferredContentSize   = issearchView == true ? CGSizeMake(view.frame.size.width , Double(44 * (array1?.count ?? 0) + 142)) : CGSizeMake(view.frame.size.width , Double(44 * (array1?.count ?? 0) + 85))
//            myVC?.arrList1 = array1 ?? []
//            myVC?.selectedArr = selectedArray ?? []
//            myVC?.titleLabel = titletext ?? "Select Item"
//            myVC?.isSearchView = issearchView
//            myVC?.keyName=keyName ?? ""
//            let popoverVC = myVC?.popoverPresentationController
//            popoverVC?.delegate=self
//    
//            popoverVC?.permittedArrowDirections = direction
//            popoverVC?.sourceView = sender
//            popoverVC?.sourceRect = CGRectMake((sender?.frame.width ?? 0) / 2, sender?.frame.height ?? 0,0,0)
//    
//            if let myVC = myVC {
//                present(myVC, animated: true)
//            }
//    
//            myVC?.onCompletionDone = { dictSelected in
//                completion(dictSelected)
//                self.dismiss(animated: true)
//            }
        }
    
    
    // MARK: - DROPDOWN DATEPICKER POPUP
        func ShowDatePicker(on sender: UIView?, arrowDirection direction: UIPopoverArrowDirection, title titletext: String? = "DateTime",DateTime showDateTime: String? = "", completion: @escaping (_ btnString: String?) -> Void) {
//            let Story = UIStoryboard(name: "Main", bundle: nil)
//            let myVC = Story.instantiateViewController(withIdentifier: "popup") as? DatePickerVC
//            myVC?.modalPresentationStyle = .popover
//            myVC?.preferredContentSize   = CGSizeMake(280, 400)
//            myVC?.titleLabel = titletext ?? "DateTime"
//            myVC?.showDateTime = showDateTime ?? ""
//            let popoverVC = myVC?.popoverPresentationController
//            popoverVC?.permittedArrowDirections = direction
//            popoverVC?.sourceView = sender
//            popoverVC?.sourceRect = CGRectMake((sender?.frame.width ?? 0) / 2, sender?.frame.height ?? 0,0,0)
//            popoverVC?.delegate = self
//            if let myVC = myVC {
//                present(myVC, animated: true)
//            }
//    
//            myVC?.onCompletionDone = { dictSelected in
//                completion(dictSelected)
//                self.dismiss(animated: true)
//            }
        }
    // MARK: - DROPDOWN DATEPICKER POPUP WITH MIN AND MAX DATES
    func ShowDatePickerWithLimit(on sender: UIView?, arrowDirection direction: UIPopoverArrowDirection, title titletext: String? = "DateTime",DateTime showDateTime: String? = "",minDate minimumDate:Date?=Date(),maxDate maximumDate:Date?=Date(),NoOfDays noOfDays:Int?=0,isTime isTimePicker:Bool?=false ,completion: @escaping (_ btnString: String?) -> Void) {
//            let Story = UIStoryboard(name: "Main", bundle: nil)
//            let myVC = Story.instantiateViewController(withIdentifier: "popup") as? DatePickerVC
//            myVC?.modalPresentationStyle = .popover
//            myVC?.preferredContentSize   = CGSizeMake(280, 400)
//            myVC?.titleLabel = titletext ?? "DateTime"
//            myVC?.showDateTime = showDateTime ?? ""
//            myVC?.minDate = minimumDate ?? Date()
//            myVC?.noOfDays = noOfDays ?? 0
//
//            //myVC?.maxDate = maximumDate ?? Date()
//            myVC?.isTimePicker = isTimePicker ?? false
//            let popoverVC = myVC?.popoverPresentationController
//            popoverVC?.permittedArrowDirections = direction
//            popoverVC?.sourceView = sender
//            popoverVC?.sourceRect = CGRectMake((sender?.frame.width ?? 0) / 2, sender?.frame.height ?? 0,0,0)
//            popoverVC?.delegate=self
//            if let myVC = myVC {
//                present(myVC, animated: true)
//            }
//    
//            myVC?.onCompletionDone = { dictSelected in
//                completion(dictSelected)
//                self.dismiss(animated: true)
//            }
        }
    
    // MARK: - CONVERT CURRENCY TO STRING
    func convertCurrencyToString(Str currencyStr: String?) -> String? {
        var currencyStr = currencyStr
        
        currencyStr = currencyStr?.replacingOccurrences(of: ",", with: "")
        
        var isNegative = false
        if (currencyStr as NSString?)?.range(of: "(").location != NSNotFound {
            currencyStr = currencyStr?.replacingOccurrences(of: "(", with: "")
            currencyStr = currencyStr?.replacingOccurrences(of: ")", with: "")
            isNegative = true
        }
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.numberStyle = .currency //also tested with NSNumberFormatterDecimalStyle
        let currency = formatter.number(from: currencyStr ?? "")
        var numberStr: String?
        if isNegative {
            numberStr = String(format: "%.2f", currency?.doubleValue ?? 0.0 * -1)
        } else {
            numberStr = String(format: "%.2f", currency?.doubleValue ?? 0.0)
        }
        
        if currency == nil {
            numberStr = currencyStr
        }
        return numberStr
    }
    
    // MARK: - CONVERT STRING TO CURRENCY
    func convertStringToCurrency(_ valueStr: String?) -> String{
        
        var valueStr = valueStr
        valueStr = valueStr?.replacingOccurrences(of: ",", with: "")
        
        var isNegative = false
        if (valueStr as NSString?)?.range(of: "(").location != NSNotFound {
            valueStr = valueStr?.replacingOccurrences(of: "(", with: "")
            valueStr = valueStr?.replacingOccurrences(of: ")", with: "")
            isNegative = true
        }
        let CurrencySymbol = "$"//hostSettings?.custAppThemeDetails?.first?.currency ?? ""
        //print(CurrencySymbol)

        if valueStr?.contains("$") ?? false {
            valueStr = valueStr?.replacingOccurrences(of: "\(CurrencySymbol)", with: "")
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "\(CurrencySymbol)"
        var currencyStr: String?
        if Double(valueStr ?? "") ?? 0.0 >= 0 && !isNegative {
            currencyStr = "\(currencyFormatter.string(from: NSNumber(value: valueStr?.toDouble() ?? 0.0)) ?? "")"
        } else {
            currencyStr = "-\(currencyFormatter.string(from: NSNumber(value: (valueStr?.replacingOccurrences(of: "-", with: ""))?.toDouble() ?? 0.0)) ?? "")"
        }
        if (currencyStr == "(\(CurrencySymbol)0.00)") {
            currencyStr = "\(CurrencySymbol)0.00"
        }
        return currencyStr ?? "\(currencyFormatter.string(from: NSNumber(value: 0.0)) ?? "")"
    }
    
    // MARK: - VALIDATION ONLY TWO DECIMAL
    func onlyNumberWith2Decimal(_ textField: UITextField?, replacementString string: String?) -> Bool {
        if (string?.count ?? 0) != 0 {
            
            var centValue: Int
            var formatedValue: NSNumber?
            var isNegative = false
            if (textField?.text?.contains("(") ?? false) || textField?.text?.contains("-") ?? false {
                isNegative = true
            }
            
            var cleanCentString = textField?.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            var prefixStr = ""
            if (cleanCentString?.count ?? 0) > 5 {
                prefixStr = (cleanCentString as NSString?)?.substring(to: (cleanCentString?.count ?? 0) - 4) ?? ""
                cleanCentString = (cleanCentString as NSString?)?.substring(from: (cleanCentString?.count ?? 0) - 4)
                
                centValue = Int(cleanCentString ?? "") ?? 0
                if centValue != 0 {
                    if centValue / 1000 != 0 {
                        if (string?.count ?? 0) > 0 {
                            centValue = centValue * 10 + (Int(string ?? "") ?? 0)
                        } else {
                            centValue = centValue / 10
                        }
                        formatedValue = NSNumber(value: Float(centValue) / 100.0)
                        prefixStr = "\(prefixStr)\(formatedValue?.stringValue ?? "")"
                    } else if centValue / 100 != 0 {
                        if (string?.count ?? 0) > 0 {
                            centValue = centValue * 10 + (Int(string ?? "") ?? 0)
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)0\(formatedValue?.stringValue ?? "")"
                        } else {
                            centValue = centValue / 10
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)0\(formatedValue?.stringValue ?? "")"
                        }
                    } else if centValue / 10 != 0 {
                        if (string?.count ?? 0) > 0 {
                            centValue = centValue * 10 + (Int(string ?? "") ?? 0)
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)00\(formatedValue ?? 0.00)"
                        } else {
                            centValue = centValue / 10
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)\(formatedValue ?? 0.00)"
                        }
                    } else {
                        if (string?.count ?? 0) > 0 {
                            centValue = centValue * 10 + (Int(string ?? "") ?? 0)
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)00\(formatedValue ?? 0.0)"
                        } else {
                            centValue = centValue / 10
                            formatedValue = NSNumber(value: Float(centValue) / 100.0)
                            prefixStr = "\(prefixStr)\(formatedValue ?? 0.0)"
                        }
                    }
                } else {
                    if (string?.count ?? 0) > 0 {
                        prefixStr = "\(prefixStr)000.0\(string ?? "")"
                    } else {
                        prefixStr = "\(prefixStr)0.00"
                    }
                }
            } else {
                centValue = Int(cleanCentString ?? "") ?? 0
                
                if (string?.count ?? 0 > 0) {
                    centValue = centValue * 10 + (Int(string ?? "") ?? 0)
                } else {
                    centValue = centValue / 10
                }
                formatedValue = NSNumber(value: Float(centValue) / 100.0)
                prefixStr = "\(prefixStr)\(formatedValue ?? 0.00)"
            }
            let f = NumberFormatter()
            f.numberStyle = .decimal
            formatedValue = f.number(from: prefixStr)
            let _currencyFormatter = NumberFormatter()
            _currencyFormatter.numberStyle = .currency
            
            if isNegative {
                textField?.text = "(\(_currencyFormatter.string(from: formatedValue ?? 0) ?? ""))"
            } else {
                textField?.text = _currencyFormatter.string(from: formatedValue ?? 0)
            }
            return false
        } else {
            var f = NSNumber()
            f = 0.00
            let _currencyFormatter = NumberFormatter()
            _currencyFormatter.numberStyle = .currency
            
            textField?.text = _currencyFormatter.string(from: f)
            return false
        }
    }
    
    // MARK: - VALIDATION ONLY NUMARIC CHARACTER
    func getNumaricCharOnly(string:String?="")-> Bool {
        let allowingChars = "0123456789"
        let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
        let validString = string?.rangeOfCharacter(from: numberOnly) == nil
        return validString
    }
    //MARK: VALIDATION ONLY Alphabet and Space CHARACTER
    func getAlphabetandSpaceOnly(string:String?="")-> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string!)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
    func getAlphabetandSpaceOnlywithDot(string:String?="")-> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string!)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
          
    
    // MARK: - VALIDATION IP ADDRESS CHECK
    func ipCheck(_ textField: UITextField?, shouldChangeCharactersIn range: NSRange, replacementString string: String?) -> Bool {
        var ipEntered: String?
        if string != "" {
            
            ipEntered = "\((textField?.text as NSString?)?.substring(to: range.location) ?? "")\(string ?? "")"
        }
        
        let validIPRegEx = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])[.]){0,3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])?$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", validIPRegEx)
        if string == "" {
            
            return true
        } else if emailTest.evaluate(with: ipEntered) {
            
            return true
        } else {
            
            return false
        }
    }
    
    // MARK: - VALIDATION IP ADDRESS VALID OR NOT
    func isValidIPAdress(_ testStr:String) -> Bool {
        let ipAddressRegex = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        
        let ipAddTest = NSPredicate(format:"SELF MATCHES %@", ipAddressRegex)
        print("ipAddTest.evaluateWithObject(testStr) = \(ipAddTest.evaluate(with: testStr))")
        return ipAddTest.evaluate(with: testStr)
    }
    //MARK: CHECK CARD VALID OR NOT
    func isCardDetailValid(cardNumber : String, month : NSNumber, year : NSNumber, cvv : String) -> Bool {
//        let params = STPCardParams()
//        params.number = cardNumber
//        params.expMonth = UInt(month)
//        params.expYear = UInt(year)
//        params.cvc = cvv
//        if STPCardValidator.validationState(forCard: params) == .valid {
//            return true
//        } else {
//            return false
//        }
        return true
    }
    
    //======================================================================
    // MARK: - GET CONNECTED IP_ADDRESS METHOD
    //======================================================================
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
                freeifaddrs(ifaddr)
            }
            return address ?? ""
        }
    
    //MARK: - CONVERT RATING POINT TO STARS
    func ratingToStars(rating: Double? = 0.0) -> String{
        return ""
    }
    // MARK: - DATES (CONVERT DATE FORMAT :-)
    
    func getDateFormattedFromStringDate(strDate: String, withInputFormat inputFormat: String, andOutputFormat outputFormat: String, isTypeOfString isString: Bool) -> Any {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = inputFormat
        
        let dte = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = outputFormat
        
        if isString {
            let strFormattedDate = dateFormatter.string(from: dte ?? Date())
            return strFormattedDate as Any
        }
        else {
            let strFormattedDate = dateFormatter.string(from: dte ?? Date())
            let formattedDate = dateFormatter.date(from: strFormattedDate)
            return formattedDate as Any
        }
    }
    
    func getserverToLocalDate(date selecteddate: Date, output outputFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = outputFormate
        let strdate = dateFormatter.string(from: selecteddate)
        
        return strdate
    }
    
    func getlocalToserverDate(date strDate: String, input inputFormate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormate
        let date = dateFormatter.date(from: strDate)
        
        return date
    }
    func getUTCDate(date strDate: String)-> String{
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let utcDate = dateFormatter.date(from: strDate)
        let utcDateFormatter = DateFormatter()
         utcDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         utcDateFormatter.timeZone = TimeZone(identifier: "UTC")
         let utcString = utcDateFormatter.string(from: utcDate ?? Date())
        return utcString
    }
    func getFormattedTime(_ strTime: String?, withInputFormat inputFormat: String?, andOutputFormat outputFormat: String?) -> String? {
        let dateFormat = DateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormat.locale = locale as Locale
        dateFormat.dateFormat = inputFormat
        let dte = dateFormat.date(from: strTime ?? "")
        dateFormat.dateFormat = outputFormat
        var strFormattedDate: String? = nil
        if let dte = dte {
            strFormattedDate = dateFormat.string(from: dte)
        }
        return strFormattedDate
    }
    func imageWith(fName: String?="abc",lName: String?="abc",width imgWidth: CGFloat?=75,height imgHeight: CGFloat?=75) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .lightGray
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        let first = fName?.first?.description
        let last = lName?.first?.description
        
        nameLabel.text = (first ?? "").capitalized + (last ?? "").capitalized
        UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
    
    func downloadImage(_ urlString: String, completion: ((_ image: UIImage?, _ urlString: String?) -> ())?) {
       guard let url = URL(string: urlString) else {
          completion?(nil, urlString)
          return
      }
      URLSession.shared.dataTask(with: url) { (data, response,error) in
         if let error = error {
            print("error in downloading image: \(error)")
            completion?(nil, urlString)
            return
         }
         guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            completion?(nil, urlString)
            return
         }
         if let data = data, let image = UIImage(data: data) {
            completion?(image, urlString)
            return
         }
         completion?(nil, urlString)
      }.resume()
    }
}
//===================================================================
// MARK: - TIMEZONE
//===================================================================
extension TimeZone {

    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }

    func offsetInHours() -> String
    {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    func localDate() -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
            guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}

            return localDate
        }
    func dateInTimeZone(timeZoneIdentifier: String, dateFormat: String) -> String {
      let dtf = DateFormatter()
      dtf.timeZone = TimeZone(identifier: timeZoneIdentifier)
      dtf.dateFormat = dateFormat

      return dtf.string(from: self)
  }
}
//===================================================================
// MARK: - STRING ====> UIDESIGN
//===================================================================

extension String {
    //Check String Length
//    var length: Int { return self.count }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    var isContainCapital: Bool{
        NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: self)
    }
    var isContainSmall: Bool{
        NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: self)
    }
    var isContainNumber: Bool{
        NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: self)
    }
    var isContainSpecial: Bool{
        NSPredicate(format: "SELF MATCHES %@", ".*[!&^%$#@()/_*+-]+.*").evaluate(with: self)
    }
    var isValidEmail: Bool {
           NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
       }
    var domainCheck: Bool{
        return self.contains(".com") || self.contains(".net") || self.contains(".org") || self.contains(".in")
    }
    var isValidPhone: Bool {
           NSPredicate(format: "SELF MATCHES %@", "^[0-9]{10}$").evaluate(with: self)
       }
    var isPasswordValid: Bool{
       
        var minLength = Int()
        var maxLength = Int()
//        if hostSettings?.custAppThemeDetails?.first?.isLengthPassword == 0{
//            minLength = 4
//            maxLength = 15
//        }
//        else{
//            minLength = hostSettings?.custAppThemeDetails?.first?.passwordMinLength ?? 4
//            maxLength = hostSettings?.custAppThemeDetails?.first?.passwordMaxLength ?? 15
//        }
       
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{\(minLength),\(maxLength)}$").evaluate(with: self)
    }
}
//===================================================================
// MARK: - UITapGestureRecognizer ====> UIDESIGN
//===================================================================
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
//===================================================================
// MARK: - BUTTON ====> UIDESIGN
//===================================================================
extension UIButton {

    //MARK: BUTTON CURVE :-
    func makeButtonCurve(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    //MARK: BUTTON ROUNDED :-
    func makeButtonRounded() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
       
    }
}

//===================================================================
// MARK: - VIEW ====> UIDESIGN
//===================================================================

extension UIView {
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    func makeViewCurve(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeViewBorderWithCurve(radius: CGFloat, bcolor: UIColor = .black, bwidth: CGFloat = 1) {
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = bwidth
        self.layer.borderColor = bcolor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
   
    func viewShadow(){
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
    }
    func btnShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.masksToBounds = false
    }
    func fadeIn(duration: TimeInterval = 0.5,
                  delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
          self.alpha = 1.0
        }, completion: completion)
      }

      func fadeOut(duration: TimeInterval = 0.5,
                   delay: TimeInterval = 0.0,
                   completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
          self.alpha = 0.0
        }, completion: completion)
      }
}

extension UIColor {
    // Press Cmd + Shift + L to open library and then select Color tab.
    static let ecom_transparent         = UIColor(named: "ecom_transparent")        // #000000 50%
    static let ecom_background          = UIColor(named: "ecom_background")         // #EFEFF7
    static let ecom_main                = UIColor(named: "ecom_main")               // #01467C
    static let ecom_vwbackground        = UIColor(named: "ecom_vwbackground")       // #01467C
    static let ecom_cellbackground      = UIColor(named: "ecom_cellbackground")     // #5CA0FF 10%
    static let ecom_buttonColor         = UIColor(named: "ecom_buttonColor")        // #FF6600
    static let ecom_white_transparent   = UIColor(named: "ecom_white_transparent")  // #FFFFFF 50%
    static let borderColor              = UIColor(named: "borderColor")             // #B1C5C1
    static let tab_bar_back             = UIColor(named: "tab_bar_back")            // #52535F
    static let unselected_tabbar_color  = UIColor(named: "unselected_tabbar_color") // #989898
    static let socialBorderColor        = UIColor(named: "socialBorderColor")       // #EAF2FB
    static let category_background      = UIColor(named: "category_background")     // #FFF0E5
    static let reviewChartColour        = UIColor(named: "reviewChartColour")       // #F9A530
    static let ecom_green               = UIColor(named: "ecom_green")              // #2AB26E
    static let ecom_red                 = UIColor(named: "ecom_red")                // #FF6161
    static let ecom_outofstock_red      = UIColor(named: "ecom_outofstock_red")     // #F1416C
    static let ecom_black               = UIColor(named: "ecom_black")              // #1D160D
    static let ecomrating_yellow        = UIColor(named: "ecom_rating_yellow")      // #FFA01C
    static let Pending                  = UIColor(named: "Pending")                 // #E9AB56
    static let InProgress               = UIColor(named: "InProgress")              // #3C8DBC
    static let Delivered                = UIColor(named: "Delivered")               // #2AB26E
    static let Cancelled                = UIColor(named: "Cancelled")               // #FF6161
    static let Assigned                 = UIColor(named: "Assigned")                // #FD7D26
    
    func toHexString() -> String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0

            getRed(&r, green: &g, blue: &b, alpha: &a)

            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

            return NSString(format:"#%06x", rgb) as String
        }
    
}
extension UILabel{
    func addUnderLineToLabel() {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.ecom_main?.cgColor
        bottomLine.cornerRadius = 2.5
        
        
        self.layer.addSublayer(bottomLine)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
//    func setRightImageWithPaddingPoints(_ amount:CGFloat,name:String) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30 + amount, height: self.frame.size.height))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        let image = UIImage(named: name)
//        imageView.center = CGPoint(x: paddingView.frame.size.width/2, y: paddingView.frame.size.height/2)
//        imageView.image = image
//        paddingView.addSubview(imageView)
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
    func makeTextViewBorderWithCurve(radius: CGFloat, bcolor: UIColor = .black, bwidth: CGFloat = 1,leftPadding:CGFloat?=10) {
        self.leftViewMode = .always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding!, height: 40))
        self.leftView = view
        self.layer.cornerRadius = radius
        self.layer.borderWidth = bwidth
        self.layer.borderColor = bcolor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    func addUnderLine () {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.size.height+3, width: self.frame.size.width, height: 1.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    //To insert Image in TextField left
    func setLeftImageToTextField(imgName: String,imgWidth: CGFloat?=24,imgHight: CGFloat?=24,padding: CGFloat?=10)
    {
        let view=UIView(frame: CGRect(x: 0, y: 0, width: imgWidth! + padding!, height: imgHight!))
        let disUser: UIImageView = UIImageView(image:UIImage(named: imgName))
        disUser.frame = CGRect(x: 0, y: 0, width: imgWidth!, height: imgHight!)
        disUser.backgroundColor = UIColor .clear
        disUser.clipsToBounds = true
        self.leftViewMode = .always
        disUser.isUserInteractionEnabled = true
        view.addSubview(disUser)
        self.leftView = view
    }
    func setEyeImagetoPasswordFields(imgname: String,imgWidth:CGFloat?=24,imgHeight:CGFloat?=24){
        self.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!))
        
        let image = UIImage(named: imgname)
        
        imageView.image = image
        imageView.tintColor = UIColor.black
        let tap=UITapGestureRecognizer(target: self, action: #selector(self.tapbutton))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.tag=1
        
        self.rightView = imageView

    }
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
        iconView.tintColor = UIColor.ecom_buttonColor
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    //Set image on right of textfield
    func rightImage(name: String){
        
        self.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        let image = UIImage(named: name)
        
        imageView.image = image
        imageView.tintColor = UIColor.black
        self.rightView = imageView
        
    }
    
    @objc func tapbutton(){
        if self.isSecureTextEntry == true{
            self.setEyeImagetoPasswordFields(imgname: "OpenEye")
        }
        else{
            self.setEyeImagetoPasswordFields(imgname: "ClosedEye")
        }
        
        self.isSecureTextEntry.toggle()
    }
   
    
    

}
extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

//        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: 20))
//        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: )
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = UIScreen.main.bounds.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 3.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 5.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.ecom_main
        
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (UIScreen.main.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}
extension UIAlertController {

    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }

    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }

        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }

    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }

        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
extension UICollectionView {

    func drawLineFrom(
        from: IndexPath,
        to: IndexPath,
        lineWidth: CGFloat = 2,
        strokeColor: UIColor = UIColor.darkGray
    ) {
//        
//        let fromPoint = self.dequeueReusableCell(withReuseIdentifier: "eventCell", for: from) as? LiveMatchEventCell
//        let toPoint = self.dequeueReusableCell(withReuseIdentifier: "eventCell", for: to) as? LiveMatchEventCell
//
//        let path = UIBezierPath()
//
//        guard let fromCenter = fromPoint?.center else { return }
//        guard let toCenter = toPoint?.center else { return }
//
//        path.move(to: convert(fromCenter, to: self))
//        path.addLine(to: convert(toCenter, to: self))
//
//        let layer = CAShapeLayer()
//
//        layer.path = path.cgPath
//        layer.lineWidth = lineWidth
//        layer.strokeColor = strokeColor.cgColor
//
//        self.layer.insertSublayer(layer, at: 0)
    }
}
