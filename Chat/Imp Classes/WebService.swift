//
//  WebService.swift
//  JMSC_POS_CORP_iPAD
//
//  Created by Mike Patel on 12/23/22.
//

import Foundation
import UIKit
import Alamofire

var Progress  = Settings()
var headers: HTTPHeaders = [
        .authorization(bearerToken: bearer_token)]
//MARK: HTTP Method Name :-
public enum HTTPMethodName: String {
    case GET        = "GET"
    case POST       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
    case patch      = "PATCH"
}

//MARK: Enum For Status String  :-
enum responseStatus: String {
    
    case Success        = "Success"
    case Failed         = "Failed"
    case errorMessage   = "OK"
    case Pending        = "Pending"
    
}
enum EnumSucessStatus: String {
    
    case Success        = "Success"
    case ItemNotFound   = "Item Not Found !!"
    case Invalid_item_code   = "Invalid item code"
    case Pending   = "Pending"
}

func readLocalJSONFile<T: Codable>(forName name: String,
                                   Model_Name   : T.Type,
                                   OnSucess     :@escaping(T) ->Void,
                                   OnFail       :@escaping(String) ->Void) {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                OnSucess(decodedData)
            } catch {
                print("error: \(error)")
                OnFail("error: \(error)")
            }
        }
    } catch {
        print("error: \(error)")
        OnFail("error: \(error)")
    }
}
func readLocalJSONFileIntoDictionary(forName name: String,
                                     OnSucess     :@escaping(AnyObject) ->Void,
                                   OnFail       :@escaping(String) ->Void) {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            
            do {
                //let decodedData = try JSONDecoder().decode(T.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data)
                print("\n\n------------Response Json ------------\n", json)
                
                OnSucess(json as AnyObject)
            } catch {
                print("error: \(error)")
                OnFail("error: \(error)")
            }
        }
    } catch {
        print("error: \(error)")
        OnFail("error: \(error)")
    }
}

