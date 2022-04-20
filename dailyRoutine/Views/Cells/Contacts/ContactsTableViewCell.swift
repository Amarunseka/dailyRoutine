//
//  ContactsTableViewCell.swift
//  dailyRoutine
//
//  Created by Миша on 17.03.2022.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    // MARK: - initialise elements
    private let nameLabel = UILabel(text: "", font: .avenirNext20())
    private let phoneLabel = UILabel(text: "", font: .avenirNext14())
    private let emailLabel = UILabel(text: "", font: .avenirNext14())
    private var stackView = UIStackView()
    
    private let contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // делаем цветной значок
        imageView.image = UIImage(systemName: "phone.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .green
        return imageView
    }()
    
    private let mailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // делаем цветной значок
        imageView.image = UIImage(systemName: "envelope.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .green
        return imageView
    }()

    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contactImageView.layer.cornerRadius = contactImageView.frame.height / 2
        setConstraints()
    }
    
    // MARK: - private methods
    private func setupView(){
        selectionStyle = .none //чтобы ячейка не выделялась когда на нее нажимаешь

        addSubview(contactImageView)
        addSubview(nameLabel)
        addSubview(stackView)
    }
    
    private func setupStackView(){
        stackView = UIStackView(
            arrangeSubviews: [phoneImageView, phoneLabel, mailImageView, emailLabel],
            axis: .horizontal,
            spacing: 3,
            distribution: .fillProportionally)
    }
    
    // метод конфигурирования ячейки при назначении ее в таблице на ContactsVC
    private func setupCell(model: ContactsRealmModel) {
        nameLabel.text = model.contactName
        phoneLabel.text = model.contactPhone
        emailLabel.text = model.contactEmail
        
        // пытаемся получить картинку из нашей модели, и если получаем то присваиваем ее контакту
        if let data = model.contactPhoto, let image = UIImage(data: data) {
            contactImageView.image = image
        } else {
            // если нет присваиваем системную картинку
            contactImageView.image = UIImage(systemName: "person.fill")
        }
    }

    
    // MARK: - public methods
    // метод конфигурирования ячейки при назначении ее в таблице на ContactsVC
    func cellConfigure(model: ContactsRealmModel) {
        setupCell(model: model)
    }
}

// MARK: - constraints
extension ContactsTableViewCell {
    
    private func setConstraints(){
        let constraints = [
            contactImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contactImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            contactImageView.widthAnchor.constraint(equalToConstant: 70),
            contactImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 21),
            
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 21),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
