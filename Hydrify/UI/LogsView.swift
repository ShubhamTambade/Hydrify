//
//  LogsView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//

import SwiftUI

struct LogsView: View {
    @ObservedObject var viewModel: WaterIntakeViewModel
    

    // Variables to store the ID and amount of the intake to be edited
    @State private var intakeToEditID: UUID?
    @State private var intakeToEditAmount: Double = 0
    @State private var showingEditSheet = false
    
    // Enum to manage active alert type
    enum ActiveAlert {
        case edit, delete
    }
    
    // Single state variable to manage alert presentation
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        if viewModel.waterIntakes.isEmpty {
            VStack{
                Text("No data to show!")
                    .foregroundColor(.gray)
                    .padding()
                    .fontWeight(.bold)
            }
        } else {
            List {
                ForEach(viewModel.waterIntakes, id: \.self) { intake in
                    VStack(alignment: .leading) {
                        Text("\(intake.amount, specifier: "%.2f") ml")
                        if let date = intake.date {
                            Text("Date: \(date, formatter: itemFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("Date: Unknown")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .contextMenu {
                        // Edit option
                        Button(action: {
                            intakeToEditID = intake.id
                            intakeToEditAmount = intake.amount
                            activeAlert = .edit
                        }) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        
                        // Delete option
                        Button(action: {
                            intakeToEditID = intake.id
                            activeAlert = .delete
                        }) {
                            Label("Delete", systemImage: "trash").foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Water Intake Logs")
            .onAppear {
                viewModel.fetchAllWaterIntakes()
            }
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .edit:
                    return Alert(
                        title: Text("Edit Record"),
                        message: Text("Do you want to edit this record?"),
                        primaryButton: .default(Text("Yes")) {
                            showingEditSheet = true
                        },
                        secondaryButton: .cancel()
                    )
                case .delete:
                    return Alert(
                        title: Text("Delete Record"),
                        message: Text("Do you want to delete this record?"),
                        primaryButton: .destructive(Text("Yes")) {
                            if let intakeToEditID = intakeToEditID {
                                viewModel.deleteWaterIntake(id: intakeToEditID)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                if let intakeID = intakeToEditID {
                    EditIntakeView(intakeID: intakeID, intakeAmount: $intakeToEditAmount, onUpdate: { newAmount in
                        viewModel.editWaterIntake(id: intakeID, newAmount: newAmount)
                        intakeToEditID = nil // Reset
                    }, onClear: {
                        viewModel.deleteWaterIntake(id: intakeID)
                        intakeToEditID = nil // Reset
                    })
                }
            }
        }
    }
}

extension LogsView.ActiveAlert: Identifiable {
    var id: Self { self }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter
}()

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView(viewModel: WaterIntakeViewModel())
    }
}


struct EditIntakeView: View {
    var intakeID: UUID
    @Binding var intakeAmount: Double
    var onUpdate: (Double) -> Void
    var onClear: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Water Intake")
                .font(.headline)

            TextField("Amount", value: $intakeAmount, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            Button("Update") {
                onUpdate(intakeAmount)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(DefaultButtonStyle())

            Button("Clear") {
                onClear()
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.red) // Apply red color to the "Clear" button text
        }
        .padding()
    }
}
