## swift 5.5는 최고의 언어다!
### Diversity
- 스위프트의 다양한 다양성을 위해서 만든 https://www.swift.org/diversity/가 있으니 커뮤니티에서 다양한 사람들과 대화해라
### Update on Swift packages
#### Swift Package Index
- Swift Package Manager를 지원하는 패키지를 찾는 데 도움이 되는 커뮤니티에서 만든 페이지
#### Swift Package Collections
- CommandLine과 Xcode 13에서 사용할 수 있는 Swift Package 선별목록
- 패키지 컬렉션을 사용하면 더 이상 인터넷에서 패키지를 검색하거나 패키지를 추가하기 위해 URL을 복사하여 붙여넣을 필요가 없다.
- 패키지 컬렉션은 어디에서나 게시할 수 있는 간단한 JSON 파일
#### Swift Collections
- Swift 표준 라이브러리에서 사용할 수 있는 데이터 구조를 보완하는 새로운 오픈 소스 패키지

1. Deque
    - Deque는 양쪽 끝에서 효율적인 삽입 및 제거를 지원
```swift
import Collections

var colors: Deque = ["red", "yellow", "blue"]

colors.prepend("green")
colors.append("orange")
// `colors` is now ["green", "red", "yellow", "blue", “orange"]

colors.popFirst() // "green"
colors.popLast() // "orange"
// `colors` is back to ["red", "yellow", "blue"]
```

2. OrderedSet
    - OrderedSet은 Array와 Set의 강력한 하이브리드입니다.
    - Array와 마찬가지로 OrderedSet은 요소를 순서대로 유지하고 임의 액세스를 지원
    - Set과 마찬가지로 OrderedSet는 각 요소가 한 번만 나타나도록 하고 효율적인 멤버십 테스트를 제공
```swift
import Collections

var buildingMaterials: OrderedSet = ["straw", "sticks", "bricks"]

for i in 0 ..< buildingMaterials.count {
    print("Little piggie #\(i) built a house of \(buildingMaterials[i])")
}
// Little piggie #0 built a house of straw
// Little piggie #1 built a house of sticks
// Little piggie #2 built a house of bricks

buildingMaterials.append("straw") // (inserted: false, index: 0)
```

3. OrderedDictionary
    - OrderedDictionary는 순서가 중요하거나 요소에 대한 임의 액세스가 필요할 때 Dictionary의 유용한 대안
```swift
import Collections

var responses: OrderedDictionary = [200: "OK", 403: "Forbidden", 404: "Not Found"]

for (code, phrase) in responses {
    print("\(code) (\(phrase))")
}
// 200 (OK)
// 403 (Forbidden)
// 404 (Not Found)
```

#### The Algorithms package
- Swift Algorithms는 관련 유형과 함께 시퀀스 및 수집 알고리즘의 오픈 소스 패키지
- 요소 컬렉션의 모든 조합 또는 순열을 생성하거나 시퀀스의 요소를 둘 또는 셋으로 반복하거나 술어에 의해 결정된 그룹에서 5개의 가장 작은 컬렉션의 요소, 가장 큰 5개 또는 임의의 5개.... 등 컬렉션에 다양하게 접근 가능

