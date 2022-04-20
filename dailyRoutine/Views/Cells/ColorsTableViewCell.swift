//
//  ColorsScheduleTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 16.03.2022.
//

import UIKit

class ColorsTableViewCell: UITableViewCell {

    // MARK: - initialise elements
    private let backgroundCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // для правильного расчета констрейнтов их нужно запускать в этом методе
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    // MARK: - private methods
    private func setupView(){
        selectionStyle = .none //чтобы ячейка не выделялась когда на нее нажимаешь
        backgroundColor = .clear
        addSubview(backgroundCellView)
    }
    
    private func cellBackgroundColorConfigure(indexPath: IndexPath){
        
        switch indexPath.section {
        case 0: backgroundCellView.backgroundColor = .systemRed
        case 1: backgroundCellView.backgroundColor = .systemOrange
        case 2: backgroundCellView.backgroundColor = .systemYellow
        case 3: backgroundCellView.backgroundColor = .systemGreen
        case 4: backgroundCellView.backgroundColor = .systemBlue
        case 5: backgroundCellView.backgroundColor = .blue
        case 6: backgroundCellView.backgroundColor = .systemPurple
            
        default:
            backgroundCellView.backgroundColor = .white
        }
    }
    
    // MARK: - public methods
    // устанавливаем цвет ячейки
    func cellConfigure(indexPath: IndexPath){
        cellBackgroundColorConfigure(indexPath: indexPath)
    }
}
    
// MARK: - constraints
extension ColorsTableViewCell {
    
    private func setConstraints(){
        let constraints = [
            backgroundCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
