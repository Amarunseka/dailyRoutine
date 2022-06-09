//
//  RealmManager.swift
//  dailyRoutine
//
//  Created by Миша on 18.03.2022.
//

import RealmSwift
import Realm

class RealmManager {
    
    static let shared = RealmManager()
    
    private init(){}
    
    let localRealm = try! Realm()
    
    // MARK: - Schedule
    func saveScheduleModel(model: ScheduleRealmModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteScheduleModel(model: ScheduleRealmModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func editScheduleModel(model: ScheduleRealmModel, nameArray: [[String]], date: Date?, time: Date?, weekDay: Int, isRepeat: Bool) {
        try! localRealm.write {
            model.scheduleDate = date
            model.scheduleWeekday = weekDay
            model.scheduleTime = time
            model.scheduleName = nameArray[1][0]
            model.scheduleType = nameArray[1][1]
            model.scheduleBuilding = nameArray[1][2]
            model.scheduleAudience = nameArray[1][3]
            model.scheduleTeacher = nameArray[2][0]
            model.scheduleColor = nameArray[3][0]
            model.scheduleRepeat = isRepeat
        }
    }
    
    // MARK: - Tasks
    func saveTaskModel(model: TasksRealmModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteTaskModel(model: TasksRealmModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func updateReadyButtonTaskModel(task: TasksRealmModel, state: Bool) {
        try! localRealm.write {
            task.taskReady = state
        }
    }
    
    func editTaskModel(model: TasksRealmModel, nameArray: [String], date: Date?) {
        try! localRealm.write {
            model.taskDate = date
            model.taskName = nameArray[1]
            model.taskDescription = nameArray[2]
            model.taskColor = nameArray[3]
        }
    }
    
    // MARK: - Contacts
    func saveContactModel(model: ContactsRealmModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteContactModel(model: ContactsRealmModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func editContactModel(model: ContactsRealmModel, nameArray: [String], imageData: Data?) {
        try! localRealm.write {
            model.contactName = nameArray[0]
            model.contactPhone = nameArray[1]
            model.contactEmail = nameArray[2]
            model.contactType = nameArray[3]
            model.contactPhoto = imageData
        }
    }
}
