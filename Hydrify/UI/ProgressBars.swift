//
//  ProgressBars.swift
//  Hydrify
//
//  Created by Shubham Tambade on 17/03/24.
//

import SwiftUI


struct CircularProgressBar: View {
    var progress: CGFloat 

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .frame(maxWidth: 200, maxHeight: 200)
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: 0.7)
            .frame(width: 150, height: 150)
    }
}



struct WaterWaveProgressShape: Shape {
    let progress: CGFloat
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate the width of the wave based on progress
        let waveHeight = rect.height * (1 - progress)
        let start = CGPoint(x: 0, y: waveHeight)
        
        // Wave parameters
        let amplitude: CGFloat = 10 // Wave amplitude
        let wavelength: CGFloat = rect.width / 2 // Wave length
        
        path.move(to: start)
        for x in stride(from: 0, through: rect.width, by: 5) {
            let relativeX = x / wavelength
            let sine = sin(relativeX * 2 * .pi + phase)
            let y = waveHeight + amplitude * CGFloat(sine)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct WaterWaveProgressView: View {
    let progress: CGFloat
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.5)) // Fill the circle with the desired color and opacity

            WaterWaveProgressShape(progress: progress, phase: self.phase)
                .fill(Color.blue.opacity(0.0))
                .clipShape(Circle()) // Clip the wave animation to a circle
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        self.phase = .pi * 2
                    }
                }

            Text("\(Int(progress * 1000))ml")
                .font(.title2)
                .foregroundColor(.blue)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(20)
    }
}



struct CombinedProgressView: View {
    var currentIntake: Double
    var viewModel: WaterIntakeViewModel
    @State private var phase: CGFloat = 0

    var body: some View {
        let progress = CGFloat(currentIntake / viewModel.waterAmount)
        let textColor = progress < 0.7 ? Color.gray : Color.white

        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)
                .animation(nil) 

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)

            WaterWaveProgressShape(progress: progress, phase: self.phase)
                .fill(Color.blue.opacity(0.5))
                .clipShape(Circle())
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        self.phase = .pi * 2
                    }
                }

            Text("\(Int(currentIntake))ml")
                .font(.title3)
                .bold()
                .foregroundColor(textColor)
                .animation(nil) 
        }
        .padding(20)
        .frame(width: 200, height: 200)
    }
}




