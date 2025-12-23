//
//  LessonVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class LessonVC: NSViewController {
    
    @IBOutlet weak var lblHomeRow: NSTextField!
    @IBOutlet weak var lblTopRow: NSTextField!
    @IBOutlet weak var lblBottomRow: NSTextField!
    @IBOutlet weak var lblFullKeyBoardRow: NSTextField!
    @IBOutlet weak var lblDifferentRow: NSTextField!
    @IBOutlet weak var CollectionViewHR: NSCollectionView!
    @IBOutlet weak var CollectionViewTR: NSCollectionView!
    @IBOutlet weak var CollectionViewBR: NSCollectionView!
    @IBOutlet weak var CollectionViewFKR: NSCollectionView!
    @IBOutlet weak var CollectionViewDR: NSCollectionView!
    
    private var chaptersByTitle: [String: Chapter] = [:]
    private let dataManager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        [CollectionViewDR,CollectionViewFKR,CollectionViewBR,CollectionViewTR,CollectionViewHR].forEach{ [weak self] cv in
            guard let self, let cv else{return}
            cv.delegate = self
            cv.dataSource = self
            cv.wantsLayer = true
            cv.layer?.cornerRadius = 20
            cv.layer?.masksToBounds = true // Bottom-left and bottom-right
        }
        
        chaptersByTitle = Dictionary(uniqueKeysWithValues: dataManager.chapters.map { ($0.title, $0) })
        
        lblHomeRow.stringValue = dataManager.chapters[0].title
        lblTopRow.stringValue = dataManager.chapters[1].title
        lblBottomRow.stringValue = dataManager.chapters[2].title
        lblDifferentRow.stringValue = dataManager.chapters[3].title
        lblFullKeyBoardRow.stringValue = dataManager.chapters[4].title
    }
    
    private func getChapter(for collectionView: NSCollectionView) -> Chapter? {
        switch collectionView {
        case CollectionViewHR:
            return chaptersByTitle["Home Row"]
        case CollectionViewTR:
            return chaptersByTitle["Top Row"]
        case CollectionViewBR:
            return chaptersByTitle["Bottom Row"]
        case CollectionViewDR:
            return chaptersByTitle["Different Rows"]
        case CollectionViewFKR:
            return chaptersByTitle["Full Keyboard"]
        default:
            return nil
        }
    }
    
}

extension LessonVC: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let chapter = getChapter(for: collectionView) else { return 0 }
        return chapter.lessons.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("LessonCVC"), for: indexPath) as? LessonCVC,
              let chapter = getChapter(for: collectionView),
              indexPath.item < chapter.lessons.count else {
            return NSCollectionViewItem()
        }
        
        let lesson = chapter.lessons[indexPath.item]
        cell.lblTitle?.stringValue = "Lesson \(lesson.lessonNumber)"
        cell.Box.wantsLayer = true
        
        if collectionView == CollectionViewHR {
            cell.Box.layer?.backgroundColor = NSColor.homeRowColor1.cgColor
        } else if collectionView == CollectionViewTR {
            cell.Box.layer?.backgroundColor = NSColor.topRowColor1.cgColor
        } else if collectionView == CollectionViewBR {
            cell.Box.layer?.backgroundColor = NSColor.bottomRowColor1.cgColor
        } else if collectionView == CollectionViewFKR {
            cell.Box.layer?.backgroundColor = NSColor.fullKeyColor1.cgColor
        } else if collectionView == CollectionViewDR {
            cell.Box.layer?.backgroundColor = NSColor.differentRowColor1.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 200, height: 60)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
              let chapter = getChapter(for: collectionView),
              indexPath.item < chapter.lessons.count else { return }
        
        let selectedLesson = chapter.lessons[indexPath.item]
        
        let vc = DictationVC(nibName: "DictationVC", bundle: nil)
        vc.lesson = selectedLesson
        vc.chapter = dataManager.chapters  // Pass full chapters array
        vc.chapterTitle = chapter.title
        vc.isFromLesson = true
        
        addChildToNavigation(vc)
        
        collectionView.deselectAll(nil)
    }
}
