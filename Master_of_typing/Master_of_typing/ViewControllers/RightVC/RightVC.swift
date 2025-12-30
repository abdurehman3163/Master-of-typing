//
//  RightVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

protocol ResettableViewController {
    func resetToInitialState()
}

class RightVC: NSCollectionViewItem, NSTabViewDelegate {
    
    @IBOutlet weak var tabView: NSTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.delegate = self  // ← Important!
        registerTabView()
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let selectedVC = tabViewItem?.viewController else { return }
        
        // Call a reset method on the selected view controller
        if let resettable = selectedVC as? ResettableViewController {
            resettable.resetToInitialState()
        }
    }
}
//
extension RightVC{
    
    func registerTabView(){
        let vc1 = NSTabViewItem(viewController: LessonVC())
        let vc2 = NSTabViewItem(viewController: StatsVC())
        let d3 = DictationVC()
        d3.isFromPractice = true
        let vc3 = NSTabViewItem(viewController: d3)
        let vc4 = NSTabViewItem(viewController: DictationVC())
        let d5 = DictationVC()
        d5.isFromTest = true
        let vc5 = NSTabViewItem(viewController: d5)
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
