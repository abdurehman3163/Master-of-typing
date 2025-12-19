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

    private var allStats: TypingStats = TypingStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateOverallStats(from: DataManager.shared.chapters)

                updateUI()
        
        setProgressIndicatorColors(for: avgSpeedProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestSpeedProgressView, progressColor: .yellow, backgroundColor: .gray)
        setProgressIndicatorColors(for: avgAccuracyProgressView, progressColor: .green, backgroundColor: .gray)
        setProgressIndicatorColors(for: bestAccuracyProgressView, progressColor: .yellow, backgroundColor: .gray)
        }
    
    
    
    private func setProgressIndicatorColors(for progressBar: NSProgressIndicator, progressColor: NSColor, backgroundColor: NSColor) {
        // Convert the colors to CIColor
        guard let progressCIColor = CIColor(color: progressColor),
              let backgroundCIColor = CIColor(color: backgroundColor) else { return }

        // Create the CIFilter for the progress bar
        let filter = CIFilter(name: "CIFalseColor")!
        filter.setValue(progressCIColor, forKey: "inputColor0")  // Foreground color (progress)
        filter.setValue(backgroundCIColor, forKey: "inputColor1")  // Background color

        // Apply the filter to the progress bar
        progressBar.contentFilters = [filter]
    }

    private func calculateOverallStats(from chapters: [Chapter]) {
        var cpmValues: [Int] = []
        var accuracyValues: [Int] = []
        
        for chapter in chapters {
            for lesson in chapter.lessons {
                for exercise in lesson.exercises {
                    if exercise.isCompleted,
                       let stats = exercise.exerciseStats {
                        if stats.cpm > 0 {
                            cpmValues.append(stats.cpm)
                            accuracyValues.append(stats.accuracy)
                        }
                    }
                }
            }
        }
        guard !cpmValues.isEmpty else {
            allStats = TypingStats()
            return
        }
        if let lastExercise = chapters.flatMap({ $0.lessons.flatMap({ $0.exercises }) })
            .last(where: { $0.isCompleted && ($0.exerciseStats?.cpm ?? 0) > 0 }),
           let lastStats = lastExercise.exerciseStats {
            allStats.currentCPM = lastStats.cpm
            allStats.currentAccuracy = lastStats.accuracy
        }
        // Average
        let averageCPM = cpmValues.isEmpty ? 0 : Int(Double(cpmValues.reduce(0, +)) / Double(cpmValues.count))
        allStats.averageCPM = averageCPM
        let averageAccuracy = accuracyValues.isEmpty ? 0 : Int(Double(accuracyValues.reduce(0, +)) / Double(accuracyValues.count))
        allStats.averageAccuracy = averageAccuracy
        
        // Best
        allStats.bestCPM = cpmValues.max() ?? 0
        allStats.bestAccuracy = accuracyValues.max() ?? 100
        
        allStats.totalSessions = cpmValues.count
    }
    
    private func updateUI() {
            // Speed circle
            let cpmNorm = min(Double(allStats.currentCPM) / 200.0, 1.0)
            speedProgressView.progress = cpmNorm
            speedProgressView.isSpeed = true
            
            // Accuracy circle
            let accNorm = Double(allStats.currentAccuracy) / 100.0
            accuracyProgressView.progress = accNorm
            accuracyProgressView.isSpeed = false
            
            // Linear bars
            updateLinearProgress(avgSpeedProgressView, value: allStats.averageCPM, max: 200, color: .systemGreen)
            updateLinearProgress(bestSpeedProgressView, value: allStats.bestCPM, max: 200, color: .systemYellow)
            
            updateLinearProgress(avgAccuracyProgressView, value: allStats.averageAccuracy, max: 100, color: .systemGreen)
            updateLinearProgress(bestAccuracyProgressView, value: allStats.bestAccuracy, max: 100, color: .systemYellow)
        }
    
    private func updateLinearProgress(_ indicator: NSProgressIndicator,
                                          value: Int,
                                          max: Int,
                                          color: NSColor) {
            let progress = min(Double(value) / Double(max), 1.0)
            indicator.doubleValue = progress * 100
            
            // Best way on macOS: Use CIFalseColor filter (reliable)
            let filled = CIColor(color: color)
            let empty = CIColor(color: NSColor.quaternaryLabelColor)
            
            let filter = CIFilter(name: "CIFalseColor")!
            filter.setValue(filled, forKey: "inputColor0")
            filter.setValue(empty, forKey: "inputColor1")
            
            indicator.contentFilters = [filter]
        }
}
