import Foundation

// Your models conforming to Codable
class Chapter: Codable {
    let title: String
    let lessons: [Lesson]
    
    var numberOfLessons: Int {
        return lessons.count
    }
    
    var completedLessons: Int {
        lessons.count(where: { $0.isCompleted })
    }
}

class Lesson: Codable {
    let id: String
    let lessonNumber: Int
    let exercises: [Exercise]
    
    var isCompleted: Bool {
        exercises.allSatisfy(\.isCompleted)
    }
    
    // This is required for Codable — keep it
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.lessonNumber = try container.decode(Int.self, forKey: .lessonNumber)
            self.exercises = try container.decode([Exercise].self, forKey: .exercises)
        }
        
        // ADD THIS: Custom convenience initializer for manual creation
        init(id: String = UUID().uuidString, lessonNumber: Int, exercises: [Exercise]) {
            self.id = id
            self.lessonNumber = lessonNumber
            self.exercises = exercises
        }
    
}

class Exercise: Codable {
    let id: String
    let title: String
    var isCompleted: Bool
    let text: String
    var exerciseStats: ExerciseStats?
    var allowedKeys: Set<Int> = []
}

class ExerciseStats: Codable {
    var wpm: Int
    var cpm: Int
    var time: Int
    var accuracy: Int
    
    init(wpm: Int, cpm: Int, time: Int, accuracy: Int) {
        self.wpm = wpm
        self.cpm = cpm
        self.accuracy = accuracy
        self.time = time
    }
}
