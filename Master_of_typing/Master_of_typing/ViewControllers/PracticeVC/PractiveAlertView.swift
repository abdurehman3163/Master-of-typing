//
//  PractiveAlertView.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 30/12/2025.
//

import Cocoa

class PractiveAlertView: NSViewController {
    
    @IBOutlet weak var exitBtn: NSButton!
    @IBOutlet weak var exitBox: NSBox!
    @IBOutlet weak var nextBtn: NSButton!
    @IBOutlet weak var nextBox: NSBox!
    @IBOutlet weak var alertDesc1: NSTextField!
    @IBOutlet weak var alertDesc2: NSTextField!
    @IBOutlet weak var alertDesc3: NSTextField!
    @IBOutlet weak var alertImage: NSImageView!
    
    var isblow80: Bool = false
    var isFromTest: Bool = false
    var isLessonCompleted: Bool = false
    // Closure to call when buttons are pressed
    var onNext: (() -> Void)?
    var onExit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isblow80 {
            if isFromTest {
                alertDesc1.stringValue = "Time's Up!"
                alertDesc2.stringValue = "You ran out of time. Try again to improve your speed!"
                alertDesc3.isHidden = true
                nextBtn.title = "Retry"
                exitBox.isHidden = true
                alertImage.isHidden = true
            }else{
                alertDesc1.isHidden = true
                alertDesc2.stringValue = "You have completed this exercise with more than 5 mistakes. We recommend you to attempt this exercise again."
                alertDesc3.isHidden = true
                nextBtn.title = "Retry"
                exitBox.isHidden = true
                alertImage.isHidden = false
            }
        }else{
            if isLessonCompleted {
                alertDesc1.stringValue = "Congratulations!"
                alertDesc2.stringValue = "Well Done! You have Completed the whole lesson?"
                alertDesc3.isHidden = true
                alertImage.isHidden = true
                nextBox.isHidden = true
                exitBtn.title = "Exit"
                exitBox.isHidden = false

            }else{
                alertDesc1.isHidden = false
                alertDesc2.stringValue = "Ready to start your next lesson?"
                alertDesc3.isHidden = false
                alertImage.isHidden = true
                nextBtn.title = "Next "
                exitBtn.title = "Exit"
                exitBox.isHidden = false
            }
        }
    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        dismiss(self)
        onExit?()
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        dismiss(self)
        onNext?()
    }
}
