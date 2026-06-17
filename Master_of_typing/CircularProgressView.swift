import Cocoa

class CircularProgressView: NSView {
    
    var lowThreshold: Double = 0.4   // Below 40% → red
    var mediumThreshold: Double = 0.7 // 40–70% → yellow
    var highThreshold: Double = 1.0   // 70%+ → green

    var lowColor: NSColor = .systemRed
    var mediumColor: NSColor = .systemYellow
    var highColor: NSColor = .systemGreen
    
    var progress: Double = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            
            // Change color based on current progress
            let newColor: NSColor
            if progress < lowThreshold {
                newColor = lowColor
            } else if progress < mediumThreshold {
                newColor = mediumColor
            } else {
                newColor = highColor
            }
            
            progressColor = newColor  // This triggers updateProgressLayer()
            
            updateProgressLayer()
        }
    }
    
    var subText: String = "" {
        didSet {
            // Update the sub-text layer when the property changes
            subTextLayer.string = subText
        }
    }

    // Configurable appearance
    var trackColor: NSColor = NSColor.whiteColor2
    var progressColor: NSColor = NSColor.appMain
    var textColor: NSColor = NSColor.black
    var lineWidth: CGFloat = 20.0
    var fontSize: CGFloat = 18.0
    
    // Private layers for performance
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let textLayer = CATextLayer()
    private let subTextLayer = CATextLayer()

    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        wantsLayer = true
        layer?.backgroundColor = nil // Transparent
        
        // Track layer (background ring)
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = nil
        trackLayer.lineCap = .round
        layer?.addSublayer(trackLayer)
        
        // Progress layer
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = nil
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0 // Start empty
        layer?.addSublayer(progressLayer)
        
        // Text layer
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1.0
        textLayer.font = CTFontCreateWithName("Helvetica-Bold" as CFString, fontSize, nil)
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = textColor.cgColor
        layer?.addSublayer(textLayer)
        
        subTextLayer.alignmentMode = .center
        subTextLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1.0
        subTextLayer.font = CTFontCreateWithName("Helvetica-Bold" as CFString, fontSize + 2, nil) // Slightly smaller font
        subTextLayer.fontSize = fontSize + 2
        subTextLayer.foregroundColor = textColor.cgColor
        layer?.addSublayer(subTextLayer)

    }
    
    override func layout() {
        super.layout()
        updateAllLayers()
    }
    
    private func updateAllLayers() {
        guard let layer = layer, bounds.width > 0, bounds.height > 0 else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2) - (lineWidth / 2)
        
        let circularPath = CGPath(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                                                    width: radius * 2, height: radius * 2), transform: nil)
        
        // Update track
        trackLayer.path = circularPath
        trackLayer.lineWidth = lineWidth
        
        // Update progress
        progressLayer.path = circularPath
        progressLayer.lineWidth = lineWidth
        
        // Update text position
        let textRect = CGRect(x: 0, y: bounds.midY + fontSize / 2, width: bounds.width, height: fontSize + 5)
        textLayer.frame = textRect
        textLayer.string = String(format: "%.0f%%", progress * 100)
        
        let subTextRect = CGRect(x: 0, y: bounds.midY - fontSize / 1, width: bounds.width, height: fontSize + 10)
        subTextLayer.frame = subTextRect
        subTextLayer.string = subText // This will be updated dynamically later
    }
    
    private func updateProgressLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        progressLayer.strokeColor = progressColor.cgColor  // ← Use current color
        progressLayer.strokeEnd = CGFloat(progress)
        textLayer.string = String(format: "%.0f%%", progress * 100)
        
        CATransaction.commit()
    }
    
    // Optional: Smooth animated progress
    func setProgress(_ newProgress: Double, animated: Bool = true, duration: CFTimeInterval = 0.3) {
        let clamped = max(0.0, min(1.0, newProgress))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clamped
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progress = clamped // This triggers updateProgressLayer()
    }
}
