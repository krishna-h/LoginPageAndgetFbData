//
//  LoginViewController.swift
//  LoginPageAndgetFbData
//
//  Created by Mac on 30/07/20.
//  Copyright © 2020 Gunde Ramakrishna Goud. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLoginBtn(_ sender: UIButton)
    {
        if let token = AccessToken.current{
            let mVC = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
            self.present(mVC, animated: true, completion: nil)
        }else{
            let manager = LoginManager()
            manager.logIn(permissions: [.publicProfile, .email, .userGender, .userBirthday], viewController: self) { (loginResult) in
                switch loginResult{
                case .failed(let error):
                    print("Error code is :\(error)")
                    case .cancelled:
                    print("User cancelle login.")
                case .success(let granted, let declined, let token):
                    print("Logged in!: \(AccessToken.self)")
                    let mVC = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
                    self.present(mVC, animated: true, completion: nil)
                
                }
            }
        }
    }
    

}
