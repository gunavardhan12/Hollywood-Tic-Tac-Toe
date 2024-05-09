//
//  Constant.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let WEBSERVICE_URL = "https://heropulseu.com/hl/json"

typealias JSONDictionary = [String: Any]

let appDelegateShared = UIApplication.shared.delegate as! AppDelegate

let pref = PreferenceManager.shared

var userProfileModel = UserProfileModel(jsonData: JSONDictionary())

struct Constant {
    static let loaderSize = CGRect(x: 0, y: 0, width: 30, height: 30)
}

let activityIndicatorView = NVActivityIndicatorView(frame: Constant.loaderSize, type: NVActivityIndicatorType.lineScale, color: .black, padding: 0)

struct AppStoryboard {
    static let Main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

enum Storyboard : String {
    case Main = "Main"
}

//MARK: - App error messages key
enum AppErrors {
    case internetNotWorking
    case apiError
}
