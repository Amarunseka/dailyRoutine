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
    private let searchController = UISearchController()
    private var stackView = UIStackView()
    private var contactsArray: Results<ContactsRealmModel>!
    private var filteredArray: Results<ContactsRealmModel>!

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine // разделитель между ячейками
        return tableView
    }()
    
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
        
        contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Friend'")
        
        setupSearchController()
        setupTableView()
        setupStackView()
        setupConstraints()
        
        navigationItem.searchController = searchController
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
    private func pushToOptionInEditingMode(contactModel: ContactsRealmModel){
        let vc = ContactsOptionsTableViewController()
        vc.editMode = true
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
            contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Friend'")
            tableView.reloadData()
        } else {
            contactsArray = RealmManager.shared.localRealm.objects(ContactsRealmModel.self).filter("contactType = 'Teacher'")
            tableView.reloadData()
        }
    }
}


// MARK: - UISearchResultsUpdating
extension ContactsViewController: UISearchResultsUpdating {

    private func filterContactForSearch(_ searchText: String){

        filteredArray = contactsArray.filter("contactName CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
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
        let model = (isFiltering ? filteredArray[indexPath.row] : contactsArray[indexPath.row])
        cell.cellConfigure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToOptionInEditingMode(contactModel: contactsArray[indexPath.row])
    }
    
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
