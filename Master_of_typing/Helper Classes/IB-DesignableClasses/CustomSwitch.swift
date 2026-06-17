//
//  CustomSwitch.swift
//  Ai Flash Generator
//
//  Created by Personal on 28/12/2024.
//


import Cocoa

@IBDesignable
class CustomSwitch: NSSwitch {
    
    // MARK: - Persisted Properties
    private var savedOnTintColor: NSColor?
    private var savedOffTintColor: NSColor?
    private var savedThumbColor: NSColor?
    
    // MARK: - Inspectable Properties
    @IBInspectable var onTintColor: NSColor = .systemGreen {
        didSet {
            savedOnTintColor = onTintColor
            updateColors()
        }
    }
    
    @IBInspectable var offTintColor: NSColor = .systemGray {
        didSet {
            savedOffTintColor = offTintColor
            updateColors()
        }
    }
    
    @IBInspectable var thumbColor: NSColor = .white {
        didSet {
            savedThumbColor = thumbColor
            updateColors()
        }
    }
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        wantsLayer = true
        
        // Ensure saved colors persist across different screens or view reloads
        savedOnTintColor = onTintColor
        savedOffTintColor = offTintColor
        savedThumbColor = thumbColor
        updateColors()
    }
    
    // MARK: - Observe State Changes
    override var state: NSControl.StateValue {
        didSet {
            updateColors()
        }
    }
    
    // MARK: - Lifecycle Method Overrides
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        updateColors()
    }
    
    override func viewWillMove(toSuperview newSuperview: NSView?) {
        super.viewWillMove(toSuperview: newSuperview)
        updateColors()
    }
    
    // MARK: - Update Colors
    private func updateColors() {
        guard let layer = layer else { return }
        
        // Use saved properties to ensure persistent colors
        let currentOnTintColor = savedOnTintColor ?? .systemGreen
        let currentOffTintColor = savedOffTintColor ?? .systemGray
        let currentThumbColor = savedThumbColor ?? .white
        
        // Update the background color based on the state
        layer.backgroundColor = (state == .on ? currentOnTintColor : currentOffTintColor).cgColor
        layer.cornerRadius = frame.height / 2
        
        // Configure the thumb layer
        let thumbSize = CGSize(width: frame.height - 6, height: frame.height - 6)
        let thumbLayer = CALayer()
        thumbLayer.backgroundColor = currentThumbColor.cgColor
        thumbLayer.cornerRadius = thumbSize.height / 2
        
        // Calculate thumb position based on state
        let thumbX = state == .on ? frame.width - thumbSize.width - 3 : 3
        thumbLayer.frame = CGRect(x: thumbX, y: 3, width: thumbSize.width, height: thumbSize.height)
        
        // Clear existing sublayers and add the thumb layer
        layer.sublayers?.removeAll()
        layer.addSublayer(thumbLayer)
    }
}
