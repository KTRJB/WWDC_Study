//
//  SandwichStore.swift
//  Sandwiches
//
//  Created by 전민수 on 2023/05/23.
//

import Foundation

class SandwichStore: ObservableObject {
    @Published var sandwiches: [Sandwich]

    init(sandwiches: [Sandwich] = []) {
        self.sandwiches = sandwiches
    }
}

let testStore = SandwichStore(sandwiches: testData)
