## Swift porject update
Swift는 언어 진화를 위해 오픈 프로세스를 따름
새로운 기능이나 동작이 제안되고 이를 **Swift 포럼**에서 공개적으로 검토
<br>


# Expressive code
깔끔한 구문을 사용하여 의미를 쉽게 표현하기

Swift 5.9) `if/else` 및 `switch` 문을 표현식으로 코드를 정리할 수 있는 방법 제공

## if 표현식
```swift
let bullet = 
  isRoot && (count == 0 || !sillExpand) ? ""
	: count == 0 ? "- "
	: maxDepth <= 0 ? "▹ " : "▿ "
```

복잡한 조건으로 `let`을 초기화하려면 복잡한 삼항 연산자 같은 표현식을 사용해야 했음

```swift
let bullet = 
  if isRoot && (count == 0 || !sillExpand) { "" }
	else if count == 0 { "- " }
	else if maxDepth <= 0 { "▹ " }
    else { "▿ " }
```
이제는 if 표현식으로 친숙하고 읽기 쉽게 사용할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/942c7b9f-c719-4306-912e-4ec3dda1758f/image.png)

또 다른 예시로 전역 변수 또는 프로퍼티를 초기화할 때 조건이 필요한 경우 클로저 형식이 필요했음

![](https://velog.velcdn.com/images/juyoung999/post/6bfc9d42-665e-489c-ba55-15e628b2c1b0/image.png)

이제 if 표현식으로 깔끔하게 사용 가능
<br>

## Result builders
SwiftUI와 같은 선언적 구문인 result builder 개선

> - 최적화 타임 검사 성능
> - 향상된 코드 완성
> - 더 정확한 오류 메시지

이전에는 타입 검사기가 많은 유효하지 않은 경로를 탐색하여 오류인 result builder가 실패하는데 오래 걸렸음

Swift 5.8부터 유효하지 않은 코드 타입 검사가 빨라지고 오류 메시지가 정확해짐

![](https://velog.velcdn.com/images/juyoung999/post/73242a05-b77a-49c3-af2f-e64f88ccc6d6/image.png)

이전에는 완전히 다른 부분에서 잘못된 오류가 발생할 수 있었지만 이제 정확한 컴파일러 진단을 받음
<br>


## type 매개변수 팩
제네릭 시스템은 코드가 제공하는 타입에서 원활하게 작동하도록 타입 정보를 보존하는 API를 활성화

![](https://velog.velcdn.com/images/juyoung999/post/50e74472-1656-40fd-b1e9-f11e1e57190e/image.png)

이제 일부 API는 타입뿐만 아니라 전달하는 **인수의 개수**에 대해서도 추상화 

![](https://velog.velcdn.com/images/juyoung999/post/a900b499-8606-46db-bdc1-e216784d6794/image.png)

ex) 한 개부터 세 개의 요청을 받아 여러 개(1~3)의 결과를 반환할 수 있는 함수

이전에는 `overload`를 통해 각 인수 개수 별로 함수를 추가하면 되지만 결국 전달할 수 있는 인수 개수에 상한이 있어 더 많이 전달한 경우 컴파일러 오류가 발생

Swift 5.9) 제네릭 시스템이 인수 개수에 대한 제네릭 추상화를 활성화하여 이 API 패턴을 지원
<br>

```swift
<each Result>
```
이 새로운 개념을 유형 **매개변수 팩**이라고 함

![](https://velog.velcdn.com/images/juyoung999/post/637c9fa1-b6d3-4fb0-9e78-35012aeebe06/image.png)

매개 변수 팩을 사용하면 개별 오버로드가 있는 API를 단일 함수로 축소 가능

-> `evaluate` 메서드는 제한 없이 모든 인수 개수를 처리 가능 
<br>
    
### Swift macro
Swift 5.9) 새로운 매크로 시스템으로 표현적인 API 디자인을 위한 새로운 도구 상자를 제공

매크로를 사용하면 기능을 확장하여 상용구를 제거하고 Swift의 표현력을 더 많이 활용 가능

#### assert 예시
조건의 참/거짓을 판별하는 `assert` 메서드

조건이 거짓이면 프로그램을 종료하지만 무엇이 잘못되었는지 정보를 알 수 없고 대신 파일과 줄 번호만 얻음
자세히 보려면 디버거에서 로깅을 하거나 프로그램을 트랩해야 함

```swift
#assert(max(a, b) == c)
```
"assert"라는 매크로를 확장 ➡️ `#assert`

![](https://velog.velcdn.com/images/juyoung999/post/368c6828-fb03-4a2c-b025-8f28defcd5e6/image.png)

이제 프로그램은 결과에 기여한 각 값과 함께 실패한 `assert`에 대한 코드를 표시

대부분의 매크로는 문자열을 통해 매크로 구현을 위한 모듈 및 타입을 지정하는 "외부 매크로"로 정의

![](https://velog.velcdn.com/images/juyoung999/post/7714f2b6-5bb9-4a00-91b2-ac1b1c9c90d8/image.png)

외부 매크로 유형은 컴파일러 플러그인 역할을 하는 별도의 프로그램에서 정의
- Swift 컴파일러는 매크로 사용을 위한 소스 코드를 플러그인에 전달 
- 플러그인은 새로운 소스 코드를 생성하여 Swift 프로그램에 다시 통합
<br>

---

우리가 작성하는 많은 상용구는 코드에서 파생된 다른 것으로 보강해야 함

열거형을 많이 사용할 때 `filter`로 특정 case를 걸러야 한다면 연산 프로퍼티를 활용할 수 있지만 지저분

![](https://velog.velcdn.com/images/juyoung999/post/dc860399-a742-4efe-b60f-9953604be740/image.png)


`@CaseDetection`를 활용!

속성 래퍼처럼 쓰이는 첨부된 매크로는 적용되는 선언 구문(여기서는 enum)을 입력으로 사용하여 새 코드를 생성

편집기에서 매크로 생성 코드를 검사, 디버깅, 복사 등의 작업을 수행할 수 있음
![](https://velog.velcdn.com/images/juyoung999/post/b1bfd6d6-9852-4b50-bdd1-35cbc55a6401/image.png)

선언을 확장하는 방법에 따라 5가지 역할로 분류
![](https://velog.velcdn.com/images/juyoung999/post/69c30b85-d188-428f-8a5d-77a11468b332/image.png)

1) **member**
- 타입 또는 확장에서 새 멤버를 생성
- `@CaseDetection`이 여기에 속함

2) **peer**
- 비동기 메서드의 Completion Handler 버전을 생성
- 반대로 생성하기 위해 연결된 선언과 함께 새 선언을 추가

3) **accessor**
- 저장된 속성을 계산된 속성으로 전환 가능
- 프로퍼티 액세스에 대한 특정 작업을 수행 또는 실제 저장소를 추상화하는 데 사용

4) **memberAttribute**
- 타입의 특정 멤버에 속성을 도입

5) **comformance**
- 새로운 프로토콜 적합성을 추가
<br>

여러 매크로를 함께 구성하여 유용한 효과를 얻을 수 있음

> 예시) **ObservableObject**를 통해 클래스의 속성에 대한 변경 사항을 관찰 방법
> - 유형이 **ObservableObject**를 준수
> - 속성을 `published`로 표시
> - 뷰에서 **ObservedObject** 속성 래퍼를 사용

이 중 하나의 단계라도 누락되면 예상대로 UI가 업데이트되지 않을 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/f5979eb2-795f-47f1-8b1a-d690c79dd2d5/image.png)

