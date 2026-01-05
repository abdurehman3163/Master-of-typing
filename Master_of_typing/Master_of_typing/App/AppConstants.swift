
import Foundation

class AppConstants : NSObject {
//    static var selectedModel: any ChatGPTModel = BaseModels.gpt4o
    static var requestCount: Int = 0
    static let privacyLink = URL(string: "https://sites.google.com/view/rabiasakhawatapps/privacy-policy")!
    static let termsOfUseLink = URL( string: "https://sites.google.com/view/rabiasakhawatapps/terms-and-conditions")!
    static let eulaLink: String = ""
    static let supportEmail : String =  "rabiasakhawatapps@gmail.com"
    static let AppName : String = "TypeZen"
    static let appIDForShowingApp : String = "6757149517"
    static let appStoreURL : String = "itms-apps://apps.apple.com/app/id\(appIDForShowingApp)?action=write-review"
    static let appShareLink = "https://apps.apple.com/app/id\(appIDForShowingApp)"
    //MARK: - StoreKit Purchase Keys
    static let weeklySubscriptionID: String =   "com.rs.typing.master.weekly"
    static let monthlySubscriptionID: String =  "com.rs.typing.master.monthly"
    static let yearlySubscriptionID: String =   "com.rs.typing.master.yearly"
    static let lifeTimeSubscriptionID: String = "com.rs.typing.master.lifetime"
    
    static let appSharedSecretKey: String = "290e9c311fd04606b58f6634e6ad3baf"
    static let hash: String = "sha256//5KjN64rxTiC13wacHTGCLnBdD2k6jwPdd7duayEkNiU="
    static var expandedRowIndices: Set<Int> = []
    static let jsonFileName: String = "HandyText.json"

}

func mainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}
