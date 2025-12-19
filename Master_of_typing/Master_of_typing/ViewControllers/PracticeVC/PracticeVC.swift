//
//  PracticeVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class PracticeVC: NSViewController {
    
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
    
    var chapter: [Chapter]?
    var exercise: Exercise?
    var viewArray: [ButtonBox] = []
    var allowedKeys: [Int] = []
    var cpmValue: Int?
    var wpmValue: Int?
    var accuracyValue: Int?
    
    private var tagToButtonBox: [Int: ButtonBox] = [:]  // Fast lookup: keyCode/tag → ButtonBox
    private var currentAllowedTags: Set<Int> = []
    private var currentIndex: Int = 0
    private var typedCharacters: [Character] = []  // User's typed chars (for comparison)
    private var startTime: Date?
    private var isFirstKeyPressed = false
    private var correctCharacters: Int = 0 // Track correct characters typed
    private var elapsedTime: TimeInterval = 0 // Track elapsed time for timer
    private var stopwatchTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let exercise = exercise else {return}
        TextField.stringValue = exercise.text
        //        TextField.delegate = self
        currentIndex = 0
        typedCharacters.removeAll()
        isFirstKeyPressed = false
        startTime = nil
        correctCharacters = 0
        elapsedTime = 0
        
        viewArray = [keyTiledAndGrave,key1AndEXCLAMATORY,key2AndAtRateOf,key3AndHash,key4AndDolor,key5AndModuel,key6AndCaret,key7AndAnd,key8AndAsteric,key9AndLeftParentheses,key0AndRightParentheses,keyMinusAndDash,keyEqualsAndPlus,keyDelete,keyTab,keyQ,keyW,keyE,keyR,keyT,keyY,keyU,keyI,keyO,keyP,keyBoxAndCurlyBracesLeft,keyBoxAndCurlyBracesRight,keyBackSlashAndPipe,keyCapsLock,keyA,keyS,keyD,keyF,keyG,keyH,keyJ,keyK,keyL,keyColonAndSemiColon,keyQuotationBoth,keyReturn,keyShiftLeft,keyZ,keyX,keyC,keyV,keyB,keyN,keyM,keyCommaAndLessthan,keyFullStopAndGreaterthan,keySlashAndQuestion,keyShiftRight,keyFuntion,keyControl,keyOption, keyCommand1,keySpacebar,keyCommand2, keyBack,keyFarword, keyUp,keyDown]
        
        tagToButtonBox.removeAll()
        currentAllowedTags = Set(exercise.allowedKeys)
        
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
    
    private func setupKeyHighlighting() {
        // Key down
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyPress(event: event, pressed: true)
            return event  // Let event continue (e.g., to TextField)
        }
        
        // Key up
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
        
        // Backspace
        if keyCode == 51 {
            guard currentIndex > 0 && currentIndex <= (exercise?.text.count ?? 0) else { return }
            typedCharacters.removeLast()
            currentIndex -= 1
            updateTextDisplay()
            updateMetrics()
            return
        }
        
        let typedChar = characters[characters.startIndex]
        
        // Block extra typing after completion
        guard currentIndex < (exercise?.text.count ?? 0) else { return }
        
        typedCharacters.append(typedChar)
        currentIndex += 1
        
        // Accuracy
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
        
        // Completion — only once
        if currentIndex >= (exercise?.text.count ?? 0) {
            exercise?.isCompleted = true
            
            let exerciseStats = ExerciseStats(wpm: wpmValue ?? 0, cpm: cpmValue ?? 0, time: 0, accuracy: accuracyValue ?? 0)
            exercise?.exerciseStats = exerciseStats
            stopStopwatch()
            DataManager.shared.saveData()
            
            exerciseFinished()  // Show results, next button, etc.
        }
    }
    
    private func updateTextDisplay() {
        guard let exercise = exercise else { return }
        let fullText = exercise.text
        let nsText = fullText as NSString
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultFont = NSFont.systemFont(ofSize: 24) // Adjust size as needed
        let grayColor = NSColor.black
        let greenColor = NSColor.systemGreen
        let redColor = NSColor.systemRed
        let currentCharColor = NSColor.systemBlue
        
        // Default style: gray
        attributedString.addAttribute(.foregroundColor, value: grayColor, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.font, value: defaultFont, range: NSRange(location: 0, length: fullText.count))
        
        // Style typed characters
        for i in 0..<min(currentIndex, typedCharacters.count) {
            let expectedChar = (i < fullText.count) ? fullText[fullText.index(fullText.startIndex, offsetBy: i)] : nil
            let typedChar = typedCharacters[i]
            
            // Check if the expected character is space
            var charToCompare = String(typedChar)
            
            if expectedChar == " " && typedChar != expectedChar {
                // Replace incorrect space with "⧫"
                charToCompare = "*"
            }
            
            // Set color for correct or incorrect typing
            let color: NSColor = (typedChar == expectedChar) ? greenColor : redColor
            
            // Add the color attribute for the current character
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: i, length: 1))
            
            // If space is typed incorrectly, replace it with "⧫"
            if expectedChar == " " && typedChar != expectedChar {
                attributedString.replaceCharacters(in: NSRange(location: i, length: 1), with: "*")
            }
        }
        
        // Highlight current character (next to type)
        if currentIndex < fullText.count {
            attributedString.addAttribute(.foregroundColor, value: currentCharColor, range: NSRange(location: currentIndex, length: 1))
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: currentIndex, length: 1))
            attributedString.addAttribute(.underlineColor, value: currentCharColor, range: NSRange(location: currentIndex, length: 1))
        }
        
        // Optional: make current char bolder
        if currentIndex < fullText.count {
            let boldFont = NSFont.boldSystemFont(ofSize: 26)
            attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: currentIndex, length: 1))
        }
        
        TextField.attributedStringValue = attributedString
        
        // Auto-scroll to keep current character visible
        scrollToCurrentCharacter()
    }
    
    private func updateMetrics() {
        //        guard let startTime = startTime else { return }
        
        //        let elapsedTime = Date().timeIntervalSince(startTime)
        
        // Prevent huge spikes at start
        guard elapsedTime >= 0.5 else {
            cpm.stringValue = "0"
            wpm.stringValue = "0"
            accuracy.stringValue = "0 %"
            timer.stringValue = "00.00"
            return
        }
        
        // CPM
        let cpmvalue = Double(currentIndex) / (elapsedTime / 60.0)
        cpm.stringValue = String(format: "%.0f", cpmvalue)
        cpmValue = Int(cpmvalue.rounded())
        
        // WPM
        let wpmvalue = cpmvalue / 5.0
        wpm.stringValue = String(format: "%.0f", wpmvalue)
        wpmValue = Int(wpmvalue.rounded())
        // Accuracy
        let accuracyvalue: Double = currentIndex > 0 ? (Double(correctCharacters) / Double(currentIndex)) * 100.0 : 100.0
        accuracy.stringValue = String(format: "%.0f %%", accuracyvalue)
        accuracyValue = Int(accuracyvalue.rounded())
    }
    
    private func updateTimerDisplay() {
        guard let timerLabel = timer else { return }  // Your @IBOutlet weak var timer: NSTextField!
        
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let hundredths = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        
        //        if minutes > 0 {
        //            timer.stringValue = String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
        //        } else {
        timer.stringValue = String(format: "%02d.%02d", minutes, seconds)
        //        }
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
    
    private func scrollToCurrentCharacter() {
        guard let textView = TextField.enclosingScrollView?.documentView as? NSTextView,
              currentIndex < exercise?.text.count ?? 0 else { return }
        
        let range = NSRange(location: currentIndex, length: 1)
        
        // This scrolls the text field to show the current character centered
        textView.scrollRangeToVisible(range)
    }
    
    private func stopStopwatch() {
        stopwatchTimer?.invalidate()
        stopwatchTimer = nil
    }
    
    private func exerciseFinished() {
        // TODO: Show results, WPM, etc.
        print("Exercise complete!")
        // Example: let elapsed = Date().timeIntervalSince(startTime ?? Date())
        // WPM = (currentIndex / 5) / (elapsed / 60)
    }
    
    @IBAction func backButton(_ sender: Any?) {
        removeChildFromNavigation()
    }
    
    @IBAction func btnRestartExcersieAction(_ sender: Any?){
        guard let exercise = exercise else { return }
        
        // Reset all typing state
        currentIndex = 0
        typedCharacters.removeAll()
        correctCharacters = 0
        isFirstKeyPressed = false
        elapsedTime = 0.0
        
        // Stop and reset timer
        stopStopwatch()
        updateTimerDisplay()
        
        // Reset stats display
        cpm.stringValue = "0"
        wpm.stringValue = "0"
        accuracy.stringValue = "100 %"
        timer.stringValue = "00.00"
        
        // Clear completion flag (so user can complete it again if needed)
        
        // Redraw text (all gray, first char highlighted)
        updateTextDisplay()
        
        // Optional: Give feedback
        print("Exercise restarted!")
    }
}
