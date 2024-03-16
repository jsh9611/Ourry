//
//  SceneDelegate.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let temp = TempViewController()
        let nvc = UINavigationController(rootViewController: temp)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
//        let isLaunched = UserDefaults.standard.bool(forKey: "isLaunched")
//        
//        if !isLaunched {
//            UserDefaults.standard.set(true, forKey: "isLaunched")
//            KeychainHelper.delete(forAccount: "access_token")
//            KeychainHelper.delete(forAccount: "refresh_token")
//        }
//
//        // 로그인한 적이 없는 경우(토큰 미발급)
//        guard KeychainHelper.read(forAccount: "access_token") != nil,
//              KeychainHelper.read(forAccount: "refresh_token") != nil else {
//            
//            let loginViewController = LoginViewController()
//            let navigationController = UINavigationController(rootViewController: loginViewController)
//            window?.rootViewController = navigationController
//            window?.makeKeyAndVisible()
//            return
//        }
//        
//        // 로그인 상태인 경우
//        let mainViewController = MainViewController()
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

