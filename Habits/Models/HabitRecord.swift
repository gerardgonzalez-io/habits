//
//  HabitRecord.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import Foundation
import SwiftData

enum HabitStatus: String, Codable
{
    case success   // ✅ Done
    case failure   // ❌ Fail
    case none      // 🔲 Not completed yet
}

@Model
class HabitRecord
{
    var id: UUID
    @Relationship var habit: Habit?
    var date: Date
    var status: HabitStatus
    
    init(
        id: UUID = UUID(),
        habit: Habit,
        date: Date,
        status: HabitStatus = .none
    ) {
        self.id = id
        self.habit = habit
        self.date = date
        self.status = status
    }
}

extension HabitRecord
{
    static let sampleData: [HabitRecord] =
    {
        let habits = Habit.sampleData
        let now = Date()
        let calendar = Calendar.current

        func daysAgo(_ n: Int) -> Date
        {
            calendar.date(byAdding: .day, value: -n, to: now)!
        }

        func record(_ habit: Habit, _ daysAgoOffset: Int, _ status: HabitStatus) -> HabitRecord
        {
            HabitRecord(
                habit: habit,
                date: daysAgo(daysAgoOffset),
                status: status
            )
        }

        var records: [HabitRecord] = []

        // Habit 0: "Go Gym" - racha actual de 3 días y una racha pasada más larga
        let gym = habits[0]
        records += [
            record(gym, 7, .success),
            record(gym, 6, .success),
            record(gym, 5, .success),
            record(gym, 4, .success),

            record(gym, 3, .failure),

            record(gym, 2, .success),
            record(gym, 1, .success),
            record(gym, 0, .success),
        ]

        // Habit 1: "No sugar"
        let noSugar = habits[1]
        records += [
            record(noSugar, 3, .success),
            record(noSugar, 1, .success),
        ]

        // Habit 2: "Study"
        let study = habits[2]
        records += [
            record(study, 0, .success)
        ]

        return records
    }()
}
