//
//  Helper.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Helper: NSObject {

    static let shared : Helper = {
        let instace = Helper()
        return instace
    }()
    
    func addActivityIndicator() {
        guard let topVC = UIApplication.topViewController() else {
            return
        }
        activityIndicatorView.center = topVC.view.center
        topVC.view.addSubview(activityIndicatorView)
    }
    
    // MARK: Start Loader
    class func startLoader() {
       DispatchQueue.main.async {
           activityIndicatorView.startAnimating()
       }
    }

    // MARK: Stop Loader
    class func stopLoader() {
        activityIndicatorView.stopAnimating()
    }
    
    func popUPWithCancel(message: String, title: String, completion:@escaping(Bool)-> Void) {
        guard let topVC = UIApplication.topViewController() else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {_ in
            completion(false)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
            completion(true)
        }))
        topVC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: check null values
    func checkNullValue(str: String) -> String {
        if str == "" || str == "<null>" || str == "Null" || str == "null" {
            return ""
        }else {
            return str
        }
    }
    
    // MARK: app error messages
    func errorCatcher(title: String, error : AppErrors) -> Void {
        DispatchQueue.main.async {
            var msg = ""
            switch error {
            case .internetNotWorking:
                msg = "Network Unavailable! Please check your internet connection."
            case .apiError:
                msg = "Something went wrong please try again."
            }
            self.alert(with: title, message: msg)
        }
    }
    
    func alert(with title: String, message: String) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.topViewController() else{
                return
            }
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okAction)
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}

extension Date {
    func toDate(format : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateFormatter.string(from: self))
    }
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toString(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func offsetyear(from date: Date) -> Int {
        if years(from: date)   == 1 { return years(from: date)   }
        if years(from: date)   > 0 { return years(from: date) }
        return 0
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1 { return "\(years(from: date)) Year"   }
        if years(from: date)   > 0 { return "\(years(from: date)) Years"   }
        if months(from: date)  == 1 { return "\(months(from: date)) Month"  }
        if months(from: date)  > 0 { return "\(months(from: date)) Months"  }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) Week"   }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) Weeks"   }
        if days(from: date)    == 1 { return "\(days(from: date)) Day"    }
        if days(from: date)    > 0 { return "\(days(from: date)) Days"    }
        if hours(from: date)   == 1 { return "\(hours(from: date)) hour"   }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours"   }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) Min" }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) Mins" }
        if seconds(from: date) == 1 { return "a moment" }
        if seconds(from: date) > 0 { return "a moment" }
        return "a moment"
    }
}

extension UIViewController {
    
    class func view(from : Storyboard) -> UIViewController? {
        if (from == .Main) {
            return AppStoryboard.Main.instantiateViewController(withIdentifier: self.viewName())
        }
        return nil
    }
    
    class func viewName() -> String {
        var className = String(describing: self)
        className = className.description.replacingOccurrences(of: "", with: "WheelGame.")
        return className
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
