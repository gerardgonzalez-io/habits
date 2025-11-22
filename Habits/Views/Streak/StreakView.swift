//
//  StreakView.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-11-25.
//

import SwiftUI
import SwiftData

struct StreakView: View
{
    let habit: Habit
    
    @Query private var records: [HabitRecord]
    
    init(habit: Habit)
    {
        self.habit = habit

        let habitID = habit.id
        let predicate = #Predicate<HabitRecord> { record in
            record.habit?.id == habitID
        }

        _records = Query(filter: predicate)
    }

    private var streak: HabitStreak
    {
        HabitStreak.make(for: habit.id, from: records)
    }

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 24)
            {
                VStack(spacing: 8)
                {
                    Text(habit.name)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Your streaks")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                ZStack
                {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.06, green: 0.42, blue: 0.33), // #0A3A2A aprox
                                    Color(red: 0.09, green: 0.63, blue: 0.52)  // #16A085 aprox
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(spacing: 16)
                    {
                        HStack(spacing: 10)
                        {
                            Image(systemName: "flame.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.title2)

                            Text("Current streak")
                                .font(.headline)
                                .foregroundStyle(.white)

                            Spacer()
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 4)
                        {
                            Text("\(streak.currentStreak)")
                                .font(.system(size: 54, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text(streak.currentStreak == 1 ? "day" : "days")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.9))

                            Spacer()
                        }

                        Text(streak.currentStreak == 0
                             ? "Start today and begin your streak."
                             : "Keep going, every day you add makes this streak stronger.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(20)
                }
                .shadow(radius: 8, y: 4)

                // Best streak + summary
                VStack(spacing: 16)
                {
                    HStack
                    {
                        VStack(alignment: .leading, spacing: 6)
                        {
                            Text("Best streak")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)

                            HStack(alignment: .firstTextBaseline, spacing: 4)
                            {
                                Text("\(streak.bestStreak)")
                                    .font(.title.bold())
                                Text(streak.bestStreak == 1 ? "day" : "days")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Image(systemName: "medal.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.title2)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.regularMaterial)
                    )

                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text("Tip")
                            .font(.subheadline.bold())

                        Text("Focus on showing up today. Long streaks are just many single days put together.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle("Streak")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    let container = HabitsSampleData.shared.modelContainer

    let habit = Habit.sampleData.first ?? Habit(name: "Go Gym")

    NavigationStack
    {
        StreakView(habit: habit)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
