//
//  SceneDelegate.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 24.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 var networking = NetworkingManager🌐()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.string(forKey: "login") != nil && UserDefaults.standard.string(forKey: "password") != nil {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        } else{
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
    }
    
    
    func changeViewController(vc:UIViewController,animated: Bool = true){
        guard let window = window else {
            return
        }
        
        window.rootViewController = vc
        
        //Обявим опцию того как будет происходить анимация
        let options: UIView.AnimationOptions = .transitionFlipFromRight
        //Задаем интервал выполнения анимации
        let duration: TimeInterval = 0.6
        
        UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
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

