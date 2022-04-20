//
//  ScheduleViewController.swift
//  dailyRoutine
//
//  Created by Миша on 14.03.2022.
//

import UIKit
import FSCalendar
import RealmSwift


class ScheduleViewController: UITabBarController {
    
    // MARK: - initialise elements
    private var viewHeightConstraint: NSLayoutConstraint!
    private let calendarView = CalendarView()
    private let tableView = UITableView()
    var scheduleArray: Results<ScheduleRealmModel>!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        view.backgroundColor = .white
        title = "Schedule"
        // добавляем кнопку в navigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))

        setupTableView()
        setConstraints()
        scheduleOnDay(date: calendarView.calendar.today!)
        setupCalendarView()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    // MARK: - Actions-Targets
    // изменение размера CalendarView
    private func changeHeightAnchorCalendarView(height: CGFloat?){
        guard let height = height else {return}
        viewHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    private func setupCalendarView(){
        calendarView.outputCalendarDelegate = self
//
//        // изменение размера календаря и вью при открытии-закрытии
//        calendarView.outputChangeHeight = { [weak self] height in
//            self?.changeHeightAnchorCalendarView(height: height)
//        }
//
//        // метод нажатия на дату на календаре
//        calendarView.outputDidSelectDate = { [weak self] date in
//            self?.scheduleOnDay(date: date)
//        }
    }
    
    private func setupTableView(){
        tableView.bounces = false // чтобы таблица не тянулась, но скролл продолжает работать
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: String(describing: ScheduleTableViewCell.self))
    }

    
    private func pushToOptionInEditingMode(scheduleModel: ScheduleRealmModel){
        // получаем дату с пикера в строке
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: scheduleModel.scheduleDate!)
        
        // получаем время в строку
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: scheduleModel.scheduleTime!)

        let vc = ScheduleOptionsTableViewController()
        vc.scheduleModel = scheduleModel
        vc.editMode = true

        // дату нужно передавать потому, что если ее не передать и не менять потом, задача не сохраниться
        vc.scheduleDate = scheduleModel.scheduleDate
        vc.scheduleWeekDay = scheduleModel.scheduleWeekday
        vc.scheduleTime = scheduleModel.scheduleTime
        vc.scheduleRepeat = scheduleModel.scheduleRepeat
        
        vc.cellNamesArray = [
            [dateString,
             timeString],
            [scheduleModel.scheduleName,
             scheduleModel.scheduleType,
             scheduleModel.scheduleBuilding,
             scheduleModel.scheduleAudience],
            [scheduleModel.scheduleTeacher,],
            [scheduleModel.scheduleColor],
            ["Repeat every 7 days"],
        ]
        navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: - загрузка данных из модели
    
    private func scheduleOnDay(date: Date){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else {return}
        
        /// предикат для события которое повторяется
        let predicateRepeat = NSPredicate(format: "scheduleWeekday = \(weekday) AND scheduleRepeat = true")
        
        
        /// предикат для события которе не повторяется
        // для начала нам нужно создать диапазон дня, как как когда мы нажимаем на дату, то мы не можем точно попасть в туже самую наносекунду
        let dateStart = date
        let dateEnd: Date = {
            let component = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: component, to: dateStart)!
        }()
        // создаем сам предикат
        let predicateUnrepeat = NSPredicate(format: "scheduleRepeat = false AND scheduleDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnrepeat])

        
        /// выгружаем событие
        scheduleArray = RealmManager.shared.localRealm.objects(ScheduleRealmModel.self).filter(compound).sorted(byKeyPath: "scheduleTime")
        tableView.reloadData()
    }
    
    @objc
    private func addButtonTapped(){
        let vc = ScheduleOptionsTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - OutputCalendarDataProtocol
extension ScheduleViewController: OutputCalendarDataProtocol {
    // изменение размеров при изменение календаря
    func outputChangeHeight(height: CGFloat) {
        changeHeightAnchorCalendarView(height: height)
    }
    
    // загрузка данных по выбранной дате на календаре
    func outputDidSelectDate(date: Date) {
        scheduleOnDay(date: date)
    }
}



// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ScheduleTableViewCell.self),
            for: indexPath) as! ScheduleTableViewCell
        
        let model = scheduleArray[indexPath.row]
        cell.cellConfigure(model: model)
        
        return cell
    }
}
  
// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // метод удаления задач
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = scheduleArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            RealmManager.shared.deleteScheduleModel(model: editingRow)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToOptionInEditingMode(scheduleModel: scheduleArray[indexPath.row])
    }
}


// MARK: - Setup Constraints

extension ScheduleViewController {
    
    private func setConstraints(){
        view.addSubview(calendarView)
        view.addSubview(tableView)

        // для того, что бы изменять размер при изменении масштаба констрейнту высоты заводим отдельно от остальных
        viewHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 320)
        viewHeightConstraint.isActive = true

        let constraints = [
            
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


