//
//  ViewController.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 27.04.2022.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: TaskListPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadScreen()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    @IBAction func addPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive , title: "Delete") { (action, sourceView, completionHandler) in
            guard let presenter = self.presenter else { return }
            if indexPath.section == 0 {
                if presenter.fetchCount(isNewTask: true) >= 1 {
                    if let item = self.presenter?.newTasks[indexPath.row] {
                        presenter.deleteNewTaskRealm(item: item)
                    }
                } else {
                    if let item = self.presenter?.doneTasks[indexPath.row] {
                        presenter.deleteDoneTaskRealm(item: item)
                    }
                }
            } else {
                if let item = self.presenter?.doneTasks[indexPath.row] {
                    presenter.deleteDoneTaskRealm(item: item)
                }
            }
            tableView.reloadData()
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 2
        if presenter?.fetchCount(isNewTask: true) == 0 {
            sectionCount = 1
        }
        if presenter?.fetchCount(isNewTask: false) == 0 {
            sectionCount = 1
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let presenter = self.presenter else { return String() }
        switch section {
        case 0:
            if presenter.fetchCount(isNewTask: true) >= 1 {
                return "Новые задачи (свайп для удаления)"
            } else if presenter.fetchCount(isNewTask: true) == 0 && presenter.fetchCount(isNewTask: false) >= 1 {
                return "Завершенные задачи"
            } else {
                return ""
            }
        case 1:
            if presenter.fetchCount(isNewTask: false) >= 1 {
                return "Завершенные задачи"
            }
        default:
            return "Default"
        }
        return "Default"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = self.presenter else { return Int() }
        switch section {
        case 0:
            if presenter.fetchCount(isNewTask: true) >= 1 {
                return presenter.fetchCount(isNewTask: true)
            } else {
                return presenter.fetchCount(isNewTask: false)
            }
        case 1:
            if presenter.fetchCount(isNewTask: false) >= 0 {
                return presenter.fetchCount(isNewTask: false)
            }
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        guard let presenter = self.presenter else { return UITableViewCell() }
        if indexPath.section == 0 {
            if presenter.fetchCount(isNewTask: true) >= 1 {
                let itemNew = presenter.newTasks[indexPath.row]
                if itemNew.isComplited == false {
                    cell.configure(delegate: self, id: itemNew.id, name: itemNew.name, image: itemNew.image, date: itemNew.date, descriptionOne: itemNew.descriptionOne , section: 0)
                }
            } else {
                let itemDone = presenter.doneTasks[indexPath.row]
                if itemDone.isComplited == true {
                    cell.configure(delegate: self, id: itemDone.id, name: itemDone.name, image: itemDone.image, date: itemDone.date, descriptionOne: itemDone.descriptionOne , section: 1)
                }
            }
        } else {
            let itemDone = presenter.doneTasks[indexPath.row]
            if itemDone.isComplited == true {
                cell.configure(delegate: self, id: itemDone.id, name: itemDone.name, image: itemDone.image, date: itemDone.date, descriptionOne: itemDone.descriptionOne , section: 1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailDidSelectViewController") as? DetailDidSelectViewController else { return }
        controller.delegate = self
        guard let presenter = self.presenter else { return }
        if indexPath.section == 0 {
            if presenter.fetchCount(isNewTask: true) >= 1 {
                controller.uuid = presenter.newTasks[indexPath.row].id
                controller.textInTextField = presenter.newTasks[indexPath.row].name
                controller.saveTextView = presenter.newTasks[indexPath.row].descriptionOne
                controller.changeImageNew = presenter.newTasks[indexPath.row].image
                controller.saveDate = presenter.newTasks[indexPath.row].date
                controller.delegate = self
                
            } else {
                controller.uuid = presenter.doneTasks[indexPath.row].id
                controller.textInTextField = presenter.doneTasks[indexPath.row].name
                controller.saveTextView = presenter.doneTasks[indexPath.row].descriptionOne
                controller.changeImageNew = presenter.doneTasks[indexPath.row].image
                controller.saveDate = presenter.doneTasks[indexPath.row].date
                controller.delegate = self
            }
            
            
        } else {
            controller.uuid = presenter.doneTasks[indexPath.row].id
            controller.textInTextField = presenter.doneTasks[indexPath.row].name
            controller.saveTextView = presenter.doneTasks[indexPath.row].descriptionOne
            controller.changeImageNew = presenter.doneTasks[indexPath.row].image
            controller.saveDate = presenter.doneTasks[indexPath.row].date
            controller.delegate = self
        }
//            if presenter.fetchCount(isNewTask: true) >= 1 {
//                controller.newTasks = presenter.newTasks[indexPath.row]
//            } else {
//                controller.doneTasks = presenter.doneTasks[indexPath.row]
//            }
//        } else {
//            controller.doneTasks = presenter.doneTasks[indexPath.row]
//        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: DetailProtocol {
    func getFirstData(id: String, label: String, image: Data, date: Date,dateClose: Date , descriptionOne: String, isComplited: Bool) {
        let task = TaskNewModelRealmm(id: id, name: label, image: image, date: date, dateClose: dateClose, descriptionOne: descriptionOne, isComplited: isComplited)
        presenter?.recordNewTaskRealm(task: task)
        let sortedList = presenter?.newTasks.sorted(byKeyPath: "date", ascending: false)
        presenter?.newTasks = sortedList
        tableView.reloadData()
    }
}

extension ViewController: DetailDidSelectProtocol {
    func updateName(id: String, label: String, textInTextField: String , image: Data, descriptionOne: String, date: Date, isComplited: Bool) {
        presenter?.newUpdateName(id: id, label: label, descriptionOne: descriptionOne, image: image)
        let sortedList = presenter?.newTasks.sorted(byKeyPath: "date", ascending: false)
        presenter?.newTasks = sortedList
        let sortedListTwo = presenter?.doneTasks.sorted(byKeyPath: "dateClose", ascending: false)
        presenter?.doneTasks = sortedListTwo
        tableView.reloadData()
    }
}

extension ViewController: TableViewProtocol {
    func getUp(id: String, label: String, image: Data, date: Date, descriptionOne: String, isComplited: Bool) {
        presenter?.newGetUp(id: id)
        let task = TaskNewModelRealmm(id: id, name: label, image: image, date: date, dateClose: Date(), descriptionOne: descriptionOne, isComplited: isComplited)
        presenter?.recordNewTaskRealm(task: task )
        let sortedList = presenter?.newTasks.sorted(byKeyPath: "date", ascending: false)
        presenter?.newTasks = sortedList
        tableView.reloadData()
    }
    
    func getData(id: String, label: String, image: Data, date: Date, descriptionOne: String, isComplited: Bool) {
        presenter?.newGetData(id: id)
        let task = TaskDoneModelRealmm(id: id, name: label, image: image, date: date, dateClose: Date(), descriptionOne: descriptionOne, isComplited: isComplited)
        presenter?.recordDoneTaskRealm(task: task)
        let sortedListTwo = presenter?.doneTasks.sorted(byKeyPath: "dateClose", ascending: false)
        presenter?.doneTasks = sortedListTwo
        tableView.reloadData()
    }
}

extension ViewController {
    static func assemblyBuilder() -> UIViewController{
        let presenter = TaskListPresenter()
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        controller.presenter = presenter
        return controller
    }
}
