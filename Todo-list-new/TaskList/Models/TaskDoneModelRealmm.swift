//
//  TaskDoneModelRealmm.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 13.05.2022.
//

import Foundation
import RealmSwift

class TaskDoneModelRealmm: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var image: Data
    @Persisted var date: Date
    @Persisted var dateClose: Date
    @Persisted var descriptionOne: String
    @Persisted var isComplited: Bool
    
    convenience init(id: String, name: String, image: Data, date: Date, dateClose: Date, descriptionOne: String, isComplited: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.date = date
        self.dateClose = dateClose
        self.descriptionOne = descriptionOne
        self.isComplited = isComplited
    }
}
