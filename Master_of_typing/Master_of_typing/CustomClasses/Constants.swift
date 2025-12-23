//
//  ButtonBox.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 12/12/2025.
//

import Foundation
import AppKit

let ud = UserDefaults.standard

func setProgressIndicatorColors(for progressBar: NSProgressIndicator, progressColor: NSColor, backgroundColor: NSColor) {
    // Convert the colors to CIColor
    guard let progressCIColor = CIColor(color: progressColor),
          let backgroundCIColor = CIColor(color: backgroundColor) else { return }
    
    // Create the CIFilter for the progress bar
    let filter = CIFilter(name: "CIFalseColor")!
    filter.setValue(progressCIColor, forKey: "inputColor0")  // Foreground color (progress)
    filter.setValue(backgroundCIColor, forKey: "inputColor1")  // Background color
    
    // Apply the filter to the progress bar
    progressBar.contentFilters = [filter]
}
