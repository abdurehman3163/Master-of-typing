import AppKit
import Cocoa

@IBDesignable
class GradientView: NSView {

    // Gradient Colors
    @IBInspectable var startColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    @IBInspectable var endColor: NSColor = .clear {
        didSet { updateGradient() }
    }

    // Gradient Direction
    @IBInspectable var startPointX: CGFloat = 0.5 {
        didSet { updateGradient() }
    }
    @IBInspectable var startPointY: CGFloat = 0.0 {
        didSet { updateGradient() }
    }
    @IBInspectable var endPointX: CGFloat = 0.5 {
        didSet { updateGradient() }
    }
    @IBInspectable var endPointY: CGFloat = 1.0 {
        didSet { updateGradient() }
    }

    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        setupGradient()
    }

    override func layout() {
        super.layout()
        // If we are using CAGradientLayer, ensure the frame is correct
        gradientLayer?.frame = bounds
    }

    private func setupGradient() {
        // In the case of a radial gradient, we won't use a CAGradientLayer
        // Instead, we'll manually draw the radial gradient using NSGradient
    }

    private func updateGradient() {
        // Perform custom drawing when the gradient is updated
        setNeedsDisplay(bounds)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Create the radial gradient
        let gradient = NSGradient(colors: [startColor, endColor])
        
        // Define the start and end points for the gradient
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.width, bounds.height) / 2

        // Draw the radial gradient
        gradient?.draw(fromCenter: center, radius: 0, toCenter: center, radius: radius, options: [])
    }
}
