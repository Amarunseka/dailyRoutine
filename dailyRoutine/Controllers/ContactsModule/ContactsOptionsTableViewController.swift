//
//  OptionsContactsTableViewController.swift
//  dailyRoutine
//
//  Created by Миша on 17.03.2022.
//

import UIKit

class ContactsOptionsTableViewController: UITableViewController {

    
    // MARK: - initialise elements
    
    // массив названий заголовков
    private let headersNameArray = ["NAME", "PHONE", "EMAIL", "TYPE", "IMAGE"]
    
    // массив названий ячеек
    var cellsNameArray = ["Name", "Phone number", "Email", "Type of contact", ""]
    
    // модель текущего контакта для сохранения и корректировки
    var contactsModel = ContactsRealmModel()
    
    // свойства для корректировки
    var imageIsChanged = false
    
    
    var editMode: Bool = false
    var dataImage: Data?
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Contact"
        setupTableView()
        // добавляем кнопку в navigationBar
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

        tableView.separatorStyle = .none // убираем разделитель между ячейками
        
        tableView.register(
            OptionsTableViewCell.self,
            forCellReuseIdentifier: String(describing: OptionsTableViewCell.self))
        
        // регистрируем Header
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
            
            /// !!!!    ВМЕСТО АЛЕРТА СДЕЛАТЬ НЕАКТИВНОЙ КНОПКУ !!!!
                alertSuccessSave(title: "Error", message: "Required fields: NAME, PHONE, EMAIL, TYPE")
            
        } else {
            
            switch editMode {
            case false:
                setImageModel()
                
                // запускаем наполнение модели из отредактированного массива после вызова алертов
                setModel()
                // сохраняем нашу модель в базу данных
                RealmManager.shared.saveContactModel(model: contactsModel)
                
                // а теперь мы наоборот говорим, что после сохранения наша модель равняется модели сохраненной в Real
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
                
                // получаем изображение из ячейки потому как мы могли его изменить
                setImageModel()
                
                // и вызываем метод обновления модели из менеджера
                RealmManager.shared.editContactModel(
                    model: contactsModel,
                    nameArray: cellsNameArray,
                    imageData: dataImage)
                contactsModel = ContactsRealmModel()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // теперь мы передаем данные в модель из массива, не напрямую алертами
    // при корректировке модель уже существует и мы не можем напрямую просто заменить в ней данные
    // поэтому этот метод вызывается только при создании новой модели когда она еще так сказать пустая, потому, что потом мы можем только прочивать из нее данные а заменить, только через специальный метов в менеджере Реалм
    private func setModel(){
        contactsModel.contactName = cellsNameArray[0]
        contactsModel.contactPhone = cellsNameArray[1]
        contactsModel.contactEmail = cellsNameArray[2]
        contactsModel.contactType = cellsNameArray[3]
        contactsModel.contactPhoto = dataImage
    }
    
    // метод преобразования изображения в дату, для передачи в модель
    private func setImageModel(){
        
        // если мы говорим, что изображение было изменено, то есть добавлено из imagePicker, тогда мы должны сохранить ее в модель, но сохранено оно в формате Image и нам нужно преобразовать ее в Data
        if imageIsChanged {
            // мы берем нашу ячейку в которой уже есть изображение
            let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
            
            // получаем изображение в формате image
            let image = cell.backgroundViewCell.image
            
            // пытаемся получить из image - Data
            guard let imageData = image?.pngData() else {return}
            
            // присваиваем значение в переменную для сохранения в модель
            dataImage = imageData
            
            // это нужно, для того, что когда мы сохраняем мы сбрасываем все, а если это не сбросим, нашу системную картинку растянет
            // а в методе сохранения у нас нет доступа к ячейке
            // но можно в cellContactsConfigure попробовать это прописать
            cell.backgroundViewCell.contentMode = .scaleAspectFit
            
            // это нужно для того, что бы при сохранении не сохранять одну и туже картинку
            // НЕ ПОНИМАЮ ПОЧЕМУ НЕЛЬЗЯ ПЕРЕНЕСТИ В МЕТОД СОХРАНЕНИЯ, !!! ПОПРОБОВАТЬ
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
            // если режим корректировки выключен то мы просто создаем ячейку как новую, тоесть передаем в режим конфигурации false, а там уже в связи с этим ячека будет создаваться как новая
        case false:
            cell.cellContactsConfigure(namesArray: cellsNameArray, indexPath: indexPath, image: nil, isEdit: editMode)
        case true:
            
            // если режим корректировки включен то мы передаем в конфигурацию true
            // и проверяем можем ли мы получить из Data сохраненной модели изображение
            if let data = contactsModel.contactPhoto, let image = UIImage(data: data) {
                // если да, то передаем его для редактирования
                cell.cellContactsConfigure(namesArray: cellsNameArray, indexPath: indexPath, image: image, isEdit: editMode)
            } else {
                // если нет так и передаем nil
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
    
    // метод работы с ImagePicker во входящих будем выбирать камера или галерея
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        // проверяем имеем ли мы доступ к ресурсам
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            // разрешаем редактирование выбранной фотографии
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    
    // этот передает захваченное изображение делегату пикера, срабатывает автоматически при закрытие пикера
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // тут мы берем ячейку из таблицы и присваиваем ей фото
        let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
        
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        
        // менять на true, чтобы выше понять, что нам нужно сохранить изображение в модель, выдернув его из ячейки
        imageIsChanged = true
        dismiss(animated: true)
    }
}
