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
    private var lastSpokenRange: NSRange = NSRange(location: 0, length: 0)
    private var originalText: String = ""  // The full text we started speaking
    // MARK: - Init
    private override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Speak the given text from the beginning (or restart if already speaking)
    func speak(_ text: String, fromStart: Bool = true) {
        stopSpeaking()
        
        guard !text.isEmpty else { return }
        
        currentText = text
        originalText = text  // ← Save full original text
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Apply voice and rate (same as before)
        if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: voiceIdentifier) ?? AVSpeechSynthesisVoice(language: "en-US")
        }
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
            lastSpokenRange = NSRange(location: 0, length: 0)  // ← Reset tracking
            delegate?.speakerManagerDidStopSpeaking()
        }
    }
    
    /// Restart current text with updated speed/voice (preserves text, doesn't reset typing)
    private func restartCurrentUtteranceIfNeeded() {
        guard (isSpeaking || isPaused), !originalText.isEmpty else { return }
        
        let wasPaused = isPaused
        
        // Just stop immediately — no need to pause first
        synthesizer.stopSpeaking(at: .immediate)
        
        // Calculate remaining text from last known spoken position
        let spokenUpTo = lastSpokenRange.location + lastSpokenRange.length
        
        // Safety: if we've somehow spoken past the end, don't resume
        guard spokenUpTo < originalText.count else {
            isSpeaking = false
            isPaused = false
            delegate?.speakerManagerDidStopSpeaking()
            return
        }
        
        let startIndex = originalText.index(originalText.startIndex, offsetBy: spokenUpTo)
        let remainingText = String(originalText[startIndex...])
        
        // Create and speak new utterance with current rate/voice
        let utterance = AVSpeechUtterance(string: remainingText)
        utterance.rate = speechSpeed
        
        if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: voiceIdentifier) ?? AVSpeechSynthesisVoice(language: "en-US")
        }
        
        currentUtterance = utterance
        synthesizer.speak(utterance)
        
        isSpeaking = true
        
        if wasPaused {
            synthesizer.pauseSpeaking(at: .immediate)
            isPaused = true
            delegate?.speakerManagerDidPauseSpeaking()
        } else {
            isPaused = false
            delegate?.speakerManagerDidStartSpeaking()
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
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        lastSpokenRange = characterRange
    }
}
