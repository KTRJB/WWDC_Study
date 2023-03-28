- 코드
```swift
// Protocol-Oriented Programming in Swift
//
// 다른 사람과 대화를 할때
// 언어가 같으면, 대화가 가능하므로 true 값을,
// 언어가 다르면,  대화가 불가능하므로 false 값을
// return하는 talk(other:) 함수를 생성
// MARK: - Object Oriented Programming
import Foundation

enum Language {
    case Korean
    case Japanese
    case Germany
    case English
    case AnimalLanguage
}
//
//class Talkable {
//    func talk(with other: Talkable) -> Bool {
//        // class는 메서드의 구현부를 필요로 하기 때문에
//        // fatalError를 통한 에러처리로 어쩔수 없이 처리
//        fatalError("This is for body implementaion because of using class")
//    }
//}
//
//func searchTalkablePeople(in members: [Talkable], forKey target: Talkable) -> [String] {
//    var talkablePeople: [String] = []
//
//    for i in members.indices {
//        if members[i].talk(with: target) {
//            let member = members[i] as! Person
//
//            talkablePeople.append(member.name)
//        }
//    }
//
//    return talkablePeople
//}
//
//class Person: Talkable {
//    let name: String
//    let language: Language
//
//    override func talk(with other: Talkable) -> Bool {
//        return language == (other as! Person).language
//    }
//
//    init(name: String, language: Language) {
//        self.name = name
//        self.language = language
//    }
//}
//
//let groot = Person(name: "groot", language: .Japanese)
//let yeton = Person(name: "yeton", language: .Japanese)
//let judy = Person(name: "judy",language: .Germany)
//let sookoong = Person(name: "sookooong", language: .Korean)
//let members = [yeton, judy, sookoong]
//
//print(searchTalkablePeople(in: members, forKey: groot))
// MARK: - Protocol Oriented Programming
//protocol Talkable {
//    func talk(with other: Self) -> Bool
//}
//
//struct Person: Talkable {
//    let name: String
//    let language: Language
//
//    func talk(with other: Person) -> Bool {
//        return language == other.language
//    }
//}
//
//func searchTalkablePeople<T: Talkable>(in members: [T], forKey target: T) -> [String] {
//    var talkablePeople: [String] = []
//
//    for i in members.indices {
//        if members[i].talk(with: target) {
//            let member = members[i] as! Person
//
//            talkablePeople.append(member.name)
//        }
//    }
//
//    return talkablePeople
//}
//
//let groot = Person(name: "groot", language: .Japanese)
//let yeton = Person(name: "yeton", language: .Japanese)
//let judy = Person(name: "judy",language: .Germany)
//let sookoong = Person(name: "sookooong", language: .Korean)
//let members = [yeton, judy, sookoong]
//
//print(searchTalkablePeople(in: members, forKey: groot))
// MARK: - Protocol Extension
//protocol Talkable {
//    func talk(with other: Self) -> Bool
//}
//
//struct Person: Talkable {
//    let name: String
//    let language: Language
//
//    func talk(with other: Person) -> Bool {
//        return language == other.language
//    }
//}
//struct Animal: Talkable {
//    let name: String
//    let language: Language
//
//    func talk(with other: Animal) -> Bool {
//        return language == other.language
//    }
//}
protocol Talkable {
    var name: String { get }
    var language: Language { get }

    func talk(with other: Talkable) -> Bool
}

struct Person: Talkable {
    var name: String
    var language: Language
}

struct Animal: Talkable {
    var name: String
    var language: Language
}

extension Talkable {
    func talk(with other: Talkable) -> Bool {
        return language == other.language
    }
}

let dog = Animal(name: "baduk", language: .AnimalLanguage)
let cat = Animal(name: "nyaong", language: .AnimalLanguage)
let sookoong = Person(name: "sookoong", language: .Korean)
let members: [Talkable] = [cat, sookoong]

func searchTalkablePeople(in members: [Talkable], forKey target: Talkable) -> [String] {
    var talkablePeople: [String] = []

    for i in members.indices {
        if members[i].talk(with: target) {
            let member = members[i]

            talkablePeople.append(member.name)
        }
    }

    return talkablePeople
}

print(searchTalkablePeople(in: members, forKey: dog))
```
