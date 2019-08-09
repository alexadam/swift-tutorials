//
//  MainWindowController.swift
//  views-test
//
//  Created by Alex Adam on 09/08/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    let windowDelegate = MainWindowDelegate()
    let splitViewDelegate = TestSplitViewDelegate()
    
    convenience init() {
        self.init(window: NSWindow())
        window?.setContentSize(NSSize(width: 800, height: 600))
        window?.level = .normal
        window?.title = "Test window"
        
        window?.center()
        window?.isMovableByWindowBackground = true
        window?.styleMask = [.closable, .resizable, .titled]
        
        window?.makeKeyAndOrderFront(window)
        
        window?.delegate = windowDelegate
        
        createLayout()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        createLayout()
    }
    
    func createLayout() {
        
        /// split view
        let splitView = NSSplitView(frame: (window?.contentView!.frame)!)
        splitView.dividerStyle = .thin
        splitView.delegate = splitViewDelegate
        
        let textv1 = NSTextView()
        textv1.string = "panel 1"
        textv1.translatesAutoresizingMaskIntoConstraints = false
        textv1.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        let textv2 = NSTextView()
        //        textv2.isHidden = true
        textv2.translatesAutoresizingMaskIntoConstraints = false
        textv2.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        textv2.string = "panel 2"
        
        let textv3 = NSTextView()
        textv3.string = "panel 3"
        textv3.translatesAutoresizingMaskIntoConstraints = false
        textv3.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        splitView.addArrangedSubview(textv1)
        splitView.addArrangedSubview(textv2)
        splitView.addArrangedSubview(textv3)
        splitView.adjustSubviews()
        window?.contentView?.addSubview(splitView)
    }
}

class MainWindowDelegate: NSObject, NSWindowDelegate {
    private func windowWillClose(notification: NSNotification) {
//        NSApplication.shared.terminate(0)
    }
}


class TestSplitViewDelegate: NSObject, NSSplitViewDelegate {
    //    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
    //        return false
    //    }
}
