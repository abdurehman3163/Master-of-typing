//
//  DictationVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class DictationVC: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var mainTitle: NSTextField!
    @IBOutlet weak var backBtn: NSButton!
    
    var mainTitleText: String?
    let array: [[String: String]] = [ ["title": "Write dictations and memorize with AI", "image" : "imgDictationAI"],
                                      ["title": "Dictate the text and than type it", "image" : "imgDictationSpeak"],
                                      ["title": "Select the suggested text and type it at dictation", "image" : "imgDictationListen"]]
    
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    var lesson: Lesson?
    var chapter: [Chapter]?
    var exercises: [Exercise] = [] // Exercises to be displayed in the collection view
    var chapterTitle: String?
    var isFromLesson: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let selectedLesson = lesson {
            exercises = selectedLesson.exercises
        }
        
        let title = NSAttributedString(string: "\(chapterTitle ?? ""): lesson \(lesson?.lessonNumber ?? 0)", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 16, weight: .semibold) ])
        if isFromLesson {
            backBtn.isHidden = false
            mainTitle.attributedStringValue = title
        }else{
            mainTitle.attributedStringValue = NSAttributedString(string: "Dictation", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])

        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        removeChildFromNavigation()
    }
    
    func showAlert(title: String, message: String) {
            let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

extension DictationVC: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFromLesson {
            return exercises.count
        }else{
            return array.count
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("DictationCVC"), for: indexPath) as? DictationCVC else {return NSCollectionViewItem()}
        if isFromLesson{
            let data = exercises[indexPath.item]
            cell.titleLabel.stringValue = data.title
            cell.image.image = nil
            cell.image.isHidden = true
            cell.boxLabel.isHidden = true
        }else {
            let data = array[indexPath.item]
            cell.titleLabel.stringValue = data["title"] ?? ""
            cell.image.image = NSImage(named: data["image"] ?? "")
            cell.button.image = NSImage(systemSymbolName: "arrow.forward", accessibilityDescription: "")
            cell.boxLabel.isHidden = !(indexPath.item == 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.frame.width, height: 56)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first else {return}
        
        if isFromLesson{
            let data = exercises[index.item]
            let isFirst = index.item == 0
            let previousCompleted = !isFirst && exercises[index.item - 1].isCompleted
//            let goodAccuracy = (data.exerciseStats?.accuracy ?? 0) >= 80

            if isFirst || previousCompleted {
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.exercise = data
                vc.chapter = chapter
                addChildToNavigation(vc)
            } else {
                showAlert(title: "", message: "Finish the previous exercise first or achieve at least 80% accuracy.")
            }
        }else{
            
        }
        selectedIndex = index
        collectionView.deselectItems(at: indexPaths)
    }
}
