//
//  TeachersTableViewController.swift
//  dailyRoutine
//
//  Created by Миша on 16.03.2022.
//

import UIKit
import RealmSwift

class TeachersTableViewController: UITableViewController {

    // MARK: - initialise elements
    var outputTeacherName: ((String)->())?
    private var contactArray: Results<ContactsRealmModel>!
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
        // заполняем наш массив всеми учителями из модели, по фильтру учитель
    }
    
    // MARK: - private methods
    private func setupView(){
        view.backgroundColor = .white
        title = "Teachers"
        contactArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Teacher'")
    }
    

    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactsTableViewCell.self))
    }
    
    // отдаем имя выбранного учителя
    private func setTeacher(teacher: String) {
        guard let outputTeacherName = outputTeacherName else {return}
        outputTeacherName(teacher)
        self.navigationController?.popViewController(animated: true)
    }
}
    
// MARK: - TableView
extension TeachersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactsTableViewCell.self),
                                                 for: indexPath) as! ContactsTableViewCell
        
        let model = contactArray[indexPath.row]
        // конфигурируем ячейку переданной в нее модели
        cell.cellConfigure(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = contactArray[indexPath.row]
        setTeacher(teacher: model.contactName)
    }
}


