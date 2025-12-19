import Foundation
import Cocoa
import PDFKit
import Vision

class FileTextExtractor {
    
    func extractText(from fileURL: URL) -> String? {
        let fileExtension = fileURL.pathExtension.lowercased()
        switch fileExtension {
        case "txt":
            return extractTextFromTXT(fileURL: fileURL)
        case "pdf":
            return extractTextFromPDF(fileURL: fileURL)
        default:
            print("Unsupported file type")
            return nil
        }
    }
    private func extractTextFromTXT(fileURL: URL) -> String? {
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            return text
        } catch {
            print("Error reading .txt file: \(error)")
            return nil
        }
    }
    private func extractTextFromPDF(fileURL: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: fileURL) else {
            print("Error loading PDF")
            return nil
        }
        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                fullText += page.string ?? ""
            }
        }
        if let images = extractImagesFromPDF(fileURL: fileURL) {
            autoreleasepool {
                for image in images {
                    ocrTextFromImage(image) { recognizedText in
                        if let text = recognizedText {
                            fullText += "\n\(text)"
                        }
                    }
                }
            }
        }
        return fullText
    }
    private func extractImagesFromPDF(fileURL: URL) -> [NSImage]? {
        guard let pdfDocument = PDFDocument(url: fileURL) else {
            print("Error loading PDF for image extraction")
            return nil
        }
        var imagesArray = [NSImage]()
        for i in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: i) else { return nil }
            let pdfRect = page.bounds(for: .cropBox)
            let pdfImage = NSImage(size: pdfRect.size)
            pdfImage.lockFocus()
            guard let context = NSGraphicsContext.current?.cgContext else{return nil}
            page.draw(with: .mediaBox, to: context)
            pdfImage.unlockFocus()
            let resizedImage = resizeImage(pdfImage, to: CGSize(width: 600, height: 600))
            imagesArray.append(resizedImage)
        }
        return imagesArray
    }
    private func resizeImage(_ image: NSImage, to size: CGSize) -> NSImage {
        let resizedImage = NSImage(size: size)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: size))
        resizedImage.unlockFocus()
        return resizedImage
    }
    func ocrTextFromImage(_ image: NSImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = CIImage(data: image.tiffRepresentation!) else {
            print("Failed to create CIImage from NSImage")
            completion(nil)
            return
        }
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("OCR failed with error: \(error)")
                completion(nil)
                return
            }
            var recognizedText = ""
            for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                if let topCandidate = observation.topCandidates(1).first {
                    recognizedText += topCandidate.string + " "
                }
            }
            completion(recognizedText)
        }
        request.recognitionLevel = .accurate
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform OCR request: \(error)")
            completion(nil)
        }
    }
}
