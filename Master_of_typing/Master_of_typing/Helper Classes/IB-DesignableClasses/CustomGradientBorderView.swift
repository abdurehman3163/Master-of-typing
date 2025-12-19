//
//  CustomViewForScrollView.swift
//  Ai Flash Generator
//
//  Created by Personal on 11/01/2025.
//


import Foundation
import AppKit

@IBDesignable
class DashPatterenBorderView: NSView {
    
    // MARK: - Inspectable Properties
    @IBInspectable var cornerRadiusFor: CGFloat = 0 {
        didSet {
            wantsLayer = true
            layer?.cornerRadius = cornerRadiusFor
            gradientLayer.cornerRadius = cornerRadiusFor
        }
    }
    
    @IBInspectable var borderWidthFor: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var dashPattern: CGFloat = 6.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var dashSpacing: CGFloat = 4.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var startColor: NSColor = .clear {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: NSColor = .clear {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet {
            updateGradient()
        }
    }
    
    // MARK: - Layers
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    // MARK: - Initialization
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layout() {
        super.layout()
        updateGradient()
        updateBorder()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        wantsLayer = true
        guard let layer = self.layer else { return }
        layer.masksToBounds = true
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
    
    private func updateGradient() {
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    private func updateBorder() {
        let path = CGPath(roundedRect: bounds, cornerWidth: cornerRadiusFor, cornerHeight: cornerRadiusFor, transform: nil)
        
        shapeLayer.path = path
        shapeLayer.lineWidth = borderWidthFor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.lineDashPattern = [NSNumber(value: Float(dashPattern)), NSNumber(value: Float(dashSpacing))]
        shapeLayer.frame = bounds
    }
}
