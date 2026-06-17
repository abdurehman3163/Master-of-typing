//
//  SingleDragDropView.swift
//  Printer4MR
//
//  Created by MacBook Pro on 03/10/2025.
//

import Cocoa

func showImage(url: URL)-> NSImage{
    return NSImage(contentsOf: url) ?? NSImage()
}

func getFileSize(url: URL) -> String {
    do {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
        if let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
            let sizeInBytes = fileSize.int64Value
            if sizeInBytes < 1024 {
                return "\(sizeInBytes) Bytes"
            } else if sizeInBytes < 1024 * 1024 {
                let sizeInKB = Double(sizeInBytes) / 1024.0
                return String(format: "%.2f KB", sizeInKB)
            } else if sizeInBytes < 1024 * 1024 * 1024 {
                let sizeInMB = Double(sizeInBytes) / (1024.0 * 1024.0)
                return String(format: "%.2f MB", sizeInMB)
            } else {
                let sizeInGB = Double(sizeInBytes) / (1024.0 * 1024.0 * 1024.0)
                return String(format: "%.2f GB", sizeInGB)
            }
        }
    } catch {
        print("Error getting file size: \(error.localizedDescription)")
    }
    return ""
}
