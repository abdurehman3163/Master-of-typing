//
//  PracticeVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa
import AVFoundation
//import Speech

class PracticeVC: NSViewController {
    
    @IBOutlet weak var textCollectionView: NSCollectionView!
    @IBOutlet weak var collectioinViewBox: NSBox!
    @IBOutlet weak var TextField: NSTextField!
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
    @IBOutlet weak var showStringsToType: NSButton!
    @IBOutlet weak var restartOrSpeakButton: NSButton!
    @IBOutlet weak var startTyping: NSButton!
    @IBOutlet weak var pauseSpeaking: NSButton!
    @IBOutlet weak var speedLabelStack: NSStackView!
    @IBOutlet weak var speedSlider: NSSlider!
    @IBOutlet weak var dictationBox: NSBox!
    @IBOutlet weak var dictationBoxImage: NSImageView!
    @IBOutlet weak var dictationBoxLabel: NSTextField!
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
    var isfromDictationVC2ndIndex: Bool = false
    var isfromDictationVC3rdIndex: Bool = false
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
    private var fullText: String = ""  // The original text to type
    private var isTypingAllowed = false  // Controls both input and highlighting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        TextField.delegate = self
        //        TextField.font = NSFont.monospacedSystemFont(ofSize: 24, weight: .regular)
        //        TextField.textContainer?.lineFragmentPadding = 20
        //        TextField.textContainer?.maximumNumberOfLines = 1
        //        TextField.isHorizontallyResizable = true
        //        TextField.isVerticallyResizable = false
        //
        //        TextField.textContainer?.widthTracksTextView = false
        //        TextField.textContainer?.maximumNumberOfLines = 1
        //        TextField.textContainer?.lineBreakMode = .byClipping
        //
        //        // Important: Start with a reasonable large size, we'll grow it dynamically
        //        TextField.textContainer?.containerSize = NSSize(width: 10000, height: TextField.bounds.height)
        
        // Hide scrollers for clean look (scrolling still works via code)
        //        TextField.enclosingScrollView?.hasHorizontalScroller = false
        //        TextField.enclosingScrollView?.hasVerticalScroller = false
        //        TextField.enclosingScrollView?.autohidesScrollers = true
        
        viewArray = [keyTiledAndGrave, key1AndEXCLAMATORY, key2AndAtRateOf, key3AndHash, key4AndDolor,
                     key5AndModuel, key6AndCaret, key7AndAnd, key8AndAsteric, key9AndLeftParentheses,
                     key0AndRightParentheses, keyMinusAndDash, keyEqualsAndPlus, keyDelete, keyTab,
                     keyQ, keyW, keyE, keyR, keyT, keyY, keyU, keyI, keyO, keyP,
                     keyBoxAndCurlyBracesLeft, keyBoxAndCurlyBracesRight, keyBackSlashAndPipe,
                     keyCapsLock, keyA, keyS, keyD, keyF, keyG, keyH, keyJ, keyK, keyL,
                     keyColonAndSemiColon, keyQuotationBoth, keyReturn, keyShiftLeft,
                     keyZ, keyX, keyC, keyV, keyB, keyN, keyM,
                     keyCommaAndLessthan, keyFullStopAndGreaterthan, keySlashAndQuestion,
                     keyShiftRight, keyFuntion, keyControl, keyOption, keyCommand1,
                     keySpacebar, keyCommand2, keyBack, keyFarword, keyUp, keyDown]
        
        textCollectionView.dataSource = self
        textCollectionView.delegate = self
        // CLEAR AND POPULATE tagToButtonBox ONCE, EARLY
        tagToButtonBox.removeAll()
        for box in viewArray {
            guard let innerButton = box.button else { continue }
            tagToButtonBox[innerButton.tag] = box
        }
        
