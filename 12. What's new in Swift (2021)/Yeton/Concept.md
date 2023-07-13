Swift 5.5에서 추가된 내용은 아래와 같다고합니다.

>1. Diversity
>2. Update on Swift Packages
>3. Update on Swift on server
>4. Developer experience improvements
>5. Ergonomic improvements
>6. Asynchronous and concurrent programming

## Diversity
- Swift 개발자 커뮤니티와 Swift 멘토링 프로그램 
    - [swift.org/diversity](https://www.swift.org/diversity/)


## Update on Swift Packages

- Swift Package Index
    - swift Package Manager가 지원하는 패키지를 찾는데 도움이 되는 커뮤니티에서 만든 페이지
    - Swift 5.5, Xcode 13의 기능으로 패키지를 쉽게 찾고 접근할 수 있는 방법을 제공
- Swift Package Collections
    - 선별된 Swift package 목록을 제공하는 Swift Package Collections를 제공함. 이걸 사용하면 더 이상 인터넷에서 패키지를 검색하거나 URL을 복사 붙여 넣기로 추가할 필요가 없음
    - Package Collection은 어디서나 게시할 수 있는 JSON 파일이고 선별된 패키지 목록을 제공하기 위한 기능
- New Swift Packages
    - 4개의 새로운 패키지를 출시함

>- Swift Algorithms
>- Swift Atomics
>- Swift Collections
>- Swift System

- Swift Collections Package
    - Swift에서 사용할 수 있는 자료구조를 확장해주는 패키지

![](https://hackmd.io/_uploads/SJWeJVhF3.png)

이렇게 3개의 자료구조를 패키지를 사용하면 새롭게 사용 가능하게 해 줌

![](https://hackmd.io/_uploads/H13PyVhKh.png)

![](https://hackmd.io/_uploads/HJeuk4hYn.png)

![](https://hackmd.io/_uploads/HytdJ4hYh.png)

- Swift Algorithms Package
    - Sequence, Collection 알고리즘의 새로운 오픈소스

![](https://hackmd.io/_uploads/Hyt71Nhth.png)

위에 존재하는 모든 알고리즘을 제공

- Swift System Package
    - system call의 저수준 인터페이스를 제공하는 패키지
    - Apple, Linux, Window에서 사용할 수 있음

- Swift Numerics Package
    - 올해는 Apple Silicon macs에도 Float 16, Flaot 16 복소수를 사용할 수 있게 됨
    - 로그, 사인, 코사인과 같은 모든 기능에 대한 복소수를 지원

![](https://hackmd.io/_uploads/Sk5Xe43Y2.png)

- Swift ArgumentParser Package

![](https://hackmd.io/_uploads/Hku8gNhK2.png)

## Update on Swift on server

>서버 개발에서 Swift를 지원하기 위해 진행된 작업들을 소개

![](https://hackmd.io/_uploads/rkCe4HnY3.png)

- Linux에서 정적 링크를 활성화해서 앱 시작 시간을 단축하고 단일 파일로 배포할 수 있는 서버 앱 배포를 간소화
- Swift 5.5에서는 Linux에서 사용되는 JSON 인코딩 디코딩이 처음부터 다시 구현돼서 성능이 향상
- AWS Lambda 런타임 라이브러리 자체의 성능을 개선하고 최적화

## Developer experience improvements

- Swift 개발자 경험을 개선하기 위해 개발 문서 부분을 개선
- Xcode 13 내부에 통합된 문서 컴파일러인 DocC가 추가됨
    - DocC는 마크다운 주석과 같이 이미 알고 있는 도구와 기술을 사용하여 문서를 쉽게 작성할 수 있도록 도와줌
- Build Improvements
    - 빌드 속도를 개선하는 작업
    - incremental import를 제공
        - 해당 모듈이 변경될 때 모듈을 import 하는 모든 소스 파일을 더 이상 빌드하지 않음
    - module dependency graph를 미리 계산
        - 변경된 항목만 incremental build를 빠르게 시작
    - extension과 함께 작동하도록 selective recompilation을 확장
        - extension을 사용했을 때 더 적은 수의 재컴파일을 의미
- Memory Management
    -  메모리 관리를 보다 효율적으로 개선
    -  참조 유지, 해제 작업 수를 크게 줄일 수 있도록 컴파일러 내부에서 참조를 추적하는 새로운 방법을 도입
    -  Xcode 설정인 Optimize Object Lifetimes를 추가하여 확인 가능

## Ergonomic improvements

- 변경된 내용들

![](https://hackmd.io/_uploads/HkxUHH2Yh.png)

- Result Builders
    - 잡한 객체 계층을 빠르고 쉽게 설명할 수 있는 새로운 문법
- Enum Codable synthesis
    - enum을 사용한 Codable 구현할 때 기존에는 모든걸 수동으로 구현해야 했는데 이제 Codable 선언만 해주면 가능해짐
- Flexible static member lookup
    -  Enum과 유사하게 사용할 수 있음

```swift
// 이전 코드

protocol Coffee {}
struct RegularCoffee: Coffee {}
struct Cappuccino: Coffee {}

func brew<CoffeeType: Coffee>(_: CoffeeType) {}

brew(Cappuccino().regular)

// 변경 코드

protocol Coffee {}
struct RegularCoffee: Coffee {}
struct Cappuccino: Coffee {}
extension Coffee where Self == Cappucino {
	static var cappucino: Cappucino = { Cappucino() }
}

func brew<CoffeeType: Coffee>(_: CoffeeType) {}

brew(.cappucino.large)
```

- Property wrappers on parameters
    - 원래 구조체에 @propertyWrapper 주석을 사용하여 고유한 property wrapper를 구현했는데 이번 업데이트를 통해 동일한 property wrapper를 함수 및 클로저의 매개변수에도 사용 가능하게 바뀜

>예시
```swift
func LogIn(@NonEmpty _ username: String) { ... }
```

> SwiftUI의 개선사항 

변경 전
```swift
import SwiftUI

struct SettingsView: View {
    @State var settings: [Setting]

    private let padding = 10.0

    var body: some View {
        List(✅0 ..< settings.count) { index in 
            #if os(macOS)
            ✅Toggle(settings[index].displayName, isOn: $settings[index].isOn)
                .toggleStyle(✅CheckboxToggleStyle())
            #else
            ✅Toggle(settings[index].displayName, isOn: $settings[index].isOn)
                .toggleStyle(SwitchToggleStyle())
            #endif
        }
        .padding(CGFloat(padding))
    }
}
```

변경 후
```swift
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

## Asynchronous and concurrent programming


>기존의 코드

![](https://hackmd.io/_uploads/BkfU3GpFh.png)
![](https://hackmd.io/_uploads/HkMRaMTt3.png)

하지만 우리가 원하는 것은 그저 "데이터"이다! 

>Swift 5.5에서 변한 코드

![](https://hackmd.io/_uploads/Hk8mkX6K2.png)


- async를 메서드 뒤에 붙임으로써 이 함수는 일시 중단을 지원하도록 컴파일되야한다는 것을 알려준다. 
- 또 위의 await 코드를 사용함으로써 URLSession이 실행되고 URLSession의 응답이 완료될 때까지 fetchImage 메서드가 일시중지된다. 응답이 완료되면 그 때 함수의 기능이 재개된다.

1. 비동기 메서드는 일시 중단된 동안 리소스를 사용하지 않는다. 
2. 스레드를 차단하지도 않기 때문에 Swift 런타임은 이 메서드가 다른 작업을 위해 실행중인 스레드를 재사용할 수 있다.
3. 이를 통해 많은 비동기 프로세스 간 매우 적은 수의 스레드를 공유할 수 있다. 
4. 제어흐름이 위 -> 아래로
5. 더이상 중첩된 복잡한 클로저가 필요하지 ❌
6. try/catch 오류 처리 사용 가능

=> 자세한건 WWDC Meet async / await in Swift를 보시라~


## async/await를 사용하는 Swift의 새로운 동시성 지원에 대해 알아보자

>문제 상황

![](https://hackmd.io/_uploads/SkomzVpF3.png)

- 3개의 다른 이미지를 렌더링 한 뒤 merge 하는 함수
- 위와 같이 순차적으로 진행되는 코드
- 이전 이미지가 완료된 후에만 시작된다는 문제점이 있음
- 동시에 그려지게 하려면?


>개선

![](https://hackmd.io/_uploads/r1vczV6Fh.png)

![](https://hackmd.io/_uploads/B1HTzEaK2.png)

- async let 구문을 사용하여 처음 두 작업을 병렬로 실행
- 다른 스레드에서 계산되는 결과를 기다려야하므로 일시 중단할 수 있도록 async 선언
- 해당 값들이 준비될 때까지 merge 작업을 기다릴 수 있도록 await 키워드 사용
-  둘 중 하나의 작업이라도 완료되지 않았다면 함수가 반환되지 않기 때문에 혹시라도 오류가 있으면 반환하기 위한 throws, try 오류처리도 해줌

> 문제 상황

멀티 스레드 환경에서 자주 발생하는 문제 중 하나인 공유자원을 처리하는 문제는 async, await 만으로 해결할 수 없다.

![](https://hackmd.io/_uploads/S1BmINat3.png)

- increment 메서드를 호출할 때마다 counter 업데이트가 필요함
- 다중 스레드 시스템에서는 제대로 작동하지 않음

> 개선 (actor 사용)

![](https://hackmd.io/_uploads/Syau8VTFh.png)

- actor 외부에서 actor 메서드 호출시 일반적으로 await을 사용하기 때문에 데이터 손상 위험 없이 actor에서 다른 메서드를 실행할 수 있다.

>데이터를 actor로 패키징함으로써 이 데이터가 동시에 액세스될 것으로 예상하고 Swift 컴파일러와 런타임이 손상이 없도록 액세스를 조정하기를 원한다는 것을 명확하게 진술

## Swift의 미래.. Swift 6

컴파일러가 개발 프로세스 초기에 더 많은 종류의 동시성 실수를 포착하고 이러한 문제를 수정하는 데 더 자세한 오류와 지침을 제공하는 방법을 이미 연구하고 있습니다.

동시성 버그를 완전히 제거하여 비동기 및 동시 프로그래밍을 다른 종류의 프로그래밍보다 복잡하지 않게 만드는 것입니다.

