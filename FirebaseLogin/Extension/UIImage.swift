//
//  UIImage.swift
//  FirebaseLogin
//
//  Created by giiiita on 2018/12/18.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import CoreGraphics
import Pring

extension UIImage {
    
    func resize(to size: CGSize, scale: CGFloat = 0.0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resized(to size: CGSize, scale: CGFloat = 0.0, contentMode: UIView.ContentMode) -> UIImage? {
        
        guard let imgRef: CGImage = self.cgImage else {
            print("*** error: image must be backed by a CGImage: %@", self)
            return nil
        }
        
        var dstSize: CGSize = size
        let srcSize: CGSize = CGSize(width: imgRef.width, height: imgRef.height)
        
        if size == srcSize {
            return self
        }
        
        var vScaleRatio: CGFloat = 1
        var hScaleRatio: CGFloat = 1
        
        switch contentMode {
        case .scaleAspectFill:
            // 短辺を基準にする
            let scaleRatio: CGFloat = srcSize.width >= srcSize.height ? size.height / srcSize.height : size.width / srcSize.width
            vScaleRatio = scaleRatio
            hScaleRatio = scaleRatio
        case .scaleAspectFit:
            // 長辺を基準にする
            if srcSize.width >= srcSize.height {
                let scaleRatio: CGFloat = size.width / srcSize.width
                let aspect: CGFloat = srcSize.height / srcSize.width
                dstSize = CGSize(width: size.width, height: size.width * aspect)
                vScaleRatio = scaleRatio
                hScaleRatio = scaleRatio
            } else {
                let scaleRatio: CGFloat = size.height / srcSize.height
                let aspect: CGFloat = srcSize.width / srcSize.height
                dstSize = CGSize(width: size.height * aspect, height: size.height)
                vScaleRatio = scaleRatio
                hScaleRatio = scaleRatio
            }
            
            let scaleRatio: CGFloat = srcSize.width <= srcSize.height ? size.height / srcSize.height : size.width / srcSize.width
            vScaleRatio = scaleRatio
            hScaleRatio = scaleRatio
            
        default:
            vScaleRatio = size.height / srcSize.height
            hScaleRatio = size.width / srcSize.width
        }
        
        let orientation: UIImage.Orientation = self.imageOrientation
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .up: //EXIF = 1
            transform = CGAffineTransform.identity
            
        case .upMirrored: //EXIF = 2
            transform = CGAffineTransform(translationX: srcSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            
        case .down: //EXIF = 3
            transform = CGAffineTransform(translationX: srcSize.width, y: srcSize.height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .downMirrored: //EXIF = 4
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            
        case .leftMirrored: //EXIF = 5
            dstSize = CGSize(width: size.height, height: size.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: srcSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2)
            
        case .left: //EXIF = 6
            dstSize = CGSize(width: size.height, height: size.width)
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2)
            
        case .rightMirrored: //EXIF = 7
            dstSize = CGSize(width: size.height, height: size.width)
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            
        case .right: //EXIF = 8
            dstSize = CGSize(width: size.height, height: size.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            
        }
        
        UIGraphicsBeginImageContextWithOptions(dstSize, false, scale)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        if orientation == .right || orientation == .left {
            context.scaleBy(x: -hScaleRatio, y: vScaleRatio)
            context.translateBy(x: -srcSize.height, y: 0)
        } else {
            context.scaleBy(x: hScaleRatio, y: -vScaleRatio)
            context.translateBy(x: 0, y: -srcSize.height)
        }
        
        context.concatenate(transform)
        
        context.draw(imgRef, in: CGRect(origin: .zero, size: srcSize))
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func toFile(image: UIImage) -> File {
        let data: Data = image.jpegData(compressionQuality: 0.65)!
        return File(data: data)
    }
}

