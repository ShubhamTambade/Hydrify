//
//  AddWaterIntakeSheet.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//

import SwiftUI

struct AddWaterIntakeSheet: View {
    @Binding var currentIntake: Double
    var goalIntake: Double
    @State private var intakeString: String

    init(currentIntake: Binding<Double>, goalIntake: Double) {
        self._currentIntake = currentIntake
        self.goalIntake = goalIntake
        self._intakeString = State(initialValue: String(format: "%g", currentIntake.wrappedValue))
    }

    var body: some View {
        VStack {
            Text("Adjust Your Water Intake")
                .font(.headline)
            
            HStack {
                TextField("Enter intake", text: $intakeString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 30) // Set the fixed height
                    // Background here is only for sizing; TextField itself doesn't directly support dynamic width based on content
                    .background(
                        GeometryReader { geometry in
                            Text(self.intakeString.isEmpty ? "Enter intake" : self.intakeString + " ml")
                                .lineLimit(1)
                                .opacity(0) // Make the Text view invisible
                                .frame(minWidth: geometry.size.width, maxWidth: .infinity, alignment: .leading)
                        }
                    )
                
                Text("ml").opacity(intakeString.isEmpty ? 0 : 1) // Hide "ml" label when intakeString is empty
            }
            .padding()

            Text("\(String(format: "%g", currentIntake))/\(String(format: "%g", goalIntake)) ml")
                .font(.title)

            HStack(spacing: 40) {
                Button(action: {
                    self.currentIntake -= 100
                    self.intakeString = String(format: "%g", self.currentIntake)
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding()
                }

                Button(action: {
                    self.currentIntake += 100
                    self.intakeString = String(format: "%g", self.currentIntake)
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding()
                }
            }
        }
        .padding()
    }
}





struct AddWaterIntakeSheet_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var currentIntake: Double = 0 // Example initial value
        
        var body: some View {
            AddWaterIntakeSheet(currentIntake: $currentIntake, goalIntake: 2000) // Example goalIntake
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
