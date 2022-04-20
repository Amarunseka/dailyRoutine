//
//  OutputCalendarDataProtocol.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

protocol OutputCalendarDataProtocol: AnyObject{
    func outputChangeHeight(height: CGFloat)
    func outputDidSelectDate(date: Date)
}
