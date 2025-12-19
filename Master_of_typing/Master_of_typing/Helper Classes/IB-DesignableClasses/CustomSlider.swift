//
//  CustomSlider.swift
//  Ai Flash Generator
//
//  Created by Personal on 24/01/2025.
//

import Cocoa

@IBDesignable
class CustomSliderCell: NSSliderCell {

    @IBInspectable public var activeColor: NSColor = NSColor(named: "6E4EDF") ?? .blue
    @IBInspectable public var inactiveColor: NSColor = NSColor(named: "131219") ?? NSColor.white
    @IBInspectable public var knobColor: NSColor = NSColor(named: "6E4EDF") ?? NSColor.white
    @IBInspectable public var disabeledColor: NSColor = NSColor(named: "FFFFFF") ?? NSColor.gray
    public var isDisabeled: Bool = false
    @IBInspectable public var knobHeight: CGFloat = 20

    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        var rect = aRect
        rect.size.height = CGFloat(3)
        let barRadius = CGFloat(2.5)
        let value = CGFloat((self.doubleValue - self.minValue) / (self.maxValue - self.minValue))
        let finalWidth = value * rect.width
        var leftRect = rect
        leftRect.size.width = finalWidth
        let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
        let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius)
        if isDisabeled {
            disabeledColor.setFill()
            bg.fill()
            disabeledColor.setFill()
            active.fill()
        } else {
            inactiveColor.setFill()
            bg.fill()
            activeColor.setFill()
            active.fill()
        }
    }
    override func drawKnob(_ knobRect: NSRect) {
        let desiredHeight = knobHeight
        let barRect = self.barRect(flipped: false)
        let centeredY = barRect.midY - desiredHeight / 2
        let value = CGFloat((self.doubleValue - self.minValue) / (self.maxValue - self.minValue))
        let knobX = value * (self.controlView!.frame.width - desiredHeight)
        let newKnobRect = NSRect(x: knobX, y: centeredY, width: desiredHeight, height: desiredHeight)
        let knobPath = NSBezierPath(ovalIn: newKnobRect)
        knobColor.setFill()
        knobPath.fill()
    }
    
    override var isHighlighted: Bool {
        didSet {
            // Handle highlight state if needed
        }
    }
    
    internal override func barRect(flipped: Bool) -> NSRect {
        var aRect = self.controlView!.bounds
        aRect.size.height = 3
        aRect.origin.y = (self.controlView!.bounds.height - aRect.height) / 2
        return aRect
    }
}
