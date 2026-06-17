//
//  ShimmerAndZoomBox.swift
//  AudioConverter
//
//  Created by Abdullah Haq  on 10/10/2025.
//
import Foundation
import Cocoa

extension NSBox {
    
    func addCircularShimmerEffect(duration: CFTimeInterval = 2) {
        
        removeShimmerEffect()
        
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        
        let maxDimension = max(self.bounds.width, self.bounds.height)
        let circleSize = maxDimension * 1.5
        
        // Create a shimmer layer
        let shimmerLayer = CALayer()
        shimmerLayer.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        shimmerLayer.backgroundColor = NSColor.white.withAlphaComponent(0.8).cgColor
        shimmerLayer.cornerRadius = circleSize / 2 // Make it circular
        shimmerLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY) // Center the circle
        
        // Add the shimmer layer to the box's layer
        self.layer?.addSublayer(shimmerLayer)
        
        // Create scaling animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0 // Start from the center (scale 0)
        scaleAnimation.toValue = 1.0 // Scale up to fill the circle
        scaleAnimation.duration = duration
        
        // Create opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0 // Start fully visible
        opacityAnimation.toValue = 0.0 // Fade out as it scales up
        opacityAnimation.duration = duration
        
        // Group the animations
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity // Infinite animation
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // Add the animation group to the shimmer layer
        shimmerLayer.add(animationGroup, forKey: "shimmer")
        
        // Register for app state notifications
        NotificationCenter.default.addObserver(
            forName: NSApplication.willBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self, weak shimmerLayer] _ in
            guard let self = self, let shimmerLayer = shimmerLayer else { return }
            // Restart the shimmer animation when the app enters the foreground
            shimmerLayer.removeAnimation(forKey: "shimmer")
            shimmerLayer.add(animationGroup, forKey: "shimmer")
        }
        
        NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self, weak shimmerLayer] _ in
            guard let self = self, let shimmerLayer = shimmerLayer else { return }
            // Remove the shimmer layer when the app goes inactive
            shimmerLayer.removeFromSuperlayer()
            // Re-add the shimmer effect when the app becomes active again
            NotificationCenter.default.addObserver(
                forName: NSApplication.willBecomeActiveNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.addCircularShimmerEffect(duration: duration)
            }
        }
    }
    
    /// Removes the shimmer effect from the box and cleans up observers.
    func removeShimmerEffect() {
        // Remove all shimmer layers with the "shimmer" animation
        self.layer?.sublayers?.forEach {
            if $0.animation(forKey: "shimmer") != nil {
                $0.removeFromSuperlayer()
            }
        }
        // Remove observers to prevent memory leaks
        NotificationCenter.default.removeObserver(self)
    }
    
    func addZoomAnimation(duration: CFTimeInterval = 0.8, scale: CGFloat = 0.97) {
           
        // Ensure the box has a layer
        self.wantsLayer = true
           
        // Create the zoom-out animation
        let zoomOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomOutAnimation.fromValue = 1.0
        zoomOutAnimation.toValue = scale
        zoomOutAnimation.duration = duration
        zoomOutAnimation.autoreverses = true
        zoomOutAnimation.repeatCount = .infinity
        zoomOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
           
        // Apply the zoom-out animation to the box's layer
        self.layer?.add(zoomOutAnimation, forKey: "zoomOut")
           
        // Create the zoom-in animation
        let zoomInAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomInAnimation.fromValue = scale
        zoomInAnimation.toValue = 1.0
        zoomInAnimation.duration = duration
        zoomInAnimation.autoreverses = true
        zoomInAnimation.repeatCount = .infinity
        zoomInAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
           
        // Apply the zoom-in animation to the box's layer
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.layer?.add(zoomInAnimation, forKey: "zoomIn")
        }
    }
    
    /// Removes the zoom animation from the box.
    func removeZoomAnimation() {
        self.layer?.removeAnimation(forKey: "zoomOut")
        self.layer?.removeAnimation(forKey: "zoomIn")
    }
}
