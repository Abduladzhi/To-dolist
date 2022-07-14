//
//  TaskListPresenter.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 13.05.2022.
//

import Foundation
import RealmSwift

protocol TaskListPresenterProtocol: AnyObject {
    var newTasks: Results<TaskNewModelRealmm>! { get set }
    var doneTasks: Results<TaskDoneModelRealmm>! { get set }
    func loadScreen()
    func fetchCount(isNewTask: Bool) -> Int
    func recordNewTaskRealm(task: TaskNewModelRealmm)
    func recordDoneTaskRealm(task: TaskDoneModelRealmm)
    func deleteNewTaskRealm(item: TaskNewModelRealmm)
    func deleteDoneTaskRealm(item: TaskDoneModelRealmm)
    func newUpdateName(id: String, label: String, descriptionOne: String, image: Data)
    func newGetUp(id: String)
    func newGetData(id: String)
}

class TaskListPresenter {
    let realm = try! Realm()
    var newTasks: Results<TaskNewModelRealmm>!
    var doneTasks: Results<TaskDoneModelRealmm>!
    let calendar = Calendar.current
}

extension TaskListPresenter: TaskListPresenterProtocol {
    func deleteNewTaskRealm(item: TaskNewModelRealmm) {
        try! self.realm.write {
            self.realm.delete(item)
        }
    }
    
    func deleteDoneTaskRealm(item: TaskDoneModelRealmm) {
        try! self.realm.write {
            self.realm.delete(item)
        }
    }
    
    func recordNewTaskRealm(task: TaskNewModelRealmm) {
        try! realm.write {
            realm.add(task)
        }
    }
    
    func recordDoneTaskRealm(task: TaskDoneModelRealmm) {
        try! realm.write {
            realm.add(task)
        }
    }
    
    func fetchCount(isNewTask: Bool) -> Int {
        if isNewTask {
            return newTasks.count
        } else {
            return doneTasks.count
        }
    }
    
    func loadScreen() {
        newTasks = realm.objects(TaskNewModelRealmm.self)
        doneTasks = realm.objects(TaskDoneModelRealmm.self)
        
    }
    
    func newUpdateName(id: String, label: String, descriptionOne: String, image: Data) {
        if let userObject = realm.objects(TaskNewModelRealmm.self).filter({$0.id == id}).first {
            try! realm.write {
                userObject.id = id
                userObject.name = label
                userObject.descriptionOne = descriptionOne
                userObject.image = image
            }
        }
        
        if let userObject = realm.objects(TaskDoneModelRealmm.self).filter({$0.id == id}).first {
            try! realm.write {
                userObject.id = id
                userObject.name = label
                userObject.descriptionOne = descriptionOne
                userObject.image = image
            }
        }
    }
    
    func newGetUp(id: String) {
        if let userObject = realm.objects(TaskDoneModelRealmm.self).filter({$0.id == id}).first {
            try! realm.write {
                realm.delete(userObject)
            }
        }
    }
    
    func newGetData(id: String) {
        if let userObject = realm.objects(TaskNewModelRealmm.self).filter({$0.id == id}).first {
            try! realm.write {
                realm.delete(userObject)
            }
        }
    }
}
