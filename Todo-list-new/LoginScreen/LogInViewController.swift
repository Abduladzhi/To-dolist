//
//  LogInViewController.swift
//  Todo-list-new
//
//  Created by Abduladzhi on 27.04.2022.
//

import UIKit


class LogInViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    
    let login = "1234"
    let password = "1234"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        let controller = UINavigationController(rootViewController: ViewController.assemblyBuilder())
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        
//        if loginTF.text == login && passwordTF.text == password {
//            let controller = UINavigationController(rootViewController: (storyboard?.instantiateViewController(withIdentifier: "ViewController")) as! ViewController)
//            controller.modalPresentationStyle = .fullScreen
//            self.present(controller, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Ошибка", message: "Неверные данные, попробуйте ещё раз", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default))
//            self.present(alert, animated: true)
//        }
    }
}
