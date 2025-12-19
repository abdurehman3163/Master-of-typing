//
//  LessonCVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 11/12/2025.
//

import Cocoa

class LessonCVC: NSCollectionViewItem {

    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var Box: NSBox!
    @IBOutlet weak var img: NSImageView!
    
    private let separator = NSView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separator.wantsLayer = true
                separator.layer?.backgroundColor = NSColor.stroke.cgColor
                view.addSubview(separator)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
                    separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
                    separator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    separator.heightAnchor.constraint(equalToConstant: 1)
                ])
    }
    
}
