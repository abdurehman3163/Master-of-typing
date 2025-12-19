//
//  App.swift
//  ChatGPTmacAR
//
//  Created by Macbook Pro on 18/05/2025.
//

import Foundation
import AppKit

class App {
    private static let defaults: UserDefaults = .standard
    
    static var isPro: Bool {
        get { defaults.bool(forKey: "isPremium") }
        set {
            defaults.set(newValue, forKey: "isPremium")
//            NotificationCenter.default.post(name: .appProStatusDidChange, object: nil)
        }
    }
    
    static var isNotPro: Bool { !isPro }
    
    static var appearance: Appearance {
        get { .init(rawValue: defaults.string(forKey: "appearance") ?? Appearance.System.rawValue) ?? .System }
        set {
            defaults.set(newValue.rawValue, forKey: "appearance")
            switch newValue {
            case .System:
                NSApp.appearance = nil
            case .Light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .Dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            }
        }
    }
    
    static var appLanguage: Languages {
        get {
            let language = languages.first(where: { $0.code == defaults.string(forKey: "appLanguage") ?? "en" })
            return language ?? .init(languageName: "English", code: "en")
        }
        set {
            defaults.set(newValue.code, forKey: "appLanguage")
//            Localize.setCurrentLanguage(newValue.code)
        }
    }
    
    private static var freeCount: Int {
        get { defaults.integer(forKey: "freeCount") }
        set { defaults.set(newValue, forKey: "freeCount") }
    }
    
    static func incrementFreeCount() {
        guard App.isNotPro else { return }
        freeCount += 1
    }
    
    static var isFree: Bool {
        return freeCount < 2
    }
    
    static var canSendQuery: Bool {
        isFree || isPro
    }
    
    private static var freeCountPrint: Int {
        get { defaults.integer(forKey: "freeCountPrint") }
        set { defaults.set(newValue, forKey: "freeCountPrint") }
    }
    
    static func incrementFreeCountPrint() {
        guard App.isNotPro else { return }
        freeCountPrint += 1
    }
    
    static var isFreePrint: Bool {
        return freeCountPrint < 1
    }
    
    static var canSendQueryPrint: Bool {
        isFreePrint || isPro
    }
    
    private static var freeCountExport: Int {
        get { defaults.integer(forKey: "freeCountExport") }
        set { defaults.set(newValue, forKey: "freeCountExport") }
    }
    
    static func incrementFreeCountExport() {
        guard App.isNotPro else { return }
        freeCountExport += 1
    }
    
    static var isFreeExport: Bool {
        return freeCountExport < 1
    }
    
    static var canSendQueryExport: Bool {
        isFreeExport || isPro
    }
    
    private static var freeCountShare: Int {
        get { defaults.integer(forKey: "freeCountShare") }
        set { defaults.set(newValue, forKey: "freeCountShare") }
    }
    
    static func incrementFreeCountShare() {
        guard App.isNotPro else { return }
        freeCountShare += 1
    }
    
    static var isFreeShare: Bool {
        return freeCountShare < 1
    }
    
    static var canSendQueryShare: Bool {
        isFreeShare || isPro
    }
    
    private static var freeCountConvert: Int {
        get { defaults.integer(forKey: "freeCountConvert") }
        set { defaults.set(newValue, forKey: "freeCountConvert") }
    }
    
    static func incrementFreeCountConvert() {
        guard App.isNotPro else { return }
        freeCountConvert += 1
    }
    
    static var isFreeConvert: Bool {
        return freeCountConvert < 1
    }
    
    static var canSendQueryConvert: Bool {
        isFreeConvert || isPro
    }
    
    private static var freeCountCopy: Int {
        get { defaults.integer(forKey: "freeCountCopy") }
        set { defaults.set(newValue, forKey: "freeCountCopy") }
    }
    
    static func incrementFreeCountCopy() {
        guard App.isNotPro else { return }
        freeCountCopy += 1
    }
    
    static var isFreeCopy: Bool {
        return freeCountCopy < 1
    }
    
    static var canSendQueryCopy: Bool {
        isFreeCopy || isPro
    }
}
