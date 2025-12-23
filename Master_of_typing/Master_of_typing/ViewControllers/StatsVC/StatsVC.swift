//
//  StatsVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class StatsVC: NSViewController {
    
    @IBOutlet weak var speedProgressView: CircularProgressView!
    @IBOutlet weak var accuracyProgressView: CircularProgressView!
    @IBOutlet weak var avgSpeedProgressView: NSProgressIndicator!
    @IBOutlet weak var bestSpeedProgressView: NSProgressIndicator!
    @IBOutlet weak var avgAccuracyProgressView: NSProgressIndicator!
    @IBOutlet weak var bestAccuracyProgressView: NSProgressIndicator!
    @IBOutlet weak var emptyLabelBox: NSBox!
    
    private var allStats: TypingStats = TypingStats()
    let dataManager = DataManager.shared.allStats

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataManager.averageAccuracy == 0 {
            emptyLabelBox.isHidden = false
        }else {
            emptyLabelBox.isHidden = true
        }
        updateUI()
        setProgressIndicatorColors(for: avgSpeedProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestSpeedProgressView, progressColor: .yellow, backgroundColor: .gray)
        setProgressIndicatorColors(for: avgAccuracyProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestAccuracyProgressView, progressColor: .yellow, backgroundColor: .gray)
    }
    
    func updateUI() {
        speedProgressView.progress = Double(dataManager.averageCPM)
        accuracyProgressView.progress = Double(dataManager.averageAccuracy)
        avgSpeedProgressView.doubleValue = Double(dataManager.averageCPM)
        bestSpeedProgressView.doubleValue = Double(dataManager.bestCPM)
        avgAccuracyProgressView.doubleValue = Double(dataManager.averageAccuracy)
        bestAccuracyProgressView.doubleValue = Double(dataManager.bestAccuracy)
    }
    
}
