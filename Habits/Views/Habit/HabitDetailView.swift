//
//  HabitDetailView.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-11-25.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View
{
    let habit: Habit

    @Environment(\.modelContext) private var context

    @State private var isMarkedToday = false
    @State private var todayRecord: HabitRecord?

    var body: some View
    {
        List
        {
            Section("Today")
            {
                VStack(alignment: .leading, spacing: 12)
                {
                    Text(isMarkedToday ? "Nice work! 🎉" : "Did you complete this habit today?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button(action: toggleTodayMark)
                    {
                        HStack(spacing: 12)
                        {
                            Image(systemName: isMarkedToday ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 28, weight: .semibold))
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.white)
                                .shadow(radius: isMarkedToday ? 4 : 0)

                            VStack(alignment: .leading, spacing: 4)
                            {
                                Text(isMarkedToday ? "Marked as done" : "Mark as done")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(isMarkedToday ? "This habit is complete for today." : "Tap to log today as completed.")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.85))
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: isMarkedToday
                                        ? [
                                            Color(red: 0.06, green: 0.42, blue: 0.33), // aprox #0A3A2A
                                            Color(red: 0.09, green: 0.63, blue: 0.52)  // aprox #16A085
                                        ]
                                        : [
                                            Color.primary.opacity(0.12),
                                            Color.primary.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .scaleEffect(isMarkedToday ? 1.02 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Habit Info"))
            {
                NavigationLink
                {
                    StreakView(habit: habit)
                }
                label:
                {
                    Label("Streak", systemImage: "flame.fill")
                        .symbolRenderingMode(.hierarchical)
                }

                NavigationLink
                {
                    CalendarView(habit: habit)
                }
                label:
                {
                    Label("Calendar", systemImage: "calendar.circle")
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadTodayState)
    }
}

extension HabitDetailView
{
    private func startOfToday() -> Date
    {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar.startOfDay(for: Date())
    }

    private func loadTodayState()
    {
        let today = startOfToday()
        let habitID = habit.id

        let predicate = #Predicate<HabitRecord>
        { record in
            record.habit?.id == habitID && record.date == today
        }

        let descriptor = FetchDescriptor<HabitRecord>(
            predicate: predicate
        )

        do
        {
            if let record = try context.fetch(descriptor).first
            {
                todayRecord = record
                isMarkedToday = (record.status == .success)
            }
            else
            {
                todayRecord = nil
                isMarkedToday = false
            }
        }
        catch
        {
            todayRecord = nil
            isMarkedToday = false
        }
    }

    private func toggleTodayMark()
    {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
        {
            if isMarkedToday
            {
                unmarkToday()
            }
            else
            {
                markToday()
            }
        }
    }

    private func markToday()
    {
        let today = startOfToday()

        if let existing = todayRecord
        {
            existing.date = today
            existing.status = .success
        }
        else
        {
            let record = HabitRecord(
                habit: habit,
                date: today,
                status: .success
            )
            context.insert(record)
            todayRecord = record
        }

        isMarkedToday = true

        do { try context.save() } catch { /* opcional: log error */ }
    }

    private func unmarkToday()
    {
        if let record = todayRecord
        {
            context.delete(record)
            todayRecord = nil
        }

        isMarkedToday = false

        do { try context.save() } catch { /* opcional: log error */ }
    }
}

#Preview
{
    let sampleHabit = Habit(
        id: UUID(),
        name: "Go Gym",
        createdAt: Date()
    )

    NavigationStack
    {
        HabitDetailView(habit: sampleHabit)
            .modelContainer(HabitsSampleData.shared.modelContainer)
    }
}
