//
//  PhotoAlert.swift
//  dailyRoutine
//
//  Created by Миша on 18.03.2022.
//

import UIKit

extension UIViewController {

    func alertPhoto(completion: @escaping (UIImagePickerController.SourceType) -> ()) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(
            title: "Camera",
            style: .default) { _ in
                let camera = UIImagePickerController.SourceType.camera
                completion(camera)
            }
        
        let photoLibrary = UIAlertAction(
            title: "Library",
            style: .default) { _ in
                let photoLibrary = UIImagePickerController.SourceType.photoLibrary
                completion(photoLibrary)
            }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .destructive)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