위 과정 없이 `Observable 매크로`를 클래스에 연결하면 모든 저장된 속성을 관찰할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/c3a84389-0f08-4c73-b667-12f33e60313c/image.png)

`Observable 매크로`는 세 가지 매크로 역할의 구성을 통해 작동됨

매크로 역시 Swift 코드이고 매크로가 어떻게 작동되는지 확인하고 싶다면 Xcode 편집기에서 `Expand Macro`를 선택하여 확인 가능
<br>

#### 요약
- Swift 매크로는 보다 표현력이 풍부한 API를 사용하고 코드에서 상용구를 제거하여 새로운 도구를 제공
- 매크로는 일반 Swift 코드를 생성하며 프로그램의 정의된 지점에 통합하므로 그 효과를 쉽게 추론 가능
- 매크로 작업을 이해하려면 확장된 소스 코드가 바로 편집기에 있음
<br>

# Swift everywhere
Swift는 확장 가능한 언어로 설계됨

Swift는 높은 수준의 기능을 가졌으면서도 효율적임

이러한 확장성을 Objective-c를 넘어 C 또는 C++을 사용하는 시스템으로 Swift를 확장

## Swift Foundation
> - **calendar** 계산 기능 20% 향상
> - **Data formatting** 150% 향상
> - **JSON coding** 200-500% 향상

**Foundation**은 `JSONDecoder` 및 `JSONEncoder`를 위한 새로운 Swift 구현을 제공하여 Objective-C 타입을 오가는 왕복 비용을 제거

이러한 개선 사항은 Objective-C에서 Swift로의 연결 비용을 줄인 것 뿐아니라 새로운 Swift 구현이 더 빠르기 때문에 필요
<br>

## 소유권
이제는 낮은 수준의 시스템에서 작동할 때 수준의 성능을 제어를 위해 옵트인 기능이 도입됨

이러한 기능은 `소유권` 개념이 중요
애플리케이션에서 값을 전달할 때 코드의 어떤 부분이 값을 **소유**하는지 초점을 맞춤

구조체나 클래스나 기본적으로 복사 가능
불필요한 복사는 코드의 병목 현상이 될 수 있지만 명시적으로 컴파일러에게 귀찮음을 받는 것보단 병목현상을 찾는게 빠를 수 있음

