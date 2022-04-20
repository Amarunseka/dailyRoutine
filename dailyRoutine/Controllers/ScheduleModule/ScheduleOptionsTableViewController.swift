//
//  OptionsScheduleViewController.swift
//  dailyRoutine
//
//  Created by Миша on 15.03.2022.
//

import UIKit
import SwiftUI

class ScheduleOptionsTableViewController: UITableViewController {

    
    // MARK: - initialise elements
    
    // названия заголовков
    private let headersNameArray = ["DATE AND TIME", "LESSON", "TEACHER", "COLOR", "PERIOD"]
    
    
    // массив названий ячеек
    var cellNamesArray = [["Date", "Time"],
                         ["Name", "Type", "Building", "Audience"],
                         ["Teacher Name"],
                         ["106BFF"],
                         ["Repeat every 7 days"]
    ]
    
    // модель сохранения в базу данных
    var scheduleModel = ScheduleRealmModel()
    var editMode = false
    
    var scheduleDate: Date?
    var scheduleTime: Date?
    var scheduleWeekDay = Int()
    var scheduleRepeat = true
//    var dateInfo: (date: Date?, numberOfWeekday: Int, time: Date?, isRepeat: Bool)?


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options Schedule"
        setupTableView()
                
        // добавляем кнопку в navigationBar
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
            // проверяем на заполенения полей для сохранения
            /// !!!!    ВМЕСТО АЛЕРТА СДЕЛАТЬ НЕАКТИВНОЙ КНОПКУ !!!!
            scheduleDate == nil ||
            scheduleTime == nil ||
            cellNamesArray[1][0] == "Name" {
            
                alertSuccessSave(title: "Error", message: "Required fields: DATE, TIME, NAME")
        } else {
            
            switch editMode {
            case false:
                setModel()

                // сохраняем нашу модель в базу данных
                RealmManager.shared.saveScheduleModel(model: scheduleModel)
                // а теперь мы наоборот говорим, что после сохранения наша модель равняется модели сохраненной в Real
                scheduleModel = ScheduleRealmModel()
                
                // возвращаем настройки по умолчанию
                cellNamesArray = [["Date", "Time"],
                                  ["Name", "Type", "Building", "Audience"],
                                  ["Teacher Name"],
                                  ["106BFF"],
                                  ["Repeat every 7 days"]]
                
                // показываем алерт что все успешно сохранено
                alertSuccessSave(title: "Success save", message: nil)
                tableView.reloadData()
                
            case true:

                RealmManager.shared.editScheduleModel(
                    model: scheduleModel,
                    nameArray: cellNamesArray,
                    date: scheduleDate,
                    time: scheduleTime,
                    weekDay: scheduleWeekDay,
                    isRepeat: scheduleRepeat)
                
                scheduleModel = ScheduleRealmModel()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    // теперь мы передаем данные в модель из массива, не напрямую алертами
    // при корректировке модель уже существует и мы не можем напрямую просто заменить в ней данные
    // поэтому этот метод вызывается только при создании новой модели когда она еще так сказать пустая, потому, что потом мы можем только прочивать из нее данные а заменить, только через специальный метов в менеджере Реалм
    private func setModel(){
        scheduleModel.scheduleDate = scheduleDate
        scheduleModel.scheduleTime = scheduleTime
        scheduleModel.scheduleWeekday = scheduleWeekDay
        scheduleModel.scheduleRepeat = scheduleRepeat

        scheduleModel.scheduleName = cellNamesArray[1][0]
        scheduleModel.scheduleType = cellNamesArray[1][1]
        scheduleModel.scheduleBuilding = cellNamesArray[1][2]
        scheduleModel.scheduleAudience = cellNamesArray[1][3]
        scheduleModel.scheduleTeacher = cellNamesArray[2][0]
        scheduleModel.scheduleColor = cellNamesArray[3][0]
    }
    
    
    // переход на teacher
    private func pushToTeacherViewController(){
        let vc = TeachersTableViewController()
        let cell = tableView.cellForRow(at: [2,0]) as! OptionsTableViewCell

        vc.outputTeacherName = { [weak self] name in
            self?.cellNamesArray[2][0] = name
            cell.nameCellLabel.text = name
            cell.nameCellLabel.textColor = .black
        }
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // просто метод для перехода
    private func pushToColorsViewController(){
        let vc = ColorsViewController()
        vc.outputColor = { [weak self] color in
            self?.cellNamesArray[3][0] = color
            self?.tableView.reloadRows(at: [[3,0],[4,0]], with: .none)
        }
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // метод делегата для OptionsTableViewCell записывающий положение переключателя в Real
    private func switchRepeatState(value: Bool) {
        scheduleRepeat = value
    }
    
    // просто метод для перехода
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
        
        switch section {
        case 0: return cellNamesArray[0].count
        case 1: return cellNamesArray[1].count
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OptionsTableViewCell.self), for: indexPath) as! OptionsTableViewCell
        
        // метод конфигурации ячейки
        cell.cellScheduleConfigure(namesArray: cellNamesArray,
                                   indexPath: indexPath,
                                   color: cellNamesArray[3][0],
                                   isEdit: editMode,
                                   isRepeat: scheduleRepeat)
        
        // для передачи в ячейку положение свитча
        cell.switchStateOutput = { [weak self] switchState in
            self?.switchRepeatState(value: switchState)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 20
    }
    
    
    // MARK: - TableView (Header)

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: HeadersTableViewCell.self)) as! HeadersTableViewCell
        
        // метод присваивания названий заголовкам
        header.headerCellConfigure(nameArray: headersNameArray, section: section)
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    // MARK: - TableView (DidSelect)

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath {
            // передаем в алерт наш лейб, и в комплишене алерта присваиваем ему название из сделанного стринга из дэйтпикера
        case [0,0]: alertDate(label: cell.nameCellLabel) { numberOfWeekday, date in
            // а потом передаем в модель дату и день недели с формированную в самом алерте и переданому в комплишене
            self.scheduleDate = date
            self.scheduleWeekDay = numberOfWeekday
        }
            // передаем в алерт наш лейб, и в комплишене алерта присваиваем ему название из сделанного стринга из дэйтпикера
        case [0,1]: alertTime(label: cell.nameCellLabel) { time in
            // а потом передаем в модель время с формированное в самом алерте и переданому в комплишене
            self.scheduleTime = time
        }
            
            // передаем в алерт наш лейбназвание алерта, потом плейсхолдер который будем видеть текстфилде алерта
        case [1,0]: alertForCellName(
            label: cell.nameCellLabel,
            name: "Name Lesson",
            placeholder: "Enter name lesson") { text in
                // передаем в модель текс из текстфилда алерта
                self.cellNamesArray[1][0] = text
            }
            
            // передаем в алерт наш лейбназвание алерта, потом плейсхолдер который будем видеть текстфилде алерта
        case [1,1]: alertForCellName(
            label: cell.nameCellLabel,
            name: "Type Lesson",
            placeholder: "Enter type lesson") { text in
                // передаем в модель текс из текстфилда алерта
                self.cellNamesArray[1][1] = text
            }
            
            // передаем в алерт наш лейбназвание алерта, потом плейсхолдер который будем видеть текстфилде алерта
        case [1,2]: alertForCellName(
            label: cell.nameCellLabel,
            name: "Building number",
            placeholder: "Enter number of building") { text in
                // передаем в модель текс из текстфилда алерта
                self.cellNamesArray[1][2] = text
            }
            
            // передаем в алерт наш лейбназвание алерта, потом плейсхолдер который будем видеть текстфилде алерта
        case [1,3]: alertForCellName(
            label: cell.nameCellLabel,
            name: "Audience number",
            placeholder: "Enter number of audience") { text in
                // передаем в модель текс из текстфилда алерта
                self.cellNamesArray[1][3] = text
            }
            
        case [2,0]:
            // в самом TeachersTableViewController есть способ передачи сюда учителя
            pushToTeacherViewController()
            
        case [3,0]:
            // в самом ScheduleColorsViewController есть способ передачи сюда цвета
            pushToColorsViewController()

        default:
            print("Error")
        }
    }
}
