//
//  Habit.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import Foundation
import SwiftData

@Model
class Habit
{
    var id: UUID
    var name: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \HabitRecord.habit)
    var habitRecords: [HabitRecord] = []

    init(id: UUID = UUID(), name: String, createdAt: Date = Date())
    {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}

extension Habit
{
    static let sampleData: [Habit] =
    {
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current

        func daysAgo(_ n: Int) -> Date {
            calendar.date(byAdding: .day, value: -n, to: now)!
        }

        return [
            Habit(name: "Go Gym",   createdAt: daysAgo(10)),
            Habit(name: "No sugar", createdAt: daysAgo(7)),
            Habit(name: "Study",    createdAt: daysAgo(3))
        ]
    }()
}
