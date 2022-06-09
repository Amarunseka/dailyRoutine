//
//  OptionsScheduleTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    // MARK: - initialise elements
    var switchStateOutput: ((Bool)->())?

    let backgroundViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameCellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray2
        return label
    }()
    
    let repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        repeatSwitch.isOn = true
        repeatSwitch.isHidden = true
        repeatSwitch.addTarget(self, action: #selector(repeatSwitchChange), for: .valueChanged)
        return repeatSwitch
    }()
    
    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(backgroundViewCell)
        addSubview(nameCellLabel)
        addSubview(repeatSwitch)
    }
    
    @objc
    private func repeatSwitchChange(paramTarget: UISwitch){
        guard let switchStateOutput = switchStateOutput else {return}
        switchStateOutput(paramTarget.isOn)
    }
}

// MARK: - setup ScheduleViewController
extension OptionsTableViewCell {
    
    private func setupForScheduleVC(namesArray: [[String]], indexPath: IndexPath, color: String, isEdit: Bool, isRepeat: Bool){
        nameCellLabel.text = namesArray[indexPath.section][indexPath.row]
        !isEdit ? (nameCellLabel.textColor = .systemGray2) : (nameCellLabel.textColor = .black)

        // присваиваем цвет ячейке при его выборе
        let color = UIColor().colorFromHex(color)
        repeatSwitch.onTintColor = color
        
        switch indexPath.section {
        case 0...2:
            repeatSwitch.isHidden = true
            backgroundViewCell.backgroundColor = .white
        case 3:
            backgroundViewCell.backgroundColor = color
            nameCellLabel.textColor = .clear
            repeatSwitch.isHidden = true
        case 4:
            backgroundViewCell.backgroundColor = .white
            nameCellLabel.textColor = .black
            !isEdit ? (repeatSwitch.isOn = true) : (repeatSwitch.isOn = isRepeat)
            repeatSwitch.isHidden = false
        default:
            break
        }
    }
    
    func cellScheduleConfigure(namesArray: [[String]], indexPath: IndexPath, color: String, isEdit: Bool, isRepeat: Bool){
        setupForScheduleVC(namesArray: namesArray, indexPath: indexPath, color: color, isEdit: isEdit, isRepeat: isRepeat)
    }
}


// MARK: - setup TasksViewController
extension OptionsTableViewCell {
    
    private func setupForTasksVC(namesArray: [String], indexPath: IndexPath, color: String, isEdit: Bool){
        repeatSwitch.isHidden = true
        nameCellLabel.text = namesArray[indexPath.section]
        
        let color = UIColor().colorFromHex(color)
        
        if indexPath.section < 3 {
            backgroundViewCell.backgroundColor = .white
            !isEdit ? (nameCellLabel.textColor = .systemGray2) : (nameCellLabel.textColor = .black)
        } else {
            backgroundViewCell.backgroundColor = color
            nameCellLabel.textColor = .clear
        }
    }
    
    func cellTasksConfigure(namesArray: [String], indexPath: IndexPath, color: String, isEdit: Bool){
        setupForTasksVC(namesArray: namesArray, indexPath: indexPath, color: color, isEdit: isEdit)
    }
}

// MARK: - setup ContactsViewController
extension OptionsTableViewCell {
    
    private func setupForContactsVC(namesArray: [String], indexPath: IndexPath, image: UIImage?, isEdit: Bool) {
        
        !isEdit ? (nameCellLabel.textColor = .systemGray2) : (nameCellLabel.textColor = .black)
        repeatSwitch.isHidden = true
        backgroundViewCell.backgroundColor = .white
        nameCellLabel.text = namesArray[indexPath.section]
        backgroundViewCell.image = nil

        switch image {
        case nil:
            indexPath.section == 4 ? backgroundViewCell.image = UIImage(systemName: "person.fill.badge.plus") : nil
        default:
            indexPath.section == 4 ? backgroundViewCell.image = image : nil
            backgroundViewCell.contentMode = .scaleAspectFill
        }
    }

    func cellContactsConfigure(namesArray: [String], indexPath: IndexPath, image: UIImage?, isEdit: Bool) {
        setupForContactsVC(namesArray: namesArray, indexPath: indexPath, image: image, isEdit: isEdit)
    }
}


// MARK: - constraints
extension OptionsTableViewCell {

    private func setConstraints(){
        let constraints = [
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            
            nameCellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCellLabel.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 15),
            
            repeatSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repeatSwitch.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


