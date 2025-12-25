//
//  SpeakerManager.swift
//  ChatGPTmacAR
//
//  Created by Macbook Pro on 2/2/25.
//

import Foundation
import AppKit
import AVFoundation
import NaturalLanguage

class SpeakerManager: NSObject, AVSpeechSynthesizerDelegate {
    static let shared: SpeakerManager = SpeakerManager()
    private var synthesizer: AVSpeechSynthesizer
    private var isPlaying: Bool = false
    private var stateChangeCallbacks: [((Bool, Int?) -> Void)] = []
    var activeCellIndex: Int? // Tracks the index of the currently playing cell
    
    var isSpeaking: Bool {
        return isPlaying
    }

    private override init() {
        synthesizer = AVSpeechSynthesizer()
        super.init()
        synthesizer.delegate = self
        // No audio session configuration needed on macOS
    }

    private func resetSynthesizer() {
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.delegate = nil
        synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        print("SpeakerManager: Synthesizer reset")
    }

    func addStateChangeCallback(_ callback: @escaping (Bool, Int?) -> Void) {
        stateChangeCallbacks.append(callback)
    }
    
    func removeStateChangeCallback(_ callback: (Bool, Int?) -> Void) {
        stateChangeCallbacks.removeAll { $0 as AnyObject === callback as AnyObject }
    }
    
    func removeAllCallbacks() {
        stateChangeCallbacks.removeAll()
    }

    func speak(_ text: String, cellIndex: Int) {
        if isPlaying {
            stopSpeaking()
        }
        resetSynthesizer()
        isPlaying = true
        activeCellIndex = cellIndex
        notifyStateChange()
        
        let utterance = AVSpeechUtterance(string: text)
        let voice = AVSpeechSynthesisVoice(language: detectLanguage(text))
        utterance.voice = voice
        utterance.rate = 0.5
        print("SpeakerManager: Speaking text '\(text.prefix(50))...' in language: \(detectLanguage(text)), voice: \(String(describing: voice?.name))")
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
        activeCellIndex = nil
        notifyStateChange()
        print("SpeakerManager: Speech stopped")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        activeCellIndex = nil
        notifyStateChange()
        print("SpeakerManager: Speech finished")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlaying = false
        activeCellIndex = nil
        notifyStateChange()
        print("SpeakerManager: Speech cancelled")
    }

    private func notifyStateChange() {
        stateChangeCallbacks.forEach { callback in
            callback(isPlaying, activeCellIndex)
        }
    }
    
    func detectLanguage(_ text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage?.rawValue ?? "en-US"
    }
}
