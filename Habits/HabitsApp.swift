//
//  HabitsApp.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import SwiftUI
import SwiftData

@main
struct HabitsApp: App
{
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var sharedModelContainer: ModelContainer =
    {
        let schema = Schema([
            Habit.self,
            HabitRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do
        {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        }
        catch
        {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene
    {
        WindowGroup
        {
            if hasCompletedOnboarding
            {
                HabitListView()
            }
            else
            {
                OnboardingView
                {
                    hasCompletedOnboarding = true
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
