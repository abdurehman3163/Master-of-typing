//
//  setSliderColors.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 22/12/2025.
//

import Cocoa

/// Applies custom colors to an NSSlider using CIFalseColor filter.
///
/// - Parameters:
///   - slider:        The NSSlider you want to recolor
///   - trackColor:    Color for the filled part of the track (the "progress" side)
///   - backgroundColor: Color for the unfilled part of the track
///   - knobColor:     Optional – if provided, a second filter will recolor the knob
func setSliderColors(
    for slider: NSSlider,
    trackColor: NSColor,
    backgroundColor: NSColor,
    knobColor: NSColor? = nil
) {
    // Remove any existing filters first (so we don’t stack them)
    slider.contentFilters = []
    
    // 1. Recolor the track (filled + unfilled parts)
    guard let trackCIColor0 = CIColor(color: trackColor),
          let trackCIColor1 = CIColor(color: backgroundColor) else {
        return
    }
    
    let trackFilter = CIFilter(name: "CIFalseColor")!
    trackFilter.setValue(trackCIColor0, forKey: "inputColor0")   // filled part
    trackFilter.setValue(trackCIColor1, forKey: "inputColor1")   // unfilled part
    
    // 2. Optional: recolor the knob/thumb
    if let knobColor = knobColor,
       let knobCIColor = CIColor(color: knobColor) {
        
        let knobFilter = CIFilter(name: "CIFalseColor")!
        // The knob is usually white/bright → map white → desired color, dark → same
        knobFilter.setValue(knobCIColor, forKey: "inputColor0")  // bright parts → knobColor
        knobFilter.setValue(knobCIColor, forKey: "inputColor1")  // shadow stays same color
        slider.contentFilters = [trackFilter, knobFilter]
    } else {
        slider.contentFilters = [trackFilter]
    }
    
    // Force redraw
    slider.needsDisplay = true
}
