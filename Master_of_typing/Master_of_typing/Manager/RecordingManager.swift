
import Cocoa
import AVFoundation
import Speech

class RecordingManager {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var speechRecognizer: SFSpeechRecognizer? { return SFSpeechRecognizer(locale: Locale.current) }
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    
    var isRecording: Bool = false
    var onSpeechRecognized: ((String) -> Void)?
    
    static let shared = RecordingManager()
    
    private init() {}
}

extension RecordingManager {
    func speechReconitionAuthorized() async -> Bool {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus != .authorized {
                    continuation.resume(returning: false)
                }
                continuation.resume(returning: true)
            }
        }
    }
    
    func microphoneAuhtorized() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func startSpeechRecognition() {
        guard let recognizer = speechRecognizer else {
            print("Speech recognition is not available")
            return
        }
        
        Task {
            guard await microphoneAuhtorized() else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    let isYes = Utility.dialogOKCancel(question: "Please allow".localized() + AppConstants.appName.localized() + "to access your Microphone from device settings".localized(), yesButtonText: "Settings".localized(), noButtonText: "Cancel".localized())
                    if isYes {
                        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    isRecording = false
                    return
                }
                return
            }
            
            guard await speechReconitionAuthorized() else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let isYes = Utility.dialogOKCancel(question: "Please allow".localized() + AppConstants.appName.localized() + "to access your Speech Recognition from device settings".localized(), yesButtonText: "Settings".localized(), noButtonText: "Cancel".localized())
                    
                    if isYes {
                        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    isRecording = false
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let isYes = Utility.dialogOKCancel(question: "Please allow".localized() + AppConstants.appName.localized() + "to access your Microphone from device settings".localized(), yesButtonText: "Settings".localized(), noButtonText: "Cancel".localized())
                    if isYes {
                        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    isRecording = false
                    return
                }
                return
            }
            
            // Configure recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                return
            }
            recognitionRequest.shouldReportPartialResults = true
            
            // Configure recognition task
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
                guard let self = self else { return }
                if let result = result {
                    let transcription = result.bestTranscription.formattedString
                    // Do something with transcription
                    if isRecording {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            onSpeechRecognized?(transcription)
                        }
                    }
                }
            })
            
            // Start audio engine
            inputNode = audioEngine.inputNode
            let recordingFormat = inputNode?.outputFormat(forBus: 0)
            inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                guard let self else { return }
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            do {
                try audioEngine.start()
                isRecording = true
            } catch {
                stopSpeechRecognition()
                isRecording = false
            }
        }
    }
    
    func stopSpeechRecognition() {
        isRecording = false
        inputNode?.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
}