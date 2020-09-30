//
//  ViewController.swift
//  SocialApp
//
//  Created by Дима Давыдов on 26.09.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonOnTouchUpInside(_ sender: UIButton) {
    }
    
//    @objc func keyboardWasShown(notification: Notification) {
//        let userInfo = notification.userInfo! as NSDictionary
//        let keyboardSize = (userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
//
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
//
//        self.scrollView?.contentInset = contentInsets
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown() {
        print("keyboardWasShown")
    }
    
    @objc func keyboardWillBeHidden() {
        print("keyboardWillBeHidden")
    }
    
}

