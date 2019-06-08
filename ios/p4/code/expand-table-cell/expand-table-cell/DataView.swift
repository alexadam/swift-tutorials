//
//  TimePatternView.swift
//  take-a-break
//
//  Created by Alex Adam on 05/06/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class DataView: UIStackView {
    var tableUpdateDelegate: TableUpdateDelegate?
    
    var isExpanded: Bool = false
    var expandButton: UIButton!
    var dataModel: DataModel? = nil
    var collapsedView: UIView!
    var expandedView: UIView!
    var label: UILabel!
    var label2: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, patternData: DataModel, patternsViewUpdateDelegate: TableUpdateDelegate) {
        super.init(frame: frame)
        self.dataModel = patternData
        self.tableUpdateDelegate = patternsViewUpdateDelegate
        createLayout()
    }
    
    func setPatternData(patternData: DataModel) {
        self.dataModel = patternData
        label.text = self.dataModel?.title
        label2.text = self.dataModel?.description
    }
    
    func createLayout() {
        
        self.backgroundColor = .black
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill // .fillProportionally
        self.spacing = 0
        
        
        // MARK: - collapsed view
        
        collapsedView = UIView()
        collapsedView.backgroundColor = .green
        
        collapsedView.translatesAutoresizingMaskIntoConstraints = false
         // subtract top padding (5 units) from total cell height (50 units)
        collapsedView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addArrangedSubview(collapsedView)
        
        
        expandButton = UIButton()
        collapsedView.addSubview(expandButton)
        expandButton.setTitle("\\/", for: UIControl.State.normal)
        expandButton.backgroundColor = .blue
        
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.topAnchor.constraint(equalTo: collapsedView.topAnchor, constant: 0).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        expandButton.leadingAnchor.constraint(equalTo: collapsedView.leadingAnchor, constant: 0).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        expandButton.addTarget(self, action: #selector(onExpand), for: UIControl.Event.touchUpInside)
        
        
        
        label = UILabel(frame: .zero)
        collapsedView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: expandButton.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: collapsedView.topAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30)
        
        label.textAlignment = .left
        label.font = UIFont(name: label.font.fontName, size: 15)
        label.text = self.dataModel?.title
        
        ///
        // MARK: - exapanded view
        ///
        
        expandedView = UIView()
        expandedView.isHidden = !self.isExpanded
        expandedView.backgroundColor = .gray
        
        expandedView.translatesAutoresizingMaskIntoConstraints = false
        expandedView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        addArrangedSubview(expandedView)
        
        
        label2 = UILabel(frame: .zero)
        expandedView.addSubview(label2)
        
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.leadingAnchor.constraint(equalTo: expandedView.leadingAnchor, constant: 10).isActive = true
        label2.topAnchor.constraint(equalTo: expandedView.topAnchor, constant: 0).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 30)
        
        label2.textAlignment = .left
        label2.font = UIFont(name: label.font.fontName, size: 15)
        label2.text = self.dataModel?.description
        
    }
    
    @objc func onExpand(_ sender: UIButton) {
        self.isExpanded = !self.isExpanded
        if !self.isExpanded {
            self.expandButton.setTitle("\\/", for: UIControl.State.normal)
        } else {
            self.expandButton.setTitle("/\\", for: UIControl.State.normal)
        }
        self.dataModel?.isExpanded = self.isExpanded
        
        // useful for animation - order matters
        // FIXME - add ref to expandedView to show/hide it after the animation ends
        if self.isExpanded == true {
            self.expandedView.isHidden = !self.isExpanded
            self.tableUpdateDelegate?.toggleCollapseExpand()
        } else {
            self.tableUpdateDelegate?.toggleCollapseExpand()
            self.expandedView.isHidden = !self.isExpanded
        }
        
    }
    
}
