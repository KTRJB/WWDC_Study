```swift
class ViewController: UIViewController {
    private var internalState: Int = 0
    private let internalQueue: DispatchQueue = DispatchQueue.global()
    var cards: Int {
        get {
            return internalQueue.sync { internalState }
        }
        set(newState) {
            internalQueue.sync { internalState = newState }
        }
    }
    
//    var cards = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }


    func start() {
        DispatchQueue.global().async {
            for _ in 1...10 {
                self.cards += 1
                print("수꿍: \(self.cards) 카드를 뽑았습니다!")
            }
        }
        
        DispatchQueue.global().async {
            for _ in 1...10 {
                self.cards += 1
                print("예톤: \(self.cards) 카드를 뽑았습니다!")
            }
        }
        
        DispatchQueue.global().async {
            for _ in 1...10 {
                self.cards += 1
                print("그루트: \(self.cards) 카드를 뽑았습니다!")
            }
        }
    }
}
```
