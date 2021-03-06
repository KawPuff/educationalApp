//
//  OtherViewController.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 23.02.2021.
//

import UIKit

class OtherViewController: UIViewController {

    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    @IBAction func OnLogoutPressed(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "login")
        UserDefaults.standard.removeObject(forKey: "password")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
        sceneDelegate?.changeViewController(vc: loginVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
