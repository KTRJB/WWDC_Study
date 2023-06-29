# Whats's new in Swift - 2020

Swift 5에 API 안정성이 도입되면서 Swift에 Binary Framework가 도입되었습니다. 이로 인해서 SwiftUI 같은 강력한 API가 등장했습니다.

또한 Swift Package Manager를 사용하여 접근할 수 있는 오픈 소스 API가 증가 되었고 도메인 문제를 해결하기 위한 Cross-Platform으로써 성장할 수 있습니다.

## 1. 런타임 성능 발전에 대해서

Swift 4이후 버전, vs Objective-C 버전

![](https://hackmd.io/_uploads/S14Jlc5_h.png)

Swift 4.1은 코드 크기 최적화로 많은 부분을 제거할 수 있었는데

Swift 5.3에서는 Objective-C 버전 코드 크기의 1.5배 이하로 줄였습니다.

SwiftUI에서는 앱의 코드 크기가 개선되었습니다.

![](https://hackmd.io/_uploads/B1Jme5cdn.png)

## 2. Dirty 메모리 사용한 개선에 대해서

Binary 크기
- 앱 실행할 때마다 클린 메모리라고 부르는 것의 일부라고 부릅니다.
- 필요할 때 다시 로드할 수 있어 제거할 수 있는 메모리입니다.

Dirty 메모리
- 응용 프로그램이 런타임에 할당하고 조작하는 메모리입니다.(중요)

## 3. Swift의 값 타입은 참조 타입보다 근본적인 이점이 있습니다.

예를 들어 UUID, String이 포함된 Object-C의 모델 타입인 경우 살펴봅시다.

해당 모델에 배열을 저장할 시 메모리 유지되는 방법

### Objective-C

![](https://hackmd.io/_uploads/B1h6e9cd3.png)

- 객체 변수는 포인터로 배열이 모델 객체에 대한 포인터를 보유 합니다.
- 해당 객체는 프로퍼티에 대한 포인터를 보유하게 됩니다.
- 할당 시엔 약간의 오버헤드와 성능 및 메모리 사용이 존재하게 됩니다.

### Swift

![](https://hackmd.io/_uploads/Bkyxf95uh.png)

- 값 타입은 포인터를 통한 엑세스가 필요없기 떄문에 UUID는 객체 내부에 저장합니다.
- 작은 문자열은 ASCII가 아닌 문자 포함 최대 15개의 코드 단위로 많은 저장이 가능합니다.
- Mountain 객체 자체를 배열 저장 공간에 직접 할당 합니다.
- 몇몇 String을 제외하고 모두 근처 메모리 블록 내에 유지 하게 됩니다. -> "메모리 이점"

### Heap 사용량

- Swift 5.1 = 20kB
- Objective-C = 35kB

-> Swift의 모델 데이터가 더 컴팩트 하다.

이러한 이점에도 불구하고 Swift는 런타임 오버헤드로 인해 여전히 많은 힙 메모리를 사용했었다.
-> Swift 시작 시 Objective-C 타입과 연결하는 데 사용되는 데이터 항목 저장을 위한 많은 캐시와 메모리를 생성을 했었다.

이제는 이것을 최적화해서 Swift 5.3에서는 작년 릴리즈 시 사용한 힙 메모리의 1/3 미만으로 오버헤드를 줄였습니다.

하지만 이러한 효과를 보기 위해선 최소 배포 대상을 iOS 14로 설정해야 합니다.

## Diagnostics(진단) - 개발자 경험 개선 방법

- 릴리즈 주기 시 컴파일러의 진단
- 오류 및 경고의 개선

Swift 컴파일러에는 문제가 발생한 소스 코드의 위치를 가리켜 오류를 생성하는 진단 전략이 있습니다.

![](https://hackmd.io/_uploads/BJ-9Xcq_n.png)

문제 해결 방법에 대한 지침 + 문제의 원인을 진단하는 휴리스틱을 제공합니다.
문제 진단 시 컴파일러는 내부적으로 문제에 대한 정보를 기록하게 됩니다.

자세한 내용은 New Diagostic Architecture Overview에서 확인해주세요. 

## Code Completion

컴파일러와 SourceKit에서 제공하는 코드 완성 추론과 Xcode 코드 에디터의 경험을 아래와 같은 경험을 통해 경험할 수 있습니다.

- 타입 추론 개선
- KeyPath 함수로 사용하기와 같은 언어의 동적 기능에 대한 기대값 제공

-> 특히 SwiftUI 코드 완성 성능이 크게 향상되었습니다.

## Code Indentation

SourceKit으로 구동되는 Xcode의 코드 들여쓰기 개선사항

- 메서드 호출
- 매개변수 호출
- 튜플 요소
- 여러 줄에 걸친 컬렉션 요소
- 여러 줄에 걸친 if, guard 및 while문

![](https://hackmd.io/_uploads/rkJ9Eccu2.png)


### Debugging

디버그 정보를 사용할 수 있는 경우 디버거는 Swift런타임 실패 트랩에 대한 이유를 표시합니다.

#### 이전
- Swift는 Clang 모듈을 사용, Objective-C에서 API를 가져왔습니다.
- 타입 및 변수에 대한 정보 확인 시 LLDB가 디버깅 컨텍스트에 표시되는 모든 Swift 및 Clang 모듈을 가져와야 함
- 떄떄로 Clang 모듈 가져오기가 컴파일 시간에 실패할 수 있습니다.

#### 현재
- LLDB는 DWARF 디버그 정보에서 Swift 디버깅 목적으로 C 및 Objective-C 타입을 가져올 수 있습니다.

## 플랫폼

### Swift는 휼륭한 범용 언어 입니다.

Apple 플랫폼에서 앱을 구축 시에도 적합하지만 다른 작업에도 적합합니다. 그렇기에 Swift 크로스 플랫폼 지원이 매우 중요합니다.

Swift 지원 플랫폼

- Apple
- Ubunto
- CentOS 8
- Amazon Linux 2
- Windows (coming soon)

## AWS Lambda

서버리스 기능은 클라이언트 애플리케이션 개발자가 애플리케이션을 클라우드로 확장할 수 있는 쉬운 방법입니다.

![](https://hackmd.io/_uploads/BkfMI9cOn.png)

오픈 소스 Swift AWS 런타임을 사용하여 쉽게 사용할 수 있습니다.

## Language and Libraries

위에 논의한 개선사항 외에도 12개 이상의 새로운 기능이 추가 되었습니다.
SE 번호인 경우 SWif Evolution 웹사이트에서 기능 문서를 조회할 수 있습니다.

### Mutiple trailling closure syntax

후행 클로저 - 메서드에 대한 마지막 인수를 괄호 밖으로 꺼낼 수 있는 구문 sugar

명확성 손실 없이 간결하게 중첩을 줄일 수 있어 호출 사이트를 쉽게 읽을 수 있지만 마지막 매겨변수에 대해서만 제한되어 있었습니다.

![](https://hackmd.io/_uploads/ryqGwcq_h.png)

중간에서 사용 시엔 역활이 명확하지 않아 코드 읽기 어려움이 있습니다.

![](https://hackmd.io/_uploads/BkkVvq9dh.png)

클로저 인수 추가 시 코드 재조정이 필요합니다.

![](https://hackmd.io/_uploads/rkwBwc5un.png)

#### API 디자인에서의 후행 클로저

![](https://hackmd.io/_uploads/S1b8vqquh.png)

take 코드의 의미를 파악하기 어렵다.

![](https://hackmd.io/_uploads/r1auwc5On.png)

사람들이 인수 레이블을 삭제할 수 있다고 가정하고 메서드 이름을 지정해보기

ex) take -> prefix

메서드의 기본 이름이 첫 번째 후행 클로저의 역활을 명확히 하는 것이 중요합니다.

### KeyPath expressions as funcsions

Swift 4.1에서 기본 값을 get set할 수 있는 프로퍼티에 대해 호출되지 않은 참조를 나타내는 KeyPath를 도입했습니다.

KeyPath는 간결하고 중첩이 적어 매개변수의 매력적인 대안 입니다.

![](https://hackmd.io/_uploads/ByqbO55On.png)

![](https://hackmd.io/_uploads/S1zMd9c_h.png)

![](https://hackmd.io/_uploads/SywMu99O3.png)

접근할 호출 사이트를 모두 복제하지 않고도 서명이 일치하는 모든 함수 매개변수에서 KeyPath 인수를 전달할 수 있습니다.

![](https://hackmd.io/_uploads/HyuEO9q_3.png)

@main

모든 프로그램은 시작 지점이 필요 합니다.

라이브러리 작성자인 경우 사용자가 진입점으로 파생할 것으로 예상되는 프로토콜 또는 수퍼 크래스에서 정적 기본 메서드를 선언하기만 하면 됩니다.

사용자가 @main으로 해당 타입에 태그를 지정할 수 있고 컴파일러가 사용자를 대신하여 main.swift를 생성할 수 있습니다.

![](https://hackmd.io/_uploads/ryrq_5c_h.png)

### Increased availability of implicit self in clousuers (Clousers에서 암시적 자아의 가용성 증가)

Swift는 캡처하는 escape 클로저에서 self를 명시적으로 사용할 것을 요구합니다.
하지만 연속적으로 self를 포함해야 하는 경우 중복되는 느낌이 강합니다.

Swift는 캡쳐하는 escape 클로저에서 self를 명시적으로 사용할 것을 요구 합니다.
하지만 연속적으로 self를 포함해야 하는 경우 중복되는 느낌 입니다.

![](https://hackmd.io/_uploads/S1rPKccd3.png)

Swift 5.3부터는 캡처 목록에 [self]를 포함 시 클로저 본문에서 생략이 가능 합니다.

self가 값 타입인 경향이 있는 SwiftUI에서 마찬가지로 참조 순환 가능성이 훨씬 적기 때문에 마찬가지로 self가 enum이나 struct인 경우 클로저에서 완전히 생략할 수 있게 되었다.

### Multi-pattern catch clauses

이전) do-catch 문은 catch 절에 switch문을 중첩시켜 사용해왔습니다.

![](https://hackmd.io/_uploads/HkpJc5c_2.png)

Swift 5.3) catch 절의 문법을 확장ㅎ하여 switch 케이스의 권한을 가집니다.

![](https://hackmd.io/_uploads/HywZ595Oh.png)

do-catch문만으로 평면환하여 쉽게 읽을 수 있게 되었습니다.

### Enum Enhancements

Swift 4.1이후 컴파일러는 다양한 타입에 대해 Equatable 및 Hashable 적합성을 가질 수 있었습니다.

![](https://hackmd.io/_uploads/HybUqq5O3.png)

Swift 5.3에서 컴파일러는 enum 타입을 한정하기 위해 comparable 적합성을 합성하는 방법을 배웠습니다.

![](https://hackmd.io/_uploads/BkeFcqq_3.png)

enum case를 프로토콜 case로 논의

![](https://hackmd.io/_uploads/HJ75c59On.png)

케이스? 정적 함수? -> 호출 사이트가 동일

![](https://hackmd.io/_uploads/r1Gn999O3.png)

Swift 5.3에서는 enum case를 개선하여 정적 var 및 정적 func 프로토콜 요구사항을 충족하는데 사용할 수 있습니다.

![](https://hackmd.io/_uploads/HyWFi5q_h.png)


### Embedded DSL Enhancements

작년 내장 DSL에 대한 지원을 추가하여 SwiftUi의 선언적 구문을 강화했습니다.

Swift5.3에서 DSL을 확장하여 if-let 및 switch와 같은 패턴 일치 제어 흐름 문을 지원하게 되었습니다.

![](https://hackmd.io/_uploads/B1z6s9cdh.png)

서로 다른 이미지 레이아웃을 switch문을 사용하여 갤러리를 구성할 수 있습니다.

#### 빌더 추론

이전에는 최상위 수준에서 DSL 구문을 사용하려면 특정 빌더 속성으로 태그를 지정했어야 했습니다.

![](https://hackmd.io/_uploads/BJCbh59O3.png)

Swift 5.3에서는 프로토콜 요구사항에서 빌더 속성을 유추하는 것을 컴파일러가 알고 있기 떄문에 Builder 속성이 더 이상 필요하지 않게 되었습니다.


## SDK

### Float16

- 4바이트를 사용하는 float와 달리 2바이트만 사용합니다.
- 크기가 절반이므로 메모리 페이지에 두 배 할당, 하드웨어 성능이 두 배 향상되었습니다.
- 데이터 타입이 작기 때문에 범위가 제한되어 있으므로 Double 또는 float으로 구현된 코드 변환 시 주의 해야 합니다.

### 애플 아카이브

- 빠른 멀티스레드 압축에 최적
- 애플 아카이브 사용 시 효율적으로 아카이브 압축이 가능합니다.

### 스위프트 시스템

시스템 호출에 관용적인 인터페이스를 제공합니다.

### OSLog

- 고성능, 개인 정보 보호 로깅
- 문자열 보간 기반API
- 표현 형식의 옵션

Swift5.3에서 정교하게 컴파일러를 최적화 했습니다. 오버헤드도 최소화하고 훨씬 빠르고 표현이 풍부해질 겁니다.(버그 찾기 용이)

### Swift Package Manager

#### Swift Numerics

- 숫자에 관련된 새로운 오픈소스 패키지
- 모든 기본적 수학적 함수를 정의

#### Swift Argument Parser

커맨드라인 argument parsing을 위한 새로운 오픈소스 패키지 입니다.

#### Swift Preview Package

프리뷰 패키지는 함수에 대한 접근을 제공합니다.

https://developer.apple.com/videos/play/wwdc2020/10170/