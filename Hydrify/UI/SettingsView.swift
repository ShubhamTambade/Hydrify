//
//  SettingsView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 14/03/24.
//
import SwiftUI

struct SettingsView: View {
    @State private var weight: Double = 50 // Start with a default value
    @State private var waterAmount: Double = 1900
    @State private var bottleSize: Double = 1000
    @State private var unit: UnitType = .metric
    @State private var gender: Gender = .female
    @State private var weather: Weather = .hot
    @State private var measure: Measure = .ml
    @State private var wakeUpTime = Date()
    @State private var bedTime = Date()
    @State private var notificationInterval = 45
    @State private var selectedTab = Tab.personalInfo
    
    enum UnitType: String, CaseIterable {
        case metric = "Metric"
        case imperial = "Imperial"
    }

    enum Gender: String, CaseIterable, Identifiable {
        case male = "Male"
        case female = "Female"
        
        var id: String { self.rawValue }
    }

    enum Weather: String, CaseIterable, Identifiable {
        case hot = "Hot"
        case cool = "Cool"
        
        var id: String { self.rawValue }
    }
    
    enum Measure: String, CaseIterable, Identifiable {
        case ml = "ml"
        case oz = "oz"
        
        var id: String { self.rawValue }
    }

    enum Tab: Hashable {
        case personalInfo, notificationSettings
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select a tab", selection: $selectedTab) {
                    Text("Personal Info").tag(Tab.personalInfo)
                    Text("Notification Settings").tag(Tab.notificationSettings)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Form {
                    Section(header: Text(selectedTab == .personalInfo ? "Personal Information" : "Notification Settings")) {
                        if selectedTab == .personalInfo {
                            weightSection
                            genderSection
                            weatherSection
                            measureSection
                            waterAmountSection
                            bottleSizeSection
                            // Remove personalInfoSection if it's not defined elsewhere
                            Spacer()
                            doneButton
                        } else {
                            wakeUpSection
                            bedTimeSection
                            notificationIntervalSection
                            // Remove notificationSettingsSection if it's not defined elsewhere
                            Spacer()
                            setMyWaterButton
                        }
                    }
                }

                .listStyle(GroupedListStyle())
                
            }
            .navigationTitle("Set My Water")
        }
    }
    
    var weightSection: some View {
        VStack {
            Slider(value: $weight, in: 0...200)
            HStack {
                Text("My weight is \(weight, specifier: "%.0f") \(unit == .metric ? "kg" : "lbs")")
                Spacer()
                Button(unit == .metric ? "kg" : "lbs") {
                    withAnimation {
                        toggleUnit()
                    }
                }
            }
        }
    }

    var genderSection: some View {
        Picker("My Gender", selection: $gender) {
            ForEach(Gender.allCases) { gender in
                Text(gender.rawValue).tag(gender)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    var weatherSection: some View {
        Picker("Weather Type", selection: $weather) {
            ForEach(Weather.allCases) { weather in
                Text(weather.rawValue).tag(weather)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var measureSection: some View {
        Picker("Measure Type", selection: $measure) {
            ForEach(Measure.allCases) { measure in
                Text(measure.rawValue).tag(measure)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    var waterAmountSection: some View {
        VStack {
            Slider(value: $waterAmount, in: 0...3000, step: 100)
            Text("Suggested quantity of water \(waterAmount, specifier: "%.0f") \(measure.rawValue)")
        }
    }

    var bottleSizeSection: some View {
        VStack {
            Slider(value: $bottleSize, in: 0...2000, step: 100)
            Text("Default Water Bottle Size \(bottleSize, specifier: "%.0f") \(measure.rawValue)")
        }
    }

    var wakeUpSection: some View {
        DatePicker("I wake up at", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
    }

    var bedTimeSection: some View {
        DatePicker("I go to bed at", selection: $bedTime, displayedComponents: .hourAndMinute)
    }

        
        var notificationIntervalSection: some View {
            Stepper("Interval between notifications \(notificationInterval) minutes", value: $notificationInterval, in: 1...120)
        }

    var doneButton: some View {
        Button("Done") {
            // Perform the save action, if any
            withAnimation {
                selectedTab = .notificationSettings // Switch to notification settings
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }
    
        var setMyWaterButton: some View {
            Button("Set My Water") {
                // Save action
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }

        func toggleUnit() {
            unit = (unit == .metric) ? .imperial : .metric
            if unit == .imperial {
                weight *= 2.20462 // Convert kg to lbs
                waterAmount /= 29.5735 // Convert ml to oz
                bottleSize /= 29.5735 // Convert ml to oz
            } else {
                weight /= 2.20462 // Convert lbs to kg
                waterAmount *= 29.5735 // Convert oz to ml
                bottleSize *= 29.5735 // Convert oz to ml
            }
        }
    }

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
