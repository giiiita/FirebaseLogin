//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by giiiita on 2018/12/18.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import FirebaseAuth
import Instantiate
import InstantiateStandard
class LoginViewController: UIViewController,  StoryboardInstantiatable{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapedLoginButton(_ sender: Any) {
        self.registAnonymus()
    }
    
    private func registAnonymus() {
        Auth.auth().signInAnonymously(completion: { (authDataResult, error) in
            if let error = error { return }
            guard let authDataResult = authDataResult else { return }
            let id: String = authDataResult.user.uid
            let user: Firebase.User = Firebase.User(id: id)
            user.save { (ref, error) in
                if let error = error { return }
                print("Regist Success")
                let vc: UserRegistrationViewController = UserRegistrationViewController.instantiate(with: .init(user: user))

                let nvc: UINavigationController = UINavigationController(rootViewController: vc)

                self.present(nvc, animated: true)

            }
        })
    }
}