        if isfromAiDictationVC {
            dictationBox.isHidden = false
            speedSlider.isHidden = false
            speedLabelStack.isHidden = false
            speakerButtons.isHidden = false
            restartOrSpeakButton.image = .imgSpeaker // or system symbol
            fullText = text
            setSliderColors(for: speedSlider, trackColor: .black, backgroundColor: .black)
            updateSpeakButtons()
            
            for box in viewArray {
                box.disable()
            }
            isTypingAllowed = false

        }else if isfromDictationVC2ndIndex {
            registerVoiceRcognizer()
            speakerButtons.isHidden = false
            dictationBox.isHidden = false
            dictationBoxImage.image = .imgDictationSpeak
            dictationBoxLabel.stringValue = "Dictate the text you want to type"
            restartOrSpeakButton.image = .imgDictationSpeak // or system symbol
            startTyping.isEnabled = false
            pauseSpeaking.isEnabled = false
            for box in viewArray {
                box.disable()
            }
            isTypingAllowed = false

        }else if isfromDictationVC3rdIndex {
            dictationBox.isHidden = false
            speedSlider.isHidden = false
            speedLabelStack.isHidden = false
            speakerButtons.isHidden = false
            showStringsToType.isHidden = false
            collectioinViewBox.isHidden = false
            dictationBoxImage.image = .imgDictationListen
            dictationBoxLabel.stringValue = "Choose the text you want to type and click start"
            restartOrSpeakButton.image = .imgSpeaker // or system symbol
            isTypingAllowed = false
            
        } else {
            isTypingAllowed = true
            guard let exercise = exercise else { return }
            fullText = exercise.text
            currentAllowedTags = Set(exercise.allowedKeys)
            mainTitle.isHidden = false
            mainTitle.stringValue = exercise.id
            
            // Enable only allowed keys in exercise mode
            for box in viewArray {
                if currentAllowedTags.contains(box.button?.tag ?? -1) {
                    box.enable()
                } else {
                    box.disable()
                }
            }
            
        }
        
        // Reset typing state
        currentIndex = 0
        typedCharacters.removeAll()
        isFirstKeyPressed = false
        startTime = nil
        correctCharacters = 0
        elapsedTime = 0
        setupKeyHighlighting()
        updateTextDisplay()
        updateAllowedKeysHighlight()
        
