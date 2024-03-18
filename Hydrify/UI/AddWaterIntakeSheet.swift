//
//  AddWaterIntakeSheet.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//

import SwiftUI
import Combine


struct AddWaterIntakeSheet: View {
    @ObservedObject var viewModel: WaterIntakeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var intakeString: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var textFieldWidth: CGFloat = 80
    @State private var intakeAmount: Double = 0 // Initialize to 0
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        VStack {
            Text("Today - \(getCurrentDate())")
                .font(.title3)
                .padding(.top, 40)

            Text("Add Water Intake")
                .font(.largeTitle)
                .padding(.top, 60)

            HStack{
                TextField("0", text: $intakeString) // Set placeholder to 0 string
                    .font(.system(size: 80))
                    .keyboardType(.numberPad) // Set keyboard type to number pad
                    .padding()
                    .border(Color.black, width: 0)
                    .frame(width: textFieldWidth, height: 80, alignment: .center)
                    .multilineTextAlignment(.center)
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                            let bottomInset = UIApplication.shared.connectedScenes
                                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                .first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
                            
                            keyboardHeight = keyboardSize.height - bottomInset
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        keyboardHeight = 0
                    }
                    .onChange(of: intakeString) { newValue in
                        if newValue.count <= 5, let newValue = Double(newValue), newValue <= 10000 {
                            intakeAmount = newValue
                        } else {
                            intakeString = String(intakeString.prefix(5))
                            intakeAmount = min(intakeAmount, 10000)
                        }
                        textFieldWidth = getWidthForText(intakeString)
                    }
                
                
                Spacer()
                    .frame(width: 20)
                
                Text("ml")
                    .font(.system(size: 20))
                    .baselineOffset(-40)
                    .frame(alignment: .leading)
                    .padding(.leading, -20)
                
                
            }
            .frame(height: 100)
            .padding()

            
            HStack(spacing: 20) {
                ForEach([50, 100, 500], id: \.self) { amount in
                    Button("+\(amount)") {
                        // Calculate new amount without exceeding 10000
                        let newAmount = min(10000, intakeAmount + Double(amount))
                        // Update the intake amount and text string
                        intakeAmount = newAmount
                        intakeString = String(format: "%.0f", newAmount)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding(.top, 20)


            Spacer()

            Button("Done") {
                if let customAmount = Double(intakeString), customAmount <= 10000 {
                    viewModel.addWaterIntake(amount: customAmount)
                    alertTitle = "Data added successfully."
                    intakeString = ""
                } else {
                    alertTitle = "Maximum 10,000 ml allowed."
                }
                showAlert = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, keyboardSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        .padding()
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: Date())
    }

    private func keyboardSafeArea() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    
    func getWidthForText(_ text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 80)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: attributes)
        let calculatedWidth = min(300, textSize.width + 40) // Add some padding and constrain to max 300
        return max(calculatedWidth, 80) // Ensure the width is at least 80
    }
}

struct AddWaterIntakeSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddWaterIntakeSheet(viewModel: WaterIntakeViewModel())
    }
}

