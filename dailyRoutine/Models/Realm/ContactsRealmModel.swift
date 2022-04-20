//
//  ContactsModel.swift
//  dailyRoutine
//
//  Created by Миша on 29.03.2022.
//

import RealmSwift
import Foundation

class ContactsRealmModel: Object {
    @Persisted var contactName: String = "Unknown"
    @Persisted var contactPhone: String = "Unknown"
    @Persisted var contactEmail: String = "Unknown"
    @Persisted var contactType: String = "Unknown"
    @Persisted var contactPhoto: Data?
}
