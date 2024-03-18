
//
//  ContentView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 16/03/24.
//



import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = WaterIntakeViewModel() // Instantiate ViewModel
    @State private var selectedTab: String = "Home"

    var body: some View {
        VStack {
            switch selectedTab {
            case "Logs":
                LogsView(viewModel: viewModel)
            case "Settings":
                SettingsView(viewModel: viewModel)
            default:
                HomeView(viewModel: viewModel)
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}





