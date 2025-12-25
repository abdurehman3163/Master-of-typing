//
//  DictationCVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 13/12/2025.
//

import Cocoa
import AVFoundation

class DictationCVC: NSCollectionViewItem {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var boxLabel: NSBox!
    @IBOutlet weak var weidth: NSLayoutConstraint!
    
    var isVoiceType: Bool = false
    var isDictationSpeed: Bool = false
    weak var speechDelegate: SpeechSpeedDelegate?
    private let allVoices = AVSpeechSynthesisVoice.speechVoices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnMenuAction(_ sender: NSButton){
    let menu = NSMenu()
    
    if isVoiceType {
        setupVoiceMenu(into: menu)
    } else if isDictationSpeed {
        setupSpeedMenu(into: menu)
    }
    
    // Pop up the menu below the button
    menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.frame.height + 4), in: sender)
}

private func setupVoiceMenu(into menu: NSMenu) {
        // Sort voices: Enhanced first, then by language, then name
    let englishVoices = allVoices.filter { $0.language.hasPrefix("en-") }
        
        // Sort: Enhanced first, then by name
        let sortedVoices = englishVoices.sorted { v1, v2 in
            if v1.quality == v2.quality {
                return v1.name < v2.name
            }
            return v1.quality.rawValue > v2.quality.rawValue // Enhanced > Premium > Default
        }
        
        for voice in sortedVoices {
            let item = NSMenuItem(title: voice.name, action: #selector(voiceSelected(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = voice.identifier  // Exact Apple identifier
            
            // Mark enhanced voices with a star (they sound the best!)
            if voice.quality == .enhanced {
                item.title += ""
            }
            
            menu.addItem(item)
        }
}

private func setupSpeedMenu(into menu: NSMenu) {
        let speeds: [(Float, String)] = [
            (AVSpeechUtteranceMinimumSpeechRate + 0.05, "0.5x"),
            (0.35, "0.75x"),
            (0.5, "1.0x"),
            (0.6, "1.25x"),
            (0.75, "1.5x"),
            (AVSpeechUtteranceMaximumSpeechRate, "2.0x")
        ]
        
        for (index, (value, title)) in speeds.enumerated() {
            let item = NSMenuItem(title: title, action: #selector(speedSelected(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = value
            menu.addItem(item)
        }
    }

    
@objc private func voiceSelected(_ sender: NSMenuItem) {
        guard let voiceID = sender.representedObject as? String else { return }
        speechDelegate?.didChangeVoice(to: voiceID)
        button.title = sender.title.replacingOccurrences(of: " ⭐", with: "") // Clean title
    }
    
    @objc private func speedSelected(_ sender: NSMenuItem) {
        guard let speed = sender.representedObject as? Float else { return }
        speechDelegate?.didChangeSpeechSpeed(to: speed)
        button.title = sender.title.components(separatedBy: " – ").first ?? "Select Speed"
    }
}
