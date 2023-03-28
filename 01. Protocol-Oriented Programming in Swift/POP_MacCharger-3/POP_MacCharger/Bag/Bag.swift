struct Bag {
    private var items: [Portable] = []
    
    mutating func put(item: Portable) {
        items.append(item)
    }
    
    func printCurrentItems() {
        self.items.forEach {
            print($0)
        }
    }
}
