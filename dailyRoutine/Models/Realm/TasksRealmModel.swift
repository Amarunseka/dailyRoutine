//
//  TasksModel.swift
//  dailyRoutine
//
//  Created by Миша on 29.03.2022.
//

import RealmSwift
import Foundation

class TasksRealmModel: Object {
    @Persisted var taskDate: Date?
    @Persisted var taskName: String = "Unknown"
    @Persisted var taskDescription: String = "Unknown"
    @Persisted var taskColor: String = "106BFF"
    @Persisted var taskReady: Bool = false
}
