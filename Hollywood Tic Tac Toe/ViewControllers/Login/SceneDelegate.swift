//
//  SceneDelegate.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        self.addObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: NotificationCenterKeys.login), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(home), name: NSNotification.Name(rawValue: NotificationCenterKeys.home), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(webOpenUrl), name: NSNotification.Name(rawValue: NotificationCenterKeys.webOpen), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: NotificationCenterKeys.logout), object: nil)
    }
    
    @objc func login(notification: NSNotification) {
        self.moveToVC(identifier: "LoginVC", storyboard: "Main")
    }
    
    @objc func home(notification: NSNotification) {
        self.moveToVC(identifier: "HomeVC", storyboard: "Main")
    }
    
    @objc func webOpenUrl(notification: NSNotification) {
        self.moveToVC(identifier: "WebOpenVC", storyboard: "Main")
    }
    
    @objc func logout(notification: NSNotification) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController? = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: vc!)
        self.window?.rootViewController = navigationController
    }
    
    func moveToVC(identifier: String, storyboard: String) {
        let mainStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        let navigationController = self.window?.rootViewController as! UINavigationController
        navigationController.viewControllers = [vc]
        self.window?.rootViewController = navigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

