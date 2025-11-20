//
//  NewHabitView.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 19-11-25.
//

import SwiftUI
import SwiftData

struct NewHabitView: View
{
    @Bindable private var habit: Habit
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    init(habit: Habit)
    {
        self.habit = habit
    }

    var body: some View
    {
        Form
        {
            TextField("Habit name", text: $habit.name)
                .autocorrectionDisabled()
        }
        .navigationTitle("New Habit")
        .toolbar
        {
            ToolbarItem(placement: .confirmationAction)
            {
                Button("Save")
                {
                    dismiss()
                }
                .disabled(habit.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            ToolbarItem(placement: .cancellationAction)
            {
                Button("Cancel")
                {
                    context.delete(habit)
                    dismiss()
                }
            }
        }
    }
}

#Preview
{
    NavigationStack
    {
        NewHabitView(habit: HabitsSampleData.shared.habit)
    }
}

