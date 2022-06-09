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
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
