//
//  CalendarView.swift
//  Habits
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-11-25.
//

import SwiftUI
import SwiftData

struct CalendarView: View
{
    let habit: Habit

    @Query private var records: [HabitRecord]
    @State private var monthOffset: Int = 0

    init(habit: Habit)
    {
        self.habit = habit

        let habitID = habit.id
        let predicate = #Predicate<HabitRecord>
        { record in
            record.habit?.id == habitID
        }

        _records = Query(filter: predicate)
    }

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 24)
            {
                header

                calendarGrid

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct DaySlot: Hashable
{
    let date: Date?
    let day: Int?
}

private extension CalendarView
{
    var header: some View
    {
        HStack(alignment: .center)
        {
            Button
            {
                monthOffset -= 1
            }
            label:
            {
                Image(systemName: "chevron.left")
                    .font(.subheadline.weight(.semibold))
                    .padding(8)
                    .contentShape(Rectangle())
            }

            Spacer()

            VStack(alignment: .center, spacing: 4)
            {
                Text(monthTitle)
                    .font(.title2.bold())

                Text("See how you've been showing up for this habit.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button
            {
                guard monthOffset < 0 else { return }
                monthOffset += 1
            }
            label:
            {
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .padding(8)
                    .opacity(monthOffset < 0 ? 1 : 0.3)
                    .contentShape(Rectangle())
            }
        }
    }

    var calendarGrid: some View
    {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

        return VStack(spacing: 12)
        {
            HStack
            {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 10)
            {
                ForEach(makeDays(), id: \.self)
                { slot in
                    if let date = slot.date, let day = slot.day
                    {
                        let status = dayVisualStatus(for: date)
                        dayCell(day: day, status: status)
                    }
                    else
                    {
                        Color.clear
                            .frame(height: 36)
                    }
                }
            }

            legend
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let translation = value.translation.width

                    if translation > 40 {
                        monthOffset -= 1
                    }
                    else if translation < -40 {
                        guard monthOffset < 0 else { return }
                        monthOffset += 1
                    }
                }
        )
    }

    func dayCell(day: Int, status: DayVisualStatus) -> some View
    {
        let (bg, border, text, iconName, iconColor) = colorsAndIcon(for: status)

        return ZStack
        {
            Circle()
                .fill(bg)
                .overlay(
                    Circle()
                        .strokeBorder(border, lineWidth: 1.5)
                )
                .frame(width: 36, height: 36)

            Text("\(day)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(text)

            if let iconName
            {
                VStack
                {
                    Spacer()
                    HStack
                    {
                        Spacer()
                        Image(systemName: iconName)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(iconColor)
                            .padding(2)
                    }
                }
            }
        }
        .frame(height: 40)
    }
    

    var legend: some View
    {
        HStack(spacing: 16)
        {
            HStack(spacing: 6)
            {
                Circle()
                    .fill(successGradient)
                    .frame(width: 14, height: 14)
                Text("Completed")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6)
            {
                Circle()
                    .strokeBorder(Color.red.opacity(0.7), lineWidth: 1.5)
                    .frame(width: 14, height: 14)
                Text("Missed")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6)
            {
                Circle()
                    .fill(Color.secondary.opacity(0.12))
                    .frame(width: 14, height: 14)
                Text("Not started")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.top, 8)
    }
}

private extension CalendarView
{
    enum DayVisualStatus
    {
        case notStarted
        case success
        case missed
    }

    var calendar: Calendar
    {
        var cal = Calendar.current
        cal.timeZone = .current
        return cal
    }

    var todayStart: Date
    {
        calendar.startOfDay(for: Date())
    }

    var habitStart: Date
    {
        calendar.startOfDay(for: habit.createdAt)
    }

    var startOfMonth: Date
    {
        let components = calendar.dateComponents([.year, .month], from: todayStart)
        let baseMonthStart = calendar.date(from: components)!

        return calendar.date(byAdding: .month, value: monthOffset, to: baseMonthStart)!
    }

    var monthTitle: String
    {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = .current
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: startOfMonth)
    }

    var weekdaySymbols: [String]
    {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1

        return (0..<7).map { symbols[($0 + firstWeekdayIndex) % 7] }
    }

    var statusByDay: [Date: HabitStatus]
    {
        var dict: [Date: HabitStatus] = [:]
        for record in records
        {
            let day = calendar.startOfDay(for: record.date)
            dict[day] = record.status
        }
        return dict
    }

    func dayVisualStatus(for date: Date) -> DayVisualStatus
    {
        let dayStart = calendar.startOfDay(for: date)

        if dayStart > todayStart || dayStart < habitStart
        {
            return .notStarted
        }

        if let status = statusByDay[dayStart], status == .success
        {
            return .success
        }
        else
        {
            return .missed
        }
    }
    
    func makeDays() -> [DaySlot]
    {
        let monthDate = startOfMonth
        let range = calendar.range(of: .day, in: .month, for: monthDate) ?? 1..<31
        
        let firstOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: monthDate)
        ) ?? monthDate

        let firstWeekdayIndex = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmpty = (firstWeekdayIndex - calendar.firstWeekday + 7) % 7
        var result: [DaySlot] = []

        result.append(
            contentsOf: Array(
                repeating: DaySlot(date: nil, day: nil),
                count: leadingEmpty
            )
        )

        for day in range
        {
            if let date = calendar.date(bySetting: .day, value: day, of: firstOfMonth)
            {
                result.append(DaySlot(date: date, day: day))
            }
        }

        while result.count % 7 != 0
        {
            result.append(DaySlot(date: nil, day: nil))
        }

        return result
    }
}

// MARK: - Colors

private extension CalendarView
{
    var successGradient: LinearGradient
    {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.42, blue: 0.33), // #0A3A2A aprox
                Color(red: 0.09, green: 0.63, blue: 0.52)  // #16A085 aprox
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    func colorsAndIcon(for status: DayVisualStatus)
        -> (bg: AnyShapeStyle, border: Color, text: Color, iconName: String?, iconColor: Color)
    {
        switch status
        {
        case .success:
            return (
                bg: AnyShapeStyle(successGradient),
                border: .clear,
                text: .white,
                iconName: "checkmark",
                iconColor: .white
            )

        case .missed:
            return (
                bg: AnyShapeStyle(Color.clear),
                border: Color.red.opacity(0.7),
                text: .primary,
                iconName: "xmark",
                iconColor: Color.red.opacity(0.8)
            )

        case .notStarted:
            return (
                bg: AnyShapeStyle(Color.secondary.opacity(0.08)),
                border: Color.secondary.opacity(0.15),
                text: .secondary,
                iconName: nil,
                iconColor: .clear
            )
        }
    }
}

// MARK: - Preview

#Preview
{
    let container = HabitsSampleData.shared.modelContainer
    let habit = Habit.sampleData.first ?? Habit(name: "Go Gym")

    NavigationStack
    {
        CalendarView(habit: habit)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
