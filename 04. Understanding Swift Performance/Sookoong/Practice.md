```swift
import Foundation

// Expensive Copies of Large Values

protocol Drawable {
    func draw()
}

struct Point : Drawable {
    var x, y: Double
    func draw() {
        print("점 그리기")
    }
}

//struct Line : Drawable {
//    var x1, y1, x2, y2: Double
//    func draw() {
//        print("선 그리기")
//    }
//}

struct Pair {
    var first: Drawable
    var second: Drawable

    init(_ f: Drawable, _ s: Drawable) {
        first = f
        second = s
    }
}

//let aLine = Line(x1: 1.0, y1: 1.0, x2: 1.0, y2: 1.0)
//let pair = Pair(aLine, aLine)
//let copy = pair

// Indirect Storage with Copy-on-Write

class LineStorage {
    var x1, y1, x2, y2: Double

    init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
}

struct Line : Drawable {
    var storage: LineStorage

    init() {
        storage = LineStorage(x1: 0, y1: 0, x2: 0, y2: 0)
    }

    func draw() {
        print("x1은 \(storage.x1), y1은 \(storage.y1), x2은 \(storage.x2), y2은 \(storage.y2)")
    }

    mutating func move(x1: Double, y1: Double, x2: Double, y2: Double) {
        if !isKnownUniquelyReferenced(&storage) {
            storage = LineStorage(x1: x1, y1: y1, x2: x2, y2: y2)
        }
    }
}

let aLine = Line()
var copy = aLine

copy.move(x1: 1, y1: 2, x2: 3, y2: 4)
copy.draw() // x1은 1.0, y1은 2.0, x2은 3.0, y2은 4.0
aLine.draw() // x1은 0.0, y1은 0.0, x2은 0.0, y2은 0.0

```
