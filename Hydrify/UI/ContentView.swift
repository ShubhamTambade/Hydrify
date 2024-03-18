//
//  ContentView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 14/03/24.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = "Logs"
    @State private var showingAddSheet = false
    @State private var currentIntake: Double = 0 // Now Double
    let goalIntake: Double = 1900 // Now Double

    var body: some View {
        TabView(selection: $selectedTab) {
            // Logs Tab with LogsView
            NavigationView {
                LogsView(viewContext: viewContext)
                    .navigationTitle("Logs")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Logs", systemImage: "list.bullet")
            }
            .tag("Logs")

            // Add Tab
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                Text("Add Item")
            }
            .tabItem {
                Label("Add", systemImage: "plus")
            }
            .tag("Add")
            .onTapGesture {
                self.showingAddSheet = true
            }

            // Settings Tab with SettingsView
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag("Settings")
        }
        .sheet(isPresented: $showingAddSheet) {
            AddWaterIntakeSheet(currentIntake: $currentIntake, goalIntake: goalIntake)
        }
    }
}


//
//struct AddWaterIntakeSheet: View {
//    @Binding var currentIntake: Int
//    var goalIntake: Int
//
//    var body: some View {
//        VStack {
//            Text("Adjust Your Water Intake")
//                .font(.headline)
//            
//            // Custom progress indicator could be implemented here
//            
//            Text("\(currentIntake)/\(goalIntake) ml")
//                .font(.title)
//            
//            HStack(spacing: 40) {
//                Button(action: {
//                    self.currentIntake = max(self.currentIntake - 100, 0)
//                }) {
//                    Image(systemName: "minus.circle")
//                        .resizable()
//                        .frame(width: 60, height: 60)
//                        .padding()
//                }
//                
//                Button(action: {
//                    self.currentIntake = min(self.currentIntake + 100, goalIntake)
//                }) {
//                    Image(systemName: "plus.circle")
//                        .resizable()
//                        .frame(width: 60, height: 60)
//                        .padding()
//                }
//            }
//        }
//        .padding()
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

