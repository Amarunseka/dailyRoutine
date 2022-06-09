//
//  CalendarView.swift
//  dailyRoutine
//
//  Created by Миша on 18.04.2022.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {
    
    // MARK: - initialise elements
    private var calendarHeightConstraint: NSLayoutConstraint!
    weak var outputCalendarDelegate: OutputCalendarDataProtocol?
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
    
    private let showHideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        setupCalendar()
        swipeAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setupCalendar(){
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
    }
}
    
// MARK: - SwipeGestureRecognizer
extension CalendarView  {

    private func swipeAction(){

        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUP.direction = .up
        calendar.addGestureRecognizer(swipeUP)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc
    private func handleSwipe(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case.up :
            showHideButtonTapped()
        case.down :
            showHideButtonTapped()
        default:
            break
        }
    }

    @objc
    private func showHideButtonTapped(){
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
}

// MARK: - FSCalendarDataSource, FSCalendarDelegate
extension CalendarView: FSCalendarDataSource, FSCalendarDelegate  {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        let outputHeight = bounds.height + showHideButton.frame.size.height
        outputCalendarDelegate?.outputChangeHeight(height: outputHeight)
        layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        outputCalendarDelegate?.outputDidSelectDate(date: date)
    }
}

// MARK: - constraints
extension CalendarView {
    private func setConstraints(){
        addSubview(calendar)
        addSubview(showHideButton)

        calendarHeightConstraint = NSLayoutConstraint(
            item: calendar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        
        let constraints = [
            calendar.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 100),
            showHideButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}



