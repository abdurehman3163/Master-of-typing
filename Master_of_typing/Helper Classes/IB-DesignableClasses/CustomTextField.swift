//
//  CustomTextField.swift
//  Ai Flash Generator
//
//  Created by Personal on 10/01/2025.
//


import Cocoa

@IBDesignable
class CustomTextField: NSTextField {

    @IBInspectable var isBezeledField: Bool = true {
        didSet {
            wantsLayer = true
            self.isBezeled = isBezeledField
        }
    }
    
    @IBInspectable var isFocusRing: Bool = true {
        didSet {
            wantsLayer = true
            self.focusRingType = .none
        }
    }

    @IBInspectable var isBorderedField: Bool = true {
        didSet {
            wantsLayer = true
            self.isBordered = isBorderedField
        }
    }

    @IBInspectable var drawsBackgroundField: Bool = true {
        didSet {
            wantsLayer = true
            self.drawsBackground = drawsBackgroundField
        }
    }

    @IBInspectable var placeholderTextColor: NSColor? {
        didSet {
            guard let placeholderStr = placeholderString, let color = placeholderTextColor else { return }
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: color,
                .font: NSFont.systemFont(ofSize: NSFont.systemFontSize)
            ]
            let attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: attrs)
            (self.cell as? NSTextFieldCell)?.placeholderAttributedString = attributedPlaceholder
        }
    }
}
