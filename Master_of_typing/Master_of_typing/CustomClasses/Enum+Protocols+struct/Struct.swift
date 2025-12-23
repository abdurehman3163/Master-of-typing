//
//  Struct.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Foundation

struct Languages {
    let languageName: String
    let code: String
}

let languages = [
    Languages(languageName: "English", code: "en"),
    Languages(languageName: "Arabic", code: "ar"),
    Languages(languageName: "Catalan", code: "ca"),
    Languages(languageName: "Chinese, Simplified", code: "zh-Hans"),
    Languages(languageName: "Chinese, Traditional", code: "zh-Hant"),
    Languages(languageName: "Croatian", code: "hr"),
    Languages(languageName: "Czech", code: "cs"),
    Languages(languageName: "Danish", code: "da"),
    Languages(languageName: "Dutch", code: "nl"),
    Languages(languageName: "Finnish", code: "fi"),
    Languages(languageName: "French", code: "fr"),
    Languages(languageName: "German", code: "de"),
    Languages(languageName: "Greek", code: "el"),
    Languages(languageName: "Hebrew", code: "he"),
    Languages(languageName: "Hindi", code: "hi"),
    Languages(languageName: "Hungarian", code: "hu"),
    Languages(languageName: "Indonesian", code: "id"),
    Languages(languageName: "Italian", code: "it"),
    Languages(languageName: "Japanese", code: "ja"),
    Languages(languageName: "Korean", code: "ko"),
    Languages(languageName: "Malay", code: "ms"),
    Languages(languageName: "Norwegian Bokmål", code: "nb"),
    Languages(languageName: "Polish", code: "pl"),
    Languages(languageName: "Portuguese (Brazil)", code: "pt-BR"),
    Languages(languageName: "Portuguese (Portugal)", code: "pt-PT"),
    Languages(languageName: "Romanian", code: "ro"),
    Languages(languageName: "Russian", code: "ru"),
    Languages(languageName: "Slovak", code: "sk"),
    Languages(languageName: "Spanish", code: "es"),
    Languages(languageName: "Swedish", code: "sv"),
    Languages(languageName: "Thai", code: "th"),
    Languages(languageName: "Turkish", code: "tr"),
    Languages(languageName: "Ukrainian", code: "uk"),
    Languages(languageName: "Vietnamese", code: "vi")
]

let userDefaultsKey = "selectedLanguageCode"

struct TypingStats {
    var currentCPM: Int = 0          // Last session CPM
    var currentAccuracy: Int = 0     // Last session accuracy
    
    var averageCPM: Int = 0
    var averageAccuracy: Int = 0
    
    var bestCPM: Int = 0
    var bestAccuracy: Int = 100
    
    var totalSessions: Int = 0
}

