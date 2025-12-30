//
//  DictationVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa


class DictationVC: NSViewController {
    
    @IBOutlet weak var dictationCollectionView: NSCollectionView!
    @IBOutlet weak var mainTitle: NSTextField!
    @IBOutlet weak var backBtn: NSButton!
    
    var selectedIndexPath: IndexPath?
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
    var isFromPractice: Bool = false
    var isFromTest: Bool = false
    private let dataManager = DataManager.shared
    private var singleChapter: Chapter?

    override func viewDidLoad() {
        super.viewDidLoad()
        dictationCollectionView.dataSource = self
        dictationCollectionView.delegate = self
        
        if let selectedLesson = lesson {
            exercises = selectedLesson.exercises
        }
                
        let title = NSAttributedString(string: "\(chapterTitle ?? ""): lesson \(lesson?.lessonNumber ?? 0)", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 16, weight: .semibold) ])
        if isFromLesson {
            backBtn.isHidden = false
            mainTitle.attributedStringValue = title
        }else if isFromPractice{
            mainTitle.attributedStringValue = NSAttributedString(string: "Practice", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])
            exercises = dataManager.exercises(forChapter: "Practice")
        }else if isFromTest{
            mainTitle.attributedStringValue = NSAttributedString(string: "Test Session", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])
            exercises = dataManager.exercises(forChapter: "Test")
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
        if isFromLesson || isFromPractice || isFromTest{
            return exercises.count
        }else{
            return array.count
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("DictationCVC"), for: indexPath) as? DictationCVC else {return NSCollectionViewItem()}
        if isFromLesson || isFromPractice || isFromTest{
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
        let item = index.item
        if isFromLesson || isFromPractice || isFromTest{
            let data = exercises[index.item]
            let isFirst = index.item == 0
            let previousCompleted: Bool = !isFirst ?
                        (exercises[item - 1].isCompleted &&
                         (exercises[item - 1].exerciseStats?.accuracy ?? 0) >= 80) : true
            //            let goodAccuracy = (data.exerciseStats?.accuracy ?? 0) >= 80
            
                        if isFirst || previousCompleted {
            let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
            vc.exercise = data
            vc.chapter = chapter
            //                vc.chapterTitle = chapterTitle
            //                vc.lesson = lesson
            addChildToNavigation(vc)
                        } else {
                            showAlert(title: "", message: "Finish the previous exercise first")
                        }
        }else{
            if item == 0 {
                let vc = AiDictationVC(nibName: "AiDictationVC", bundle: nil)
                addChildToNavigation(vc)
            }else if item == 1{
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.isfromDictationVC2ndIndex = true
                addChildToNavigation(vc)
            }else if item == 2{
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.isfromDictationVC3rdIndex = true
                addChildToNavigation(vc)
            }
        }
        selectedIndex = index
        collectionView.deselectItems(at: indexPaths)
    }
}
