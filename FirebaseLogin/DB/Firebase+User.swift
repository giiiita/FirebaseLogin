//
//  Firebase+User.swift
//  FirebaseLogin
//
//  Created by giiiita on 2018/12/18.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Pring


extension Firebase {
    @objcMembers
    class User: Object {
        
        dynamic var name: String?
        dynamic var thumbnail: File?
        
        // nameとthumnailが登録されていれば利用可能
        dynamic var isActivated: Bool = false
        
    }
}

