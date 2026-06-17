//
//  ProCVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 25/12/2025.
//

import Cocoa

class ProCVC: NSCollectionViewItem {
    
    @IBOutlet weak var normalBox: NSBox!
    @IBOutlet weak var freeTrialBox: NSBox!
    @IBOutlet weak var basicPlaneLabel: NSTextField!
    @IBOutlet weak var weeklyLabel: NSTextField!
    @IBOutlet weak var currentPriceLabel: NSTextField!
    @IBOutlet weak var perWeekPriceLabel: NSTextField!
    @IBOutlet weak var freeTrialLabel: NSTextField!

    private var canSelect: Bool = false
    override var isSelected: Bool {
        didSet { updateSelection() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateSelection() {
        if isSelected {
            view.layer?.backgroundColor = NSColor.appMain.cgColor
            view.layer?.borderWidth = 2
            view.layer?.borderColor = NSColor.appMain.cgColor
            view.layer?.cornerRadius = 15
            weeklyLabel.textColor = .white
            currentPriceLabel.textColor = .white
            perWeekPriceLabel.textColor = .white
        } else {
            view.layer?.backgroundColor = NSColor.whiteColor2.cgColor
            view.layer?.borderWidth = 2
            view.layer?.borderColor = NSColor.border.cgColor
            view.layer?.cornerRadius = 15
            weeklyLabel.textColor = .black
            currentPriceLabel.textColor = .black
            perWeekPriceLabel.textColor = .black

        }
    }
    
    func configure(weekly product: ProductInfo?) {
        guard let product else { return }
        weeklyLabel.stringValue = "Weekly".localized()
        currentPriceLabel.stringValue = product.displayPrice
        basicPlaneLabel.stringValue = "Basic".localized()
//        offPersentBox.fillColor = .leftVCBackground
        perWeekPriceLabel.stringValue = product.currencySymbol + String(format: "%.2f", product.price*2) + "/" + "Week".localized()
        perWeekPriceLabel.textColor = .black
        perWeekPriceLabel.setAttributedStrike(color: .red)
        
        freeTrialBox.isHidden = true
        normalBox.isHidden = false
        normalBox.layer?.cornerRadius = 12
        normalBox.backgroundColor = .white

    }
    
    func configure(monthly product: ProductInfo?) {
        guard let product else { return }
        weeklyLabel.stringValue = "Monthly".localized()
        currentPriceLabel.stringValue = product.displayPrice
        basicPlaneLabel.stringValue = "Free Trial".localized()
//        offPersentBox.fillColor = .proOrange
        perWeekPriceLabel.stringValue = product.currencySymbol + String(format: "%.2f", product.price/4) + "/" + "Week".localized()
        perWeekPriceLabel.textColor = .textColor2
        freeTrialBox.isHidden = false
        
        freeTrialBox.isHidden = false
        normalBox.isHidden = true

    }
    
    func configure(yearly product: ProductInfo?) {
        guard let product else { return }
        weeklyLabel.stringValue = "Yearly".localized()
        currentPriceLabel.stringValue = product.displayPrice
        perWeekPriceLabel.stringValue = product.currencySymbol + String(format: "%.2f", product.price / 52) + "/" + "Week".localized()
        if let weeklyProduct = StoreManager.shared.weekly {
            let productPricePerWeek = ProductInfo(id: "", displayName: "", description: "", currencySymbol: "", price: product.price / 52, displayPrice: "", period: nil, periodCount: 0, product: "")
            let discount = productPricePerWeek.calculateDiscountPercentage(priceBeforeDiscount: weeklyProduct.price)
            basicPlaneLabel.stringValue = "Save".localized() + " \(Int(discount))%"
        }
//        offPersentBox.fillColor = .proPurple
        
        freeTrialBox.isHidden = true
        normalBox.isHidden = false
        normalBox.layer?.cornerRadius = 12
        normalBox.backgroundColor = .proYellow

    }
    
    func configure(lifetime product: ProductInfo?) {
        guard let product else { return }
        weeklyLabel.stringValue = "Lifetime".localized()
        currentPriceLabel.stringValue = product.displayPrice
        perWeekPriceLabel.stringValue = product.currencySymbol + String(format: "%.2f", product.price * 2.4)
        perWeekPriceLabel.textColor = .black
        perWeekPriceLabel.setAttributedStrike(color: .systemRed)
        let discount = product.calculateDiscountPercentage(priceBeforeDiscount: product.price * 2.4)
        basicPlaneLabel.stringValue = "\(Int(discount))%" + "Off".localized()
        
        freeTrialBox.isHidden = true
        normalBox.isHidden = false
        normalBox.layer?.cornerRadius = 12
        normalBox.backgroundColor = .proYellow

    }
}
