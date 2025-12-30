//
//  LessonVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class LessonVC: BaseVC {
    
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
        updateRowLabels()
        
        if App.isNotPro {
//            if RemoteConfigManager.sharedInstance.fetchComplete == true {
                showPremiumScreen()
//            } else {
//                RemoteConfigManager.sharedInstance.loadingDoneCallback = { [weak self] in
//                    self?.showPremiumScreen()
//                }
//            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Reload collection views in case completion status changed (e.g., checkmarks)
        [CollectionViewHR, CollectionViewTR, CollectionViewBR, CollectionViewFKR, CollectionViewDR].forEach { $0?.reloadData() }
        
        // Update progress numbers
        updateRowLabels()
    }
    
    private func updateRowLabels() {
        let chapters = DataManager.shared.chapters
        
        // Helper to find chapter by title and compute progress
        func progress(for title: String) -> (completed: Int, total: Int) {
            guard let chapter = chapters.first(where: { $0.title == title }) else {
                return (0, 0)
            }
            return (chapter.completedLessons, chapter.numberOfLessons)
        }
        
        let home = progress(for: "Home Row")
        lblHomeRow.stringValue = "Home Row (\(home.completed)/\(home.total))"
        
        let top = progress(for: "Top Row")
        lblTopRow.stringValue = "Top Row (\(top.completed)/\(top.total))"
        
        let bottom = progress(for: "Bottom Row")
        lblBottomRow.stringValue = "Bottom Row (\(bottom.completed)/\(bottom.total))"
        
        let different = progress(for: "Different Rows")
        lblDifferentRow.stringValue = "Different Rows (\(different.completed)/\(different.total))"
        
        let full = progress(for: "Full Keyboard")
        lblFullKeyBoardRow.stringValue = "Full Keyboard (\(full.completed)/\(full.total))"
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
    
    @IBAction func settingMenuBtn(_ sender: NSButton) {
        let menu = NSMenu()

        // Upgrade to Pro
        let upgradeItem = NSMenuItem()
        upgradeItem.title = "Upgrade to Pro"
        upgradeItem.image = .imgSettingCrown
        upgradeItem.target = self
        upgradeItem.action = #selector(upgradeToProTapped) // Replace with your actual selector
        menu.addItem(upgradeItem)

        // Restore Purchases
        let restoreItem = NSMenuItem()
        restoreItem.title = "Restore Purchase"
        restoreItem.image = .imgSettingRestore
        restoreItem.target = self
        restoreItem.action = #selector(restorePurchasesTapped) // Replace with your actual selector
        menu.addItem(restoreItem)

        // Separator (optional, for visual grouping)
        menu.addItem(NSMenuItem.separator())

        // Rate us
        let rateItem = NSMenuItem()
        rateItem.title = "Rate us"
        rateItem.image = .imgSettingRateUs
        rateItem.target = self
        rateItem.action = #selector(rateAppTapped) // Replace with your actual selector
        menu.addItem(rateItem)

        // Share us
        let shareItem = NSMenuItem()
        shareItem.title = "Share us"
        shareItem.image = .imgSettingShare
        shareItem.target = self
        shareItem.action = #selector(shareAppTapped) // Replace with your actual selector
        menu.addItem(shareItem)

        // Support
        let supportItem = NSMenuItem()
        supportItem.title = "Support"
        supportItem.image = .imgSettingSupport
        supportItem.target = self
        supportItem.action = #selector(supportTapped) // Replace with your actual selector
        menu.addItem(supportItem)

        let location = sender.convert(sender.frame.origin, to: sender)
        menu.popUp(positioning: nil, at: location, in: sender.superview)
    }
    
    @objc  func upgradeToProTapped(){
        Utility.showProScreen(caller: self)
    }
    @objc  func restorePurchasesTapped(){
        showHud(hudView: view)
        Task {
            do {
                try await StoreManager.shared.restore()
                hideHud()
            } catch {
                hideHud()
                showAlert(title: "Error", message: "Failed to restore purchase, please try again later.")
            }
        }
    }
    @objc  func rateAppTapped(){
        Utility.rateApp(appId: AppConstants.appIDForShowingApp) { _ in}
    }
    @objc  func shareAppTapped(){
        Utility.shareApp(appId: AppConstants.appIDForShowingApp, sender: view)
    }
    @objc  func supportTapped(){
        Utility.openEmail(address: AppConstants.supportEmail, subject: AppConstants.AppName + "Support", body: "")
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
        let isFirstLesson = indexPath.item == 0
        let isProUser = App.isPro  // ← Your Pro check

        cell.lblTitle?.stringValue = "Lesson \(lesson.lessonNumber)"
        cell.Box.wantsLayer = true
        
        if collectionView == CollectionViewHR {
            cell.Box.layer?.backgroundColor = NSColor.homeRowColor1.cgColor
            cell.img.contentTintColor = .homeRow
        } else if collectionView == CollectionViewTR {
            cell.Box.layer?.backgroundColor = NSColor.topRowColor1.cgColor
            cell.img.contentTintColor = .topRow
        } else if collectionView == CollectionViewBR {
            cell.Box.layer?.backgroundColor = NSColor.bottomRowColor1.cgColor
            cell.img.contentTintColor = .bottomRow
        } else if collectionView == CollectionViewFKR {
            cell.Box.layer?.backgroundColor = NSColor.fullKeyColor1.cgColor
            cell.img.contentTintColor = .fullKey
        } else if collectionView == CollectionViewDR {
            cell.Box.layer?.backgroundColor = NSColor.differentRowColor1.cgColor
            cell.img.contentTintColor = .differentRow
        }
        
        if isFirstLesson || isProUser {
                cell.img.isHidden = true  // First lesson always unlocked + Pro users see no locks
            } else {
                cell.img.isHidden = false
                cell.img.image = .imgLessonLock
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
        
        let isFirstLesson = indexPath.item == 0
            let isProUser = App.isPro  // ← Your Pro check
        
        if !isFirstLesson && !isProUser {
                Utility.showProScreen(caller: self)  // ← Reuse your existing Pro screen
                collectionView.deselectItems(at: indexPaths)
                return
            }
        
        let selectedLesson = chapter.lessons[indexPath.item]
        
        let vc = DictationVC(nibName: "DictationVC", bundle: nil)
        vc.lesson = selectedLesson
        vc.chapter = dataManager.chapters  // Pass full chapters array
        vc.chapterTitle = chapter.title
        vc.isFromLesson = true
        
        addChildToNavigation(vc)
        pushedViewController = vc
        collectionView.deselectItems(at: indexPaths)
    }
}
