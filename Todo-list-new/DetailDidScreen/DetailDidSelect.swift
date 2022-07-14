//
//  DetailDidSelect.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 10.05.2022.
//

import UIKit

protocol DetailDidSelectProtocol {
    func updateName(id: String, label: String, textInTextField: String , image: Data, descriptionOne: String, date: Date, isComplited: Bool)

}

class DetailDidSelectViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageBigg: UIImageView!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    var delegate: DetailDidSelectProtocol?

    var buttonSortIsHidden = true

    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()

    var textInTextField: String?
    
    var saveTextView: String?
    
    var uuid: String?
    
    var saveDate: Date?
    
    var changeImageNew: Data?
    
    var doneTasks: TaskDoneModelRealmm?
    var newTasks: TaskNewModelRealmm?
    
    let buttons = [ButtonsNew.changeImage.rawValue, ButtonsNew.removeImage.rawValue, ButtonsNew.cancel.rawValue] as [Any]

    enum ButtonsNew: String, CaseIterable {
        case changeImage = "Change Image"
        case removeImage = "Remove Image"
        case cancel = "Cancel"
    }

    var tableList: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableSortCell")
        tableView.backgroundColor = .gray
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDescription.layer.borderWidth = 0.5
        textViewDescription.layer.cornerRadius = 6
        textViewDescription.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.addSubview(tableList)
        textViewDescription.delegate = self
        self.textFieldName.delegate = self
        tableList.delegate = self
        tableList.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Setting", style: .done, target: self, action: #selector(addPhoto))
        
//        if newTasks != nil {
//            imageView.image = UIImage(data: newTasks?.image ?? Data())
//            textFieldName.text = newTasks?.name
//            textViewDescription.text = newTasks?.descriptionOne
//        } else {
//            textViewDescription.text = "Description"
//            textViewDescription.textColor = UIColor.lightGray
//        }
//        if saveTextView == "Description" {
//            textViewDescription.text = "Description"
//            textViewDescription.textColor = UIColor.lightGray
//        }
//
//        if newTasks != nil {
//            imageView.image = UIImage(data: doneTasks?.image ?? Data())
//            textFieldName.text = newTasks?.name
//            textViewDescription.text = doneTasks?.descriptionOne
//        } else {
//            textViewDescription.text = "Description"
//            textViewDescription.textColor = UIColor.lightGray
//        }
//        if saveTextView == "Description" {
//            textViewDescription.text = "Description"
//            textViewDescription.textColor = UIColor.lightGray
//        }
        
        if changeImageNew != nil {
            imageView.image = UIImage(data: changeImageNew ?? Data())
        }

        if textInTextField != nil {
            textFieldName.text = textInTextField
        }

        
        
        if saveTextView != nil {
            textViewDescription.text = saveTextView
        } else {
            textViewDescription.text = "Description"
            textViewDescription.textColor = UIColor.lightGray
        }
        if saveTextView == "Description" {
            textViewDescription.text = "Description"
            textViewDescription.textColor = UIColor.lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableList.translatesAutoresizingMaskIntoConstraints = false
        tableList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableList.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    @IBAction func savePress(_ sender: Any) {
        
        delegate?.updateName(id: uuid ?? "", label: textFieldName.text ?? "", textInTextField: textInTextField ?? "", image: changeImageNew ?? Data(), descriptionOne: textViewDescription.text, date: saveDate ?? Date.now, isComplited: false)
        navigationController?.popViewController(animated: true)

    }
}


extension DetailDidSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func addPhoto() {

        if buttonSortIsHidden {
            buttonSortIsHidden = !buttonSortIsHidden
            tableList.isHidden = buttonSortIsHidden
        } else {
            buttonSortIsHidden = !buttonSortIsHidden
            tableList.isHidden = buttonSortIsHidden
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let dataNew = image.jpegData(compressionQuality: 0.1) as Data?
            imageView.image = image
            changeImageNew = dataNew
        }

    }
}



extension DetailDidSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ButtonsNew.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCell(withIdentifier: "tableSortCell", for: indexPath)
        let ttt = buttons[indexPath.row]
        cell.textLabel?.text = String("\(ttt)")
        return cell
    }

    func oneHidden() {
        buttonSortIsHidden = !buttonSortIsHidden
        tableList.isHidden = buttonSortIsHidden
    }

    func secondHidden() {
        buttonSortIsHidden = !buttonSortIsHidden
        tableList.isHidden = buttonSortIsHidden
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false

                present(imagePicker, animated: true, completion: nil)
            }
            if buttonSortIsHidden {
                oneHidden()
            } else {
                secondHidden()
            }
        case 1:
            imageView.image = nil
            changeImageNew = nil
            if buttonSortIsHidden {
                oneHidden()
            } else {
                secondHidden()
            }
        case 2:

            if buttonSortIsHidden {
                oneHidden()
            } else {
                secondHidden()
            }

        default:

            if buttonSortIsHidden {
                oneHidden()
            } else {
                secondHidden()
            }
        }
    }
}

