```swift
import Foundation

let queue1 = DispatchQueue(label: "test1")
let queue2 = DispatchQueue(label: "test1")

queue1.async {
    print("다른 스레드")

    DispatchQueue.main.async {
        print("메인 스레드")
    }
}

let workItem1 = DispatchWorkItem(qos: .default, block: {
    print("Work Item 1이 실행됩니다.")
})

let workItem2 = DispatchWorkItem(qos: .default, block: {
    print("Work Item 1이 끝나고 2가 실행됩니다.")
})

let workItem3 = DispatchWorkItem(qos: .default, block: {
    Thread.sleep(forTimeInterval: 3)
    print("Work Item 2가 끝나고 3이 실행됩니다.")
})


let group = DispatchGroup()

group.wait()
queue1.async(group: group, execute: workItem1)
queue.async(group: group, execute: workItem2)
queue.async(group: group, execute: workItem3)
workItem1.notify(queue: queue1, execute: workItem2)
workItem2.notify(queue: .main, execute: workItem3)

group.notify(queue: queue1, work: DispatchWorkItem(block: {
    print("그룹이 끝났습니다")
}))

class MyActor {
    private var internalState: Int = 0
    private let internalQueue: DispatchQueue = DispatchQueue(label: "")
    var state: Int {
        get {
            return internalQueue.sync { internalState }
        }
        
        set (newState) {
            internalQueue.sync { internalState = newState }
        }
    }
    
    init(state: Int) {
        self.internalState = state
    }
    
    deinit {
    }
}

let myActor = MyActor(state: 0)
var number = 0

DispatchQueue.global().async {
    for _ in 0...1000 {
        number += 1
        print(number)
    }
}

DispatchQueue.global().async {
    for _ in 0...1000 {
        number += 1
        print(number)
    }
}

DispatchQueue.global().async {
    for _ in 0...1000 {
        myActor.state += 1
        print(myActor.state)
    }
}

DispatchQueue.global().async {
    for _ in 0...1000 {
        myActor.state += 1
        print(myActor.state)
    }
}

```
