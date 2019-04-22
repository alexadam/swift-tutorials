//
//  ViewController.swift
//  Basic-Layout
//
//  Created by Alex Adam on 22/04/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    
        createContainers(parentView: view)
    }

    func createContainers(parentView: UIView) {
        let topContainer = UIView()
        parentView.addSubview(topContainer)
        topContainer.backgroundColor = .green
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: topContainer, attribute: .leading, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: topContainer, attribute: .trailing, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            ])
        
        
        let bottomContainer = UIView()
        parentView.addSubview(bottomContainer)
        bottomContainer.backgroundColor = .green
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let scrollContainer = UIScrollView()
        parentView.addSubview(scrollContainer)
        scrollContainer.backgroundColor = .yellow
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: scrollContainer, attribute: .leading, relatedBy: .equal, toItem: parentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: scrollContainer, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: scrollContainer, attribute: .top, relatedBy: .equal, toItem: topContainer, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: scrollContainer, attribute: .bottom, relatedBy: .equal, toItem: bottomContainer, attribute: .top, multiplier: 1, constant: -10)
            ])
        
    
        let stackContainer = UIStackView()
        scrollContainer.addSubview(stackContainer)
        stackContainer.backgroundColor = .black
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .vertical
        stackContainer.alignment = .leading
        stackContainer.distribution = .fillProportionally
        stackContainer.spacing = 12
        stackContainer.isLayoutMarginsRelativeArrangement = true
        stackContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: scrollContainer, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackContainer, attribute: .trailing, relatedBy: .equal, toItem: scrollContainer, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackContainer, attribute: .top, relatedBy: .equal, toItem: scrollContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackContainer, attribute: .bottom, relatedBy: .equal, toItem: scrollContainer, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        for i in 0...25 {
            let tmpView = UIView()
            stackContainer.addArrangedSubview(tmpView)
            tmpView.backgroundColor = .gray
            tmpView.translatesAutoresizingMaskIntoConstraints = false
            
            tmpView.heightAnchor.constraint(equalToConstant: CGFloat(50 + Int.random(in: 0..<120))).isActive = true
            tmpView.widthAnchor.constraint(equalToConstant: 370).isActive = true
            
            let label = UILabel()
            label.backgroundColor = .orange
            label.text = "Label \(i)"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            tmpView.addSubview(label)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: tmpView, attribute: .leading, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: tmpView, attribute: .trailing, multiplier: 1, constant: -10),
                NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: tmpView, attribute: .top, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                ])
        }
    }


}

