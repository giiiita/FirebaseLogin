//
//  UserViewController.swift
//  FirebaseLogin
//
//  Created by giiiita on 2018/12/18.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard
import Firebase
import Pring
import SDWebImage
class UserViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var user: Firebase.User!
    struct Dependency {
        var user: Firebase.User
    }

    func inject(_ dependency: UserViewController.Dependency) {
        self.user = dependency.user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = self.user.name
        if let url: URL = self.user.thumbnail?.downloadURL {
            self.thumnailImageView.sd_setImage(with: url, completed: nil)
        }
        self.nameLabel.text = user.name
    }
}
