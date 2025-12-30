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
