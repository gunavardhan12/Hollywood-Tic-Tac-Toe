//
//  PreferenceManager.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import Foundation

class PreferenceManager: NSObject {
    
    private lazy var defaults: UserDefaults = {
        UserDefaults.standard
    }()

    static let shared = PreferenceManager()

    private override init() {
    }

    var isLogin: Bool {
        set{
            defaults.setValue(newValue, forKey: PreferenceKey.login.rawValue)
            defaults.synchronize()
        }get{
            return defaults.value(forKey: PreferenceKey.login.rawValue) as? Bool ?? false
        }
    }
    
    var userProfileModel : UserProfileModel {
        set{
            defaults.setValue(newValue.toDictionary(), forKey: PreferenceKey.userProfileModel.rawValue)
            defaults.synchronize()
        }get{
            let userDict = defaults.value(forKey: PreferenceKey.userProfileModel.rawValue) as? [String : Any] ?? [:]

            return UserProfileModel.init(jsonData: userDict)
        }
    }
    
    var rewardDate: String {
        set{
            defaults.setValue(newValue, forKey: PreferenceKey.rewardDate.rawValue)
            defaults.synchronize()
        }get{
            return defaults.value(forKey: PreferenceKey.rewardDate.rawValue) as? String ?? ""
        }
    }
    
    var rewardScore: String {
        set{
            defaults.setValue(newValue, forKey: PreferenceKey.rewardScore.rawValue)
            defaults.synchronize()
        }get{
            return defaults.value(forKey: PreferenceKey.rewardScore.rawValue) as? String ?? ""
        }
    }
    
    var currentScore: String {
        set{
            defaults.setValue(newValue, forKey: PreferenceKey.currentScore.rawValue)
            defaults.synchronize()
        }get{
            return defaults.value(forKey: PreferenceKey.currentScore.rawValue) as? String ?? "0"
        }
    }
    var finalScore: String{
        set {
            defaults.setValue(newValue, forKey: PreferenceKey.finalScore.rawValue)
            defaults.synchronize()
            print("Set finalScore: \(newValue)")
        }
        get {
            let value = defaults.value(forKey: PreferenceKey.finalScore.rawValue) as? String ?? "0"
            print("Get finalScore: \(value)")
            return value
        }
    }
    var gameSound: Bool {
        set{
            defaults.setValue(newValue, forKey: PreferenceKey.gameSound.rawValue)
            defaults.synchronize()
        }get{
            return defaults.value(forKey: PreferenceKey.gameSound.rawValue) as? Bool ?? true
        }
    }
}

enum PreferenceKey : String {
    case login            = "Login"
    case userProfileModel = "UserProfileModel"
    case rewardDate       = "RewardDate"
    case rewardScore      = "RewardScore"
    case gameSound        = "GameSound"
    case currentScore     = "CurrentScore"
    case finalScore       = "FinalScore"
}
