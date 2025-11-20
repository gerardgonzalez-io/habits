//
//  HabitStreak.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import Foundation

struct HabitStreak: Codable, Hashable
{
    let habitId: UUID
    let currentStreak: Int
    let bestStreak: Int
}

extension HabitStreak
{
    static func make(for habitId: UUID, from records: [HabitRecord]) -> HabitStreak
    {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        // Nos quedamos con los días cumplidos (✅) para este hábito, normalizados a "inicio de día"
        let successDatesSet: Set<Date> = Set(
            records
                .filter { $0.habit?.id == habitId && $0.status == .success }
                .map { calendar.startOfDay(for: $0.date) }
        )
        
        // Si no hay días cumplidos, ambas rachas son 0
        guard !successDatesSet.isEmpty else
        {
            return HabitStreak(habitId: habitId, currentStreak: 0, bestStreak: 0)
        }
        
        let sortedDates = successDatesSet.sorted()
        
        // MARK: - Best streak (mejor racha histórica)
        var bestStreak = 1
        var currentRun = 1
        
        if sortedDates.count > 1
        {
            for index in 1..<sortedDates.count
            {
                let previous = sortedDates[index - 1]
                let current = sortedDates[index]
                
                if let diff = calendar.dateComponents([.day], from: previous, to: current).day,
                   diff == 1
                {
                    // Día consecutivo
                    currentRun += 1
                }
                else
                {
                    // Se rompió la racha, actualizamos best y reseteamos
                    bestStreak = max(bestStreak, currentRun)
                    currentRun = 1
                }
            }
        }
        
        bestStreak = max(bestStreak, currentRun)
        
        // MARK: - Current streak (racha actual hasta hoy)
        var currentStreak = 0
        var day = calendar.startOfDay(for: Date())
        
        while successDatesSet.contains(day)
        {
            currentStreak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: day)
            else
            {
                break
            }
            day = previousDay
        }
        
        return HabitStreak(
            habitId: habitId,
            currentStreak: currentStreak,
            bestStreak: bestStreak
        )
    }
}
