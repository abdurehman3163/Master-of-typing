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
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnStartBox: NSBox!
    
    let array = ["Voice Type","Dictation Speed"]
    var selectedIndex: IndexPath?
    var speechSpeed: Float = 1.0
    var VoiceType: String = "com.apple.ttsbundle.siri_aaron_en-US_compact"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        textView.delegate = self
        updateStartButtonState()
    }
    
    private func updateStartButtonState() {
            let text = textView.string.trimmingCharacters(in: .whitespacesAndNewlines)
            let isEmpty = text.isEmpty
            
            // Animate the changes for a smooth feel
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                
                self.btnStartBox.alphaValue = isEmpty ? 0.5 : 1.0
                self.btnStart.isEnabled = !isEmpty
            }
        }
    
    @IBAction func btnStartAction(_ sender: Any?) {
        let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
        vc.speechSpeed = speechSpeed
        vc.VoiceType = VoiceType
        vc.isfromAiDictationVC = true
        vc.text = textView.string
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
            updateStartButtonState()
        }
        
        // Optional: Also handle paste, drag-drop, etc.
        func textDidEndEditing(_ notification: Notification) {
            updateStartButtonState()
        }
    
}
