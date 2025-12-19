
import Foundation
import AppKit
extension NSTextField {
    
    var customFontName: String? {
        get {
            return self.font?.fontName
        }
        set {
            if let fontName = newValue, let fontSize = self.font?.pointSize {
                self.font = NSFont(name: fontName, size: fontSize)
            }
        }
    }
    var customFontSize: CGFloat {
        get {
            return self.font?.pointSize ?? NSFont.systemFontSize
        }
        set {
            setFontSize(newValue)
        }
    }
    
    private func setFontSize(_ size: CGFloat) {
        if let fontName = self.font?.fontName {
            self.font = NSFont(name: fontName, size: size)
        }
    }
    @IBInspectable var underline: Bool {
        get {
            return attributedStringValue.attribute(.underlineStyle, at: 0, effectiveRange: nil) as? Int == NSUnderlineStyle.single.rawValue
        }
        set {
            let currentText = stringValue
            let attributedString = NSMutableAttributedString(string: currentText)
            if newValue {
                attributedString.addAttribute(.underlineStyle,
                                              value: NSUnderlineStyle.single.rawValue,
                                              range: NSRange(location: 0, length: currentText.count))
            } else {
                attributedString.removeAttribute(.underlineStyle, range: NSRange(location: 0, length: currentText.count))
            }
            attributedStringValue = attributedString
        }
    }
    func bestHeight(for text: String, width: CGFloat) -> CGFloat {
        stringValue = text
        let height = cell!.cellSize(forBounds: NSRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)).height
        return height
    }
    func bestWidth(for text: String, height: CGFloat) -> CGFloat {
        stringValue = text
        let width = cell!.cellSize(forBounds: NSRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height)).width
        return width
    }
    func addLineSpacing(_ spacing: CGFloat, textAlignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = textAlignment
        
        let mutableString = NSMutableAttributedString(attributedString: self.attributedStringValue)
        mutableString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: mutableString.length))
        self.attributedStringValue = mutableString
    }
    public func customizeCursorColor(_ cursorColor: NSColor) {
        let fieldEditor = self.window?.fieldEditor(true, for: self) as! NSTextView
        fieldEditor.insertionPointColor = cursorColor
    }
    func adjustFontSizeToFitWidth() {
        guard let originalFont = self.font else {
            return
        }
        let originalString = self.stringValue
        var fontSize = originalFont.pointSize
        var size = originalString.size(withAttributes: [NSAttributedString.Key.font: originalFont])
        
        while size.width > self.bounds.width {
            fontSize -= 1.5
            let newFont = NSFont(name: originalFont.fontName, size: fontSize)
            
            if let newFont = newFont {
                size = originalString.size(withAttributes: [NSAttributedString.Key.font: newFont])
                self.font = newFont
            } else {
                break
            }
        }
    }
    
    func setAttributedStrike(color: NSColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.thick.rawValue,
            .foregroundColor: color
        ]
        attributedStringValue = NSAttributedString(string: stringValue, attributes: attributes)
    }
}
