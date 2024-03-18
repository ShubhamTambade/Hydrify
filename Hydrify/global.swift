//
//  global.swift
//  Hydrify
//
//  Created by Shubham Tambade on 17/03/24.
//

import Foundation
import SwiftUI



var appPrimaryColor = "#5DCCFC" //Blue color
var appSecondryColor = "#F2F2F2" //off white color
var appFontPrimaryColor = "#000000" // black color
var appFontSecondryColor = "#625D5D" //dark grey color
var appFontTertiaryColor = "#90A5B4" //light grey color
var goalIntake: Double = 3000 // Example goal


// Function to get current time
    func getCurrentTime() -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "h:mm a" // Format: 11:00 AM
       return dateFormatter.string(from: Date())
   }

func getCurrentDate() -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    let currentDate = Date()
    let formattedDate = dateFormatter.string(from: currentDate)
    return formattedDate

}

struct ResizableTextField: View {
    @Binding var text: String
    let placeholder: String
    let onCommit: () -> Void
    
    // This state will be used to store the width of the text
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Invisible Text to measure width
                Text(text.isEmpty ? placeholder : text)
                    .font(.system(size: 80))
                    .bold()
                    .background(GeometryReader { textGeometry -> Color in
                        DispatchQueue.main.async {
                            // Update the text width
                            self.textWidth = textGeometry.size.width
                        }
                        return .clear
                    })
                
                // Actual TextField
                TextField(placeholder, text: $text, onCommit: onCommit)
                    .font(.system(size: 80)) // Use the same font size as above
                    .frame(width: textWidth, height: 90, alignment: .leading) // Bind the frame width to the text width
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 90)
    }
}

func displayActivityAlert(title: String, presentingViewController: UIViewController, completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        presentingViewController.present(pending, animated: true, completion: nil)
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            pending.dismiss(animated: true) {
                completion() 
            }
        }
    }
}

// Extension to allow initialization of Color with a hex string
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Skip the hash mark if present
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0xFF00) >> 8) / 255.0
        let b = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

