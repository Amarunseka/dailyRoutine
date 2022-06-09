//
//  HeaderOptionsScheduleTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

class HeadersTableViewCell: UITableViewHeaderFooterView {

    // MARK: - initialise elements
    let headerLabel: UILabel = {
        let label = UILabel(text: "", font: .avenirNext14())
        label.textColor = .darkGray
        return label
    }()
    
    
    // MARK: - life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    // MARK: - private methods
    private func setupView(){
        contentView.backgroundColor = .systemGray6
        addSubview(headerLabel)
    }
    
    private func setHeaderLabelText(nameArray: [String], section: Int) {
        headerLabel.text = nameArray[section]
    }
    
    // MARK: - public methods
    func headerCellConfigure(nameArray: [String], section: Int) {
        setHeaderLabelText(nameArray: nameArray, section: section)
    }
}
    
// MARK: - constraints
extension HeadersTableViewCell {
    private func setConstraints(){

        let constraints = [
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
