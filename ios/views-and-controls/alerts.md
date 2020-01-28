# Alerts

## Display normal Alerts & Alerts as Action Sheets & Alerts with input

```
//
//  Alerts.swift
//  all-views-ios
//
//  Created by Alex Adam on 28/01/2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class AlertsView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("Display Alert", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.frame = CGRect(x: 100, y: 100, width: 250, height: 30)
        button.addTarget(self, action: #selector(displayAlerts), for: .touchDown)
        
        let button2 = UIButton()
        view.addSubview(button2)
        button2.setTitle("Display Alert as Action Sheet", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.backgroundColor = .white
        button2.frame = CGRect(x: 100, y: 150, width: 250, height: 30)
        button2.addTarget(self, action: #selector(displayAlertsAsActionSheet), for: .touchDown)
        
        let button3 = UIButton()
        view.addSubview(button3)
        button3.setTitle("Display Alert with input", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.backgroundColor = .white
        button3.frame = CGRect(x: 100, y: 200, width: 250, height: 30)
        button3.addTarget(self, action: #selector(displayAlertsInput), for: .touchDown)
        
        
        let close = UIButton()
        view.addSubview(close)
        close.setTitle("close", for: .normal)
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = .white
        close.frame = CGRect(x: 100, y: 400, width: 250, height: 30)
        close.addTarget(self, action: #selector(closeAction), for: .touchDown)
    }
    
    @objc func displayAlerts() {
        let alertController = UIAlertController(title: "Alert", message: "Alert Example Title", preferredStyle: .alert)
                
        let action1 = UIAlertAction(title: "Default", style: .default) { (action:UIAlertAction) in
            print("Default");
        }

        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("Cancel");
        }

        let action3 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            print("Delete");
        }

        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func displayAlertsAsActionSheet() {
        let alertController = UIAlertController(title: "Alert", message: "Alert Example Title", preferredStyle: .actionSheet)
                
        let action1 = UIAlertAction(title: "Default", style: .default) { (action:UIAlertAction) in
            print("Default");
        }

        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("Cancel");
        }

        let action3 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            print("Delete");
        }

        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func displayAlertsInput() {
        let alertController = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                print("input:" + text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Tag"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

```