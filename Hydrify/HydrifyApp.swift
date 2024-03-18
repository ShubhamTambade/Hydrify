//
//  HydrifyApp.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//  

import SwiftUI

@main
struct HydrifyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    let persistenceController = PersistenceController.shared
    // Instantiate your NotificationDelegate
      let notificationDelegate = NotificationDelegate()
    
    

    init() {
          requestNotificationPermission()
          
          UNUserNotificationCenter.current().delegate = notificationDelegate
      }

    
    var body: some Scene {
        WindowGroup {
            if isAppLaunched {
                if hasCompletedOnboarding {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .preferredColorScheme(.light)
                } else {
                    OnboardingView()
                        .preferredColorScheme(.light)
                }
            } else {
                launchScreen
            }
        }
    }

    
    func requestNotificationPermission() {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
               // Handle the response to the permission request here.
           }
       }
    
    @State private var isAppLaunched = false
       
    var launchScreen: some View {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Hydrify"
        
        return ZStack {
            Image("launchScreenImg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8) // Adjust opacity as needed

            VStack {
                Image("launchImg2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160)

                Text(appName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                Text("Stay hydrated and track your daily water intake")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
                withAnimation {
                    isAppLaunched = true
                }
            }
        }
    }



}
