//
//  PracticeVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa
import AVFoundation

class PracticeVC: NSViewController {
    
    @IBOutlet weak var TextField: NSTextView!
    @IBOutlet weak var mainTitle: NSTextField!
    @IBOutlet weak var wpm: NSTextField!
    @IBOutlet weak var cpm: NSTextField!
    @IBOutlet weak var timer: NSTextField!
    @IBOutlet weak var accuracy: NSTextField!
    @IBOutlet weak var keyTiledAndGrave: ButtonBox!
    @IBOutlet weak var key1AndEXCLAMATORY: ButtonBox!
    @IBOutlet weak var key2AndAtRateOf: ButtonBox!
    @IBOutlet weak var key3AndHash: ButtonBox!
    @IBOutlet weak var key4AndDolor: ButtonBox!
    @IBOutlet weak var key5AndModuel: ButtonBox!
    @IBOutlet weak var key6AndCaret: ButtonBox!
    @IBOutlet weak var key7AndAnd: ButtonBox!
    @IBOutlet weak var key8AndAsteric: ButtonBox!
    @IBOutlet weak var key9AndLeftParentheses: ButtonBox!
    @IBOutlet weak var key0AndRightParentheses: ButtonBox!
    @IBOutlet weak var keyMinusAndDash: ButtonBox!
    @IBOutlet weak var keyEqualsAndPlus: ButtonBox!
    @IBOutlet weak var keyDelete: ButtonBox!
    @IBOutlet weak var keyTab: ButtonBox!
    @IBOutlet weak var keyQ: ButtonBox!
    @IBOutlet weak var keyW: ButtonBox!
    @IBOutlet weak var keyE: ButtonBox!
    @IBOutlet weak var keyR: ButtonBox!
    @IBOutlet weak var keyT: ButtonBox!
    @IBOutlet weak var keyY: ButtonBox!
    @IBOutlet weak var keyU: ButtonBox!
    @IBOutlet weak var keyI: ButtonBox!
    @IBOutlet weak var keyO: ButtonBox!
    @IBOutlet weak var keyP: ButtonBox!
    @IBOutlet weak var keyBoxAndCurlyBracesLeft: ButtonBox!
    @IBOutlet weak var keyBoxAndCurlyBracesRight: ButtonBox!
    @IBOutlet weak var keyBackSlashAndPipe: ButtonBox!
    @IBOutlet weak var keyCapsLock: ButtonBox!
    @IBOutlet weak var keyA: ButtonBox!
    @IBOutlet weak var keyS: ButtonBox!
    @IBOutlet weak var keyD: ButtonBox!
    @IBOutlet weak var keyF: ButtonBox!
    @IBOutlet weak var keyG: ButtonBox!
    @IBOutlet weak var keyH: ButtonBox!
    @IBOutlet weak var keyJ: ButtonBox!
    @IBOutlet weak var keyK: ButtonBox!
    @IBOutlet weak var keyL: ButtonBox!
    @IBOutlet weak var keyColonAndSemiColon: ButtonBox!
    @IBOutlet weak var keyQuotationBoth: ButtonBox!
    @IBOutlet weak var keyReturn: ButtonBox!
    @IBOutlet weak var keyShiftLeft: ButtonBox!
    @IBOutlet weak var keyZ: ButtonBox!
    @IBOutlet weak var keyX: ButtonBox!
    @IBOutlet weak var keyC: ButtonBox!
    @IBOutlet weak var keyV: ButtonBox!
    @IBOutlet weak var keyB: ButtonBox!
    @IBOutlet weak var keyN: ButtonBox!
    @IBOutlet weak var keyM: ButtonBox!
    @IBOutlet weak var keyCommaAndLessthan: ButtonBox!
    @IBOutlet weak var keyFullStopAndGreaterthan: ButtonBox!
    @IBOutlet weak var keySlashAndQuestion: ButtonBox!
    @IBOutlet weak var keyShiftRight: ButtonBox!
    @IBOutlet weak var keyFuntion: ButtonBox!
    @IBOutlet weak var keyControl: ButtonBox!
    @IBOutlet weak var keyOption: ButtonBox!
    @IBOutlet weak var keyCommand1: ButtonBox!
    @IBOutlet weak var keySpacebar: ButtonBox!
    @IBOutlet weak var keyCommand2: ButtonBox!
    @IBOutlet weak var keyBack: ButtonBox!
    @IBOutlet weak var keyFarword: ButtonBox!
    @IBOutlet weak var keyUp: ButtonBox!
    @IBOutlet weak var keyDown: ButtonBox!
    @IBOutlet weak var restartOrSpeakButton: NSButton!
    @IBOutlet weak var startTyping: NSButton!
    @IBOutlet weak var pauseSpeaking: NSButton!
    @IBOutlet weak var speedLabelStack: NSStackView!
    @IBOutlet weak var speedSlider: NSSlider!
    @IBOutlet weak var dictationBox: NSBox!
    @IBOutlet weak var speakerButtons: NSStackView!
    
