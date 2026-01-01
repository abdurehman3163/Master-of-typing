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
    private var separatorHeightConstraint: NSLayoutConstraint?
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var separatorTrailingConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSeparator()
    }
    
    private func setupSeparator() {
        separator.wantsLayer = true
        separator.layer?.backgroundColor = NSColor.stroke.cgColor  // default color
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let height = separator.heightAnchor.constraint(equalToConstant: 1)
        let leading = separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        let trailing = separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        
        self.separatorHeightConstraint = height
        self.separatorLeadingConstraint = leading
        self.separatorTrailingConstraint = trailing
        NSLayoutConstraint.activate([
            leading,
            trailing,
            separator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            height        ])
    }
    
    /// Public function to set separator color from outside
    func configureSeparator(
        color: NSColor = .stroke,
        thickness: CGFloat = 1.0,
        leadingInset: CGFloat = 12.0,
        trailingInset: CGFloat = 12.0
    ) {
        separator.layer?.backgroundColor = color.cgColor
        separatorHeightConstraint?.constant = thickness
        separatorLeadingConstraint?.constant = leadingInset
        separatorTrailingConstraint?.constant = -trailingInset  // negative for trailing
    }
}
