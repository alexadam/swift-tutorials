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
