//
//  SettingsVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//

import UIKit
import MessageUI
class SettingsVC: UIViewController {

    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var gameSoundView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var soundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        termsView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        logoutView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        feedbackView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        gameSoundView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        deleteView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        setupBaseAppearance()
    }
    func setupBaseAppearance() {
        privacyView.addViewShadow()
        termsView.addViewShadow()
        feedbackView.addViewShadow()
        gameSoundView.addViewShadow()
        logoutView.addViewShadow()
        deleteView.addViewShadow()
        if pref.isLogin {
        }else {
            deleteView.isHidden = true
            logoutView.isHidden = true
            
        }
        updateSoundImage(pref.gameSound)
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func policyBtn(_ sender: Any) {
        self.navigationController?.pushViewController(PrivacyPolicyVC.view(from: .Main)!, animated: true)
    }
    @IBAction func gameSoundBtn(_ sender: Any) {
        updateSoundImage(pref.gameSound)
    }
    func updateSoundImage(_ isSoundOn: Bool) {
            if isSoundOn {
                soundImage.image = UIImage(named: "sound")
            } else {
                // Convert the image to grayscale
                if let image = UIImage(named: "sound") {
                    let grayscaleImage = image.withRenderingMode(.alwaysTemplate)
                    soundImage.image = grayscaleImage
                    soundImage.tintColor = .gray
                }
            }
        }
    @IBAction func termsOfUseBtn(_ sender: Any) {
        self.navigationController?.pushViewController(TermsOfUseVC.view(from: .Main)!, animated: true)
    }
    @IBAction func feedbackBtn(_ sender: Any) {
        sendEmail()
    }
    @IBAction func logoutBtn(_ sender: Any) {
        self.alert(message: "Are you sure you want to logout?")
    }
    @IBAction func deleteBtn(_ sender: Any) {
        self.alertDelete(message: "Are you sure you want to delete your account?")
    }
    func alert(message: String) {
        DispatchQueue.main.async {
            Helper().popUPWithCancel(message: message, title: "Message") { success in
                if success {
                    DispatchQueue.main.async {
                        self.moveToLogin()
                    }
                }
            }
        }
    }
    func alertDelete(message: String) {
        DispatchQueue.main.async {
            Helper().popUPWithCancel(message: message, title: "Message") { success in
                if success {
                    DispatchQueue.main.async {
                        self.resetAll()
                    }
                }
            }
        }
    }
    func resetAll() {
        pref.currentScore = "0"
        let keyStore = NSUbiquitousKeyValueStore()
        let keys: [String] = keyStore.dictionaryRepresentation.keys.compactMap { $0 }
        keys.forEach { key in
            if key == "savedScore" {
                keyStore.removeObject(forKey: key)
            }
        }
        keyStore.synchronize()
        self.moveToLogin()
    }
    func moveToLogin() {
        pref.isLogin = false
        pref.rewardScore = ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKeys.logout), object: nil)
    }
}
extension SettingsVC: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.delegate = self
        composeVC.setToRecipients(["tanrefuirubn@gmx.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .saved:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
