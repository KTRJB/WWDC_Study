//
//  POP.swift
//  WWDCExample
//
//  Created by 김주영 on 2023/03/27.
//

import Foundation

// Class
class OrderedClass {
    func precedes(other: OrderedClass) -> Bool {
        fatalError("implement me!")
    }
}

class NumberClass: OrderedClass {
    var value: Double = 0
    
    override func precedes(other: OrderedClass) -> Bool {
        return value < (other as! NumberClass).value
    }
}

func binarySearch(sortedKeys: [OrderedClass], forKey k: OrderedClass) -> Int {
    var lo = 0
    var hi = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(other: k) { lo = mid + 1 }
        else { hi = mid }
    }
    return lo
}


// Protocol
protocol OrderedProtocol {
    func precedes(other: Self) -> Bool
}

struct NumberProtocol: OrderedProtocol {
    var value: Double = 0

    func precedes(other: NumberProtocol) -> Bool {
        return value < other.value
    }
}


// 타입으로 사용할 수 없어 제네릭 형태로 사용
func binarySearch<T: OrderedProtocol>(sortedKeys: [T], forKey k: T) -> Int {
    var lo = 0
    var hi = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(other: k) { lo = mid + 1 }
        else { hi = mid }
    }
    return lo
}
