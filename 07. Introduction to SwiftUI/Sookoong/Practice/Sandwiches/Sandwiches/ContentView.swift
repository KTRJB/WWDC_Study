//
//  ContentView.swift
//  Sandwiches
//
//  Created by 전민수 on 2023/05/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: SandwichStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.sandwiches) { sandwich in
                    SandwichCell(sandwich: sandwich)
                }
                .onMove(perform: moveSandwiches)
                .onDelete(perform: deleteSandwiches)

                HStack {
                    Spacer()
                    Text("\(store.sandwiches.count) Sandwiches")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .navigationTitle("Sandwiches")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add", action: makeSandwich)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    #if os(iOS)
                    EditButton()
                    #endif
                }
            }

            Text("Select a aandwich")
        }
    }

    func makeSandwich() {
        withAnimation {
            store.sandwiches.append(Sandwich(name: "Patty melt", ingredientCount: 3))
        }
    }

    func moveSandwiches(from: IndexSet, to: Int) {
        withAnimation {
            store.sandwiches.move(fromOffsets: from, toOffset: to)
        }
    }

    func deleteSandwiches(offsets: IndexSet) {
        withAnimation {
            store.sandwiches.remove(atOffsets: offsets)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: testStore)
        ContentView(store: testStore)
            .environment(\.dynamicTypeSize, .xxxLarge)
        ContentView(store: testStore)
            .preferredColorScheme(.dark)
            .environment(\.dynamicTypeSize, .xSmall)
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.locale, Locale(identifier: "ko"))
    }
}

struct SandwichCell: View {
    var sandwich: Sandwich

    var body: some View {
        NavigationLink(destination: SandwichDetail(sandwich: sandwich)) {
            HStack {
                Image(sandwich.imageName)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(sandwich.name)
                    Text("\(sandwich.ingredientCount) ingredients")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
