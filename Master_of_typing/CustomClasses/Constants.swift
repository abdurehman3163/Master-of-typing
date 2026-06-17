//
//  ButtonBox.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 12/12/2025.
//

import Foundation
import AppKit

let ud = UserDefaults.standard

func setProgressIndicatorColors(for progressBar: NSProgressIndicator, progressColor: NSColor, backgroundColor: NSColor) {
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

let typingStrings: [[String: String]] = [
    ["title": "The quick brown fox jumps over the lazy dog.", "description": "The quick brown fox jumps over the lazy dog. This sentence is often used to test the font and readability of various fonts in printing and typing exercises. It contains all the letters of the English alphabet at least once, which makes it a perfect sentence for typing practice."],
    
    ["title": "In the heart of the city, there lies a park where children run and play.", "description": "In the heart of the city, there lies a park where children run and play. People of all ages gather here, enjoying the fresh air and peaceful surroundings. The park is not only a place for relaxation but also serves as a community hub for various events and activities."],
    
    ["title": "Technology has changed the way we live and interact with each other.", "description": "Technology has changed the way we live and interact with each other. From smartphones to the internet, we are now more connected than ever before. However, this constant connectivity also comes with its own challenges, including the loss of privacy and the constant bombardment of information."],
    
    ["title": "As the sun sets, the sky turns a brilliant mix of colors, from deep blues to fiery oranges.", "description": "As the sun sets, the sky turns a brilliant mix of colors, from deep blues to fiery oranges. The beauty of a sunset reminds us to take a moment and appreciate the natural world around us. It’s a peaceful end to the day, offering a brief escape from the hustle and bustle of daily life."],
    
    ["title": "The internet has revolutionized communication, allowing people to connect across the globe instantly.", "description": "The internet has revolutionized communication, allowing people to connect across the globe instantly. Social media platforms, email, and video calls make it easier than ever to stay in touch with family, friends, and colleagues. However, the constant flow of information can also be overwhelming at times."],
    
    ["title": "Exploring new places and cultures can be an enriching experience.", "description": "Exploring new places and cultures can be an enriching experience. Traveling opens our minds to different perspectives, helping us understand the world in ways we never thought possible. From tasting new foods to experiencing diverse traditions, travel broadens our horizons and creates lasting memories."],
    
    ["title": "Climate change is one of the most pressing issues of our time.", "description": "Climate change is one of the most pressing issues of our time. Rising global temperatures, melting ice caps, and extreme weather events are all evidence of the impact human activity has had on the environment. It is essential that we take action now to reduce our carbon footprint and protect the planet for future generations."],
    
    ["title": "The universe is vast and mysterious, filled with billions of stars, planets, and galaxies.", "description": "The universe is vast and mysterious, filled with billions of stars, planets, and galaxies. Scientists have only just begun to scratch the surface of understanding the true nature of the cosmos. Through advanced telescopes and space missions, we continue to learn more about the origins of our universe and our place within it."],
    
    ["title": "Artificial intelligence has made significant strides in recent years.", "description": "Artificial intelligence has made significant strides in recent years, with applications ranging from voice assistants to self-driving cars. As AI continues to evolve, it promises to revolutionize various industries, including healthcare, finance, and education. However, it also raises important ethical and privacy concerns that must be addressed."],
    
    ["title": "Creativity is the ability to generate original ideas and solutions to problems.", "description": "Creativity is the ability to generate original ideas and solutions to problems. It can manifest in many forms, from art and music to business innovations and scientific discoveries. Fostering creativity in individuals and organizations can lead to groundbreaking advancements and the solving of complex challenges in various fields."],
    
    ["title": "Reading books is a great way to expand your knowledge and improve your vocabulary.", "description": "Reading books is a great way to expand your knowledge and improve your vocabulary. Whether you're reading fiction or non-fiction, books provide an opportunity to learn about new ideas, cultures, and perspectives. Many people find that reading is also an enjoyable and relaxing way to unwind after a long day."],
    
    ["title": "Time management is an essential skill for achieving success in both personal and professional life.", "description": "Time management is an essential skill for achieving success in both personal and professional life. By setting clear goals, prioritizing tasks, and avoiding distractions, individuals can make the most of their time and accomplish more. Effective time management leads to increased productivity and a greater sense of accomplishment."],
    
    ["title": "The future of transportation is an exciting topic, with advancements in electric vehicles.", "description": "The future of transportation is an exciting topic, with advancements in electric vehicles, autonomous driving technology, and hyperloop systems. These innovations promise to make travel faster, safer, and more sustainable. As technology continues to evolve, transportation will play a key role in shaping the cities and societies of tomorrow."],
    
    ["title": "Learning a new language can be challenging but also incredibly rewarding.", "description": "Learning a new language can be challenging but also incredibly rewarding. It opens up new opportunities for communication, travel, and career advancement. Whether it's through formal classes, language apps, or immersion experiences, acquiring a new language enhances cognitive abilities and cultural understanding."],
    
    ["title": "Music has the power to evoke deep emotions and connect people across cultures.", "description": "Music has the power to evoke deep emotions and connect people across cultures. From classical symphonies to modern pop hits, music transcends language barriers and brings people together. It has been an integral part of human culture for centuries, providing a source of entertainment, expression, and comfort."],
    
    ["title": "Self-care is crucial for maintaining both mental and physical well-being.", "description": "Self-care is crucial for maintaining both mental and physical well-being. Taking time to relax, exercise, and engage in activities that bring you joy can help reduce stress and improve overall health. It’s important to make self-care a priority, especially in today’s fast-paced world where demands on time and energy are high."]
]

