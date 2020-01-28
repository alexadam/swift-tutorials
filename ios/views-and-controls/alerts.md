# Alerts

## Display normal Alerts and Alerts as Action Sheets

```
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
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

```