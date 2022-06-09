//
//  OptionTasksTableView.swift
//  dailyRoutine
//
//  Created by Миша on 16.03.2022.
//

import UIKit

class TasksOptionsTableViewController: UITableViewController {

    // MARK: - initialise elements
    private let headersNameArray = ["DATE", "LESSON", "TASK", "COLOR"]
    var cellsNameArray = ["Date", "Name lesson", "Description task", "106BFF"]
    var tasksModel = TasksRealmModel()
    var editMode = false
    var taskDate: Date?    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options Tasks"
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped))
    }
    
    // MARK: - Actions-Targets
    private func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.bounces = false

        tableView.separatorStyle = .none
        
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
            taskDate == nil ||
            cellsNameArray[1] == "Name lesson" ||
            cellsNameArray[2] == "Description task" {

            alertSuccessSave(title: "Error", message: "Required fields: DATE, LESSON, TASK")
        } else {
            
            switch editMode {
            case false:
                setModel()
                
                RealmManager.shared.saveTaskModel(model: tasksModel)
                
                tasksModel = TasksRealmModel()
                cellsNameArray = ["Date", "Name lesson", "Description task", "106BFF"]
                alertSuccessSave(title: "Successive save", message: nil)
                tableView.reloadData()
            case true:
                
                RealmManager.shared.editTaskModel(model: tasksModel, nameArray: cellsNameArray, date: taskDate)
                tasksModel = TasksRealmModel()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setModel(){
        tasksModel.taskDate = taskDate
        tasksModel.taskName = cellsNameArray[1]
        tasksModel.taskDescription = cellsNameArray[2]
        tasksModel.taskColor = cellsNameArray[3]
    }
    
    private func pushToColorsViewController(){
        let vc = ColorsViewController()
        vc.outputColor = { [weak self] color in
            self?.cellsNameArray[3] = color
            self?.tableView.reloadRows(at: [[3,0]], with: .none)
        }
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OptionsTableViewCell.self), for: indexPath) as! OptionsTableViewCell
        
        cell.cellTasksConfigure(namesArray: cellsNameArray, indexPath: indexPath, color: cellsNameArray[3], isEdit: editMode)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
            
        case 0: alertDate(
            label: cell.nameCellLabel) { (_, date) in
                self.taskDate = date
        }
            
        case 1: alertForCellName(
            label: cell.nameCellLabel,
            name: "Name Lesson",
            placeholder: "Enter name lesson") { text in
                self.cellsNameArray[1] = text
            }
            
        case 2: alertForCellName(
            label: cell.nameCellLabel,
            name: "Description Task",
            placeholder: "Enter name task") { text in
                self.cellsNameArray[2] = text
            }
            
        case 3: pushToColorsViewController()
            
        default:
            print("Error")
        }
    }
}
