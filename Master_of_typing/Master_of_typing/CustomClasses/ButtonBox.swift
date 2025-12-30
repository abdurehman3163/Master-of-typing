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
    }
    
    func disable() {
        alphaValue = 0.3
    }
    
    func highlight(_ pressed: Bool, isAllowed: Bool) {
        if pressed {
            // On press: always full alpha (pulse feedback for any key)
            self.alphaValue = 1.0
            
            // Optional: add scale animation for nice feel
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.1
                self.animator().layer?.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            }
        } else {
            // On release:
            if isAllowed {
                // Allowed keys stay bright
                self.alphaValue = 1.0
                self.layer?.transform = CATransform3DIdentity
            } else {
                // Non-allowed keys go back to dim
                self.alphaValue = 0.3
                self.layer?.transform = CATransform3DIdentity
            }
        }
    }
    

}
