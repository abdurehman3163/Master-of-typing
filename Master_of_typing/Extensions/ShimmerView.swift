//
//  ShimmerView.swift
//  DownTik
//
//  Created by Macbook Pro on 26/06/2025.
//

import Foundation
import Cocoa

class ShimmerView: NSView {

    private let gradientLayer = CAGradientLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupShimmer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }

    private func setupShimmer() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor // Transparent background

        // Configure the shimmer gradient
        gradientLayer.colors = [
            NSColor.white.withAlphaComponent(0.01),
            NSColor.white.withAlphaComponent(0.3).cgColor,
            NSColor.white.withAlphaComponent(0.01)
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = .init(x: 0, y: 0, width: 10, height: bounds.size.height)
        layer?.addSublayer(gradientLayer)

        // Animate the shimmer
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 2
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmer")
    }

    override func layout() {
        super.layout()
        gradientLayer.frame = bounds
    }

    override var isOpaque: Bool {
        return false
    }
}
