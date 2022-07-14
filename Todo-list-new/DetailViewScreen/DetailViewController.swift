//
//  DetailViewController.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 27.04.2022.
//

import UIKit


protocol DetailProtocol {
    func getFirstData(id: String, label: String, image: Data, date: Date, dateClose: Date, descriptionOne: String, isComplited: Bool)

}

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var textFieldName: UITextField!
    var delegate: DetailProtocol?
    @IBOutlet weak var imageBigg: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    var buttonSortIsHidden = true
    
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    var uuid: String?
    
    var textInTextField: String?
    var changeImageNew: Data?
    
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
        view.addSubview(tableList)
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.delegate = self
        textView.text = "Description"
        textView.textColor = UIColor.lightGray
        tableList.delegate = self
        tableList.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Setting", style: .done, target: self, action: #selector(addPhoto))
        self.textFieldName.delegate = self
        
        if changeImageNew != nil {
            imageView.image = UIImage(data: changeImageNew ?? Data())
        }
        
        if textInTextField != nil {
            textFieldName.text = textInTextField
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
        let id = UUID().uuidString
        
        if textFieldName.text == "" {
            let alert = UIAlertController(title: "Оповещение", message: "Введите название задачи", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        } else {
            delegate?.getFirstData(id: id, label: textFieldName.text ?? "", image: changeImageNew ?? Data(), date: Date.now,dateClose: Date.now, descriptionOne: textView.text, isComplited: false)
            navigationController?.popViewController(animated: true)
        }
    }
}


extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            let dataNew = image.jpegData(compressionQuality: 0.5) as Data?
            imageView.image = image
            changeImageNew = dataNew
        }
        
    }
}



extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
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

//extension DetailViewController {
//    static func assemblyBuilder() -> UIViewController {
//
//    }
//}
