//
//  GradientButton.swift
//  Ai Flash Generator
//
//  Created by Personal on 29/12/2024.
//

import AppKit
import Cocoa

@IBDesignable
class GradientButton: NSButton {

    // Gradient Colors
    @IBInspectable var startColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    @IBInspectable var endColor: NSColor = .clear {
        didSet { updateGradient() }
    }

    // Gradient Direction
    @IBInspectable var startPointX: CGFloat = 0.5 {
        didSet { updateGradient() }
    }
    @IBInspectable var startPointY: CGFloat = 0.0 {
        didSet { updateGradient() }
    }
    @IBInspectable var endPointX: CGFloat = 0.5 {
        didSet { updateGradient() }
    }
    @IBInspectable var endPointY: CGFloat = 1.0 {
        didSet { updateGradient() }
    }

    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        setupGradient()
    }

    override func layout() {
        super.layout()
        gradientLayer?.frame = bounds
    }

    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        layer?.addSublayer(gradientLayer!)
        updateGradient()
    }

    private func updateGradient() {
        gradientLayer?.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer?.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer?.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
}
