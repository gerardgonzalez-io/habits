//
//  WelcomePage.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import SwiftUI

struct WelcomePage: View
{
    var body: some View
    {
        VStack
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.tint)

                Image(systemName: "figure.cooldown")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
            
            Text("Welcome to Habits")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text("Build habits, stay consistent, and transform your life.")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview
{
    WelcomePage()
}
