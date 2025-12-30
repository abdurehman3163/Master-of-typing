//
//  StatsVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa
import Combine

class StatsVC: NSViewController {
    
    @IBOutlet weak var speedProgressView: CircularProgressView!
    @IBOutlet weak var accuracyProgressView: CircularProgressView!
    @IBOutlet weak var avgSpeedProgressView: NSProgressIndicator!
    @IBOutlet weak var bestSpeedProgressView: NSProgressIndicator!
    @IBOutlet weak var avgAccuracyProgressView: NSProgressIndicator!
    @IBOutlet weak var bestAccuracyProgressView: NSProgressIndicator!
    @IBOutlet weak var avgSpeedLabel: NSTextField!
    @IBOutlet weak var bestSpeedLabel: NSTextField!
    @IBOutlet weak var avgAccuracyLabel: NSTextField!
    @IBOutlet weak var bestAccuracyLabel: NSTextField!

    @IBOutlet weak var emptyLabelBox: NSBox!
    
    let dataManager = DataManager.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateUI()
        
        dataManager.$allStats.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                updateUI()
            }.store(in: &cancellables)
        setProgressIndicatorColors(for: avgSpeedProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestSpeedProgressView, progressColor: .yellow, backgroundColor: .gray)
        setProgressIndicatorColors(for: avgAccuracyProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestAccuracyProgressView, progressColor: .yellow, backgroundColor: .gray)
    }
    
    func updateUI() {
//        speedProgressView.subtitle = "Current Speed"
//        accuracyProgressView.subtitle = "Accuracy"
        speedProgressView.progress = Double(dataManager.allStats.averageCPM) / 100.0
        accuracyProgressView.progress = Double(dataManager.allStats.averageAccuracy) / 100.0
        avgSpeedProgressView.doubleValue = Double(dataManager.allStats.averageCPM)
        bestSpeedProgressView.doubleValue = Double(dataManager.allStats.bestCPM)
        avgAccuracyProgressView.doubleValue = Double(dataManager.allStats.averageAccuracy)
        bestAccuracyProgressView.doubleValue = Double(dataManager.allStats.bestAccuracy)
        avgSpeedLabel.stringValue = "\(dataManager.allStats.averageCPM) CPM"
        bestSpeedLabel.stringValue = "\(dataManager.allStats.bestCPM) CPM"
        avgAccuracyLabel.stringValue = "\(dataManager.allStats.averageAccuracy)"
        bestAccuracyLabel.stringValue = "\(dataManager.allStats.bestAccuracy)"
        
        if dataManager.allStats.averageAccuracy == 0 {
            emptyLabelBox.isHidden = false
        }else {
            emptyLabelBox.isHidden = true
        }

    }
    
}
