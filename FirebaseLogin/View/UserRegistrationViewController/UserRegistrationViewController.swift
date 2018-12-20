//
//  UserRegistrationViewController.swift
//  FirebaseLogin
//
//  Created by giiiita on 2018/12/18.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard
import CropViewController
import Pring

class UserRegistrationViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var user: Firebase.User!
    struct Dependency {
        var user: Firebase.User
    }
    func inject(_ dependency: UserRegistrationViewController.Dependency) {
        self.user = dependency.user
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.thumnailImageView.layer.cornerRadius = 90
        self.thumnailImageView.clipsToBounds = true
    }
    @IBAction func tappedThumnailImageButton(_ sender: Any) {
        let controller: UIImagePickerController = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func tappedRegistButton(_ sender: Any) {
        guard let name = self.nameTextField.text else { return }
        self.user.name = name
        
        self.user.update { [weak self] (error) in
            if let error = error { return }
            guard let `self` = self else { return }
            let vc: UserViewController = UserViewController.instantiate(with: .init(user: self.user))
            self.present(vc, animated: true)
        }
    }
}

extension UserRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.setAspectRatioPreset(TOCropViewControllerAspectRatioPreset.presetSquare, animated: false)
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPickerButtonHidden = true
        picker.pushViewController(cropViewController, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let resizedImage: UIImage = image.resized(to: CGSize(width: 1080, height: 1080), scale: 1, contentMode: .scaleAspectFill)!
        self.thumnailImageView.image = resizedImage
        self.thumnailImageView.setNeedsDisplay()
        let data: Data = resizedImage.jpegData(compressionQuality:  0.65)!
        let file: File = File(data: data, mimeType: .jpeg)
        self.user.thumbnail = file
        cropViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