Swift 5.9) **struct** 및 **enum**에 적용할 수 있는 타입 복사를 억제하는 새로운 구문 도입 - `~Copyable`
![](https://velog.velcdn.com/images/juyoung999/post/e984eee7-ae10-4844-9a52-5ede34993e7e/image.png)


타입이 복사 불가능하면 값이 범위를 벗어날 때 클래스처럼 `deinit`을 지정할 수 있음

- `consuming으`로 표시한 메서드를 호출하면 호출한 메서드에 대한 값 소유권이 포기됨
- 해당 타입은 복사할 수 없으므로 `소유권 포기 = 더 이상 값을 사용할 수 없음`을 의미
- `close`를 호출한 다음 다른 메서드를 사용하는 문제를 해결
- 만약 `close` 이후 다른 메서드를 호출하려 하면 런타임 실패가 아니라 컴파일 오류 메시지가 표시
<br>

## C++ 상호 운용성
Objective-C와의 상호 운용성은 Swift 성공의 핵심이었음

많은 앱에 C++로 구현된 핵심 비즈니스 로직이 있어 이에 대한 인터페이스가 어려웠음

Swift 5.9) Swift에서 직접 C++ 타입 및 함수와 상호 작용하는 기능을 도입

![](https://velog.velcdn.com/images/juyoung999/post/bd3fb94a-1018-4f95-9669-044ced76d8b3/image.png)

Swift 컴파일러는 일반적인 C++ 관용구를 이해하여 많은 타입을 직접 사용 가능

벡터나 맵과 같은 C++ 컨테이너도 Swift의 컬렉션으로 접근 가능
<br>

CMake에서 Swift 지원을 개선하기 위해 CMake 커뮤니티와 협력
이제 Swift 코드를 CMake 빌드에 통합 가능

![](https://velog.velcdn.com/images/juyoung999/post/42d2575c-a09f-4018-b8f4-e1b6f39a8876/image.png)

즉, 크로스 플랫폼 C++ 프로젝트에서 Swift를 채택할 수 있다.
<br>

## Actors and concurrency
Swift 동시성 모델은 다양한 환경과 라이브러리에 적용할 수 있는 추상 모델


> **Task**
> - 어디에서나 실행할 수 있는 순차적인 작업 단위
> - await이 있을 때마다 작업을 일시 중지 후 다시 시작할 수 있음
> 
> **Actor**
> - 격리된 상태에 대한 상호배타적인 접근을 제공하는 동기화 매커니즘
> - 외부에서 Actor를 사용하면 작업을 일시 중지할 수 있으므로 await이 필요


- Task는 global concurrenty pool에서 실행됨
	- 해당 풀에서 작업 일정을 결정하는 방법은 환경에 따라 다름
- 제한된 환경에서는 다중 스레드 스케즐러의 오버헤드가 허용되지 않을 수 있음
- 추상 모델은 다양한 런타임 환경에 매핑 가능한 유연한 모델로 동일한 Swift 코드가 여러 환경에서 모두 작동
- 콜백 기반 라이브러리와 상호 운용성은 처음부터 `async/await` 지원이 내장
![](https://velog.velcdn.com/images/juyoung999/post/eae92ad9-98c9-4aec-a257-f10ac499dcd1/image.png)

`withCheckedContinuation` 작업을 통해 작업을 일시 중지 후 콜백에 대한 응답으로 다시 시작 가능
<br>

### Actors
Actor는 lock-free 큐 실행이 표준 구현이지만 다른 구현도 가능
대신 다른 제한된 환경에서는 Atomic하지 않을 수 있으므로 spinrock과 같은 동시성 선점을 사용할 수도 있음

Swift 5.9) Custom actor executors를 사용하면 특정 액터가 자체 동기화 메커니즘을 구현 가능

![](https://velog.velcdn.com/images/juyoung999/post/c92c2152-f976-4d1b-96f3-3b82ee2d87c7/image.png)

액터에 직렬 디스패치 큐를 추가하고 해당 디스패치 큐에 해당하는 executor를 생성하는 `unownedSerialExecutor` 구현 추가

이제 Actor 인스턴스에 대한 모든 동기화는 해당 대기열에서 디스패치 비동기화 수행

이 방식을 통해 개별 Actor가 동기화를 제공하는 방법을 잘 제어할 수 있고, Objective-C 또는 C++로 작성되어 아직 Actor를 사용하지 않는 다른 코드와 동기화 가능

![](https://velog.velcdn.com/images/juyoung999/post/05621f94-638d-463a-9fd2-3466a4cf4b1f/image.png)

<br>

### Concurrency
추상 모델은 매우 유연하여 iPhone에서부터 Apple Watch, 서버 그 이상까지 다양한 실행 환경에 적응

Swift Concurrency를 채택하지 않은 코드와 상호 운용 가눙
<br>

### FoundationDB
상용 하드에워에서 실행되고 MacOS, Linux 및 windows 등 다양한 플랫폼을 지원하는 key-value 저장소를 위한 분산 데이터베이스

**FoundationDB**는 C++로 작성된 대규모 코드 베이스가 포함된 오픈 소스 프로젝트 Swift의 상호 운용성을 활용하여 기존 코드 베이스에 통합했습니다.
 
<br><br>

---

[What's new in Swift - 2023](https://developer.apple.com/videos/play/wwdc2023/10164/)
 
