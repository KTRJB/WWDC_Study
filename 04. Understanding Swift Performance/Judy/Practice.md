```swift
import Foundation

//struct MovieData: Hashable {
//    let uuid: UUID
//    let currentRank: String
//    let title: String
//    let openDate: String
//    let totalAudience: String
//    let rankChange: String
//    let isNewEntry: Bool
//    let productionYear: String
//    let openYear: String
//    let showTime: String
//    let genreName: String
//    let directorName: String
//    let actors: [String]
//    let ageLimit: String
//}
// --> String 없애기!

struct MovieData: Hashable {
    let uuid: UUID
    let currentRank: Int
    let title: String
    let openDate: Date
    let totalAudience: Int
    let rankChange: Int
    let isNewEntry: Bool
    let productionYear: Date
    let openYear: Date
    let showTime: Double
    let genreName: Genre
    let directorName: String
    let actors: [String]
    let ageLimit: AgeLimit
}

enum AgeLimit: String {
    case all = "전체관람가"
    case twelveOver = "12세이상관람가"
    case fifteenOver = "15세이상관람가"
    case teenagersNotAllowed = "청소년관람불가"
    case fullLimit = "제한상영가"
    
    var age: String {
        switch self {
        case .all:
            return " ALL "
        case .twelveOver:
            return " 12 "
        case .fifteenOver:
            return " 15 "
        case .teenagersNotAllowed:
            return " 18 "
        case .fullLimit:
            return " X "
        }
    }
}

enum Genre {
    case drama
    case horror
    case comedy
    
    var description: String {
        switch self {
        case .drama:
            return "드라마"
        case .horror:
            return "공포"
        case .comedy:
            return "코미디"
        }
    }
}
```
