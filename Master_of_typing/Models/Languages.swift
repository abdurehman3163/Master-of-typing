//
//  Languages.swift
//  QuizMaker
//
//  Created by Abdul Rehman on 10/16/25.
//

//import Foundation
////
////enum Languages: String, CaseIterable {
////    case English
////    case Arabic
////    case Catalan
////    case ChineseSimplified
////    case ChineseTraditional
////    case Croatian
////    case Czech
////    case Danish
////    case Dutch
////    case Finnish
////    case French
////    case German
////    case Greek
////    case Hebrew
////    case Hindi
////    case Hungarian
////    case Indonesian
////    case Italian
////    case Japanese
////    case Korean
////    case Malay
////    case Norwegian
////    case Polish
////    case PortugueseBrazil
////    case PortuguesePortugal
////    case Romanian
////    case Russian
////    case Slovenian
////    case Slovak
////    case Spanish
////    case Swedish
////    case Thai
////    case Turkish
////    case Ukrainian
////    case Vietnamese
////}
//enum Languages: String, CaseIterable {
//    case english = "en"
//    case arabic = "ar"
//    case catalan = "ca"
//    case chineseSimplified = "zh-Hans"
//    case chineseTraditional = "zh-Hant"
//    case croatian = "hr"
//    case czech = "cs"
//    case danish = "da"
//    case dutch = "nl"
//    case finnish = "fi"
//    case french = "fr"
//    case german = "de"
//    case greek = "el"
//    case hebrew = "he"
//    case hindi = "hi"
//    case hungarian = "hu"
//    case indonesian = "id"
//    case italian = "it"
//    case japanese = "ja"
//    case korean = "ko"
//    case malay = "ms"
//    case norwegian = "nb"
//    case polish = "pl"
//    case portugueseBrazil = "pt-BR"
//    case portuguesePortugal = "pt-PT"
//    case romanian = "ro"
//    case russian = "ru"
//    case slovenian = "sl"
//    case slovak = "sk"
//    case spanish = "es"
//    case swedish = "sv"
//    case thai = "th"
//    case turkish = "tr"
//    case ukrainian = "uk"
//    case vietnamese = "vi"
//}
import Foundation

struct Languages {
    let languageName: String
    let code: String
}

let languages = [
    Languages(languageName: "English", code: "en"),
    Languages(languageName: "العربية", code: "ar"),
    Languages(languageName: "Català", code: "ca"),
    Languages(languageName: "中文（简体）", code: "zh-Hans"),
    Languages(languageName: "中文（繁體）", code: "zh-Hant"),
    Languages(languageName: "Hrvatski", code: "hr"),
    Languages(languageName: "Čeština", code: "cs"),
    Languages(languageName: "Dansk", code: "da"),
    Languages(languageName: "Nederlands", code: "nl"),
    Languages(languageName: "Suomi", code: "fi"),
    Languages(languageName: "Français", code: "fr"),
    Languages(languageName: "Deutsch", code: "de"),
    Languages(languageName: "Ελληνικά", code: "el"),
    Languages(languageName: "עברית", code: "he"),
    Languages(languageName: "हिन्दी", code: "hi"),
    Languages(languageName: "Magyar", code: "hu"),
    Languages(languageName: "Bahasa Indonesia", code: "id"),
    Languages(languageName: "Italiano", code: "it"),
    Languages(languageName: "日本語", code: "ja"),
    Languages(languageName: "한국어", code: "ko"),
    Languages(languageName: "Bahasa Melayu", code: "ms"),
    Languages(languageName: "Norsk Bokmål", code: "nb"),
    Languages(languageName: "Polski", code: "pl"),
    Languages(languageName: "Português (Brasil)", code: "pt-BR"),
    Languages(languageName: "Português (Portugal)", code: "pt-PT"),
    Languages(languageName: "Română", code: "ro"),
    Languages(languageName: "Русский", code: "ru"),
    Languages(languageName: "Slovenščina", code: "sl"),
    Languages(languageName: "Slovenčina", code: "sk"),
    Languages(languageName: "Español", code: "es"),
    Languages(languageName: "Svenska", code: "sv"),
    Languages(languageName: "ไทย", code: "th"),
    Languages(languageName: "Türkçe", code: "tr"),
    Languages(languageName: "Українська", code: "uk"),
    Languages(languageName: "Tiếng Việt", code: "vi")
]

let userDefaultsKey = "selectedLanguageCode"

//// Add this computed property in Languages struct
extension Languages {
    var flagEmoji: String {
        switch code {
        case "en":      return "🇺🇸"   // or "🇺🇸" — you decide
        case "ar":      return "🇸🇦"
        case "ca":      return "🇪🇸"   // Catalan - Spain (common choice)
        case "zh-Hans": return "🇨🇳"
        case "zh-Hant": return "🇹🇼"   // or 🇭🇰
        case "hr":      return "🇭🇷"
        case "cs":      return "🇨🇿"
        case "da":      return "🇩🇰"
        case "nl":      return "🇳🇱"
        case "fi":      return "🇫🇮"
        case "fr":      return "🇫🇷"
        case "de":      return "🇩🇪"
        case "el":      return "🇬🇷"
        case "he":      return "🇮🇱"
        case "hi":      return "🇮🇳"
        case "hu":      return "🇭🇺"
        case "id":      return "🇮🇩"
        case "it":      return "🇮🇹"
        case "ja":      return "🇯🇵"
        case "ko":      return "🇰🇷"
        case "ms":      return "🇲🇾"
        case "nb":      return "🇳🇴"
        case "pl":      return "🇵🇱"
        case "pt-BR":   return "🇧🇷"
        case "pt-PT":   return "🇵🇹"
        case "ro":      return "🇷🇴"
        case "ru":      return "🇷🇺"
        case "sl":      return "🇸🇮"
        case "sk":      return "🇸🇰"
        case "es":      return "🇪🇸"
        case "sv":      return "🇸🇪"
        case "th":      return "🇹🇭"
        case "tr":      return "🇹🇷"
        case "uk":      return "🇺🇦"
        case "vi":      return "🇻🇳"
        default:        return "🌍"
        }
    }
////    
////    var flagImage: NSImage? {
////            NSImage(named: flagAssetName) ?? NSImage(systemSymbolName: "globe", accessibilityDescription: nil)
////        }
}
