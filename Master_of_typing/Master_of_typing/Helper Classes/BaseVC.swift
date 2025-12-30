
import Cocoa
import Reachability
import Vision
import PDFKit
import StoreKit

class BaseVC: NSViewController {
    
    weak var pushedViewController: NSViewController?
    var hud: MBProgressHUD!
    var isNetConnected: Bool {
        return ReachabilityManager.shared.netConnected
    }
    var appearanceObserver: NSKeyValueObservation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearanceObserver = NSApp.observe(\.effectiveAppearance) { [weak self] _, _ in
            self?.appearanceChanged()
        }
        
        languageDidChange()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appProStatusDidChange), name: .appProStatusDidChange, object: nil)
    }
    
    func removePushedViewController() {
        pushedViewController?.removeChild()
    }
    
    func showPremiumScreen() {
        mainQueue { [weak self] in
            guard let self else { return }
            let controller = ProVC()
            presentAsSheet(controller)
        }
    }
    
    @objc func languageDidChange() {
//        view.localizeSubviews()
    }
    func appearanceChanged() {}
    @objc func appProStatusDidChange() {}
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            Utility.dialogOK(question: title, text: message)
        }
    }
    
    func showReviewPopup() {
        DispatchQueue.main.async {
            if #available(macOS 13.0, *) {
                AppStore.requestReview(in: self)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    //MARK: Progress HUD
    func showHud(hudView: NSView) -> Void {
        if ReachabilityManager.shared.netConnected {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                self.hud = MBProgressHUD.showAdded(to: hudView, animated: true)
            }
        } else {
            self.hideHud()
        }
    }
    
    func hideHud() -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let parentView = self.parent{
                if parentView.view.isKind(of: DisableInteraction.self) {
                    (parentView.view as! DisableInteraction).userInteractionEnabled = true
                }
            } else {
                if self.view.isKind(of: DisableInteraction.self){
                    (self.view as! DisableInteraction).userInteractionEnabled = true
                }
            }
            self.hud?.hide(true)
        }
    }
    
    deinit {
        appearanceObserver = nil
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Objective C Functions
//extension BaseVC{
//    @objc func checkAppStatus(){}
//    @objc func appLanguageChanged(){/*view.localizeSubviews()*/}
//    @objc func appThemeChanged(){}
//    @objc func showFullScreenWindow(){}
//    @objc func showMinimumScreenWindow(){}
////    @objc func showProScreen(){Utility.showProScreen(caller: self)}
//    @objc func lightModeChanged() {
//        //        let currentMode = ThemeManager.getSavedTheme()
//        //        let newMode: ThemeMode = (currentMode == .light) ? .dark : .light
//        //        ThemeManager.saveTheme(mode: newMode)
//    }
//    
//    func showAlert(title: String, message: String) {
//        DispatchQueue.main.async {
//            Utility.dialogOK(question: title, text: message)
//        }
//    }
//    
//    func showHud(hudView: NSView) -> Void {
//        if ReachabilityManager.shared.netConnected {
//            DispatchQueue.main.async {[weak self] in
//                guard let self = self else {return}
//                self.hud = MBProgressHUD.showAdded(to: hudView, animated: true)
//            }
//        } else {
//            self.hideHud()
//        }
//    }
//    
//    func hideHud() -> Void {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            if let parentView = self.parent{
//                if parentView.view.isKind(of: DisableInteraction.self) {
//                    (parentView.view as! DisableInteraction).userInteractionEnabled = true
//                }
//            } else {
//                if self.view.isKind(of: DisableInteraction.self){
//                    (self.view as! DisableInteraction).userInteractionEnabled = true
//                }
//            }
//            self.hud?.hide(true)
//        }
//    }
//    
//    func applyShadow(to box: NSBox) {
//        // Ensure the box has a layer
//        box.wantsLayer = true
//        
//        // Set the shadow properties
//        box.layer?.shadowColor = NSColor.white.cgColor      // Shadow color
//        box.layer?.shadowOpacity = 0.5                      // Shadow opacity (0.0 to 1.0)
//        box.layer?.shadowOffset = CGSize(width: 0, height: -3) // Shadow offset (horizontal, vertical)
//        box.layer?.shadowRadius = 5.0                       // Shadow blur radius
//        
//        // Disable content clipping so shadow is visible outside the box bounds
//        box.layer?.masksToBounds = false
//    }
//
//}

//extension BaseVC {
//    func restore() {
//        Task {
//            showHud(hudView: view)
//            do {
//                try await StoreManager.shared.restore()
//                hideHud()
//            } catch {
//                showAlert(title: "Error", message: "Failed to restore purchase, please try again later.")
//                hideHud()
//            }
//        }
//    }
//}
