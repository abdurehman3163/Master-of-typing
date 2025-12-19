
import Foundation

class AppConstants : NSObject {
//    static var selectedModel: any ChatGPTModel = BaseModels.gpt4o
    static var requestCount: Int = 0
    static let privacyLink = URL(string: "https://sites.google.com/view/rabiasakhawatapps/privacy-policy")!
    static let termsOfUseLink = URL( string: "https://sites.google.com/view/rabiasakhawatapps/terms-and-conditions")!
    static let eulaLink: String = ""
    static let supportEmail : String =  "rabiasakhawatapps@gmail.com"
    static let AppName : String = "HandyText"
    static let appIDForShowingApp : String = "6755829992"
    static let appStoreURL : String = "itms-apps://apps.apple.com/app/id\(appIDForShowingApp)?action=write-review"
    static let appShareLink = "https://apps.apple.com/app/id\(appIDForShowingApp)"
    //MARK: - StoreKit Purchase Keys
    static let weeklySubscriptionID: String = "com.rs.handy.text.weekly"
    static let monthlySubscriptionID: String = "com.rs.handy.text.monthly"
    static let yearlySubscriptionID: String = "com.rs.handy.text.yearly"
//    static let lifeTimeSubscriptionID: String = "com.printcore.printer.app.lifetime"
    
    static let appSharedSecretKey: String = "cc50bea698754b5eae7650b3a0644ba5"
    static let hash: String = "sha256//5KjN64rxTiC13wacHTGCLnBdD2k6jwPdd7duayEkNiU="
    static var expandedRowIndices: Set<Int> = []
    static let jsonFileName: String = "HandyText.json"

}

func mainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}
