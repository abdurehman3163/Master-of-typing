//
//  ButtonBox.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 12/12/2025.
//

import Cocoa

class ButtonBox: NSBox {
    
    @IBOutlet weak var button: NSButton!
    
    
    func enable() {
        alphaValue = 1
        button.isEnabled = true
    }
    
    func disable() {
        alphaValue = 0.3
        button.isEnabled = false
    }
    
    func highlight(_ pressed: Bool, isAllowed: Bool) {
        if pressed {
            // Save original fill color on first press            
            // Highlight appearance
            alphaValue = 0.7
            wantsLayer = true
            layer?.cornerRadius = 8
            layer?.borderWidth = 2
            layer?.borderColor = NSColor.systemBlue.cgColor
        } else {
            // Key released → restore original fill, and correct alpha based on allowed state
            alphaValue = isAllowed ? 1.0 : 0.3
            layer?.borderWidth = 0
        }
    }
}
