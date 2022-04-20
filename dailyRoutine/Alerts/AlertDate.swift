//
//  AlertDate.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertDate(label: UILabel, completion: @escaping (Int, Date)->()) {
        
        let alert = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        // изменяем на английский язык
        datePicker.locale = Locale(identifier: "en_US")
        datePicker.preferredDatePickerStyle = .wheels
        
        alert.view.addSubview(datePicker)
        
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default) { (action) in
                
                // получаем дату с пикера в строке
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                dateFormatter.locale = Locale(identifier: "en_US")
                let dateString = dateFormatter.string(from: datePicker.date)
                
                // определяем текущий календарь
                let calendar = Calendar.current
                
                // получаем номер дня недели
                let component = calendar.dateComponents([.weekday], from: datePicker.date)
                guard let weekday = component.weekday else {return}
                
//                let numberOfWeekday = weekday
                // получаем дату с пикера
                let date = datePicker.date
                
                // передаем данные в completion
                completion(weekday, date)
                
                // пишем дату
                label.textColor = .black
                label.text = dateString
            }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.negativeWidthConstraint()
        
        
        // увеличиваем наш алерт
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        
        present(alert, animated: true)
    }
}
