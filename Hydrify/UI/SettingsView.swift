//
//  SettingsView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//
import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: WaterIntakeViewModel
    @State private var selectedTab = Tab.personalInfo
    @State private var customWaterGoalString: String = ""
      
    
    var body: some View {
        NavigationView {
            Form {
                pickerSection
                
                if selectedTab == .personalInfo {
                    personalInfoSection
                } else {
                    notificationSettingsSection
                }
            }
            .navigationTitle("Set My Water")
            // When the form dismisses, save settings and re-schedule notifications.
            .onDisappear {
                viewModel.saveUserSettings()
                viewModel.saveSettings()
                viewModel.scheduleHydrationReminder()
            }
        }
    }
    
    private var pickerSection: some View {
        Picker("Select a tab", selection: $selectedTab) {
            Text(Tab.personalInfo.rawValue).tag(Tab.personalInfo)
            Text(Tab.notificationSettings.rawValue).tag(Tab.notificationSettings)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var personalInfoSection: some View {
        Section(header: Text("Personal Information")) {
            
            
            TextField("Enter your name", text: $viewModel.userName)
            
            // Weight slider
            Slider(value: $viewModel.weight, in: 30...150, step: 1) {
                Text("Weight")
            } minimumValueLabel: {
                Text("30kg")
            } maximumValueLabel: {
                Text("150kg")
            }
            .onChange(of: viewModel.weight) { _ in
                viewModel.calculateHydrationGoal()
                viewModel.saveUserSettings()
            }
            
            Text("Your weight: \(viewModel.weight, specifier: "%.0f") kg")
            
            // Custom water intake goal TextField
            TextField("Set custom water intake goal", text: $customWaterGoalString)
                .keyboardType(.numberPad)
                .onChange(of: customWaterGoalString) { newValue in
                    if let newGoal = Double(newValue), newGoal > 0 {
                        viewModel.setCustomWaterGoal(newGoal)
                    }
                }

            
            Text("Daily water intake goal: \(viewModel.waterAmount, specifier: "%.0f") ml")
            
            
        }
    }
    
    private var notificationSettingsSection: some View {
        Section(header: Text("Notification Settings")) {
            DatePicker("Wake Up Time", selection: $viewModel.wakeUpTime, displayedComponents: .hourAndMinute)
                .onChange(of: viewModel.wakeUpTime) { _ in
                    viewModel.saveUserSettings()
                }
            
            DatePicker("Bed Time", selection: $viewModel.bedTime, displayedComponents: .hourAndMinute)
                .onChange(of: viewModel.bedTime) { _ in
                    viewModel.saveUserSettings()
                }
            
            /*
            // In SettingsView, when setting up the notification settings section
            Stepper("Interval between notifications: \(Int(viewModel.notificationInterval * 60)) seconds", value: $viewModel.notificationInterval, in: Int(0.5)...120)
            .onChange(of: viewModel.notificationInterval) { _ in
                viewModel.saveUserSettings()
            }
             */
            Stepper("Interval between notifications: \(viewModel.notificationInterval) minutes", value: $viewModel.notificationInterval, in: 1...120)
            .onChange(of: viewModel.notificationInterval) { newValue in
                viewModel.saveUserSettings()
            }



        }
    }

}


extension SettingsView {
    enum Tab: String, CaseIterable {
        case personalInfo = "Personal Information"
        case notificationSettings = "Notification Settings"
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: WaterIntakeViewModel())
    }
}