func CallService<T: Codable>( Model_Name    : T.Type,
                                URLstr      : String,
                                method      : String = HTTPMethodName.POST.rawValue,
                              parameters    : Alamofire.Parameters? = nil,
                                encoding    : ParameterEncoding = JSONEncoding.default,
                                headers     : HTTPHeaders? = headers,
                                hideProgress: Bool? = false,
                                OnSucess    :@escaping(T) ->Void,
                                OnFail      :@escaping(String) ->Void)
{
    //MARK: - Set Progress Hud
    if !(hideProgress ?? false){
        Progress.showProgress()
    }
   
    
    print("\n\n------------Request URL ------------\n", URLstr);
    if let param = parameters {
        var JsonData: Data? = nil
        do {
            JsonData = try JSONSerialization.data(withJSONObject: param, options: [.prettyPrinted,.withoutEscapingSlashes,.fragmentsAllowed])
        } catch {
            print("No Json")
        }
        var jsonString: String? = nil
        if let JsonData {
            jsonString = String(data: JsonData, encoding: .utf8)
            print(jsonString!);
        }
        
        
    }
    if NetworkReachabilityManager()?.isReachable == true {
        AF.request(URLstr,method: HTTPMethod(rawValue: method) ,parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            //MARK: - Dismiss Progress Hud
//            Progress.dismissProgress()
//            if  response.error?.errorDescription != nil {
//                // ---  SHOW ALERT THAT URL NOT VALID OR PARAMETER NOT SEND OR STATUS CODE "400" ETC
//                print(response.error?.errorDescription ?? "")
//                OnFail(response.error?.errorDescription ?? "")
//            }
            if (200...300).contains(response.response?.statusCode ?? 0){
                switch response.result{
                case .success(let ModelClass):
                    Progress.dismissProgress()
                    
                    //Below Code Only Used to print Response of Server in Json Format
                    do {
                        if let da = response.data {
                            let json = try JSONSerialization.jsonObject(with: da) as AnyObject
                            print("\n\n------------Response Json ------------\n", json)
                        }
                    } catch let error {
                        print(error)
                    }
                    OnSucess(ModelClass)
                    break
                case .failure(let err):
                    print(err)
                    Progress.dismissProgress()
                    showAlertController(message: AlertMsg.failService.rawValue, forOther: "OK", isSingle: true) { btnString in }
                }
            }
            else{
                print("Fail")
                Progress.dismissProgress()
                showAlertController(message: AlertMsg.somethingWrong.rawValue, forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
            }
        }
    } else {
        print("Fail")
        Progress.dismissProgress()
        showAlertController("No Internet",message: "Make sure your device is connected to the internet.", forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
    }
    
}
func CallWebServiceWithToken<T: Codable>( Model_Name    : T.Type,
                                URLstr      : String,
                                method      : String = HTTPMethodName.POST.rawValue,
                                parameters  : Alamofire.Parameters? = nil,
                                encoding    : ParameterEncoding = JSONEncoding.default,
                                headers     : HTTPHeaders? = headers,
                                hideProgress: Bool? = false,
                                OnSucess    :@escaping(T) ->Void,
                                OnFail      :@escaping(String) ->Void)
{
    //MARK: - Set Progress Hud
    if !(hideProgress ?? false){
        Progress.showProgress()
    }
    
    print("\n\n------------Request URL ------------\n", URLstr);
    if let param = parameters {
        var JsonData: Data? = nil
        do {
            JsonData = try JSONSerialization.data(withJSONObject: param, options: [.prettyPrinted,.withoutEscapingSlashes,.fragmentsAllowed])
        } catch {
            print("No Json")
        }
        var jsonString: String? = nil
        if let JsonData {
            jsonString = String(data: JsonData, encoding: .utf8)
            print(jsonString!);
        }
        
        
    }
    if NetworkReachabilityManager()?.isReachable == true {
        AF.request(URLstr,method: HTTPMethod(rawValue: method) ,parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            //MARK: - Dismiss Progress Hud
//            Progress.dismissProgress()
//            if  response.error?.errorDescription != nil {
//                // ---  SHOW ALERT THAT URL NOT VALID OR PARAMETER NOT SEND OR STATUS CODE "400" ETC
//                print(response.error?.errorDescription ?? "")
//                OnFail(response.error?.errorDescription ?? "")
//            }
            if (200...300).contains(response.response?.statusCode ?? 0){
                switch response.result{
                case .success(let ModelClass):
                    Progress.dismissProgress()
                    
                    //Below Code Only Used to print Response of Server in Json Format
                    do {
                        if let da = response.data {
                            let json = try JSONSerialization.jsonObject(with: da) as AnyObject
                            print("\n\n------------Response Json ------------\n", json)
                            if json["status"] as? String == "Unauthorized"{
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let vc = storyBoard.instantiateViewController(withIdentifier: "LogInStory") as! LogInVC
//                                let nav = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.rootViewController = nav
                                break
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                    
                    OnSucess(ModelClass)
                    break
                case .failure(let err):
                    print(err)
                    Progress.dismissProgress()
                    showAlertController(message: AlertMsg.failService.rawValue, forOther: "OK", isSingle: true) { btnString in }
                }
            }
            else{
                print("Fail")
                Progress.dismissProgress()
                showAlertController(message: AlertMsg.somethingWrong.rawValue, forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
            }
        }
    } else {
        print("Fail")
        Progress.dismissProgress()
        showAlertController("No Internet",message: "Make sure your device is connected to the internet.", forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
    }
    
}
fileprivate func PrintRequstJson(strURL: String,  parameters: Alamofire.Parameters?) {
    print("\n\n------------Request URL ------------\n", strURL);
    if let param = parameters {
        var JsonData: Data? = nil
        do {
            JsonData = try JSONSerialization.data(withJSONObject: param, options: [.prettyPrinted,.withoutEscapingSlashes,.fragmentsAllowed])
        } catch {
            print("No Json")
        }
        var jsonString: String? = nil
        if let JsonData {
            jsonString = String(data: JsonData, encoding: .utf8)
            print(jsonString!);
        }
        
        
    }
}

func callWebServiceToFetchJsonData(strURL       : String,
                               method       : String = HTTPMethodName.POST.rawValue,
                               parameters   : Alamofire.Parameters? = nil,
                               encodeing    : ParameterEncoding =  URLEncoding.default,
                               headers      : HTTPHeaders? = headers,
                               hideProgress : Bool? = false,
                               OnSucess     : @escaping (AnyObject?) ->Void,
                               OnFail       : @escaping(String) ->Void)
{
    //MARK: - Set Progress Hud
    if !(hideProgress ?? false){
        Progress.showProgress()
    }
    
    //Th is Functin Print Requsted Json In Log
    PrintRequstJson(strURL: strURL, parameters: parameters)
    if NetworkReachabilityManager()?.isReachable == true {
        AF.request(strURL,method: HTTPMethod(rawValue: method) ,parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { response in
            //MARK: - Dismiss Progress Hud
//            Progress.dismissProgress()
//            if  response.error?.errorDescription != nil {
//                print(response.error?.errorDescription)
//            }
            if(200...300).contains(response.response?.statusCode ?? 0){
                switch response.result{
                case .success(let res):
                    Progress.dismissProgress()
                    do {
                        let json = try JSONSerialization.jsonObject(with: res) as AnyObject
                        print("\n\n------------Response Json ------------\n", json)
                        if json["status"] as? String == "Unauthorized"{
//                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyBoard.instantiateViewController(withIdentifier: "LogInStory") as! LogInVC
//                            let nav = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.rootViewController = nav
                            break
                        }
                        OnSucess(json)
                        
                    } catch let error {
                        print(String(data: res, encoding: .utf8) ?? "nothing received")
                        print(error.localizedDescription)
                    }
                    break
                case .failure(let err):
                    print(err)
                    Progress.dismissProgress()
                    showAlertController(message: AlertMsg.failService.rawValue, forOther: "OK", isSingle: true) { btnString in }
                }
            }
            else{
                print("Fail")
                Progress.dismissProgress()
                showAlertController(message: AlertMsg.somethingWrong.rawValue, forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
            }
        })
    } else {
        Progress.dismissProgress()
        showAlertController("No Internet",message: "Make sure your device is connected to the internet.", forOther: "Try Again !!", isSingle: true, textAlignment: .center) { btnString in }
    }
}

//===================================================================
// MARK: - ALERTVIEW  METHOD - CUSTOM ALERTVIEW
//===================================================================

func showAlertController(_ title: String? = "", message msg: String?, forCancel cancelString: String? = "Cancel", forOther otherString: String?, isSingle isSingleButton:Bool=false, textAlignment alignment: NSTextAlignment = .left, alertImage image: String? = "eraser.fill",backColor color:UIColor? = .ecom_background,otherButtonColor otherColor: UIColor? = .ecom_buttonColor,cancelButtonColor cancelColor: UIColor? = .red,completionHandler: @escaping (_ btnString: String?) -> Void) {
    
//    let Story = UIStoryboard(name: "Main", bundle: nil)
//    let myVC = Story.instantiateViewController(withIdentifier: "AlertStory") as? AlertVC
//    myVC?.providesPresentationContextTransitionStyle = true
//    myVC?.definesPresentationContext = true
//    myVC?.stralerttitle = title ?? ""
//    myVC?.stralertmsg = msg ?? ""
//    myVC?.btncanceltitle = cancelString ?? "Cancel"
//    myVC?.btnothertitle = otherString ?? "OK"
//    myVC?.isSingleBtn = isSingleButton
//    myVC?.textAlignment = alignment
//    myVC?.image = image ?? "eraser.fill"
//    myVC?.backgroundColor = color ?? .ecom_background!
//    myVC?.otherButtonColor = otherColor ?? .ecom_buttonColor!
//    myVC?.cancelButtonColor = cancelColor ?? .red
//    myVC?.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//
//    if let myVC = myVC {
//        let vw = UIApplication
//            .shared
//            .connectedScenes
//            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
//            .first { $0.isKeyWindow }
//
//        vw?.rootViewController?.present(myVC, animated: true)
//
//        myVC.onCompletionClose = {
//            vw?.rootViewController?.dismiss(animated: true) {}
//        }
//
//        myVC.onCompletionDone = {
//            vw?.rootViewController?.dismiss(animated: true){
//
//            }
//        }
//    }
}

class WebService :UIViewController {
    
    static let Shared:WebService = {
        let sharedInstance = WebService()
        return sharedInstance
    }()
    
//    func GetServerData(urlStr : String) {
//
//    }
//    func
//    func LoadDataSimple
    func LoadServerDataPost<T: Codable>(ModelName   : T.Type,
                                        URLstr      : String,
                                        parameters  : Alamofire.Parameters? = nil,
                                        encoding    : ParameterEncoding = JSONEncoding.default,
                                        headers     : HTTPHeaders? = headers,
                                        OnSucess    :@escaping(T) ->Void,
                                        OnFail      :@escaping(String) ->Void)
    {
        
//        AF.request("").responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let asJSON = try JSONSerialization.jsonObject(with: data)
//                    // Handle as previously success
//                } catch {
//                    // Here, I like to keep a track of error if it occurs, and also print the response data if possible into String with UTF8 encoding
//                    // I can't imagine the number of questions on SO where the error is because the API response simply not being a JSON and we end up asking for that "print", so be sure of it
//                    print("Error while decoding response: "\(error)" from: \(String(data: data, encoding: .utf8))")
//                }
//            case .failure(let error):
//                break
//                // Handle as previously error
//            }
//        }
        AF.request(URLstr, method: .post,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).responseDecodable(of: T.self) { response in
            switch response.result{
            case .success(let ModelClass):
                OnSucess(ModelClass)
                
                break
            case .failure(let err):
                print(err)
                OnFail(response.error?.errorDescription ?? "")

            }
        }
//        AF.request(URLstr ,parameters: parameters).responseDecodable(of: T.self) { response in
//
//            if  response.error?.errorDescription != nil {
//                print()
//                OnFail(response.error?.errorDescription ?? "")
//            }
//            switch response.result{
//            case .success(let ModelClass):
//                OnSucess(ModelClass)
//
//                break
//            case .failure(let err):
//                print(err)
//            }
//        }
    }
    
    
    
//    func LoadJson(){
//        var semaphore = DispatchSemaphore (value: 0)
//
//        let parameters = "{\n    \"AuthToken\":\"-!!JAIMAHARAJ!!-\",\n    \"DeviceCode\":\"123\",\n    \"DeviceKey\":\"123\",\n    \"COMPANY_ID\":\"1\",\n    \"LOCATION_ID\":\"1\"\n}"
//        let postData = parameters.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "http://192.168.2.66:80/api/SalesOnLoad/GetSalesButtonMenuList_Category")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          guard let data = data else {
//            print(String(describing: error))
//            semaphore.signal()
//            return
//          }
//            do {
//                let jsonData = try JSONDecoder().decode(GetSalesButtonMenuList_Category.self, from: data)
//                print(jsonData)
//
//
//
//                // make sure this JSON is in the format we expect
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as?  AnyObject {
//                    //                    OnSucess(T.self as! T)
//                    // try to read out a string array
//                    //                    if let names = json["names"] as? [String] {
//                    print(json)
//                    //                    }
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//            //UnComment Below line when want to JSON Decode to Your Struct xdr556
////            let nnn = try? JSONDecoder().decode(GetSalesButtonMenuList_Category.self, from: data)
//
//          print(String(data: data, encoding: .utf8)!)
//          semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
//    }
}



