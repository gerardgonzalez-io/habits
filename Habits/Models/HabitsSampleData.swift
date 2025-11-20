//
//  HabitsSampleData.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import Foundation
import SwiftData

@MainActor
class HabitsSampleData
{
    static let shared = HabitsSampleData()

    let modelContainer: ModelContainer

    var context: ModelContext
    {
        modelContainer.mainContext
    }

    var habit: Habit
    {
        Habit.sampleData.first!
    }

    private init()
    {
        let schema = Schema([
            Habit.self,
            HabitRecord.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do
        {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            insertSampleData()
            try context.save()
        }
        catch
        {
            fatalError("Could not create model container: \(error)")
        }
    }

    private func insertSampleData()
    {
        for habit in Habit.sampleData
        {
            context.insert(habit)
        }

        for record in HabitRecord.sampleData
        {
            context.insert(record)
        }
    }
}
