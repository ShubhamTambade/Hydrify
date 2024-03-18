//
//  WaterIntakeViewModel.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//

import Foundation
import CoreData
import Combine
import UserNotifications


class WaterIntakeViewModel: ObservableObject {
    
    @Published var currentIntake: Double = 0
    
    @Published var intakeString: String = "0"
    @Published var waterIntakes: [WaterIntake] = []
    @Published var currentDayIntakeString = "0 ml"
    
    @Published var wakeUpTime = Date()
    @Published var bedTime = Date()
    @Published var notificationInterval = 1 // Minutes
    @Published var weight: Double = 70 // Weight in kilograms
    @Published var waterAmount: Double = 2450 // Example default value
    
    // Add a published property for the user's name
    @Published var userName: String = ""
    @Published var isCustomWaterGoalSet: Bool = false
    
    
    
    
    
    // Manage the presentation of the AddWaterIntakeSheet
    @Published var showingAddSheet = false
    
    // You will need to calculate these values based on your data model
    var waterIntakeAmount: Int { 200 }
    var waterIntakeGlasses: Int { 2 }
    
    
    // Computed property for greeting based on time of day
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : return "Good Morning,"
        case 12..<18: return "Good Afternoon,"
        case 18..<22: return "Good Evening,"
        default: return "Hello,"
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // Load settings from UserDefaults
        notificationInterval = UserDefaults.standard.integer(forKey: "notificationInterval")
        weight = UserDefaults.standard.double(forKey: "weight")
        waterAmount = UserDefaults.standard.double(forKey: "waterAmount")
        userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        // Provide default values if none are stored
        if notificationInterval == 0 { notificationInterval = 60 }
        if weight == 0 { weight = 70 }
        if waterAmount == 0 { waterAmount = 2450 }
        
        // Set Setting defaults if not already set
        let defaultWakeUpTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let defaultBedTime = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        wakeUpTime = UserDefaults.standard.object(forKey: "wakeUpTime") as? Date ?? defaultWakeUpTime
        bedTime = UserDefaults.standard.object(forKey: "bedTime") as? Date ?? defaultBedTime
        notificationInterval = UserDefaults.standard.integer(forKey: "notificationInterval")
        if notificationInterval == 0 { notificationInterval = 30 } // Default to 30 minutes if not set

        self.loadCurrentDayIntake()
        self.fetchAllWaterIntakes() // Fetch water intake data when the view model is initialized
    }

    
    // Functions to add, save, and load water intake
    func addWaterIntake(amount: Double) {
        let newEntry = WaterIntake(context: PersistenceController.shared.container.viewContext)
        newEntry.id = UUID()
        newEntry.amount = amount
        newEntry.date = Date() // Use the current date and time
        
        saveContext()
        loadCurrentDayIntake() // Refresh the current day's total intake
        fetchAllWaterIntakes() // This should refresh your list
    }
    
    private func saveContext() {
        let context = PersistenceController.shared.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Handle the error
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func loadCurrentDayIntake() {
        let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", dateFrom as NSDate, dateTo as NSDate)
        
        do {
            let entries = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            let totalIntake = entries.reduce(0) { $0 + $1.amount }
            
            DispatchQueue.main.async {
                self.currentIntake = totalIntake
                print("loadCurrentDayIntake ",self.currentIntake)
            }
        } catch {
            // Handle the error
            print("Could not fetch data: \(error)")
        }
    }
    
    

    func fetchAllWaterIntakes() {
        let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        DispatchQueue.main.async {
            do {
                self.waterIntakes = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            } catch {
                print("Could not fetch water intakes: \(error)")
            }
        }
    }

    
    
    // Edit a water intake entry
    func editWaterIntake(id: UUID, newAmount: Double) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let waterIntakeToEdit = results.first {
                waterIntakeToEdit.amount = newAmount
                try context.save()
                loadCurrentDayIntake() // Refresh the data
                fetchAllWaterIntakes() // Refresh the list
            }
        } catch {
            print("Failed to fetch or update: \(error.localizedDescription)")
        }
    }

    // Delete a water intake entry
    func deleteWaterIntake(id: UUID) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<WaterIntake> = WaterIntake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let waterIntakeToDelete = results.first {
                context.delete(waterIntakeToDelete)
                try context.save()
                loadCurrentDayIntake() // Refresh the data
                fetchAllWaterIntakes() // Refresh the list
            }
        } catch {
            print("Failed to fetch or delete: \(error.localizedDescription)")
        }
    }

    
    // Calculate dynamic hydration goal
    func calculateHydrationGoal() {
        if !isCustomWaterGoalSet {
            // Hydration goal based on weight (e.g., 35 ml per kg of body weight)
            let goal = weight * 35
            waterAmount = goal
        }
        // If isCustomWaterGoalSet is true, do nothing
    }
    
    
   


    
    func saveSettings() {
        // Implement saving logic for user settings, e.g., to UserDefaults or a database
        calculateHydrationGoal()
        // Schedule or update notifications based on new settings
    }
    
    
    func setCustomWaterGoal(_ goal: Double) {
        isCustomWaterGoalSet = true
        waterAmount = goal
    }
    
    func saveUserSettings() {
        // Convert wakeUpTime and bedTime to data because UserDefaults doesn't directly store Date objects
        if let wakeUpTimeData = try? NSKeyedArchiver.archivedData(withRootObject: wakeUpTime, requiringSecureCoding: false) {
            UserDefaults.standard.set(wakeUpTimeData, forKey: "wakeUpTime")
        }
        if let bedTimeData = try? NSKeyedArchiver.archivedData(withRootObject: bedTime, requiringSecureCoding: false) {
            UserDefaults.standard.set(bedTimeData, forKey: "bedTime")
        }

        UserDefaults.standard.set(notificationInterval, forKey: "notificationInterval")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(waterAmount, forKey: "waterAmount")
        UserDefaults.standard.set(userName, forKey: "userName")
        
        // Force UserDefaults to synchronize the changes
        UserDefaults.standard.synchronize()
    }

    
    func loadUserSettings() {
        // Load settings
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "Buddy"
        // Load other settings as needed
    }

  
/*
    func scheduleHydrationReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

                let content = UNMutableNotificationContent()
                content.title = "Hydration Reminder"
                content.body = "Time to drink some water!"
                content.sound = .default

                // Schedule a notification for every 30 seconds (for testing)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Scheduled a notification for every 60 seconds.")
                    }
                }
            }
        }
    }
*/

    func scheduleHydrationReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            guard granted, let self = self else { return }
            
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
                let content = UNMutableNotificationContent()
                content.title = "Hydration Reminder"
                content.body = "Time to drink some water!"
                content.sound = .default
                
                // Convert minutes to seconds for the time interval
                let timeIntervalInSeconds = self.notificationInterval * 60
                
                // Schedule the notification with the user-defined interval
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntervalInSeconds), repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Scheduled a notification for every \(self.notificationInterval) minutes. current time: \(getCurrentTime())")
                    }
                }
            }
        }
    }




}

