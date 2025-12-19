//
//  Utility.swift
//  Ai Flash Generator
//
//  Created by Personal on 05/01/2025.
//


import Cocoa
import StoreKit
import Reachability

class Utility: NSObject {
    
    class func isNetworkAvailable()->Bool{
        do {
            let reachability = try Reachability()
            switch reachability.connection{
            case .unavailable:
                return false
            default:
                return true
            }
            
        }catch{
            return false
        }
    }
    class func lockPdfFile(window: NSWindow,completion: @escaping (String) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Lock PDF"
        alert.informativeText = "Enter the Password to Protect PDF File :"
        alert.alertStyle = .informational
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        inputTextField.placeholderString = "Enter the Password"
        alert.accessoryView = inputTextField
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window){ response in
            if response == .alertFirstButtonReturn {
                let newName = inputTextField.stringValue
                if !newName.isEmpty {
                    completion(newName)
                } else {
                    print("No input provided.")
                }
            } else {
                print("Rename canceled by user.")
            }
        }
    }
    class func dialogOK(question: String, text: String, title: String = "OK",window: NSWindow){
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: title)
        return alert.beginSheetModal(for: window)
    }
    class func showAlertSheet(
        message: String,
        information: String,
        window: NSWindow,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.informativeText = information
        alert.addButton(withTitle: "Confirm")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window) { modalResponse in
            let response = modalResponse == .alertFirstButtonReturn
            completion(response)
        }
    }
    @discardableResult
    class func dialogOK(question: String, text: String) -> NSApplication.ModalResponse{
        var response:NSApplication.ModalResponse = .OK
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        //        alert.beginSheetModal(for: appDelegate.window) { res in
        //            response = res
        //        }
        return response
    }
    class func dialogOKCancel(question: String, yesButtonText yesBtnText:String, noButtonText noBtnText:String ) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.alertStyle = .warning
        alert.addButton(withTitle: yesBtnText)
        alert.addButton(withTitle: noBtnText)
        return alert.runModal() == .alertFirstButtonReturn
    }
    @discardableResult
    class func dialogOK(question: String, text: String, title: String = "OK") -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: title)
        return alert.runModal()
    }
    @discardableResult
    class func dialogWithMsg(message: String) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "OK")
        return alert.runModal()
    }
    class func dialogReset(question: String) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = question
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        return alert.runModal()
    }
    @discardableResult
    class func dialogLargeImage(question: String) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = question
        alert.alertStyle = .warning
        alert.informativeText = "Please select image of size upto 10MB"
        alert.addButton(withTitle: "OK")
        return alert.runModal()
    }
    class func dialogOKWithCancel(question: String, text: String, yesButtonText:String, noButtonText :String ) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: yesButtonText)
        alert.addButton(withTitle: noButtonText)
        return alert.runModal() == .alertFirstButtonReturn
    }
    class func showAlertForDismiss(question: String, text: String,window : NSWindow?, completion: @escaping (NSApplication.ModalResponse) -> Void) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        DispatchQueue.main.async {
            if let windw = window {
                print("Showing alert as a sheet modal.")
                alert.beginSheetModal(for: windw) { response in
                    completion(response)
                }
            } else {
                print("No main window. Falling back to runModal.")
                let response = alert.runModal()
                completion(response)
            }
        }
    }
    class func showAlertSheet(message: String,information: String,window: NSWindow,title: String,completion: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.informativeText = information
        alert.addButton(withTitle: title)
        //        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window) { modalResponse in
            let response = modalResponse == .alertFirstButtonReturn
            completion(response)
        }
    }
    class func showOneTextfieldAlert(
        messageTest: String,
        informativeText: String = "",
        window: NSWindow,
        completion: ((String?) -> Void)?
    ) {
        let alert = NSAlert()
        alert.informativeText = informativeText
        alert.messageText = messageTest
        alert.addButton(withTitle: "Confirm")
        alert.addButton(withTitle: "Cancel")
        
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        inputTextField.focusRingType = .none
        inputTextField.placeholderString = ("Enter New File name")
        alert.accessoryView = inputTextField
        alert.beginSheetModal(for: window) { modalResponse in
            if modalResponse == .alertFirstButtonReturn {
                completion?(inputTextField.stringValue)
            }
        }
    }
    class func showProScreen(caller:NSViewController){
        if !App.isPro{
                    DispatchQueue.main.async {
//                        let vc = PROViewController(nibName: "PROViewController", bundle: nil)
//                        caller.presentAsSheet(vc)
                    }
                }
    }
    class func openUrl(url: String){
        guard let url = URL(string: url) else{return}
        NSWorkspace.shared.open(url)
    }
    class func setContainerFrame(_ mainViewSize:NSSize,_ templateSize:NSSize) -> NSSize {
        let ratio = (mainViewSize.width / templateSize.width)/(mainViewSize.height / templateSize.height)
        if ratio > 1 {
            return NSSize( width: mainViewSize.width/ratio, height: mainViewSize.height)
        }else if ratio < 1 {
            return NSSize(width: mainViewSize.width, height: mainViewSize.height*ratio)
        }
        return mainViewSize
    }
    
    class func saveDefaultObject(obj:String,forKey strKey:String){
        ud.set(obj, forKey: strKey)
    }
    
    class func getDefaultObject(forKey strKey:String) -> String {
        if let obj = ud.value(forKey: strKey) as? String{
            let obj2 = ud.value(forKey: strKey) as! String
            return obj2
        }else{
            return ""
        }
    }
    

    
    class func splitTextIntoLines(text: String, attributes: [NSAttributedString.Key: Any], maxWidth: CGFloat) -> [String] {
        var lines: [String] = []
        let paragraphLines = text.components(separatedBy: .newlines)
        for paragraph in paragraphLines {
            if paragraph.trimmingCharacters(in: .whitespaces).isEmpty {
                lines.append("")
                continue
            }
            let words = paragraph.components(separatedBy: .whitespaces)
            var currentLine = ""
            for word in words {
                let testLine = currentLine.isEmpty ? word : "\(currentLine) \(word)"
                if testLine.calculateWidth(attributes: attributes) <= maxWidth {
                    currentLine = testLine
                } else {
                    if !currentLine.isEmpty {
                        lines.append(currentLine)
                    }
                    currentLine = word
                }
            }
            if !currentLine.isEmpty {
                lines.append(currentLine)
            }
        }
        return lines
    }
    
    
    class func openEmail(address: String, subject: String, body: String) {
        var deviceName = ""
        let deviceStr = Host.current().localizedName
        if let device = deviceStr?.components(separatedBy: "’s ").last {
            deviceName = device
        }
        
        var buildVersion = ""
        let pro = (App.isPro) == true ? "P" : ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String , let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildVersion = "\(version) (\(build))"
        }
        
        let html = NSString.init(format: "<br> <br> <br> <br><br> %@ <br>%@<br><b>OSX Versoin :</b> %@ <br> <b>Device Type :</b> %@ <br> This information will help us to find your issue.", body, AppConstants.AppName , ProcessInfo.processInfo.operatingSystemVersionString, deviceName)
        
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        service?.recipients = [address]
        service?.subject = "\(AppConstants.AppName) | MAC | \(buildVersion) | \(pro)"
        
        service?.perform(withItems: [String.init(html).convertHtml()])
    }
    
    class func shareApp(appId: String, sender: NSView) {
        guard let url = URL(string : "macappstore://itunes.apple.com/app/id\(appId)") else {
            return
        }
        let sharingPicker = NSSharingServicePicker(items: [url])
        sharingPicker.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
    }
    
    class func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "macappstore://itunes.apple.com/app/id\(appId)?mt=8&action=write-review") else {
            completion(false)
            return
        }
        completion(NSWorkspace.shared.open(url))
    }
}
