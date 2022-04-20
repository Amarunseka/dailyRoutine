//
//  UIStackView.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangeSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangeSubviews)
        self.axis = axis // ось как притягивать друг другу
        self.spacing = spacing // интервал между элементами
        self.distribution = distribution // распределение размеров элементов по stackView
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
