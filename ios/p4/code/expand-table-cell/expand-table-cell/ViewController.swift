//
//  ViewController.swift
//  expand-table-cell
//
//  Created by Alex Adam on 07/06/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        createLayout()
    }
    
    func createLayout() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        tableView.register(TableCellView.self, forCellReuseIdentifier: "TableCellView")
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension ViewController: TableUpdateDelegate {
    func toggleCollapseExpand() {
        
        // add a reference to the animated view to show/hide it after/before the animation ends
        UIView.animate(withDuration: 0.2) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
//        self.tableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = DataStore.shared.data[indexPath.row]
        if (data.isExpanded) {
            return 350
        }
        return 50
        //        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellView", for: indexPath) as! TableCellView
        cell.contentView.isUserInteractionEnabled = true
        cell.dataIndex = indexPath.row
        cell.selectionStyle = .none
        cell.updateTimePatternsViewDelegate = self
        
        return cell
    }
    
    
}

class TableCellView: UITableViewCell {
    
    var label: UILabel!
    var patternView: DataView!
    var dataIndex: Int = -1 {
        didSet {
            self.data = DataStore.shared.data[self.dataIndex]
        }
    }
    var data: DataModel? = nil {
        didSet {
            patternView.setPatternData(patternData: self.data!)
        }
    }
    var updateTimePatternsViewDelegate: TableUpdateDelegate? = nil {
        didSet {
            patternView.tableUpdateDelegate = self.updateTimePatternsViewDelegate
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        
        patternView = DataView()
        contentView.addSubview(patternView)
        
        patternView.translatesAutoresizingMaskIntoConstraints = false
        patternView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        patternView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        patternView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        patternView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true        
    }
    
}

