import SwiftUI
import WidgetKit

struct ContentView: View {
    private let appGroup = "group.com.udhaya.internshipcountdown"

    @State private var endDate: Date = {
        var c = DateComponents()
        c.year = 2026; c.month = 12; c.day = 15
        return Calendar.current.date(from: c) ?? Date()
    }()
    @State private var label = "Internship ends"
    @State private var saved = false

    private var defaults: UserDefaults? { UserDefaults(suiteName: appGroup) }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Leave empty for no title", text: $label)
                }
                Section("End date") {
                    DatePicker("End date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                Section {
                    Button(saved ? "Saved ✓" : "Save") { save() }
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("Countdown")
            .onAppear(perform: load)
        }
    }

    private func load() {
        if let d = defaults?.object(forKey: "endDate") as? Date { endDate = d }
        if let l = defaults?.string(forKey: "label") { label = l }
    }

    private func save() {
        defaults?.set(endDate, forKey: "endDate")
        defaults?.set(label, forKey: "label")
        WidgetCenter.shared.reloadAllTimelines()
        withAnimation { saved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { saved = false }
        }
    }
}

#Preview { ContentView() }
