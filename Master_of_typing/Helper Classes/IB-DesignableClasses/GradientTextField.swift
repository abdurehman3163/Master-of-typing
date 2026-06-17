//
//  GradientTextField.swift
//  Ai Flash Generator
//
//  Created by Personal on 10/01/2025.
//


import Cocoa

@IBDesignable
class GradientTextField: NSTextField {

    // MARK: - Inspectable Properties
    @IBInspectable var startColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    
    @IBInspectable var endColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet { updateGradient() }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateGradient()
    }
    
    override func layout() {
        super.layout()
        updateGradient()
    }
    
    private func updateGradient() {
        gradientLayer.removeFromSuperlayer()
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = isHorizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
        gradientLayer.frame = bounds
        
        // Create a mask using the text field's text
        let textMask = createTextMask()
        gradientLayer.mask = textMask
        layer?.addSublayer(gradientLayer)
    }
    
    private func createTextMask() -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = stringValue
        textLayer.font = font
        textLayer.fontSize = font?.pointSize ?? 0
        textLayer.frame = bounds
        textLayer.foregroundColor = NSColor.black.cgColor
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1
        textLayer.alignmentMode = .center
        return textLayer
    }
}
