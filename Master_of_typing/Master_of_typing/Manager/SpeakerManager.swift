import Foundation
import AVFoundation

final class SpeakerManager: NSObject {
    
    // MARK: - Shared Instance (or inject if preferred)
    static let shared = SpeakerManager()
    
    // MARK: - Public Properties
    var speechSpeed: Float = 0.5 { // Default normal speed
        didSet {
            if speechSpeed != oldValue && isSpeaking {
                restartCurrentUtteranceIfNeeded()
            }
        }
    }
    
    var voiceIdentifier: String = "en-US" {
        didSet {
            if voiceIdentifier != oldValue && isSpeaking {
                restartCurrentUtteranceIfNeeded()
            }
        }
    }
    
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    
    // MARK: - Delegates & Callbacks
    weak var delegate: SpeakerManagerDelegate?
    
    // MARK: - Private Properties
    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    private var currentText: String = ""
    
    // MARK: - Init
    private override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Speak the given text from the beginning (or restart if already speaking)
    func speak(_ text: String, fromStart: Bool = true) {
        stopSpeaking() // Always stop any ongoing speech first
        
        guard !text.isEmpty else { return }
        
        currentText = text
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Apply voice
        if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: voiceIdentifier) ??
                             AVSpeechSynthesisVoice(language: "en-US")
        }
        
        // Apply rate
        utterance.rate = speechSpeed
        
        currentUtterance = utterance
        synthesizer.speak(utterance)
        
        isSpeaking = true
        isPaused = false
        delegate?.speakerManagerDidStartSpeaking()
    }
    
    /// Pause or resume current speech
    func pauseOrResume() {
        if isPaused {
            synthesizer.continueSpeaking()
        } else if isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    /// Stop speaking immediately and reset state
    func stopSpeaking() {
        if isSpeaking || isPaused {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            isPaused = false
            currentUtterance = nil
            delegate?.speakerManagerDidStopSpeaking()
        }
    }
    
    /// Restart current text with updated speed/voice (preserves text, doesn't reset typing)
    private func restartCurrentUtteranceIfNeeded() {
        guard isSpeaking || isPaused, !currentText.isEmpty else { return }
        
        let wasPaused = isPaused
        let range = synthesizer.pauseSpeaking(at: .word) // Try graceful pause first
        
        // Fallback to immediate stop if needed
        if !range {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Re-speak the same text with new settings
        speak(currentText, fromStart: false)
        
        if wasPaused {
            pauseOrResume() // Re-apply pause state
        }
    }
}

// MARK: - Delegate Protocol
protocol SpeakerManagerDelegate: AnyObject {
    func speakerManagerDidStartSpeaking()
    func speakerManagerDidFinishSpeaking()
    func speakerManagerDidPauseSpeaking()
    func speakerManagerDidResumeSpeaking()
    func speakerManagerDidStopSpeaking()
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeakerManager: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        isPaused = false
        delegate?.speakerManagerDidStartSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
        delegate?.speakerManagerDidFinishSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPaused = true
        delegate?.speakerManagerDidPauseSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isPaused = false
        delegate?.speakerManagerDidResumeSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
        delegate?.speakerManagerDidStopSpeaking()
    }
}
