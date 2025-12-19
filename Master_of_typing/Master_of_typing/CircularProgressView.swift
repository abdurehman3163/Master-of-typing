import Cocoa

class CircularProgressView: NSView {
    var progress: Double = 0.6 {
        didSet {
            needsDisplay = true
        }
    }
    
    var isSpeed: Bool = true {  // New boolean variable to toggle speed text visibility
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard !dirtyRect.isEmpty else { return }  // Avoid drawing if bounds are invalid
        
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 * 0.8
        let lineWidth: CGFloat = 10.0
        
        // Background circle
        let backgroundPath = NSBezierPath()
        backgroundPath.appendArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 360)
        NSColor.white.setStroke()  // Ensure this color is available
        backgroundPath.lineWidth = lineWidth
        backgroundPath.stroke()
        
        // Progress circle
        let progressPath = NSBezierPath()
        let endAngle = 360 * progress - 90
        progressPath.appendArc(withCenter: center, radius: radius, startAngle: -90, endAngle: endAngle)
        NSColor.blue.setStroke()  // Ensure this color is available
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = .round
        progressPath.stroke()
        
        // Declare percentageText outside the if conditions
        var percentageText: String
        var cpmText: String
        var speedText: String
        
        // Assign the text based on isSpeed condition
        if isSpeed {
            percentageText = String(format: "%.0f", progress * 100) // Display without percentage symbol for speed
            cpmText = "CPM" //
            speedText = "Current Speed"
        } else {
            percentageText = String(format: "%.0f%%", progress * 100) // Display with percentage symbol for normal progress
            cpmText = "Accuracy" //
            speedText = "Accuracy Rate"
        }
        

        // Set up attributes for the text with different font sizes for each text
        let percentageTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 30), // Percentage text size
            .foregroundColor: NSColor.black
        ]
        
        let cpmTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16, weight: .semibold), // CPM text size
            .foregroundColor: NSColor.black
        ]
        
        let speedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .semibold), // Speed text size
            .foregroundColor: NSColor.black
        ]
        
        // Calculate sizes for each text
        let percentageTextSize = percentageText.size(withAttributes: percentageTextAttributes)
        let cpmTextSize = cpmText.size(withAttributes: cpmTextAttributes)
        let speedTextSize = speedText.size(withAttributes: speedTextAttributes)

        // Calculate the Y positions to space the texts vertically
        let totalHeight = percentageTextSize.height + cpmTextSize.height + speedTextSize.height + 10 // 10 is the space between text lines
        let percentageY = center.y + totalHeight / 2 - percentageTextSize.height / 2 - 10 // Add extra padding for percentage
        let cpmY = percentageY - percentageTextSize.height - 5 // 5 is the spacing between percentage and cpm
        let speedY = cpmY - cpmTextSize.height - 5 // 5 is the spacing between cpm and speed

        // Calculate the X position (centered horizontally)
        let textX = center.x - max(percentageTextSize.width, cpmTextSize.width, speedTextSize.width) / 2
        
        // Draw the text
        percentageText.draw(at: NSPoint(x: textX, y: percentageY), withAttributes: percentageTextAttributes)
        cpmText.draw(at: NSPoint(x: textX, y: cpmY), withAttributes: cpmTextAttributes)
        speedText.draw(at: NSPoint(x: textX, y: speedY), withAttributes: speedTextAttributes)
    }
}
