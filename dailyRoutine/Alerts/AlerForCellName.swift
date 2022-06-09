//
//  AlerForCellName.swift
//  dailyRoutine
//
//  Created by Миша on 16.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertForCellName(label: UILabel, name: String, placeholder: String, completion: @escaping (String) ->() ) {
        
        
        let alert = UIAlertController(
            title: name,
            message: nil,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(
            title: "Ok",
            style: .default) { (action) in
                
                let textField = alert.textFields?.first
                guard let text = textField?.text else {return}
                
                if text != "" {
                    label.textColor = .black
                    label.text = text
                } else {
                    label.textColor = .systemGray2
                    label.text = label.text
                }
                completion(text)
            }
        
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
