//
//  DataManager.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 19/12/2025.
//

import Foundation



class DataManager {
    
    @Published var chapters: [Chapter] = []
    @Published var allStats: AllStats = .init(averageCPM: 0, bestCPM: 0, averageAccuracy: 0, bestAccuracy: 0)
    
    private let fileName: String = "HandyText"
    
    static let shared = DataManager()
    
    private init() {
        loadData()
    }
    
    func loadData() {
        chapters = loadJSONFromFile(named: fileName)
        calculateStats()
        
        print("Average CPM: \(allStats.averageCPM)")
        print("Best CPM: \(allStats.bestCPM)")
        print("Average Accuracy: \(allStats.averageAccuracy)")
        print("Best Accuracy: \(allStats.bestAccuracy)")
    }
    
    func saveData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFileURL = documentsDirectory.appending(path: AppConstants.jsonFileName)
        do {
            let data = try JSONEncoder().encode(chapters)
            try data.write(to: jsonFileURL)
            print("writen JSON file to disk.")
        } catch {
            print("Error:    Could not write JSON file to disk.")
        }
    }

    func calculateStats() {
        var totalCPM = 0
        var totalAccuracy = 0
        var bestCPM = 0
        var bestAccuracy = 0
        var totalExercises = 0
        
        for chapter in chapters {
            for lesson in chapter.lessons {
                for exercise in lesson.exercises {
                    if let stats = exercise.exerciseStats {
                        totalExercises += 1
                        totalCPM += stats.cpm
                        totalAccuracy += stats.accuracy
                        
                        // Update best CPM and best accuracy
                        bestCPM = max(bestCPM, stats.cpm)
                        bestAccuracy = max(bestAccuracy, stats.accuracy)
                    }
                }
            }
        }
        
        // Calculate averages
        let averageCPM = totalExercises > 0 ? totalCPM / totalExercises : 0
        let averageAccuracy = totalExercises > 0 ? totalAccuracy / totalExercises : 0
        
        allStats = AllStats(
            averageCPM: averageCPM,
            bestCPM: bestCPM,
            averageAccuracy: averageAccuracy,
            bestAccuracy: bestAccuracy
        )
    }

}

private extension DataManager {
    func loadJSONFromFile(named fileName: String) -> [Chapter] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFileURL = documentsDirectory.appending(path: AppConstants.jsonFileName)
        
        if FileManager.default.fileExists(atPath: jsonFileURL.path()) {
            do {
                let data = try Data(contentsOf: jsonFileURL)
                print("Loaded from documents directory")
                return try JSONDecoder().decode([Chapter].self, from: data)
            } catch {
                print("Error reading local JSON file: \(error)")
                return []
            }
        } else {
            // Get the file URL in the main bundle
            guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("Error: Could not find the file \(fileName).json")
                return []
            }
            
            do {
                // Load the file data into a Data object
                let data = try Data(contentsOf: fileURL)
                try data.write(to: jsonFileURL)
                print("Loaded from bundle")
                // Decode the JSON data into the Root model
                let decoder = JSONDecoder()
                return try decoder.decode([Chapter].self, from: data)
                
            } catch {
                print("Error decoding data from \(fileName): \(error)")
                return []
            }
        }
    }
}
