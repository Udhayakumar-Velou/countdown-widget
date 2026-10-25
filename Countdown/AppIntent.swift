//
//  AppIntent.swift
//  Countdown
//
//  Created by Udhaya on 25/10/2026.
//

import WidgetKit
import AppIntents

enum EndMonth: Int, AppEnum {
    case m1 = 1
    case m2 = 2
    case m3 = 3
    case m4 = 4
    case m5 = 5
    case m6 = 6
    case m7 = 7
    case m8 = 8
    case m9 = 9
    case m10 = 10
    case m11 = 11
    case m12 = 12

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Month" }
    static var caseDisplayRepresentations: [EndMonth: DisplayRepresentation] = [
        .m1: "January",
        .m2: "February",
        .m3: "March",
        .m4: "April",
        .m5: "May",
        .m6: "June",
        .m7: "July",
        .m8: "August",
        .m9: "September",
        .m10: "October",
        .m11: "November",
        .m12: "December",
    ]
}

enum EndDay: Int, AppEnum {
    case d1 = 1
    case d2 = 2
    case d3 = 3
    case d4 = 4
    case d5 = 5
    case d6 = 6
    case d7 = 7
    case d8 = 8
    case d9 = 9
    case d10 = 10
    case d11 = 11
    case d12 = 12
    case d13 = 13
    case d14 = 14
    case d15 = 15
    case d16 = 16
    case d17 = 17
    case d18 = 18
    case d19 = 19
    case d20 = 20
    case d21 = 21
    case d22 = 22
    case d23 = 23
    case d24 = 24
    case d25 = 25
    case d26 = 26
    case d27 = 27
    case d28 = 28
    case d29 = 29
    case d30 = 30
    case d31 = 31

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Day" }
    static var caseDisplayRepresentations: [EndDay: DisplayRepresentation] = [
        .d1: "1",
        .d2: "2",
        .d3: "3",
        .d4: "4",
        .d5: "5",
        .d6: "6",
        .d7: "7",
        .d8: "8",
        .d9: "9",
        .d10: "10",
        .d11: "11",
        .d12: "12",
        .d13: "13",
        .d14: "14",
        .d15: "15",
        .d16: "16",
        .d17: "17",
        .d18: "18",
        .d19: "19",
        .d20: "20",
        .d21: "21",
        .d22: "22",
        .d23: "23",
        .d24: "24",
        .d25: "25",
        .d26: "26",
        .d27: "27",
        .d28: "28",
        .d29: "29",
        .d30: "30",
        .d31: "31",
    ]
}

enum EndYear: Int, AppEnum {
    case y2026 = 2026
    case y2027 = 2027
    case y2028 = 2028
    case y2029 = 2029
    case y2030 = 2030
    case y2031 = 2031

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Year" }
    static var caseDisplayRepresentations: [EndYear: DisplayRepresentation] = [
        .y2026: "2026",
        .y2027: "2027",
        .y2028: "2028",
        .y2029: "2029",
        .y2030: "2030",
        .y2031: "2031",
    ]
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Countdown" }
    static var description: IntentDescription { "Choose the date to count down to." }

    // On: use the date and title saved in the app. Off: use the fields below.
    @Parameter(title: "Use App Settings", default: true)
    var useAppSettings: Bool

    @Parameter(title: "Month", default: .m12)
    var month: EndMonth

    @Parameter(title: "Day", default: .d15)
    var day: EndDay

    @Parameter(title: "Year", default: .y2026)
    var year: EndYear

    // Leave empty to hide the label
    @Parameter(title: "Label", default: "Internship ends")
    var label: String

    var endDate: Date {
        var c = DateComponents()
        c.year = year.rawValue; c.month = month.rawValue; c.day = day.rawValue
        return Calendar.current.date(from: c) ?? Date()
    }
}
