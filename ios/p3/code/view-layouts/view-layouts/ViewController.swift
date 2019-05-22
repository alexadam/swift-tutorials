//
//  ViewController.swift
//  view-layouts
//
//  Created by Alex Adam on 20/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let collectionViewDelegateAndDataSource = CollectionViewDelegateAndDataSource()
    let tableViewDelegateAndDataSource = TableViewDelegateAndDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        addViews(parentView: view)
    }
    
    func addViews(parentView: UIView) {
        let topContainer = UIView()
        parentView.addSubview(topContainer)
        topContainer.backgroundColor = .green
        topContainer.translatesAutoresizingMaskIntoConstraints = false

        // the Top Container is positioned relative to the main view
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: topContainer, attribute: .leading, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: topContainer, attribute: .trailing, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            ])

        let titleLabel = UITextView()
        topContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "View Layouts"
        titleLabel.isEditable = false
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size: 20)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: topContainer, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: topContainer, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: -10),
            ])
        
        //////
        /// source https://github.com/Dougly/ViewsProgrammatically
        //////
        
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        let collectionView = UICollectionView(frame: parentView.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        parentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10).isActive = true
        //        numbersCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "ContainerCell")
        collectionView.delegate = collectionViewDelegateAndDataSource
        collectionView.dataSource = collectionViewDelegateAndDataSource
        
        //////
        //////

        let tableView = UITableView(frame: parentView.frame)
        parentView.addSubview(tableView)
        tableView.backgroundColor = .green

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView.delegate = tableViewDelegateAndDataSource
        tableView.dataSource = tableViewDelegateAndDataSource
         
    }

}


class CollectionViewDelegateAndDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let numbers: [Int]
    var tableViewRef: UITableView? = nil
    
    override init() {
        var nums: [Int] = []
        for i in 0...200 {
            nums.append(i)
        }
        self.numbers = nums
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCell", for: indexPath) as! CollectionViewCell
        cell.label.text = "a" + String(numbers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(String(numbers[indexPath.row]))
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        label = UILabel(frame: contentView.frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 12)
        self.contentView.backgroundColor = .white
    }
}


////

class TableViewDelegateAndDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let numbers: [Int]
    
    override init() {
        var nums: [Int] = []
        for i in 0...200 {
            nums.append(i)
        }
        self.numbers = nums
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        cell.label?.text = "task " + String(self.numbers[indexPath.row])
        return cell
    }
    
}


class TableViewCell: UITableViewCell {
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        label = UILabel(frame: contentView.frame)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 15)
        self.contentView.backgroundColor = .lightGray
    }
}
