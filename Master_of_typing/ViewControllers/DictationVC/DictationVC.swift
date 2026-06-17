//
//  DictationVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa


class DictationVC: BaseVC, LessonCompleted {
    func lessonCompleted() {
        delegate?.lessonCompleted()
    }
    
    
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

    weak var delegate: LessonCompleted?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        dictationCollectionView.dataSource = self
        dictationCollectionView.delegate = self
        
        if let selectedLesson = lesson {
            exercises = selectedLesson.exercises
        }
    }
    
    override func languageDidChange() {
        view.localizeSubviews()
        setTitle()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            dictationCollectionView.reloadData()
        }
       
    }
    
    override func viewWillAppear() {
        dictationCollectionView.reloadData()
        setTitle()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        dictationCollectionView.collectionViewLayout?.invalidateLayout()
    }

    
    func setTitle(){
        
        let title = NSAttributedString(string: "\(chapterTitle?.localized() ?? ""): " + "Lesson".localized() + " \(lesson?.lessonNumber ?? 0)", attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 16, weight: .semibold) ])
        if isFromLesson {
            backBtn.isHidden = false
            mainTitle.attributedStringValue = title
        }else if isFromPractice{
            mainTitle.attributedStringValue = NSAttributedString(string: "Practice".localized(), attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])
            exercises = dataManager.exercises(forChapter: "Practice")
        }else if isFromTest{
            mainTitle.attributedStringValue = NSAttributedString(string: "Test Session".localized(), attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])
            exercises = dataManager.exercises(forChapter: "Test")
        }else{
            mainTitle.attributedStringValue = NSAttributedString(string: "Dictation".localized(), attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24, weight: .bold) ])

        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        removeChildFromNavigation()
    }
    
    override func showAlert(title: String, message: String) {
            let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK".localized())
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
            
            let isFirst = indexPath.item < 1
            let isProUser = App.isPro
            // ← Your existing Pro check
            if isFromPractice || isFromTest {
                if isFirst || isProUser {
                    // No lock for first exercise or Pro users
                    cell.farwardArrowImage.image = NSImage(systemSymbolName: "arrow.forward", accessibilityDescription: "")
                } else {
                    cell.farwardArrowImage.image = .imgLessonLock
                }
            }
        }else {
            let isFirst = indexPath.item == 0
            let isProUser = App.isPro
            let data = array[indexPath.item]
            cell.titleLabel.stringValue = data["title"]?.localized() ?? ""
            cell.NewLabel.stringValue = "New".localized()
            cell.image.image = NSImage(named: data["image"] ?? "")
            cell.boxLabel.isHidden = !(indexPath.item == 0)
            
            if isFirst || isProUser {
                // No lock for first exercise or Pro users
                cell.farwardArrowImage.image = NSImage(systemSymbolName: "arrow.forward", accessibilityDescription: "")
            } else {
                cell.farwardArrowImage.image = .imgLessonLock
            }

        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.frame.width, height: 56)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first else {return}
        collectionView.deselectItems(at: indexPaths)
        let item = index.item
        let isProUser = App.isPro
        if isFromLesson || isFromPractice || isFromTest{
            let data = exercises[index.item]
            let isFirst = index.item < 1
            let previousCompleted: Bool = !isFirst ?
            (exercises[item - 1].isCompleted &&
             (exercises[item - 1].exerciseStats?.accuracy ?? 0) >= 80) : true
            //            let goodAccuracy = (data.exerciseStats?.accuracy ?? 0) >= 80
            
            if isFromPractice || isFromTest{
                if !isFirst && !isProUser {
                    Utility.showProScreen(caller: self)
                    collectionView.deselectItems(at: indexPaths)
                    return
                }
            }
            if isFirst || previousCompleted {
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.exercise = data
                vc.chapter = chapter
                //                vc.chapterTitle = chapterTitle
                vc.lesson = lesson
                vc.delegate = self
                if isFromPractice {
                        // Create a temporary lesson containing ALL Practice exercises
                    let practiceLesson = Lesson(
                            lessonNumber: 1,
                            exercises: exercises  // All Practice exercises
                            // id is optional — defaults to a new UUID
                        )
//                        practiceLesson.title = "Practice Session"  // if you add title later

                        vc.lesson = practiceLesson
                        vc.isFromPractice = true

                } else if isFromTest {
                    let testLesson = Lesson(
                            lessonNumber: 1,
                            exercises: exercises
                        )
//                        testLesson.title = "Test Session"

                        vc.lesson = testLesson
                        vc.isFromTest = true
                }
                addChildToNavigation(vc)
                pushedViewController = vc
            } else {
                showAlert(title: "", message: "Finish the previous exercise first".localized())
            }
            
        }else{
            if item == 0 {
                let vc = AiDictationVC(nibName: "AiDictationVC", bundle: nil)
                addChildToNavigation(vc)
                pushedViewController = vc
            }else if item == 1{
                if !isProUser {
                    Utility.showProScreen(caller: self)
                    return
                }
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.isfromDictationVC2ndIndex = true
                addChildToNavigation(vc)
                pushedViewController = vc
            }else if item == 2{
                if !isProUser {
                    Utility.showProScreen(caller: self)
                    return
                }
                let vc = PracticeVC(nibName: "PracticeVC", bundle: nil)
                vc.isfromDictationVC3rdIndex = true
                addChildToNavigation(vc)
                pushedViewController = vc
            }
        }
        selectedIndex = index
       
    }
}
