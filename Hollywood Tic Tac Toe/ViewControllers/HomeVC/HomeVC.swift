//
//  HomeVC.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 07/05/24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var scoreArray: [String]? = nil
    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var settingView: UIView!
    
    var keyStore = NSUbiquitousKeyValueStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScore()
    }
}

// MARK: - Private
private extension HomeVC {
    
    func setupBaseAppearance() {
        setupNavigationBar()
        rewardView.addViewShadow()
        scoreView.addViewShadow()
        playView.addViewShadow()
        ruleView.addViewShadow()
        settingView.addViewShadow()
//        rewardsLabel.text = "\(pref.rewardScore)"
        playView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        ruleView.roundCorners(corners:UIRectCorner.allCorners , radius: 20)
        settingView.roundCorners(corners:UIRectCorner.allCorners , radius: 10)
        nameLabel.textColor = .black
    }
    
    func updateScore() {
        if pref.isLogin {
            if let appleId = keyStore.string(forKey: "appleId") {
                if appleId == pref.userProfileModel.appleId {
                    let name = keyStore.string(forKey: "name")
                    print("name:  \(name)")
                    nameLabel.text = "Hi, \(name ?? "")👋"
                    getFinalScore()
                    scoreLabel.text = "\(pref.finalScore)"
                    
                }else {
                    print("in second")
                    nameLabel.text = "Hi, \(pref.userProfileModel.name)👋"
                    scoreLabel.text = "\(pref.currentScore)"
                }
            }else {
                nameLabel.text = "Hi, \(pref.userProfileModel.name)👋"
                scoreLabel.text = "0"
            }
        }else {
            nameLabel.text = "Hi, Guest👋"
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Action
extension HomeVC {
    
    @IBAction func scoreBtn(_ sender: Any) {
        if pref.isLogin {
            self.navigationController?.pushViewController(ScoreVC.view(from: .Main)!, animated: true)
        }else {
            self.alert(message: "Please login to continue.")
        }
    }
    
    func alert(message: String) {
        DispatchQueue.main.async {
            Helper().popUPWithCancel(message: message, title: "Message") { success in
                if success {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKeys.logout), object: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        self.navigationController?.pushViewController(SettingsVC.view(from: .Main)!, animated: true)
    }
    
    @IBAction func playBtn(_ sender: Any) {
        self.navigationController?.pushViewController(PlayGameVC.view(from: .Main)!, animated: true)
    }
    
    @IBAction func rulesBtn(_ sender: Any) {
        self.navigationController?.pushViewController(GameRulesVC.view(from: .Main)!, animated: true)
    }
    func getFinalScore() {
        if let appleId = keyStore.string(forKey: "appleId") {
            if appleId == pref.userProfileModel.appleId {
                if let scoreArr = keyStore.array(forKey: "savedScore") {
                    // Safely cast scoreArr to an array of dictionaries
                    if let scoreData = scoreArr as? [[String: Any]] {
                        // Access the first element (assuming you want the final score for the first day)
                        if let firstElement = scoreData.last {
                            // Extract final score (handle potential absence)
                            if let finalScore = firstElement["finalScore"] as? String {
                                pref.finalScore = finalScore
                                scoreLabel.text = finalScore
                            } else {
                                print("No 'finalScore' key found in the first element.")
                                scoreLabel.text = "0" // Or use a more appropriate default value
                            }
                        } else {
                            print("No data found in the first element of scoreArr")
                            // Handle the case where the first element is missing (e.g., set default score)
                            scoreLabel.text = "0" // Or use a more appropriate default value
                        }
                    } else {
                        print("Failed to cast scoreArr to an array of dictionaries")
                        // Handle the case where the cast fails (e.g., set default score)
                        scoreLabel.text = "0" // Or use a more appropriate default value
                    }
                } else {
                    print("No score data found in keyStore")
                    // Handle the case where no score data is found (e.g., set default score)
                    scoreLabel.text = "0" // Or use a more appropriate default value
                }
            }
        }
    }

}

