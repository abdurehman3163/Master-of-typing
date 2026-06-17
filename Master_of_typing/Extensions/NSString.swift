//
//  NSString.swift
//  DownTik
//
//  Created by Ahsan Murtaza on 24/06/2024.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = NSString(string: self)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}


extension String{
    func localized() -> String {
        return localized(using: nil, in: .main)
    }
    
    func getLocalizedString(languageCode: String) -> String {
        if let languageBundle = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
          let bundle = Bundle(path: languageBundle) {
          return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
          return self
        }
      }
    
    func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let LCLBaseBundle = "Base"
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        else if let path = bundle.path(forResource: LCLBaseBundle, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }
}

