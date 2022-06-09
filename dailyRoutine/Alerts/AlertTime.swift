//
//  AlertTime.swift
//  dailyRoutine
//
//  Created by Миша on 16.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertTime(label: UILabel, completion: @escaping (Date)->()) {
        
        let alert = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .wheels
        
        alert.view.addSubview(datePicker)
        
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default) { (action) in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"

                let timeString = dateFormatter.string(from: datePicker.date)
                
                let timeSchedule = datePicker.date
                
                completion(timeSchedule)
                
                label.textColor = .black
                label.text = timeString
            }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        
        present(alert, animated: true)
    }
}
