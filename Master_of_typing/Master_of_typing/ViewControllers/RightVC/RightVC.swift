//
//  RightVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class RightVC: NSCollectionViewItem {
    
    @IBOutlet weak var tabView: NSTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTabView()
    }
}
//
extension RightVC{
    
    func registerTabView(){
        let vc1 = NSTabViewItem(viewController: LessonVC())
        let vc2 = NSTabViewItem(viewController: StatsVC())
        let vc3 = NSTabViewItem(viewController: PracticeVC())
        let vc4 = NSTabViewItem(viewController: DictationVC())
        let vc5 = NSTabViewItem(viewController: TestVC())
        tabView.addTabViewItem(vc1)
        tabView.addTabViewItem(vc2)
        tabView.addTabViewItem(vc3)
        tabView.addTabViewItem(vc4)
        tabView.addTabViewItem(vc5)
    }
}

extension RightVC: GetSelectedViewControllerProtocol{
    func getSelectedIndex(index: Int) {
        Task{ @MainActor in
            tabView.selectTabViewItem(at: index)
        }
    }
}