    var chapter: [Chapter]?
    var exercise: Exercise?
    var viewArray: [ButtonBox] = []
    var allowedKeys: [Int] = []
    var cpmValue: Int?
    var wpmValue: Int?
    var accuracyValue: Int?
    //    var chapterTitle: String?
    //    var lesson: Lesson?
    var isfromAiDictationVC: Bool = false
    var speechSpeed: Float = 0.5
    var VoiceType: String = "en-US"
    var text: String = ""
    private var isSpeaking = false
    private var isPaused = false
    private var isFirstStart = true
    private var tagToButtonBox: [Int: ButtonBox] = [:]  // Fast lookup: keyCode/tag → ButtonBox
    private var currentAllowedTags: Set<Int> = []
    private var currentIndex: Int = 0
    private var typedCharacters: [Character] = []  // User's typed chars (for comparison)
    private var startTime: Date?
    private var isFirstKeyPressed = false
    private var correctCharacters: Int = 0 // Track correct characters typed
    private var elapsedTime: TimeInterval = 0 // Track elapsed time for timer
    private var stopwatchTimer: Timer?
    private let synthesizer = AVSpeechSynthesizer()
    private var isSpeechPaused = false
    private var currentUtterance: AVSpeechUtterance?  // To track current utterance
    private var fullText: String = ""  // The original text to type
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.delegate = self             // For change notifications
        TextField.font = NSFont.monospacedSystemFont(ofSize: 24, weight: .regular)
        TextField.textContainer?.lineFragmentPadding = 20
        TextField.textContainer?.maximumNumberOfLines = 1
        if isfromAiDictationVC {
            dictationBox.isHidden = false
            speedSlider.isHidden = false
            speedLabelStack.isHidden = false
            speakerButtons.isHidden = false
            restartOrSpeakButton.image = .imgSpeaker
            fullText = text
            setSliderColors(for: speedSlider, trackColor: .black, backgroundColor: .black)
            updateSpeakButtons(isSpeaking: false, isPaused: false)
        }else{
            guard let exercise = exercise else {return}
            fullText = exercise.text
            currentAllowedTags = Set(exercise.allowedKeys)
            mainTitle.isHidden = false
            mainTitle.stringValue = exercise.title
        }
        
        currentIndex = 0
        typedCharacters.removeAll()
        isFirstKeyPressed = false
        startTime = nil
        correctCharacters = 0
        elapsedTime = 0
        
        viewArray = [keyTiledAndGrave,key1AndEXCLAMATORY,key2AndAtRateOf,key3AndHash,key4AndDolor,key5AndModuel,key6AndCaret,key7AndAnd,key8AndAsteric,key9AndLeftParentheses,key0AndRightParentheses,keyMinusAndDash,keyEqualsAndPlus,keyDelete,keyTab,keyQ,keyW,keyE,keyR,keyT,keyY,keyU,keyI,keyO,keyP,keyBoxAndCurlyBracesLeft,keyBoxAndCurlyBracesRight,keyBackSlashAndPipe,keyCapsLock,keyA,keyS,keyD,keyF,keyG,keyH,keyJ,keyK,keyL,keyColonAndSemiColon,keyQuotationBoth,keyReturn,keyShiftLeft,keyZ,keyX,keyC,keyV,keyB,keyN,keyM,keyCommaAndLessthan,keyFullStopAndGreaterthan,keySlashAndQuestion,keyShiftRight,keyFuntion,keyControl,keyOption, keyCommand1,keySpacebar,keyCommand2, keyBack,keyFarword, keyUp,keyDown]
        
        tagToButtonBox.removeAll()
        
        for box in viewArray {
            guard let innerButton = box.button else { continue }
            tagToButtonBox[innerButton.tag] = box
            if currentAllowedTags.contains(innerButton.tag) {
                box.enable()
            } else {
                box.disable()
            }
        }
        
