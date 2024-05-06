//
//  ViewController.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import UIKit

class SplashVC: UIViewController {
    
    var webOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupBaseAppearance()
    }

}

private extension SplashVC {
    
    func setupBaseAppearance() {
        setupNavigationBar()
        self.callMasterGameAPI() { (success, responseData) in
            DispatchQueue.main.async {
                if success {
                    if responseData?.count ?? 0 > 0 {
                        let dict = responseData?["app"] as? NSDictionary
                        if dict?.count ?? 0 > 0 {
                            let turnPwa = "\(dict?["turnPwa"] ?? "")"
                            if turnPwa.lowercased() == "off" {
                                self.moveToViewController()
                            }else {
                                self.webOpen = true
                                appDelegateShared.webUrl = "\(dict?["pwaUrl"] ?? "")"
                                self.moveToViewController()
                            }
                        }else {
                            self.moveToViewController()
                        }
                    }
                }else {
                    self.moveToViewController()
                }
            }
        }
    }
    
    func moveToViewController() {
        DispatchQueue.main.async {
            Helper.stopLoader()
        }
        if webOpen {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKeys.webOpen), object: nil)
        }else {
            if pref.isLogin {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKeys.home), object: nil)
            }else {
                print("before calling login")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                    NotificationCenterKeys.login), object: nil)
            }
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension SplashVC {
    
    func callMasterGameAPI(completion: @escaping(Bool, [String : Any]?)-> Void) {
        Helper().addActivityIndicator()
        if isConnectedToNetwork() == true {
            DispatchQueue.main.async {
                Helper.startLoader()
            }
            WebServices().startParsingWithGetApi(url: WEBSERVICE_URL) { (success, responseData) in
                if success {
                    completion(true, responseData)
                }else {
                    DispatchQueue.main.async {
                        Helper.stopLoader()
                    }
                }
            }
        }
    }
}