>[swift-algorithms](https://github.com/apple/swift-algorithms)

#### Swift System
- 지난 가을, 우리는 시스템 호출에 관용적인 저수준 인터페이스를 제공하는 라이브러리인 Swift System을 오픈 소스로 공개했다.
- 시스템은 Apple 플랫폼, Linux 및 Windows에서도 사용할 수 있다.
- 시스템의 FilePath 유형에 강력한 새 API를 추가했다.
    - 확장을 쿼리하거나 설정하고, 구성 요소를 추가 및 제거하고, 경로 정규화를 수행하는 기능이 포함
```swift
import System

var path: FilePath = "/tmp/WWDC2021.txt"
print(path.lastComponent)         // "WWDC2021.txt"

print(path.extension)             // "txt"
path.extension = "pdf"            // path == "/tmp/WWDC2021.pdf"
path.extension = nil              // path == "/tmp/WWDC2021"
print(path.extension)             // nil

path.push("../foo/bar/./")        // path == "/tmp/wwdc2021/../foo/bar/."
path.lexicallyNormalize()         // path == "/tmp/foo/bar"
print(path.ends(with: "foo/bar")) // true!
```

![스크린샷 2023-07-10 오후 10 28 07](https://github.com/Groot-94/WWDC_Study/assets/96932116/472b3bda-e31c-4c68-901c-1725cd5c7239)

#### Swift Numerics
- Apple Silicon Mac에 Float16 지원과 Float16 기반 복소수를 만드는 기능을 추가

```swift
import Numerics

let x: Float16 = 1.5
let y = Float16.exp(x)

let z = Complex(0, Float16.pi) // πi
let w = Complex.exp(z)         // exp(πi) ≅ -1
```

#### Swift ArgumentParser???
- Fish 셸용 코드 완성 스크립트를 생성하는 기능, 결합된 짧은 옵션 및 향상된 오류 메시지와 같은 기능을 개선????

### Update On Swift on server
- 서버 개발에서 Swift를 지원하기 위해 수행한 몇 가지 작업에 대한 이야기
1. Static linking on Linux
    - 애플리케이션 시작 시간을 개선하고 이제 단일 파일로 배포할 수 있는 서버 애플리케이션의 배포를 단순화
2. Improved JSON performance
    - Swift 5.5에서는 Linux에서 사용되는 JSON 인코딩 및 디코딩이 처음부터 다시 구현되어 대부분의 일반적인 사용 사례에서 성능이 향상
3. Enhanced AWS Lambda runtime
    - AWS Lambda 런타임 라이브러리 자체의 성능을 개선하고 최적화
    
### Developer experience imporvements
#### DocC
- Swift 프레임워크 또는 패키지 사용 방법을 가르치는 데 도움이 되도록 Xcode 13 내부에 깊이 통합된 문서 컴파일러
- Swift 소스 코드의 마크다운 주석과 같이 이미 알고 있고 좋아하는 도구와 기술을 사용하여 문서를 쉽게 작성하고 비교할 수 있도록 구축됨.

#### Build imporvements
1. Faster builds when changing imported modules
    - incremental import를 지원 -> 모듈이 변경될 때 모듈을 가져오는 모든 소스 파일을 더 이상 다시 빌드하지 않아도 된다.
2. Faster startup time before launching compiles
    - 이제 모듈 종속성 그래프를 미리 계산하여 변경된 항목에 대해서만 증분 빌드를 빠르게 시작
3. Fewer recompilations after changing an extension body
    - 확장과 함께 작동하도록 선택적 재컴파일을 확장. 이는 확장의 본문을 변경할 때 더 적은 재컴파일을 의미
- Swift 5.5에서 증분 가져오기를 통해 가져온 모듈이 변경될 때 재컴파일하는 파일 수가 10분의 1도 안 되고 빌드 시간이 약 1/3 감소함.

#### Memory Management
- Swift에서 메모리 관리를 보다 효율적으로 만들어 Swift 프로그램이 메모리를 더 빨리 회수하도록 개선

### Ergonomic improvements
#### Enum Codable Synthesis
```swift
enum Command {
    case load(key: String)
    case store(key: String, value: Int)
}
```
- enum을 사용한 Codable 구현할 때 기존에는 모든걸 수동으로 구현해야 했다.
```swift
// You used to have to manually implement all of this boilerplate.

enum Command: Codable {
    case load(key: String)
    case store(key: String, value: Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.count != 1 {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Invalid number of keys found, expected one.")
            throw DecodingError.typeMismatch(Command.self, context)
        }

        switch container.allKeys.first.unsafelyUnwrapped {
        case .load:
            let nested = try container.nestedContainer(
                keyedBy: LoadCodingKeys.self,
                forKey: .load)
            self = .load(
                key: try nested.decode(String.self, forKey: .key))
        case .store:
            let nested = try container.nestedContainer(
                keyedBy: StoreCodingKeys.self,
                forKey: .store)
            self = .store(
                key: try nested.decode(String.self, forKey: .key),
                value: try nested.decode(Int.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .load(key):
            var nested = container.nestedContainer(keyedBy: LoadCodingKeys.self, 
                                                   forKey: .load)
            try nested.encode(key, forKey: .key)
        case let .store(key, value):
            var nested = container.nestedContainer(keyedBy: StoreCodingKeys.self, 
                                                   forKey: .store)
            try nested.encode(key, forKey: .key)
            try nested.encode(value, forKey: .value)
        }
    }

    /// Contains keys for all cases of the enum.
    enum CodingKeys: CodingKey {
        case load
        case store
    }

    /// Contains keys for all associated values of `case load`.
    enum LoadCodingKeys: CodingKey {
        case key
    }

    /// Contains keys for all associated values of `case store`.
    enum StoreCodingKeys: CodingKey {
        case key
        case value
    }
}
```
- 하지만, 이젠 Codable 선언으로 끝.
```swift
enum Command: Codable {
    case load(key: String)
    case store(key: String, value: Int)
}
```

#### Flexible static member lookup
- Swift의 유형 검사기에 몇 가지 주요 개선
- Swift에서 유형 추론은 중복 유형 정보를 생략할 수 있음을 의미
    - Coffee.regular를 .regular로 줄일 수 있다.
```swift
enum Coffee {
    case regular
    case decaf
}

func brew(_ coffee: Coffee) { ... }

brew(.regular)
```

- 만약 프로토콜을 준수하는 유형 모음이 있고 API에서 해당 유형의 인스턴스를 사용하려는 경우
- 아래와 같이 .large와 같은 연관값 참조를 포함하여 일반 컨텍스트에서 정적 속성에 대해 보다 일반적으로 추론할 수 있도록 하는 Swift의 유형 검사기 개선으로 가능
```swift
protocol Coffee { ... }
struct RegularCoffee: Coffee { }
struct Cappuccino: Coffee { }
extension Coffee where Self == Cappucino {
    static var cappucino: Cappucino { Cappucino() }
}

func brew<CoffeeType: Coffee>(_ coffee: CoffeeType) { ... }

brew(.cappucino.large)
```

#### Property wrappers on parameters
- 동일한 속성 래퍼를 함수 및 클로저 매개변수에 사용할 수 있다.
```swift
@propertyWrapper
struct NonEmpty<Value: Collection> {
    init(wrappedValue: Value) {
        precondition(!wrappedValue.isEmpty)
        self.wrappedValue = wrappedValue
    }

    var wrappedValue: Value {
        willSet { precondition(!newValue.isEmpty) }
    }
}

func logIn(@NonEmpty _ username: String) {
    print("Logging in: \(username)")
}
```

- SwiftUI 코드에서 개선사항을 확인해보자
```swift
// Instead of writing this...

import SwiftUI

struct SettingsView: View {
    @State var settings: [Setting]

    private let padding = 10.0

    var body: some View {
        List(0 ..< settings.count) { index in
            #if os(macOS)
            Toggle(settings[index].displayName, isOn: $settings[index].isOn)
                .toggleStyle(CheckboxToggleStyle())
            #else
            Toggle(settings[index].displayName, isOn: $settings[index].isOn)
                .toggleStyle(SwitchToggleStyle())
            #endif
        }
        .padding(CGFloat(padding))
    }
}
```

- 개선 된 유형 추론을 통해 중복을 제거함.(Toggle)
- 속성 래퍼를 매개변수로 사용함.($settings)
```swift
// You can now write this.

import SwiftUI

struct SettingsView: View {
    @State var settings: [Setting]

    private let padding = 10.0

    var body: some View {
        List($settings) { $setting in 
            Toggle(setting.displayName, isOn: $setting.isOn)
              #if os(macOS)
              .toggleStyle(.checkbox)
              #else
              .toggleStyle(.switch)
              #endif
        }
        .padding(padding)
    }
}
```

### Asynchronous and concurrent programing
- 일반적으로 코드는 순차적으로 실행된다.
- Asynchronous 코드는 코드 실행에서 지연이 발생할 수 있다. (네트워크)
- concurrent 코드는 두개의 코드를 함께 실행해야 할 수 있다.
![스크린샷 2023-07-10 오후 11 04 20](https://github.com/Groot-94/WWDC_Study/assets/96932116/8b09664c-d368-46ab-9280-8b25d5838578)

#### Asynchronous Programming with Async/Await
- 기존에 사용하던 비동기 코드는 길고 복잡하다.
- 클로저를 사용하여 비동기 코드를 표현하면 이 코드를 살펴보면서 알 수 있듯이 작업 순서가 다소 어색하다.
- 다소 어색한 실행 순서 외에도 completion handler를 사용하면 try/catch 오류 처리를 사용할 수 없다.

```swift
// Instead of writing this...

func fetchImage(id: String, completion: (UIImage?, Error?) -> Void) {
    let request = self.imageURLRequest(for: id)
    let task = URLSession.shared.dataTask(with: request) {
        data, urlResponse, error in
        if let error = error {
            completion(nil, error)
        } else if let httpResponse = urlResponse as? HTTPURLResponse,
                httpResponse.statusCode != 200 {
            completion(nil, MyTransferError())
        } else if let data = data, let image = UIImage(data: data) {
            completion(image, nil)
        } else {
            completion(nil, MyOtherError())
        }
    }
   task.resume()
}
```

- async/await을 사용해보자
- 데이터 메서드가 시작되는 즉시 함수를 일시 중지할 수 있으며 해당 작업이 완료될 때까지 할당을 완료할 수 없음을 컴파일러에 알리는 **await 키워드**
- 제어 흐름은 위에서 아래로 더 이상 중첩 클로저가 필요하지 않으며 try/catch 오류 처리를 사용할 수 있다.
```swift
// You can now write this.

func fetchImage(id: String) async throws -> UIImage {
    let request = self.imageURLRequest(for: id)
    let (data, response) = try await URLSession.shared.data(for: request)
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode != 200 {
        throw TransferFailure()
    }
    guard let image = UIImage(data: data) else {
        throw ImageDecodingFailure()
    }
    return image
}
```
- 이 경우 URLSession이 요청을 시작하자마자 작업이 다른 곳에서 수행되는 동안 Swift 런타임에 의해 기능이 일시 중지.
- 성공적인 응답이든 오류 발생이든 최종 결과가 준비되면 그때에만 우리의 기능이 재개.
- 비동기 함수는 일시 중단된 동안 리소스를 사용하지 않는다.
    - 특히 스레드를 차단하지 않는다

![스크린샷 2023-07-10 오후 11 11 16](https://github.com/Groot-94/WWDC_Study/assets/96932116/9f36a002-c39b-4cce-af2a-eb80be797cf7)


#### async/await 개념을 기반으로 하는 Swift의 새로운 동시성 지원
- 세 가지 다른 이미지를 렌더링한 다음 결합하는 기능을 만든다고 해보자.
- 배경, 전경 및 제목 이미지는 차례로 렌더링되며 각각은 이전 이미지가 완료된 후에만 시작한다.
- 렌더링 작업이 병렬로 발생하기를 바라고, 세 가지 결과가 모두 나올 때까지 병합 작업도 보류해야 함.

![스크린샷 2023-07-10 오후 11 13 32](https://github.com/Groot-94/WWDC_Study/assets/96932116/53adf4ce-9278-456a-ac1e-c17327fd0844)

- 다른 스레드에서 계산되는 결과를 기다려야 하는 경우 일시 중단할 수 있도록 이 함수를 "async"로 표시
- 다음으로 async let 구문을 사용하여 처음 두 작업을 병렬로 실행
    - 이 초기화는 결과를 사용하려고 할 때까지 다른 코드와 병렬로 실행된다.
- 이 코드의 가장 중요한 점은 백그라운드 작업이 이 기능보다 오래 지속될 수 없다는 것. 
    - 다른 말로 하면, 이 함수는 두 백그라운드 작업 중 하나가 여전히 실행 중인 경우 반환할 수 없으며 반환하지 않는다.
    - 이 함수 내부에서 오류가 발생하면 Swift 런타임은 여전히 ​​백그라운드 작업이 완료될 때까지 기다린다.
![스크린샷 2023-07-10 오후 11 15 50](https://github.com/Groot-94/WWDC_Study/assets/96932116/49f263f2-2389-4872-b6a6-897b25d27659)

#### actors
- 두 개의 개별 스레드가 데이터를 공유할 때마다 데이터가 일치하지 않거나 손상될 위험이 있다.
- actors는 이 문제로부터 데이터를 보호하는데 도움이 됨.

- 아래의 코드는 둘 이상의 스레드가 동시에 증가 메서드를 호출하면 심하게 손상된 카운트로 끝날 수 있다.
```swift
class Statistics {
    private var counter: Int = 0
    func increment() {
        counter += 1
    }
}
```
- Swift actor로 변경하면 이러한 손상을 방지할 수 있다.
- actor는 특정 변경을 수행하는 것이 안전할 때까지 데이터 손상을 유발할 수 있는 모든 작업을 일시 중단하여 작동한다.
- actor 외부에서 actor 메서드를 호출할 때 일반적으로 await를 사용
```swift
actor Statistics {
    private var counter: Int = 0
    func increment() {
        counter += 1
    }
    func publish() async {
        await sendResults(counter)
    }
}

var statistics = Statistics()
await statistics.increment()
```
- 액터는 클래스와 같은 참조 유형이지만 멀티 스레드 환경에서 액터를 안전하게 사용할 수 있도록 설계된 여러 규칙을 따른다.

## Swift 6
- Safe concurrency
- Tell us about your experiences
- Try a compiler snapshot
- Participate in the forums
