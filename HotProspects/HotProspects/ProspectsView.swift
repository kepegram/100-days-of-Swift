//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Kadin Pegram on 6/29/26.
//

internal import AVFoundation
import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }

    enum SortOrder: String, CaseIterable, Identifiable {
        case name = "Name"
        case mostRecent = "Most Recent"

        var id: Self { self }
    }

    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    @AppStorage("sortOrder") private var sortOrder = SortOrder.name
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()

    let filter: FilterType

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "People to contact"
        }
    }

    var sortedProspects: [Prospect] {
        switch sortOrder {
        case .name:
            prospects.sorted {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        case .mostRecent:
            prospects.sorted {
                $0.dateAdded > $1.dateAdded
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(sortedProspects, selection: $selectedProspects) { prospect in
                NavigationLink {
                    EditProspectView(prospect: prospect)
                } label: {
                    ProspectRow(prospect: prospect, showsContactedStatus: filter == .none)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Move to To Contact", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort contacts", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) { order in
                                Text(order.rawValue)
                            }
                        }
                    }
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "PaulHudson\npaul@hackingwithswift.com",
                    completion: handleScan
                )
            }
        }
    }

    init(filter: FilterType) {
        self.filter = filter

        if filter != .none {
            let showContactedOnly = filter == .contacted

            _prospects = Query(
                filter: #Predicate {
                    $0.isContacted == showContactedOnly
                }
            )
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) {
                    success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct ProspectRow: View {
    let prospect: Prospect
    let showsContactedStatus: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(prospect.name)
                    .font(.headline)

                Text(prospect.emailAddress)
                    .foregroundStyle(.secondary)
            }

            if showsContactedStatus {
                Spacer()

                Image(systemName: prospect.isContacted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(prospect.isContacted ? .green : .secondary)
                    .accessibilityLabel(prospect.isContacted ? "Contacted" : "Not contacted")
            }
        }
    }
}

struct EditProspectView: View {
    @Environment(\.dismiss) var dismiss

    let prospect: Prospect

    @State private var name: String
    @State private var emailAddress: String

    var body: some View {
        Form {
            TextField("Name", text: $name)
                .textContentType(.name)

            TextField("Email address", text: $emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
        }
        .navigationTitle("Edit Prospect")
        .toolbar {
            Button("Save") {
                prospect.name = name
                prospect.emailAddress = emailAddress
                dismiss()
            }
        }
    }

    init(prospect: Prospect) {
        self.prospect = prospect
        _name = State(initialValue: prospect.name)
        _emailAddress = State(initialValue: prospect.emailAddress)
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
