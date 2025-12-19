//
//  FourGradientColorView.swift
//  Ai Flash Generator
//
//  Created by Personal on 19/01/2025.
//


import AppKit

@IBDesignable
class FourGradientColorView: NSView {

    // MARK: - IBInspectable properties for colors and locations

    @IBInspectable var startColor: NSColor = NSColor.clear {
        didSet { updateGradient() }
    }

    @IBInspectable var secondColor: NSColor = NSColor.clear {
        didSet { updateGradient() }
    }

    @IBInspectable var thirdColor: NSColor = NSColor.clear {
        didSet { updateGradient() }
    }

    @IBInspectable var endColor: NSColor = NSColor.clear {
        didSet { updateGradient() }
    }

    @IBInspectable var startLocation: CGFloat = 0.0 {
        didSet { updateGradient() }
    }

    @IBInspectable var secondLocation: CGFloat = 0.33 {
        didSet { updateGradient() }
    }

    @IBInspectable var thirdLocation: CGFloat = 0.70 {
        didSet { updateGradient() }
    }

    @IBInspectable var endLocation: CGFloat = 1.0 {
        didSet { updateGradient() }
    }

    // MARK: - Gradient direction
    @IBInspectable var startPointX: CGFloat = 0.0 {
        didSet { updateGradient() }
    }

    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet { updateGradient() }
    }

    @IBInspectable var endPointX: CGFloat = 1.0 {
        didSet { updateGradient() }
    }

    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet { updateGradient() }
    }

    // MARK: - Gradient Layer
    private var gradientLayer: CAGradientLayer!

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }

    override func layout() {
        super.layout()
        gradientLayer.frame = self.bounds
    }

    // MARK: - Setup and Update Gradient Layer
    private func setupGradientLayer() {
        wantsLayer = true
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        self.layer?.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }

    private func updateGradient() {
        gradientLayer.colors = [
            startColor.cgColor,
            secondColor.cgColor,
            thirdColor.cgColor,
            endColor.cgColor
        ].compactMap { $0 }
        gradientLayer.locations = [
            NSNumber(value: Float(startLocation)),
            NSNumber(value: Float(secondLocation)),
            NSNumber(value: Float(thirdLocation)),
            NSNumber(value: Float(endLocation))
        ]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
}
