# Misc

## Change View / ViewController

```
let svc = SecondViewController()

// optional
svc.modalPresentationStyle = .overCurrentContext

self.parentViewController.present(svc, animated: true, completion: nil)
// OR
self.present(ViewController(), animated: true, completion: nil)
```

## Swipe action on table cell

```
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let TrashAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        TrashAction.backgroundColor = .red

        // Write action code for the Flag
        let FlagAction = UIContextualAction(style: .normal, title:  "Flag", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        FlagAction.backgroundColor = .orange

        // Write action code for the More
        let MoreAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        MoreAction.backgroundColor = .gray


        return UISwipeActionsConfiguration(actions: [TrashAction, FlagAction, MoreAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->                UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }

        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])


        ////// !!!
        swipeActionConfig.performsFirstActionWithFullSwipe = false

        return swipeActionConfig

    }

    /// ??
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

```

## Get size of text based on font's type & size

```
    let word = "word"
    let font = UIFont(name: "Helvetica", size: 30)
    let size = word.size(withAttributes:[.font: font])
    // size.width, size.height

    // OR
    let size = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:18.0)])

```

## Add Borders to Text Label

```
    /* src https://gist.github.com/MrJackdaw/6ffbc33fc274838412bfe3ad48592b9b
    switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
    }
    /*


    var label: UILabel!

    let border = CALayer()
    border.backgroundColor = UIColor.blue.cgColor
    border.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.maxY, width: contentView.frame.width, height: 3)
    label.layer.addSublayer(border)
```