        SpeakerManager.shared.delegate = self
        SpeakerManager.shared.speechSpeed = speechSpeed
        SpeakerManager.shared.voiceIdentifier = VoiceType
    }
    
    private func updateSpeakButtons() {
        if isfromAiDictationVC || isfromDictationVC3rdIndex {
            if SpeakerManager.shared.isSpeaking && !SpeakerManager.shared.isPaused {
                startTyping.title = "Restart"
                restartOrSpeakButton.image = NSImage(systemSymbolName: "speaker.slash.fill", accessibilityDescription: "Pause")
            } else {
                startTyping.title = "Start"
                restartOrSpeakButton.image = NSImage(systemSymbolName: "speaker.fill", accessibilityDescription: "Speak")
            }
        } else if isfromDictationVC2ndIndex {
            if RecordingManager.shared.isRecording {
                restartOrSpeakButton.image = NSImage(systemSymbolName: "stop.fill", accessibilityDescription: "Stop Recording")
            } else {
                restartOrSpeakButton.image = .imgDictationSpeak // or microphone icon
                startTyping.title = "Start Typing"
            }
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
        guard isTypingAllowed else { return }
        // Restrict keys ONLY in regular exercise mode
        // Allow all keys in AI dictation mode OR free dictation typing mode
//        if !(isfromAiDictationVC || isfromDictationVC2ndIndex || isfromDictationVC3rdIndex) {
//            guard currentAllowedTags.contains(keyCode) else { return }
//        }
        
        // Highlight the key
        guard let buttonBox = tagToButtonBox[keyCode] else {
            print("Warning: No button box for keyCode \(keyCode)")
            return
        }
        let isAllowedKey = currentAllowedTags.contains(keyCode) ||
                           (isfromAiDictationVC || isfromDictationVC2ndIndex || isfromDictationVC3rdIndex)

        buttonBox.highlight(pressed, isAllowed: isAllowedKey)
        guard pressed else { return }
        guard let characters = event.characters, !characters.isEmpty else { return }
        
        // Backspace
        if keyCode == 51 {
            if currentIndex > 0 {
                typedCharacters.removeLast()
                currentIndex -= 1
                updateTextDisplay()
                updateMetrics()
            }
            return
        }
        
        // Normal typing
        let typedChar = characters[characters.startIndex]
        guard currentIndex < fullText.count else { return }
        
        typedCharacters.append(typedChar)
        currentIndex += 1
        
        // Accuracy (only meaningful in exercise mode, but safe to run)
        if currentIndex - 1 < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex - 1)
            let expectedChar = fullText[index]
            
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
        
        // Completion (only in exercise mode)
        if currentIndex >= fullText.count {
            stopStopwatch()
            let finalAccuracy = accuracyValue ?? 0
            // Optional: show "Well done!" message or stats popup
            
            if !isfromAiDictationVC && !isfromDictationVC2ndIndex && !isfromDictationVC3rdIndex {
                // Only real exercises get saved
                exercise?.isCompleted = true
                let stats = ExerciseStats(wpm: wpmValue ?? 0,
                                          cpm: cpmValue ?? 0,
                                          time: Int(elapsedTime),
                                          accuracy: accuracyValue ?? 0)
                exercise?.exerciseStats = stats
                DataManager.shared.saveData()
                
                if finalAccuracy >= 80 {
                            showSuccessAndNextExerciseAlert()
                        } else {
                            showRetryEncouragementAlert()
                        }
            }
        }
    }

    private func showRetryEncouragementAlert() {
        let alertVC = PractiveAlertView(nibName: "PractiveAlertView", bundle: nil)
            
        alertVC.isblow80 = true
            alertVC.onNext = { [weak self] in
                self?.resetTypingStateFully()
                self?.updateTextDisplay()
            }
            
            alertVC.onExit = { [weak self] in
                self?.removeChildFromNavigation()
            }
            
            presentAsSheet(alertVC)
    }

    private func showSuccessAndNextExerciseAlert() {
        let alertVC = PractiveAlertView(nibName: "PractiveAlertView", bundle: nil)
            alertVC.onNext = { [weak self] in
                self?.goToNextExercise()
            }
            
            alertVC.onExit = { [weak self] in
                self?.removeChildFromNavigation()
            }
            presentAsSheet(alertVC)
    }
    
    private func goToNextExercise() {
        guard let currentExercise = exercise,
              let chapters = chapter else {
            removeChildFromNavigation()
            return
        }
        
        let currentExerciseId = currentExercise.id  // No 'let' unwrap needed – it's already String
        
        // Find the chapter containing this exercise
        guard let currentChapter = chapters.first(where: { chapter in
            chapter.lessons.contains { lesson in
                lesson.exercises.contains { exercise in
                    exercise.id == currentExerciseId
                }
            }
        }) else {
            removeChildFromNavigation()
            return
        }
        
        // Find the lesson containing this exercise
        guard let lesson = currentChapter.lessons.first(where: { lesson in
            lesson.exercises.contains { exercise in
                exercise.id == currentExerciseId
            }
        }) else {
            removeChildFromNavigation()
            return
        }
        
        // Find current index and check for next exercise
        guard let currentIndex = lesson.exercises.firstIndex(where: { $0.id == currentExerciseId }),
              currentIndex + 1 < lesson.exercises.count else {
            removeChildFromNavigation()
            return
        }
        
        // Load next exercise
        let nextExercise = lesson.exercises[currentIndex + 1]
        
        // Update current PracticeVC with next exercise
        self.exercise = nextExercise
        self.fullText = nextExercise.text
        self.currentAllowedTags = Set(nextExercise.allowedKeys)
        self.mainTitle.stringValue = nextExercise.title
        
        // Update key states
        for box in viewArray {
            if currentAllowedTags.contains(box.button?.tag ?? -1) {
                box.enable()
            } else {
                box.disable()
            }
        }
        
        // Reset typing progress
        resetTypingStateFully()
        updateAllowedKeysHighlight()
        updateTextDisplay()
        
        print("Advanced to next exercise: \(nextExercise.title)")
    }
    
    private func updateTextDisplay() {
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center  // ← This forces center
        let defaultFont = NSFont.systemFont(ofSize: 20, weight: .medium)
        let grayColor = NSColor.black
        let greenColor = NSColor.systemGreen
        let redColor = NSColor.systemRed
        let currentCharColor = NSColor.systemBlue
        
        attributedString.addAttribute(.foregroundColor, value: grayColor, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: fullText.count))
        
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
            let boldFont = NSFont.boldSystemFont(ofSize: 20)
            attributedString.addAttributes([
                .foregroundColor: currentCharColor,
                .font: boldFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: currentCharColor
            ], range: NSRange(location: currentIndex, length: 1))
        }
        TextField.attributedStringValue = attributedString
    }
    
    private func updateAllowedKeysHighlight() {
        // Default: dim all keys
        for box in viewArray {
            box.layer?.opacity = 0.3
        }
        
        // In exercise mode: brighten only allowed keys
        if !(isfromAiDictationVC || isfromDictationVC2ndIndex || isfromDictationVC3rdIndex) {
            for box in viewArray {
                if let tag = box.button?.tag,
                   currentAllowedTags.contains(tag) {
                    box.layer?.opacity = 1.0
                }
            }
        } else {
            // In dictation modes: all keys bright when typing allowed
            if isTypingAllowed {
                for box in viewArray {
                    box.layer?.opacity = 1.0
                }
            }
        }
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
    
    private func resetTypingStateFully() {
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
        updateMetrics()
        updateAllowedKeysHighlight()
    }
    
    private func enableAllKeys() {
        for box in viewArray {
            box.enable()
        }
    }
    
    private func disableAllKeys() {
        for box in viewArray {
            box.disable()
        }
    }
    
    func registerVoiceRcognizer() {
        RecordingManager.shared.onSpeechRecognized = { [weak self] result in
            guard let self = self else { return }
                
                // Update the displayed text and fullText
                TextField.stringValue = result
                fullText = result
                
                // Only apply character limit in Free Dictation mode
                guard self.isfromDictationVC2ndIndex else { return }
                
                // If recognized text reaches 300 characters → automatically stop recording
                if result.count >= 300 {
                    RecordingManager.shared.stopSpeechRecognition()
                    
                    // Update UI to reflect typing mode
                    self.dictationBoxLabel.stringValue = "Click start to type..."
                    self.startTyping.isEnabled = true
                    
                    // Optional: show a subtle message
                    // You can add a temporary label or alert if you want
                    print("Auto-stopped recording at 300 characters")
                }
        }
    }
    @IBAction func backButton(_ sender: Any?) {
        removeChildFromNavigation()
        SpeakerManager.shared.stopSpeaking()
    }
    
    @IBAction func btnRestartExcersieAction(_ sender: Any?) {
        // MARK: AI Dictation Mode (Listen to text)
        if isfromAiDictationVC {
            if SpeakerManager.shared.isSpeaking || SpeakerManager.shared.isPaused {
                SpeakerManager.shared.pauseOrResume()
            } else {
                // Start speaking from beginning
                resetTypingStateFully()           // <--- important: reset timer & progress
                SpeakerManager.shared.speak(fullText)
                isTypingAllowed = true
                enableAllKeys()
                
                dictationBox.isHidden = true
                dictationBoxLabel.stringValue = "Listen and type the text"
                dictationBoxImage.image = NSImage(systemSymbolName: "headphones", accessibilityDescription: "Listen")
            }
            // MARK: Free Dictation Mode (Speak your own text)
        } else if isfromDictationVC2ndIndex {
            //            dictationBox.isHidden = true
            if RecordingManager.shared.isRecording {
                RecordingManager.shared.stopSpeechRecognition()
                dictationBoxLabel.stringValue = "Click start to type..."
                startTyping.isEnabled = true
            } else {
                startTyping.isEnabled = false
                resetTypingStateFully()           // <--- reset before new recording
                RecordingManager.shared.startSpeechRecognition()
                dictationBox.isHidden = false
                isTypingAllowed = false
                disableAllKeys()
                
                dictationBoxLabel.stringValue = "Speak now..."            }
        }else if isfromDictationVC3rdIndex {
            if SpeakerManager.shared.isSpeaking || SpeakerManager.shared.isPaused {
                SpeakerManager.shared.pauseOrResume()
            } else {
                // Start speaking from beginning
                resetTypingStateFully()           // <--- important: reset timer & progress
                SpeakerManager.shared.speak(fullText)
                isTypingAllowed = true
                enableAllKeys()
                
                dictationBox.isHidden = true
                dictationBoxLabel.stringValue = "Listen and type the text"
                dictationBoxImage.image = NSImage(systemSymbolName: "headphones", accessibilityDescription: "Listen")
            }
        }else {
            guard let exercise = exercise else { return }
            resetTypingStateFully()
            updateTextDisplay()
            print("Exercise restarted!")
        }
        updateSpeakButtons()
        updateAllowedKeysHighlight()
    }
    
    @IBAction func startButtonAction(_ sender: Any?) {
        if isfromAiDictationVC {
            // Mode 2: Restart speaking from beginning
            resetTypingStateFully()
            updateAllowedKeysHighlight()
            SpeakerManager.shared.stopSpeaking()
            SpeakerManager.shared.speak(fullText)
            isTypingAllowed = true
            enableAllKeys()
            dictationBox.isHidden = true
            App.incrementFreeCount()

        } else if isfromDictationVC2ndIndex {
            // Mode 3: User finished recording → start typing
            if !RecordingManager.shared.isRecording {
                isTypingAllowed = true
                enableAllKeys()
                dictationBox.isHidden = true
                updateAllowedKeysHighlight()
            }
        } else if isfromDictationVC3rdIndex {
            // Mode 3: User finished recording → start typing
            resetTypingStateFully()
            updateAllowedKeysHighlight()
            SpeakerManager.shared.stopSpeaking()
            SpeakerManager.shared.speak(fullText)
            isTypingAllowed = true
            enableAllKeys()
            dictationBox.isHidden = true
        }
        
        updateSpeakButtons()
    }
    
    @IBAction func pauseAndPlayButtonAction(_ sender: Any?) {
        guard isfromAiDictationVC || isfromDictationVC3rdIndex else { return }
        SpeakerManager.shared.pauseOrResume()
    }
    
    @IBAction func showStringsToTypeAction(_ sender: Any?) {
            collectioinViewBox.isHidden.toggle()
    }
    
    @IBAction func speedSliderChanged(_ sender: NSSlider) {
        guard isfromAiDictationVC || isfromDictationVC3rdIndex else { return }
            
            let sliderValue = Float(sender.doubleValue)
            let speedSteps: [(rate: Float, label: String)] = [
                (0.25, "0.5x"),
                (0.35, "0.75x"),
                (0.50, "1.0x"),
                (0.55, "1.5x"),
                (0.60, "1.75x"),
                (0.65, "2.0x")
            ]
            
            let numSteps = Float(speedSteps.count - 1)
            let stepIndex = round(sliderValue * numSteps)
            let index = Int(min(max(stepIndex, 0), numSteps))
            
            SpeakerManager.shared.speechSpeed = speedSteps[index].rate
    }
}

extension PracticeVC: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return typingStrings.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("LessonCVC"), for: indexPath) as? LessonCVC else { return NSCollectionViewItem() }
        cell.img.isHidden = true
        cell.lblTitle?.stringValue = typingStrings[indexPath.item]
        cell.lblTitle?.font = NSFont.systemFont(ofSize: 16, weight: .medium)
        cell.setSeparatorColor(NSColor.border)
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        NSSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        
        let selectedtext = typingStrings[indexPath.item]
        fullText = selectedtext
        TextField.stringValue = selectedtext
        collectioinViewBox.isHidden = true
        
        collectionView.deselectAll(nil)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension PracticeVC: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        updateTextDisplay()
        updateMetrics()
    }
}

extension PracticeVC: SpeakerManagerDelegate {
    
    func speakerManagerDidStartSpeaking() {
        updateSpeakButtons()
    }
    
    func speakerManagerDidFinishSpeaking() {
        updateSpeakButtons()
    }
    
    func speakerManagerDidPauseSpeaking() {
        updateSpeakButtons()
    }
    
    func speakerManagerDidResumeSpeaking() {
        updateSpeakButtons()
    }
    
    func speakerManagerDidStopSpeaking() {
        updateSpeakButtons()
    }
}
