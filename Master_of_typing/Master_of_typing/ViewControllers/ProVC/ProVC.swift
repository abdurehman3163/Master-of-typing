//
//  ProVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 23/12/2025.
//

import Cocoa
import Combine

class ProVC: BaseVC {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var threeDayFreeTrialLabel: NSTextField!
    @IBOutlet weak var startForFreeLabel: NSButton!

    private let storeManager = StoreManager.shared
    private var selectedProduct: ProductInfo?
    private var cancellable = Set<AnyCancellable>()

    var subscriptionPlanList : [String] = [AppConstants.weeklySubscriptionID,
                                           AppConstants.monthlySubscriptionID,
                                           AppConstants.yearlySubscriptionID,
                                           AppConstants.lifeTimeSubscriptionID]
    var selectedIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        storeManager.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                guard let self else { return }
                selectedProduct = StoreManager.shared.monthly
                collectionView.reloadData()
                
                if selectedProduct != nil {
                    collectionView.selectItem(index: selectedIndex, section: 0)
                    //                    purchaseButton.isEnabled = true
                    updateStartForFreeLabel()
                }
            }.store(in: &cancellable)
        if StoreManager.shared.weekly == nil {
            StoreManager.shared.fetchProducts()
            
        }
    }
    
    override func appProStatusDidChange() {
        if App.isPro {
            dismiss(nil)
        }
    }
    
    func updateStartForFreeLabel() {
        guard storeManager.weekly != nil else { return }
        guard let selectedProduct else {
            threeDayFreeTrialLabel.isHidden = true
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if selectedProduct.haveFreeTrial {
                threeDayFreeTrialLabel.isHidden = false
                threeDayFreeTrialLabel.stringValue = "\(selectedProduct.trialDays) " + "Days Free Trial, then" + " \(selectedProduct.displayPrice) / " + "Monthly"
                startForFreeLabel.title = "Start 3 Days Free Trial"
            } else {
                threeDayFreeTrialLabel.isHidden = true
                threeDayFreeTrialLabel.stringValue = ""
                startForFreeLabel.title = "C O N T I N U E"
            }
        }
    }
    
    @IBAction func startForFreeBtnAction(_ sender: Any?) {
        guard let selectedProduct else { return }
        showHud(hudView: view)
        Task {
            do {
                let result = try await StoreManager.shared.purchase(product: selectedProduct)
                if let success = result as? Bool, success {
                    dismiss(nil)
                } else {
                    hideHud()
                }
            } catch {
                showAlert(title: "Error", message: "Failed to purchase, Please try again.")
            }
            hideHud()
        }
    }
    
    @IBAction func privacyPolicyBtnAction(_ sender: Any?) {
        NSWorkspace.shared.open(AppConstants.privacyLink)
    }
    
    @IBAction func purchaseRestoreBtnAction(_ sender: Any?) {
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
    
    @IBAction func termAndConditionsBtnAction(_ sender: Any?) {
        NSWorkspace.shared.open(AppConstants.termsOfUseLink)
    }
    
}

extension ProVC: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionPlanList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("ProCVC"), for: indexPath) as? ProCVC else { return NSCollectionViewItem() }
        let item = indexPath.item

        let index = indexPath.item
        if index == 0 {
            cell.configure(weekly: storeManager.weekly)
            let string = "Save upto 50%, than \(cell.perWeekPriceLabel.stringValue)"
            threeDayFreeTrialLabel.stringValue = string

        } else if index == 1 {
            cell.configure(monthly: storeManager.monthly)
            let string = "\(cell.basicPlaneLabel.stringValue), than \(cell.perWeekPriceLabel.stringValue)"
            threeDayFreeTrialLabel.stringValue = string

        } else if index == 2 {
            cell.configure(yearly: storeManager.yearly)
            let string = "\(cell.basicPlaneLabel.stringValue), than \(cell.perWeekPriceLabel.stringValue)"
            threeDayFreeTrialLabel.stringValue = string

        }  else if index == 3 {
            cell.configure(lifetime: storeManager.yearly)
            let string = "\(cell.basicPlaneLabel.stringValue), than \(cell.perWeekPriceLabel.stringValue)"
            threeDayFreeTrialLabel.stringValue = string

        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        NSSize(width: 185 , height: 190)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first?.item else{return}

        if index == 0 {
            selectedProduct = storeManager.weekly
        } else if index == 1 {
            selectedProduct = storeManager.monthly
        } else if index == 2 {
            selectedProduct = storeManager.yearly
        } else if index == 3 {
            selectedProduct = storeManager.lifetime
        }
        selectedIndex = index
        updateStartForFreeLabel()

    }

}
