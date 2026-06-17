//
//  ButtonBox.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 12/12/2025.
//

import Cocoa

class ButtonBox: NSBox {
    
    @IBOutlet weak var button: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        // Assume you have an opaque fillColor set in IB or code, e.g.:
        // self.fillColor = NSColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)  // Your normal color
    }
    
    func enable() {
        
        self.layer?.opacity = 1.0
    }
    
    func disable() {
        self.layer?.opacity = 0.3
    }
    
    func highlight(_ pressed: Bool, isAllowed: Bool) {
        if pressed {
            // On press: always full alpha (pulse feedback for any key)
            self.layer?.opacity = 1.0
            // Optional: add scale animation for nice feel
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.1
                self.animator().layer?.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            }
        } else {
            // On release:
            if isAllowed {
                // Allowed keys stay bright
                self.layer?.opacity = 1.0
                self.layer?.transform = CATransform3DIdentity
            } else {
                // Non-allowed keys go back to dim
                self.layer?.opacity = 0.3
                self.layer?.transform = CATransform3DIdentity
            }
        }
    }
    

}
