    //
    //  CustomTabBar.swift
    //  Hydrify
    //
    //  Created by Shubham Tambade on 17/03/24.
    //

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: String

    var body: some View {
        HStack {
            // Logs tab button
            Button(action: { self.selectedTab = "Logs" }) {
                VStack {
                    Image(systemName: "list.bullet")
                        .foregroundColor(selectedTab == "Logs" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                    Text("Logs")
                        .foregroundColor(selectedTab == "Logs" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                }
            }

            Spacer()

            // Home tab button (centered in the HStack)
            Button(action: { self.selectedTab = "Home" }) {
                VStack {
                    Image(systemName: "house")
                        .foregroundColor(selectedTab == "Home" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                    Text("Home")
                        .foregroundColor(selectedTab == "Home" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()
            
            // Settings tab button
            Button(action: { self.selectedTab = "Settings" }) {
                VStack {
                    Image(systemName: "gear")
                        .foregroundColor(selectedTab == "Settings" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                    Text("Settings")
                        .foregroundColor(selectedTab == "Settings" ? Color(hex: appPrimaryColor) : Color(hex: appFontPrimaryColor))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(20)
    }
}
