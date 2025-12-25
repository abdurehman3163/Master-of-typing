//
//  AiDictationVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 18/12/2025.
//

import Cocoa

class AiDictationVC: NSCollectionViewItem {

//    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var CollectionView: NSCollectionView!
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var characterCountLabel: NSTextField!
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnStartBox: NSBox!
    
    let array = ["Voice Type","Dictation Speed"]
    var selectedIndex: IndexPath?
    var speechSpeed: Float = 0.5
    var VoiceType: String = "com.apple.ttsbundle.siri_aaron_en-US_compact"
    private let maxCharacters = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        textView.delegate = self
//        updateStartButtonState()
        updateCharacterCountAndStyle()
    }
    
    private func updateCharacterCountAndStyle() {
            let text = textView.string
            let characterCount = text.count  // Includes spaces and newlines
        characterCountLabel.stringValue = "\(characterCount)/\(maxCharacters)"

            // Update label
            if characterCount > maxCharacters {
                characterCountLabel.stringValue = "\(characterCount)/\(maxCharacters)"
                characterCountLabel.textColor = NSColor.systemRed
                
                // Turn all text red
                textView.textColor = NSColor.systemRed
                
                // Disable Start button
                btnStartBox.alphaValue = 0.5
                btnStart.isEnabled = false
            } else {
                characterCountLabel.stringValue = "\(characterCount)/\(maxCharacters)"
                characterCountLabel.textColor = NSColor.black
                
                // Normal black text
                textView.textColor = NSColor.black  // or .black
                
                // Enable Start button only if not empty
                let isEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                btnStartBox.alphaValue = isEmpty ? 0.5 : 1.0
                btnStart.isEnabled = !isEmpty
            }
        }
    
    @IBAction func btnStartAction(_ sender: Any?) {
        let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
        vc.speechSpeed = speechSpeed
        vc.VoiceType = VoiceType
        vc.isfromAiDictationVC = true
        let cleanedText = textView.string
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")    // Also handles Windows newlines
            .trimmingCharacters(in: .whitespacesAndNewlines)  // Clean start/end

        // Optional: collapse multiple spaces into one
        let finalText = cleanedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        vc.text = finalText
        addChildToNavigation(vc)
    }
    
    @IBAction func backButtonAction(_ sender: Any?) {
        removeChildFromNavigation()
    }
}

extension AiDictationVC: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("DictationCVC"), for: indexPath) as? DictationCVC else { return NSCollectionViewItem() }
        cell.titleLabel.stringValue = array[indexPath.item]
        cell.image.isHidden = true
        cell.boxLabel.isHidden = true
        cell.button.image = .imgMenuPopdown
        cell.weidth.constant = 102
        cell.speechDelegate = self
        if indexPath.item == 0 {
            cell.isVoiceType = true
            cell.button.title = "Aaron"
        }else if indexPath.item == 1 {
            cell.isDictationSpeed = true
            cell.button.title = "1.0x"
        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.frame.width, height: 56)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first else { return }
        self.selectedIndex = index
        
    }
}

extension AiDictationVC: SpeechSpeedDelegate, NSTextViewDelegate {
    func didChangeVoice(to voice: String) {
        VoiceType = voice
    }
    
    func didChangeSpeechSpeed(to speed: Float) {
        speechSpeed = speed
    }
    
    func textDidChange(_ notification: Notification) {
            // This is called every time the text changes
        updateCharacterCountAndStyle()
    }
        
        // Optional: Also handle paste, drag-drop, etc.
        func textDidEndEditing(_ notification: Notification) {
            updateCharacterCountAndStyle()
        }
    
}
