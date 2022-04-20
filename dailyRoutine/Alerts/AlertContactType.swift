//
//  AlertContactType.swift
//  dailyRoutine
//
//  Created by Миша on 17.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertContactType(label: UILabel, completion: @escaping (String) -> ()) {
        let friendType = "Friend"
        let teacherType = "Teacher"

        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let friend = UIAlertAction(
            title: friendType,
            style: .default) { _ in
                label.text = friendType
                label.textColor = .black
                completion(friendType)
            }
        
        let teacher = UIAlertAction(
            title: teacherType,
            style: .default) { _ in
                label.text = teacherType
                label.textColor = .black
                completion(teacherType)
            }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .destructive)
        
        alert.addAction(friend)
        alert.addAction(teacher)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
