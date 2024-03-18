//
//  NotificationDelegate.swift
//  Hydrify
//
//  Created by Shubham Tambade on 18/03/24.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification as an alert and play the sound
        completionHandler([.alert, .sound])
    }
    
    // Add any other delegate methods as needed
}
