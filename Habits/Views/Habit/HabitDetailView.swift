//
//  HabitDetailView.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-11-25.
//

import SwiftUI

struct HabitDetailView: View
{
    let habit: Habit
    @State private var isMarkedToday = false   // Solo para UI por ahora

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

                    Button(action:
                    {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                        {
                            isMarkedToday.toggle()
                        }
                    })
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
                    StreakView()
                }
                label:
                {
                    Label("Streak", systemImage: "flame.fill")
                        .symbolRenderingMode(.hierarchical)
                }

                NavigationLink
                {
                    CalendarView()
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
    }
}
