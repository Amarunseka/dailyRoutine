//
//  TasksTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    // MARK: - initialise elements
    var completeTaskOutput: ((IndexPath)->())?
    var indexPath: IndexPath?

    let taskName = UILabel(
        text: "",
        font: .avenirNextDemiBold20())
    
    let taskDescription = UILabel(
        text: "",
        font: .avenirNext14())
    
    let readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        return button
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
        selectionStyle = .none //чтобы ячейка не выделялась когда на нее нажимаешь
        taskDescription.numberOfLines = 2

        addSubview(taskName)
        addSubview(taskDescription)
        contentView.addSubview(readyButton)
    }

    @objc
    private func readyButtonTapped(){
        guard
            let index = indexPath,
            let completeTaskOutput = completeTaskOutput else {return}
        
        completeTaskOutput(index)
    }
    
    private func setupCell(model: TasksRealmModel) {
        taskName.text = model.taskName
        taskDescription.text = model.taskDescription
        backgroundColor = UIColor().colorFromHex("\(model.taskColor)")
        
        if model.taskReady {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        } else {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        }
    }
    
    // MARK: - public methods
    func cellConfigure(model: TasksRealmModel) {
        setupCell(model: model)
    }
}
    
// MARK: - constraints
extension TasksTableViewCell {

    private func setConstraints(){
        let constraints = [
            readyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            readyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 40),
            readyButton.widthAnchor.constraint(equalToConstant: 40),
            
            taskName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            taskName.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskName.heightAnchor.constraint(equalToConstant: 25),

            taskDescription.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 5),
            taskDescription.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
