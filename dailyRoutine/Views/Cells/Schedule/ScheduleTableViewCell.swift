//
//  ScheduleTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 14.03.2022.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    // MARK: - initialise elements
    private var topStackView = UIStackView()
    private var bottomStackView = UIStackView()

    private let lessonNameLabel = UILabel(
        text: "",
        font: UIFont.avenirNextDemiBold20())

    private let teacherNameLabel = UILabel(
        text: "",
        font: UIFont.avenirNext20(),
        alignment: .right)

    private let lessonTimeLabel = UILabel(
        text: "",
        font: UIFont.avenirNextDemiBold20())
    
    private let typeLabel = UILabel(
        text: "Type",
        font: UIFont.avenirNext14(),
        alignment: .right)

    private let lessonTypeLabel = UILabel(
        text: "",
        font: UIFont.avenirNextDemiBold14())

    private let buildingLabel = UILabel(
        text: "Building",
        font: UIFont.avenirNext14(),
        alignment: .right)

    private let lessonBuildingLabel = UILabel(
        text: "",
        font: UIFont.avenirNextDemiBold14())
 
    private let audienceLabel = UILabel(
        text: "Audience",
        font: UIFont.avenirNext14(),
        alignment: .right)
 
    private let lessonAudienceLabel = UILabel(
        text: "",
        font: UIFont.avenirNextDemiBold14())

    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupStackViews()
        self.setupView()
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
        selectionStyle = .none

        addSubview(topStackView)
        addSubview(lessonTimeLabel)
        addSubview(bottomStackView)
    }
    
    private func setupStackViews(){
        self.topStackView = UIStackView(
            arrangeSubviews: [lessonNameLabel,
                              teacherNameLabel],
            axis: .horizontal,
            spacing: 10,
            distribution: .fillEqually)
        
        self.bottomStackView = UIStackView(
            arrangeSubviews: [typeLabel,
                              lessonTypeLabel,
                              buildingLabel,
                              lessonBuildingLabel,
                              audienceLabel,
                              lessonAudienceLabel],
            axis: .horizontal,
            spacing: 5,
            distribution: .fillProportionally)
    }
    
    private func setupCell(model: ScheduleRealmModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        
        guard let time = model.scheduleTime else {return}
        
        lessonNameLabel.text = model.scheduleName
        teacherNameLabel.text = model.scheduleTeacher
        lessonTimeLabel.text = dateFormatter.string(from: time)
        lessonTypeLabel.text = model.scheduleType
        lessonBuildingLabel.text = model.scheduleBuilding
        lessonAudienceLabel.text = model.scheduleAudience
        backgroundColor = UIColor().colorFromHex("\(model.scheduleColor)")
    }
    
    // MARK: - public methods
    func cellConfigure(model: ScheduleRealmModel) {
        setupCell(model: model)
    }
}

// MARK: - constraints
extension ScheduleTableViewCell {
    
    private func setConstraints(){
        let constraints = [
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            topStackView.heightAnchor.constraint(equalToConstant: 25),
            
            lessonTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lessonTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            lessonTimeLabel.widthAnchor.constraint(equalToConstant: 100),
            lessonTimeLabel.heightAnchor.constraint(equalToConstant: 25),
            
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            bottomStackView.leadingAnchor.constraint(equalTo: lessonTimeLabel.trailingAnchor, constant: 5),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            bottomStackView.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
