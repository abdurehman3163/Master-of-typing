//
//  Ext-String.swift
//  JotlyNoteTaker
//
//  Created by MacBook Pro on 21/06/2025.
//

import Foundation
import AppKit
extension String {
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey
                        .characterEncoding: String.Encoding.utf8.rawValue,
                ], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    func size(with font: NSFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)
        return size
    }
    func toCGSize() -> CGSize? {
        let regex = try? NSRegularExpression(pattern: "CGSize\\(width: (.*), height: (.*)\\)", options: [])
        let range = NSRange(location: 0, length: self.count)
        if let match = regex?.firstMatch(in: self, options: [], range: range) {
            let widthRange = match.range(at: 1)
            let heightRange = match.range(at: 2)
            let widthString = (self as NSString).substring(with: widthRange)
            let heightString = (self as NSString).substring(with: heightRange)
            if let widthFloat = Float(widthString), let heightFloat = Float(heightString) {
                return CGSize(width: CGFloat(widthFloat.rounded()), height: CGFloat(heightFloat.rounded()))
            }
        }
        return nil
    }
    
    func calculateWidth(attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let attributed = NSAttributedString(string: self, attributes: attributes)
        return attributed.size().width
    }
}

let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"
let LCLDefaultLanguage = "en"


class Localize: NSObject {
    
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}
