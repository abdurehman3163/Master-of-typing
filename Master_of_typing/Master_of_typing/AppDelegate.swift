//
//  AppDelegate.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let splitViewController: NSSplitViewController = NSSplitViewController()
    var leftView: LeftVC?
    var rightView: RightVC?
    var window: NSWindow!
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        goToHomeScreen(contentVC: splitViewController)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if let keyPressed = event.charactersIgnoringModifiers {
                print("Global key press detected: \(keyPressed)")
            }
        }

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

func goToHomeScreen(contentVC: NSViewController) {
    leftView = LeftVC()
    rightView = RightVC()
    guard let leftView ,let rightView else{return}
    let leftViewItem = NSSplitViewItem(sidebarWithViewController: leftView)
    let rightViewItem = NSSplitViewItem(viewController: rightView)
    leftViewItem.minimumThickness = 120
    leftViewItem.maximumThickness = 120
    leftViewItem.canCollapse = true
    leftViewItem.canCollapseFromWindowResize = false
    splitViewController.splitViewItems = [leftViewItem,rightViewItem]
    leftView.delegate = rightView
    window = NSWindow(contentViewController: contentVC)
    window.titlebarSeparatorStyle = .line
    guard let mainAppWindow = window else {return}
    mainAppWindow.minSize = .init(width: 1202, height: 750)
    mainAppWindow.setContentSize(mainAppWindow.minSize)
    mainAppWindow.title = AppConstants.AppName
    mainAppWindow.styleMask = [.titled,.closable,.miniaturizable,.fullSizeContentView,.resizable]
    mainAppWindow.titlebarAppearsTransparent = true
    mainAppWindow.titleVisibility = .hidden
    mainAppWindow.center()
    mainAppWindow.makeKeyAndOrderFront(nil)
//        addToolbar()
}
    
}

