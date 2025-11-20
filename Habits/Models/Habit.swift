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
    static let sampleData: [Habit] = [
        Habit(name: "Go Gym"),
        Habit(name: "No sugar"),
        Habit(name: "Study")
    ]
}
