//
//  OnboardingView.swift
//  Hydrify
//
//  Created by Shubham Tambade on 17/03/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @State private var selectedPageIndex = 0
    
    var body: some View {
        if !hasCompletedOnboarding {
            TabView(selection: $selectedPageIndex) {
                OnboardingPage(imageName: "onboarding1", title: "Track your daily water intake with Us.", description: "Achieve your hydration goals with a simple tap!", buttonText: "NEXT") {
                    selectedPageIndex += 1
                }
                .tag(0)
                
                OnboardingPage(imageName: "onboarding2", title: "Smart Reminders Tailored to You", description: "Quick and easy to set your hydration goal & then track your daily water intake progress.", buttonText: "NEXT") {
                    selectedPageIndex += 1
                }
                .tag(1)
                
                OnboardingPage(imageName: "onboarding3", title: "Easy to Use – Drink, Tap, Repeat", description: "Staying hydrated every day is easy with Drops Water Tracker.", buttonText: "GET STARTED") {
                    hasCompletedOnboarding = true
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            // Custom pagination indicator
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == selectedPageIndex ? Color(hex: appPrimaryColor) : Color(hex: appSecondryColor))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom)
        }
    }
}

struct OnboardingPage: View {
    var imageName: String
    var title: String
    var description: String
    var buttonText: String
    var action: () -> Void

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(.top)
            
            Text(title)
                .foregroundColor(Color(hex: appFontPrimaryColor))
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Text(description)
                .foregroundColor(Color(hex: appFontSecondryColor))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Spacer()
            
            Button(action: action) {
                Text(buttonText)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: appPrimaryColor))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 16)
    }
}



