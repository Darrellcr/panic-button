//
//  HistoryView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 20/06/25.
//

import SwiftUI

struct HistoryItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var date: Date
    var location: String
    var reason: String
}

struct HistoryView: View {
    @State var historyItems: [HistoryItem]
    
    @State private var expandedSections: Set<String> = []
    
    var groupedHistory: [String: [HistoryItem]] {
        Dictionary(grouping: historyItems) { formatMonthYear(from: $0.date) }
    }
    
    var body: some View {
        NavigationStack {
            
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(groupedHistory.sorted(by: { $0.key < $1.key }), id: \.key) { key, items in
                        sectionView(title: key, items: items)
                    }
                }
                .padding(.vertical)
                .animation(.easeInOut, value: expandedSections)
            }
            .navigationTitle("History")
        }
    }
    
    // MARK: - Section View
    func sectionView(title: String, items: [HistoryItem]) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut) {
                    if expandedSections.contains(title) {
                        expandedSections.remove(title)
                    } else {
                        expandedSections.insert(title)
                    }
                }
            }) {
                HStack {
                    // ini buat nampilin bulan + tahun
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(expandedSections.contains(title) ? 90 : 0))
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.backColor1))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if expandedSections.contains(title) {
                itemListView(items: items)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
    
    // MARK: - Item List View
    func itemListView(items: [HistoryItem]) -> some View {
        VStack(spacing: 10) {
            ForEach(items.sorted(by: { $0.date < $1.date }), id: \.date) { item in
                itemView(item: item)
            }
        }
    }
    
    // MARK: - Item View
    func itemView(item: HistoryItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                // tampilin hari
                Text(item.date, format: .dateTime.day(.twoDigits))
                    .font(.headline)
                // tampilin jam + menit
                Text(item.date, format: .dateTime.hour().minute())
                    .font(.caption)
                    .foregroundStyle(.gray.opacity(1))
            }
            .frame(width: 60)
            .padding(8)
            .background(Color(.white))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                // tampilin location
                Text(item.location)
                    .font(.body)
                // tampilin reason, kalau misal null harus jadi -
                Text(item.reason)
                    .font(.callout)
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
        .background(Color(.backColor1.opacity(0.1)))
        .cornerRadius(12)
    }
}

// MARK: - Helper
func formatMonthYear(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "id_ID")
    formatter.dateFormat = "MMMM yyyy"
    return formatter.string(from: date)
}

func dateFromString(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yy HH:mm:ss"
    return formatter.date(from: string) ?? Date()
}



#Preview {
    
    HistoryView(historyItems: [
        HistoryItem(date: dateFromString("18/06/25 10:30:00"), location: "Universitas Ciputra", reason: "Jatuh"),
        HistoryItem(date: dateFromString("20/06/25 14:20:00"), location: "Universitas Ciputra", reason: "Kesandung"),
        HistoryItem(date: dateFromString("21/05/25 04:20:00"), location: "Universitas Ciputra", reason: "Kejatuhan barang"),
        HistoryItem(date: dateFromString("02/05/25 19:15:00"), location: "Cafe XYZ", reason: "Pingsan")
    ])
    
}
