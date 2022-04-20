//
//  AlertSuccessSave.swift
//  dailyRoutine
//
//  Created by Миша on 21.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertSuccessSave(title: String, message: String?) {
        
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(
            title: "Ok",
            style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
