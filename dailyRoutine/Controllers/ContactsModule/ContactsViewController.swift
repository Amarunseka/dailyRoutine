//
//  ContactsTableViewController.swift
//  dailyRoutine
//
//  Created by Миша on 17.03.2022.
//

import UIKit
import RealmSwift

class ContactsViewController: UIViewController {
    
    
    // MARK: - initialise elements
    // поиск по контактам
    private let searchController = UISearchController()
    private var stackView = UIStackView()

    // все контакты сохраненные в реалма
    private var contactsArray: Results<ContactsRealmModel>!
    // массив куда помещаются контакты после того как вводишь их в поиске, и потом отображаются из него
    private var filteredArray: Results<ContactsRealmModel>!

    // сегментед для переключения между учителями и друзьями
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    // таблица для отображения контактов
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine // разделитель между ячейками
        return tableView
    }()
    
    // ЭТИ ДВА СВОЙСТВА НУЖНЫ ЧТОБЫ ПРОВЕРИТЬ, ЧТО У НАС ЗАПУЩЕНА ФИЛЬТРАЦИЯ НА ОСНОВАНИИ ВВЕДЕННЫХ ДАННЫХ В СЕРЧКОНТРОЛ, И ВЫГРУЗИТЬ ДАННЫЕ ИЗ ОТФИЛЬТРОВАННОГО МАССИВА - filteredArray
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return true}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts Tasks"
        view.backgroundColor = .white
        
        // выгружаем данные из модели, так как у нас сегмент стоит на друзьях то и выгружаем мы сначала друзей, а остальное в методе сегмента
        contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Friend'")
        
        setupSearchController()
        setupTableView()
        setupStackView()
        setupConstraints()
        
        // добавляем поиск сразу в табБар
        navigationItem.searchController = searchController
        // добавляем кнопку в navigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Targets & Methods
    
    private func setupSearchController(){
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }

    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ContactsTableViewCell.self,
            forCellReuseIdentifier: String(describing: ContactsTableViewCell.self))
    }
    
    
    private func setupStackView(){
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView(
            arrangeSubviews: [segmentedControl, tableView],
            axis: .vertical,
            spacing: 0,
            distribution: .equalSpacing)
    }
    
    // MARK: - настройка режима корректировки
    // метод назначения модели для редактировавания запускается при нажатии на контакт
    private func pushToOptionInEditingMode(contactModel: ContactsRealmModel){
        // создаем VC для перехода
        let vc = ContactsOptionsTableViewController()
        
        // передаем что мы входим в режим корректировки
        vc.editMode = true

        // в его модель передаем данные из уже сохраненной модели
        vc.contactsModel = contactModel

        vc.cellsNameArray = [
            contactModel.contactName,
            contactModel.contactPhone,
            contactModel.contactEmail,
            contactModel.contactType,
            ""
        ]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func addButtonTapped(){
        let vc = ContactsOptionsTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - настройка сегмента
    @objc
    private func segmentChanged(){
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // если в сегменте выбраны друзья то массив контактов формируется фильтром из друзей
            contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Friend'")
            tableView.reloadData()
        } else {
            // а здесь из учителей
            contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Teacher'")
            tableView.reloadData()
        }
    }
}


// MARK: - UISearchResultsUpdating

// методы делегата поиска для наполнения отфильтрованного массива нужными результатами
extension ContactsViewController: UISearchResultsUpdating {
    
    // здесь мы заполняем наш массив результатами поиска
    private func filterContactForSearch(_ searchText: String){
        // здесь мы настраиваем, что фильтр должен содержать вводимые данные
        filteredArray = contactsArray.filter("contactName CONTAINS[c] %@", searchText)
        // и потом перезагружаем таблицу и так как мы ввели данные то isFiltering у нас true и таблица наполняется из отфильтрованного массива, а не простых контактов
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // этот метод срабатывает когда мы вводим данные в поиск, и мы запускаем наполнение массива
        filterContactForSearch(searchController.searchBar.text!)
    }
}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isFiltering ? filteredArray.count : contactsArray.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactsTableViewCell.self),
                                                 for: indexPath) as! ContactsTableViewCell
        
        // смотрим, что если у нас isFiltering = true, то наполняем таблицу и отфильрованного массива, а в методе фильтрации (filterContactForSearch) уже перезагружаем таблицу
        let model = (isFiltering ? filteredArray[indexPath.row] : contactsArray[indexPath.row])
        cell.cellConfigure(model: model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // передаем сюда объект из сохраненной модели, как мы на этом контроллере отображаем данные загруженные из модели, и отображенные по порядку, то и получается что когда мы нажимаем то выбираем тот объект из модели, который отображается
        pushToOptionInEditingMode(contactModel: contactsArray[indexPath.row])
    }
    
    
    // метод удаления задач
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = contactsArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            RealmManager.shared.deleteContactModel(model: editingRow)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


// MARK: - Setup Constraints

extension ContactsViewController {
    
    private func setupConstraints(){
        view.addSubview(stackView)
        
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
