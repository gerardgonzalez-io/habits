//
//  FeaturePage.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import SwiftUI

struct FeaturePage: View
{
    var onFinish: (() -> Void)? = nil
    
    var body: some View
    {
        VStack
        {
            Text("Features")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.top, 100)
            
            FeatureCard(iconName: "checkmark.circle.fill",
                        description: "Turn intentions into habits you actually follow through.")
            
            FeatureCard(iconName: "arrow.triangle.2.circlepath",
                        description: "Stay consistent by showing up for your habits every day.")
            
            FeatureCard(iconName: "flame.fill",
                        description: "Keep your streaks alive and feel the fire of progress.")

            Spacer()

            Button
            {
                finishOnboarding()
            }
            label:
            {
                Text("Get Started")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.2), in: .capsule)
                    .overlay(
                        Capsule().strokeBorder(.white.opacity(0.35), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding()
    }
    
    private func finishOnboarding()
    {
        withAnimation(.easeInOut(duration: 0.25))
        {
            if let onFinish
            {
                onFinish()
            }
        }
    }
}

#Preview
{
    FeaturePage()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
        .foregroundStyle(.white)
}


