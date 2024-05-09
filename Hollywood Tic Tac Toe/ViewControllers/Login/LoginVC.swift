//
//  LoginVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 06/05/24.
//

import UIKit
import AuthenticationServices
import NVActivityIndicatorView

class LoginVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var keyStore = NSUbiquitousKeyValueStore()
    @IBOutlet weak var loginGuest:UIButton!
    @IBOutlet weak var appleLogin:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
        loginGuest.cornerRadius = 25
        appleLogin.cornerRadius = 25
    }
}

// MARK: - Private
private extension LoginVC {
    
    func setupBaseAppearance() {
        setupNavigationBar()
        containerView.addViewDarkShadow()
        Helper().addActivityIndicator()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Action
extension LoginVC {
    
    @IBAction func appleLoginBtn(_ sender: Any) {
        continueWithApple()
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        pref.isLogin = false
        self.navigationController?.pushViewController(HomeVC.view(from: .Main)!, animated: true)
    }
    
    @IBAction func policyBtn(_ sender: Any) {
        self.navigationController?.pushViewController(PrivacyPolicyVC.view(from: .Main)!, animated: true)
    }
    
    @IBAction func termsOfUseBtn(_ sender: Any) {
        self.navigationController?.pushViewController(TermsOfUseVC.view(from: .Main)!, animated: true)
    }
}

extension LoginVC {
    func continueWithApple() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()

        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self

        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }
    
    func saveLoginData() {
        pref.isLogin = true
        let date = Date().toString(format: "dd-MM-yyyy")
        pref.rewardDate = "\(date)"
        if pref.rewardScore == "" {
            pref.rewardScore = "10"
        }else {
            if pref.userProfileModel.fname == "" {
                if let appleId = keyStore.string(forKey: "appleId") {
                    if appleId == pref.userProfileModel.appleId {
                        let reward = Int(pref.rewardScore) ?? 0
                        pref.rewardScore = "\(reward + 10)"
                    }else {
                        pref.rewardScore = "10"
                    }
                }else {
                    pref.rewardScore = "10"
                }
            }else {
                pref.rewardScore = "10"
            }
        }
        keyStore.set(pref.userProfileModel.name, forKey: "name")
        keyStore.set(pref.userProfileModel.email, forKey: "email")
        keyStore.set(pref.userProfileModel.appleId, forKey: "appleId")
        keyStore.synchronize()
        completedLogin()
    }
    
    func completedLogin() {
        DispatchQueue.main.async {
            Helper.stopLoader()
        }
        self.navigationController?.pushViewController(HomeVC.view(from: .Main)!, animated: true)
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("in error")
        print(error.localizedDescription)
        DispatchQueue.main.async {
            Helper.stopLoader()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("inside appl")
        DispatchQueue.main.async {
            Helper.startLoader()
        }
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async { [self] in
                let appleId = "\(appleIDCredential.user)"
                pref.userProfileModel.appleId = appleId
                let appleUserFirstName = "\(appleIDCredential.fullName?.givenName ?? "")"
                let appleUserLastName = "\(appleIDCredential.fullName?.familyName ?? "")"
                let appleUserEmail = "\(appleIDCredential.email ?? "")"
                if appleUserFirstName != "" {
                    UserDefaults.standard.set(appleUserFirstName, forKey: "appleFname")
                    pref.userProfileModel.fname = appleUserFirstName
                }else {
                    pref.userProfileModel.fname = "\(UserDefaults.standard.value(forKey: "appleFname") ?? "")"
                }
                if appleUserLastName != "" {
                    UserDefaults.standard.set(appleUserLastName, forKey: "appleLname")
                    pref.userProfileModel.lname = appleUserLastName
                }else {
                    pref.userProfileModel.lname = "\(UserDefaults.standard.value(forKey: "appleLname") ?? "")"
                }
                if appleUserEmail != "" {
                    UserDefaults.standard.set(appleUserEmail, forKey: "appleEmail")
                    pref.userProfileModel.email = appleUserEmail
                }else {
                    pref.userProfileModel.email = "\(UserDefaults.standard.value(forKey: "appleEmail") ?? "")"
                }
                pref.userProfileModel.name = "\(pref.userProfileModel.fname) \(pref.userProfileModel.lname)"
                if pref.userProfileModel.fname == "" {
                    if let appleId = keyStore.string(forKey: "appleId") {
                        if appleId == pref.userProfileModel.appleId {
                            let name = keyStore.string(forKey: "name")
                            pref.userProfileModel.name = "\(name ?? "")"
                            let email = keyStore.string(forKey: "email")
                            pref.userProfileModel.email = "\(email ?? "")"
                        }
                    }
                }
                print("appleUserFirstName: \(appleUserFirstName)")
                print("appleUserLastName: \(appleUserLastName)")
                print("appleId: \(appleId)")
                print("appleUserEmail: \(appleUserEmail)")
                self.saveLoginData()
            }
        } else if authorization.credential is ASPasswordCredential {
        //let appleUsername = passwordCredential.user
        //let applePassword = passwordCredential.password
        }
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
