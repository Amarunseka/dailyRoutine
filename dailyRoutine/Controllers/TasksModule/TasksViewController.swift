//
//  TasksViewController.swift
//  dailyRoutine
//
//  Created by Миша on 14.03.2022.
//

import UIKit
import FSCalendar
import RealmSwift

class TasksViewController: UITabBarController {

    // MARK: - initialise elements
    var tasksArray: Results<TasksRealmModel>!
    private var calendarHeightConstraint: NSLayoutConstraint!
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
    
    private let showHideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.bounces = false // чтобы таблица не тянулась, но скролл продолжает работать
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Tasks"

        setupCalendar()
        setupTableView()
        setConstraints()
        swipeAction()
        
        setTaskOnDay(date: calendar.today!)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
    }
    
    
    // MARK: - Actions-Targets

    private func setupCalendar(){
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TasksTableViewCell.self,
            forCellReuseIdentifier: String(describing: TasksTableViewCell.self))
    }
    
    private func pushToOptionInEditingMode(taskModel: TasksRealmModel){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: taskModel.taskDate!)

        
        let vc = TasksOptionsTableViewController()
        vc.tasksModel = taskModel
        vc.editMode = true

        vc.taskDate = taskModel.taskDate
        vc.cellsNameArray = [
            dateString,
            taskModel.taskName,
            taskModel.taskDescription,
            taskModel.taskColor]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    private func addButtonTapped(){
        let vc = TasksOptionsTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    private func showHideButtonTapped(){
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
    
    
    // MARK: - SwipeGestureRecognizer
    private func swipeAction(){
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUP.direction = .up
        calendar.addGestureRecognizer(swipeUP)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc
    private func handleSwipe(gesture: UISwipeGestureRecognizer){
        
        switch gesture.direction {
        case.up :
            showHideButtonTapped()
        case.down :
            showHideButtonTapped()
        default:
            break
        }
    }
    
    
    // MARK: - загрузка данных из модели
    private func setTaskOnDay(date: Date){

        let dateStart = date
        let dateEnd: Date = {
            let component = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: component, to: dateStart)!
        }()
        
        tasksArray = RealmManager.shared.localRealm.objects(TasksRealmModel.self).filter("taskDate BETWEEN %@", [dateStart, dateEnd])
        tableView.reloadData()
    }
    
    private func readyButtonTapped(indexPath: IndexPath) {

        let task = tasksArray[indexPath.row]
        RealmManager.shared.updateReadyButtonTaskModel(task: task, state: !task.taskReady)
        tableView.reloadData()
    }
}
  
// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                  for: indexPath) as! TasksTableViewCell
        
        cell.indexPath = indexPath
        cell.completeTaskOutput = { [weak self] indexPath in
            self?.readyButtonTapped(indexPath: indexPath)
        }
        
        let model = tasksArray[indexPath.row]
        cell.cellConfigure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToOptionInEditingMode(taskModel: tasksArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = tasksArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            RealmManager.shared.deleteTaskModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - FSCalendarDataSource, FSCalendarDelegate

extension TasksViewController: FSCalendarDataSource, FSCalendarDelegate  {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setTaskOnDay(date: date)
    }
}

// MARK: - Setup Constraints
extension TasksViewController {
    
    private func setConstraints(){
        view.addSubview(calendar)
        view.addSubview(showHideButton)
        view.addSubview(tableView)

        calendarHeightConstraint = NSLayoutConstraint(
            item: calendar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        let constraints = [
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 100),
            showHideButton.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}



