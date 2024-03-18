//
//  HomeView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 17/03/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: WaterIntakeViewModel
    @State private var progress: CGFloat = 0.7
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(viewModel.greeting)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                
                
                
                IntakeView(viewModel: viewModel)
                Spacer()
                
                CombinedProgressView(currentIntake: viewModel.currentIntake, viewModel: viewModel)
              
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadUserSettings()
        }
    }

}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WaterIntakeViewModel() // Create a ViewModel instance for the preview
        HomeView(viewModel: viewModel) // Pass the ViewModel to the HomeView
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


struct IntakeView: View {
    @ObservedObject var viewModel: WaterIntakeViewModel

    var body: some View {
        ZStack {
            // The image is set to fill the width of the ZStack
            Image("launchScreenImg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .cornerRadius(20)
                .clipped()
            
            // Content overlay
            VStack {
                // Top content with padding
                HStack {
                    VStack(alignment: .leading) {
                        Text(getCurrentTime()) // Show current time dynamically
                            .font(.title3)
                            .foregroundColor(Color.init(hex: appFontPrimaryColor))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        
                        
                        
                        Text(String(format: "%.2f ml", viewModel.currentIntake)) // Dynamic intake amount
                            .foregroundColor(Color.init(hex: appFontPrimaryColor))
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.showingAddSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .font(.headline)
                    }
                    
                    Image("launchImg2")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 120, maxHeight: 120)
                        .cornerRadius(20)
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                        .clipped()
                    
                }
                
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 16)
        .sheet(isPresented: $viewModel.showingAddSheet) {
            AddWaterIntakeSheet(viewModel: viewModel)
        }
    }
}

struct IntakeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WaterIntakeViewModel()
        IntakeView(viewModel: viewModel)
    }
}

