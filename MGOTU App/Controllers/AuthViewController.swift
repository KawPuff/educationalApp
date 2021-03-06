//
//  AuthViewController.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 09.12.2020.
//

import UIKit
import NVActivityIndicatorView
class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var fieldsTableView: AuthTableView!
    @IBOutlet weak var loaderView: LoaderView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var originY: CGFloat?
    
    
    weak var failedAuthDescriptionTF: UILabel?
    weak var loginTF: UITextField?
    weak var passwordTF: UITextField?
    weak var passwordDetailsButton: UIButton?
    weak var loginButton: UIButton!{
        didSet{
            loginButton.isEnabled = false
        }
    }
    
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    typealias LoginDetails = (login: String, password: String)
    var loginDetails = LoginDetails("","")
    let networking = NetworkingManager🌐()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsTableView.dataSource = self
        fieldsTableView.delegate = self
        fieldsTableView.touchedTableViewDelgate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkForFieldsNotEmpty(){
        loginButton.isEnabled = !loginTF!.text!.isEmpty && !passwordTF!.text!.isEmpty
    }
    @objc func loginTFEdited(_ sender: UITextField) {
        loginDetails.login = sender.text!
        checkForFieldsNotEmpty()
    }
    
    @objc func passwordTFEdited(_ sender: UITextField) {
        loginDetails.password = sender.text!
        checkForFieldsNotEmpty()
    }

    //MARK: - Keyboard Events
    @objc func onKeyboardShow(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if fieldsTableView.frame.maxY > keyboardSize.minY{
        originY = fieldsTableView.frame.origin.y
        fieldsTableView.frame.origin.y = keyboardSize.minY - fieldsTableView.frame.height
       // fieldsTableView.frame.origin.y = loginButton.frame.minY - fieldsTableView.frame.height
        }
    }
    @objc func onKeyboardHide(notification:NSNotification){
        guard let y = originY else{
            return
        }
        fieldsTableView.frame.origin.y = y
    }
    
    @objc func showPasswordDetail(_ sender:UIButton){
        passwordTF?.isSecureTextEntry = !passwordTF!.isSecureTextEntry
        let image = passwordTF!.isSecureTextEntry ? UIImage(systemName: "eye.slash.fill") : UIImage(systemName: "eye.fill")
        sender.setImage(image, for: .normal)
    }
    @objc func authButtonPressed(_ sender: UIButton) {
        fieldsTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isHidden = true
        loaderView.isHidden = false
        activityIndicator.startAnimating()
        
        networking.auth(login: loginDetails.login, password: loginDetails.password)
        
          
        networking.requestGroup.notify(queue: .main) { [self] in
            activityIndicator.stopAnimating()
            loaderView.isHidden = true
            guard let status = networking.authStatus else{
                failedAuthDescriptionTF?.text = "Соединение с сервером потеряно"
                fieldsTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isHidden = false
            return
        }
       
        if status == true {
            print(status)
            UserDefaults.standard.setValue(loginDetails.login, forKey: "login")
            UserDefaults.standard.setValue(loginDetails.password, forKey: "password")
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let newVC = sb.instantiateViewController(withIdentifier: "MainTabBarController")
            sceneDelegate?.changeViewController(vc: newVC, animated: true)
            
        } else {
            failedAuthDescriptionTF!.text = "Неверная связка логин/пароль"
            fieldsTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isHidden = false
            
        }
        }
          
    }
    
}

//MARK: - TableView Extencion

extension AuthViewController: UITableViewDelegate, UITableViewDataSource, TouchedTableViewDelegate{
  
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 2
        } else{
        return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as? DescriptionCell
            failedAuthDescriptionTF = cell?.descriptionLabel
            cell?.isHidden = true
            return cell!
        case 1:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as? LoginCell
                loginTF = cell?.loginTF
                loginTF?.addTarget(self, action: #selector(loginTFEdited), for: .editingChanged)
                return cell!
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell") as? PasswordCell
                passwordTF = cell?.passwordTF
                passwordDetailsButton = cell?.passwodDeatailsBotton
                passwordTF?.addTarget(self, action: #selector(passwordTFEdited), for: .editingChanged)
                passwordDetailsButton?.addTarget(self, action: #selector(showPasswordDetail), for: .touchUpInside)
                return cell!
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as? ButtonCell
                loginButton = cell?.authButton
                loginButton.addTarget(self, action: #selector(authButtonPressed), for: .touchUpInside)
                return cell!
            }
        default:
            return UITableViewCell()
        }
      return UITableViewCell()
    }
    
    func touchesBeganInTableView(_touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
protocol TouchedTableViewDelegate: class{
    func touchesBeganInTableView(_touches: Set<UITouch>, with event: UIEvent?)
}
class AuthTableView: UITableView{
    var touchedTableViewDelgate: TouchedTableViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedTableViewDelgate?.touchesBeganInTableView(_touches: touches, with: event)
    }
}
