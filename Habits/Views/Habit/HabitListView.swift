//
//  HabitList.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import SwiftUI
import SwiftData

struct HabitListView: View
{
    @Query(sort: \Habit.name) private var habits: [Habit]
    @Environment(\.modelContext) private var context
    @State private var newHabit: Habit?
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(habits)
                { habit in
                    NavigationLink(habit.name)
                    {
                        HabitDetailView(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationTitle("Your habits")
            .toolbar
            {
                ToolbarItem
                {
                    Button("Add habit", systemImage: "plus", action: addHabit)
                }
                ToolbarItem(placement: .topBarTrailing)
                {
                    EditButton()
                }
            }
            .sheet(item: $newHabit)
            { habit in
                NavigationStack
                {
                    NewHabitView(habit: habit)
                }
                .interactiveDismissDisabled()
            }
        }
    }
    
    private func addHabit()
    {
        let newHabit = Habit(name: "")
        context.insert(newHabit)
        self.newHabit = newHabit
    }

    private func deleteHabit(_ indexes: IndexSet)
    {
        for index in indexes
        {
            context.delete(habits[index])
        }
    }
}

#Preview("Dark")
{
    HabitListView()
        .modelContainer(HabitsSampleData.shared.modelContainer)
        .preferredColorScheme(.dark)
}

#Preview("Light")
{
    HabitListView()
        .modelContainer(HabitsSampleData.shared.modelContainer)
        .preferredColorScheme(.light)
}