        // Start monitoring physical key presses
        setupKeyHighlighting()
        updateTextDisplay()
    }
    
    private func speakText(fromStart: Bool = false) {
        if isSpeaking || isPaused {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        if fromStart {
            // Reset text to initial state if starting fresh
            fullText = text
        }
        
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        currentUtterance = utterance
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        isSpeaking = true
        isPaused = false
        updateSpeakButtons(isSpeaking: true, isPaused: false)
    }

    
    private func pauseOrResumeSpeech() {
        if isPaused {
            synthesizer.continueSpeaking()
            isPaused = false
            updateSpeakButtons(isSpeaking: true, isPaused: false)
        } else {
            synthesizer.pauseSpeaking(at: .immediate)
            isPaused = true
            updateSpeakButtons(isSpeaking: true, isPaused: true)
        }
    }

    private func updateSpeakButtons(isSpeaking: Bool, isPaused: Bool) {
        guard isfromAiDictationVC else { return }
        
        if isSpeaking && !isPaused {
            startTyping.title = "Restart"
            restartOrSpeakButton.image = NSImage(systemSymbolName: "speaker.slash.fill", accessibilityDescription: "Pause Speaking")
            pauseSpeaking.image = NSImage(systemSymbolName: "pause.fill", accessibilityDescription: "Pause")
        } else if isSpeaking && isPaused {
            startTyping.title = "Restart"
            restartOrSpeakButton.image = NSImage(systemSymbolName: "speaker.fill", accessibilityDescription: "Resume Speaking")
            pauseSpeaking.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: "Resume")
        } else {
            startTyping.title = "Start"
            restartOrSpeakButton.image = NSImage(systemSymbolName: "speaker.fill", accessibilityDescription: "Start Speaking")
            pauseSpeaking.image = NSImage(systemSymbolName: "pause.fill", accessibilityDescription: "Pause")
        }
    }
    
    private func setupKeyHighlighting() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyPress(event: event, pressed: true)
            return event  // Let event continue (e.g., to TextField)
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
            self?.handleKeyPress(event: event, pressed: false)
            return event
        }
    }
    
    private func handleKeyPress(event: NSEvent, pressed: Bool) {
        let keyCode = Int(event.keyCode)
        
        guard currentAllowedTags.contains(keyCode) else { return }
        guard let buttonBox = tagToButtonBox[keyCode] else { return }
        buttonBox.highlight(pressed, isAllowed: true)
        
        guard pressed else { return }
        guard let characters = event.characters, !characters.isEmpty else { return }
        if keyCode == 51 {
            guard currentIndex > 0 && currentIndex <= (exercise?.text.count ?? 0) else { return }
            typedCharacters.removeLast()
            currentIndex -= 1
            updateTextDisplay()
            updateMetrics()
            return
        }
        
        let typedChar = characters[characters.startIndex]
        guard currentIndex < (exercise?.text.count ?? 0) else { return }
        typedCharacters.append(typedChar)
        currentIndex += 1
        
        if let exerciseText = exercise?.text,
           currentIndex - 1 < exerciseText.count {
            let expectedChar = exerciseText[exerciseText.index(exerciseText.startIndex, offsetBy: currentIndex - 1)]
            if typedChar == expectedChar {
                correctCharacters += 1
            }
        }
        
        if !isFirstKeyPressed {
            isFirstKeyPressed = true
            startStopwatch()
        }
        
        updateTextDisplay()
        updateMetrics()
        
        if currentIndex >= (exercise?.text.count ?? 0) {
            exercise?.isCompleted = true
            
            let exerciseStats = ExerciseStats(wpm: wpmValue ?? 0, cpm: cpmValue ?? 0, time: 0, accuracy: accuracyValue ?? 0)
            exercise?.exerciseStats = exerciseStats
            stopStopwatch()
            DataManager.shared.saveData()
        }
    }
    
    private func updateTextDisplay() {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultFont = NSFont.systemFont(ofSize: 24)
        let grayColor = NSColor.black
        let greenColor = NSColor.systemGreen
        let redColor = NSColor.systemRed
        let currentCharColor = NSColor.systemBlue
        
        attributedString.addAttribute(.foregroundColor, value: grayColor, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: fullText.count))
        
        for i in 0..<min(currentIndex, typedCharacters.count) {
            let index = fullText.index(fullText.startIndex, offsetBy: i)
            let expectedChar = fullText[index]
            let typedChar = typedCharacters[i]
            
            let color: NSColor = (typedChar == expectedChar) ? greenColor : redColor
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: i, length: 1))
            
            if expectedChar == " " && typedChar != expectedChar {
                attributedString.replaceCharacters(in: NSRange(location: i, length: 1), with: "*")
            }
        }
        if currentIndex < fullText.count {
            let boldFont = NSFont.boldSystemFont(ofSize: 26)
            attributedString.addAttributes([
                .foregroundColor: currentCharColor,
                .font: boldFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: currentCharColor
            ], range: NSRange(location: currentIndex, length: 1))
        }
        TextField.textStorage?.setAttributedString(attributedString)
        centerCursorAtCurrentIndex()
    }
    
    private func centerCursorAtCurrentIndex() {
        guard currentIndex < exercise?.text.count ?? 0 else { return }
        
        guard let layoutManager = TextField.layoutManager,
              let textContainer = TextField.textContainer,
              let scrollView = TextField.enclosingScrollView else { return }
        
        let charRange = NSRange(location: currentIndex, length: 1)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: charRange, actualCharacterRange: nil)
        
        guard glyphRange.length > 0 else { return }
        
        let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        let rectInView = TextField.convert(glyphRect, to: nil)
        let rectInWindow = TextField.window?.convertToScreen(TextField.convert(glyphRect, to: nil)) ?? rectInView
        
        var visibleRect = scrollView.documentVisibleRect
        
        let targetOffsetX = glyphRect.midX - visibleRect.width / 2
        
        let maxOffsetX = max(0, scrollView.documentView?.frame.width ?? 0 - visibleRect.width)
        let newOffsetX = min(max(0, targetOffsetX), maxOffsetX)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            visibleRect.origin.x = newOffsetX
            scrollView.contentView.scroll(to: NSPoint(x: newOffsetX, y: visibleRect.origin.y))
        }
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }
    
    private func updateMetrics() {
        guard elapsedTime >= 0.5 else {
            cpm.stringValue = "0"
            wpm.stringValue = "0"
            accuracy.stringValue = "0 %"
            timer.stringValue = "00.00"
            return
        }
        
        let cpmvalue = Double(currentIndex) / (elapsedTime / 60.0)
        cpm.stringValue = String(format: "%.0f", cpmvalue)
        cpmValue = Int(cpmvalue.rounded())
        
        let wpmvalue = cpmvalue / 5.0
        wpm.stringValue = String(format: "%.0f", wpmvalue)
        wpmValue = Int(wpmvalue.rounded())

        let accuracyvalue: Double = currentIndex > 0 ? (Double(correctCharacters) / Double(currentIndex)) * 100.0 : 100.0
        accuracy.stringValue = String(format: "%.0f %%", accuracyvalue)
        accuracyValue = Int(accuracyvalue.rounded())
    }
    
    private func updateTimerDisplay() {
        guard let timerLabel = timer else { return }  // Your @IBOutlet weak var timer: NSTextField!
        
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let hundredths = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        timer.stringValue = String(format: "%02d.%02d", minutes, seconds)
    }
    
    private func startStopwatch() {
        elapsedTime = 0.0
        updateTimerDisplay()
        
        stopwatchTimer?.invalidate()
        stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.elapsedTime += 0.05
            self?.updateTimerDisplay()
        }
    }
    
    private func stopStopwatch() {
        stopwatchTimer?.invalidate()
        stopwatchTimer = nil
    }
        
    @IBAction func backButton(_ sender: Any?) {
        removeChildFromNavigation()
    }
    
    @IBAction func btnRestartExcersieAction(_ sender: Any?){
        if isfromAiDictationVC{
            if isSpeaking {
                // Pause speech
                pauseOrResumeSpeech()
            } else {
                // Start or resume speech
                speakText(fromStart: isFirstStart)
                isFirstStart = false
            }
            dictationBox.isHidden = true
        }else {
            guard let exercise = exercise else { return }
            currentIndex = 0
            typedCharacters.removeAll()
            correctCharacters = 0
            isFirstKeyPressed = false
            elapsedTime = 0.0
            
            stopStopwatch()
            updateTimerDisplay()
            cpm.stringValue = "0"
            wpm.stringValue = "0"
            accuracy.stringValue = "0 %"
            timer.stringValue = "00.00"
            updateTextDisplay()
            print("Exercise restarted!")
        }
    }
    
    @IBAction func startButtonAction(_ sender: Any?) {
        if isSpeaking || isPaused {
            synthesizer.stopSpeaking(at: .immediate)
        }
        fullText = text  // Reset the text
        speakText(fromStart: true)
        dictationBox.isHidden = true
    }
    
    @IBAction func pauseAndPlayButtonAction(_ sender: Any?) {
        guard isfromAiDictationVC else { return }
        pauseOrResumeSpeech()
    }
}

extension PracticeVC: NSTextViewDelegate, AVSpeechSynthesizerDelegate {
    
    func textDidChange(_ notification: Notification) {
        updateTextDisplay()
        updateMetrics()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        updateSpeakButtons(isSpeaking: false, isPaused: false)
    }
    
    // When speech pauses
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPaused = true
        updateSpeakButtons(isSpeaking: true, isPaused: true)
    }
    
    // When speech continues
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isPaused = false
        updateSpeakButtons(isSpeaking: true, isPaused: false)
    }
    
    // When speech is canceled
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        updateSpeakButtons(isSpeaking: false, isPaused: false)
    }
}
