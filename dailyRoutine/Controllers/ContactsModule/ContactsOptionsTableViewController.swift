//
//  OptionsContactsTableViewController.swift
//  dailyRoutine
//
//  Created by Миша on 17.03.2022.
//

import UIKit

class ContactsOptionsTableViewController: UITableViewController {

    // MARK: - initialise elements
    private let headersNameArray = ["NAME", "PHONE", "EMAIL", "TYPE", "IMAGE"]
    var cellsNameArray = ["Name", "Phone number", "Email", "Type of contact", ""]
    var contactsModel = ContactsRealmModel()
    var imageIsChanged = false
    
    var editMode: Bool = false
    var dataImage: Data?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Contact"
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped))
    }
    
    // MARK: - Targets & Methods
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.bounces = false
        tableView.separatorStyle = .none
        
        tableView.register(
            OptionsTableViewCell.self,
            forCellReuseIdentifier: String(describing: OptionsTableViewCell.self))
        
        tableView.register(
            HeadersTableViewCell.self,
            forHeaderFooterViewReuseIdentifier: String(describing: HeadersTableViewCell.self))
    }
    
    @objc
    private func saveButtonTapped(){
        if
            cellsNameArray[0] == "Name" ||
            cellsNameArray[1] == "Phone number" ||
            cellsNameArray[2] == "Email" ||
            cellsNameArray[3] == "Type of contact"
        {
                alertSuccessSave(title: "Error", message: "Required fields: NAME, PHONE, EMAIL, TYPE")
            
        } else {
            
            switch editMode {
            case false:
                setImageModel()
                setModel()
                RealmManager.shared.saveContactModel(model: contactsModel)
                
                contactsModel = ContactsRealmModel()
                cellsNameArray = ["Name", "Phone number", "Email", "Type of contact", ""]
                
                alertSuccessSave(title: "Success save", message: nil)
                tableView.reloadData()
                
            case true:
                if contactsModel.contactPhoto == nil && imageIsChanged == false {
                    imageIsChanged = false
                } else {
                    imageIsChanged = true
                }
                
                setImageModel()
                
                RealmManager.shared.editContactModel(
                    model: contactsModel,
                    nameArray: cellsNameArray,
                    imageData: dataImage)
                contactsModel = ContactsRealmModel()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    private func setModel(){
        contactsModel.contactName = cellsNameArray[0]
        contactsModel.contactPhone = cellsNameArray[1]
        contactsModel.contactEmail = cellsNameArray[2]
        contactsModel.contactType = cellsNameArray[3]
        contactsModel.contactPhoto = dataImage
    }

    private func setImageModel(){
        
        if imageIsChanged {
            let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
            let image = cell.backgroundViewCell.image
            guard let imageData = image?.pngData() else {return}

            dataImage = imageData
            cell.backgroundViewCell.contentMode = .scaleAspectFit
            imageIsChanged = false
        } else {
            dataImage = nil
        }
    }
    
    private func pushViewController(vc: UIViewController){
        let vc = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OptionsTableViewCell.self), for: indexPath) as! OptionsTableViewCell
        
        switch editMode {
        case false:
            cell.cellContactsConfigure(namesArray: cellsNameArray, indexPath: indexPath, image: nil, isEdit: editMode)
        case true:
            if let data = contactsModel.contactPhoto, let image = UIImage(data: data) {
                cell.cellContactsConfigure(namesArray: cellsNameArray, indexPath: indexPath, image: image, isEdit: editMode)
            } else {
                cell.cellContactsConfigure(namesArray: cellsNameArray, indexPath: indexPath, image: nil, isEdit: editMode)
            }
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 4: return 200
        default: return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: HeadersTableViewCell.self)) as! HeadersTableViewCell
        
        header.headerCellConfigure(nameArray: headersNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell

        switch indexPath.section {

        case 0: alertForCellName(
            label: cell.nameCellLabel,
            name: "Contact name",
            placeholder: "Enter contact name") { text in
                self.cellsNameArray[0] = text
            }

        case 1: alertForCellName(
            label: cell.nameCellLabel,
            name: "Phone number",
            placeholder: "Enter phone number") { text in
                self.cellsNameArray[1] = text
            }

        case 2: alertForCellName(
            label: cell.nameCellLabel,
            name: "Email",
            placeholder: "Enter email") { text in
                self.cellsNameArray[2] = text
            }
            
        case 3: alertContactType(
            label: cell.nameCellLabel) { type in
                self.cellsNameArray[3] = type
        }
            
        case 4: alertPhoto { source in
            self.chooseImagePicker(source: source)
        }
            
        default:
            print("Error")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ContactsOptionsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            // разрешаем редактирование выбранной фотографии
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
        
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        
        imageIsChanged = true
        dismiss(animated: true)
    }
}
