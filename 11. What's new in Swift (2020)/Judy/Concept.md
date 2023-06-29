## 배경
- Swift 5에 Binary Framework 도입, 이로 인해 SwiftUI같은 강력한 API 등장
- Swift Package Manager를 사용하여 접근할 수 있는 오픈 소스 API 증가
- 도메인 문제를 해결하기 위한 Cross-Platform으로써 성장
<br>

## 런타입 성능 발전
### Code Size
#### Swift 4 이후 버전 vs Objective-C 버전

![](https://velog.velcdn.com/images/juyoung999/post/6ccab4ba-4a9a-4618-b66f-2bed04c824bf/image.png)

Swift 4.1은 코드 크기 최적화로 많은 부분을 제거
Swift 5.3에서는 Objective-C 버전 코드 크기의 1.5배 이하로 줄임

#### SwiftUI
![](https://velog.velcdn.com/images/juyoung999/post/91b3754a-4d05-4f3b-b9d2-48b1d5a4e2bb/image.png)

Swift 5.3에서 SwiftUI 앱의 코드 크기가 크게 개선됨
<br>

### Dirty 메모리 사용량 개선
Binary 크기  
- 앱을 실행할 때 클린 메모리라고 부르는 것의 일부
- 필요할 때 다시 로드할 수 있어 제거할 수 있는 메모리

**Dirty 메모리** 
- 응용 프로그램이 런타임에 할당하고 조작하는 메모리 -> 중요

Swift의 값 타입은 참조 유형보다 근본적인 이점이 있다

예제) UUID, String이 포함된 Objective-C의 모델 타입
해당 모델을 배열에 저장할 때 메모리에 유지되는 방법

#### Objective-C 
![](https://velog.velcdn.com/images/juyoung999/post/a2e65855-f473-40bd-a16c-cd47e01edc4e/image.png)
- 객체 변수는 포인터로 배열이 모델 객체에 대한 포인터를 보유
- 해당 객체는 프로퍼티에 대한 포인터를 보유
- 할당 시 약간의 오버헤드와 성능 및 메모리 사용 존재
<br>

#### Swift
![](https://velog.velcdn.com/images/juyoung999/post/55184667-9557-44f9-a57e-7042bfe698c3/image.png)
- 값 타입은 포인터를 통한 엑세스가 필요 없어 UUID는 객체 내부에 저장
- 작은 문자열은 ASCII가 아닌 문자 포함 최대 15개의 코드 단위로 많은 문자를 저장 가능
- Mountain 객체 자체를 배열 저장 공간에 직접 할당 
- 몇몇 String을 제외하고 모두 인접한 메모리 블록 내에 유지
=> 상당한 메모리 이점
<br>

#### Heap 사용량
> - **Swift 5.1** = 20kB
> - **Objective-C** = 35kB
-> Swift의 모델 데이터가 더 컴팩트

이러한 이점에도 불구하고 Swift는 런타임 오버헤드로 인해 여전히 많은 힙 메모리를 사용했음
-> Swift를 시작할 때 Objective-C 타입과 연결하는 데 사용되는 데이터 항목 저장을 위한 많은 캐시와 메모리를 생성했움

이것을 최적화하여 Swift 5.3에서는 작년 릴리즈 시 사용한 힙 메모리의 1/3 미만으로 오버헤드를 줄였다!

❕ 이러한 개선 사항을 최대한 활용하려면 최소 배포 대상을 iOS 14로 설정해야 함
<br>

### Diagnostics
> 개발자 경험을 개선하는 방법

- 릴리즈 주기에서 컴파일러의 진단
- 오류 및 경고의 개선

Swift 컴파일러에는 문제가 발생한 소스 코드의 정확한 위치를 가리켜 정확한 오류를 생성하는 새로운 진단 전략이 있다.

![](https://velog.velcdn.com/images/juyoung999/post/9a439720-4556-4583-9a4f-b31d6eaccd45/image.png)

`문제 해결 방법에 대한 지침` + `문제의 원인을 진단하는 새로운 휴리스틱` 제공
문제를 진단할 때 컴파일러는 내부적으로 문제에 대한 정보를 기록

자세한 내용은 Swift.org에서 New Diagostic Architecture Overview에서 확인
<br>

### Code Completion
컴파일러와 SourceKit에서 제공하는 코드 완성 추론과 Xcode 코드 편집기 경험을 통해 수행

1) 타입 추론 개선
2) **KeyPath**를 함수로 사용하기와 같이 언어의 동적인 기능에 대해 기대 값을 제공

특히 SwiftUI에서 코드 완성 성능이 크게 향상
<br>

### Code Indentation
SourceKit으로 구동되는 Xcode의 코드 들여쓰기 개선

- 메서드 호출
- 매개변수 호출
- 튜플 요소
- 여러 줄에 걸친 컬렉션 요소
- 여러 줄에 걸친 if, guard 및 while 문

![](https://velog.velcdn.com/images/juyoung999/post/6532a8f5-2211-42aa-bd6c-d71c7e9e0a6b/image.png)

<br>

### Debugging
디버그 정보를 사용할 수 있는 경우 디버거는 Swift 런타임 실패 트랩에 대한 이유를 표시

**과거**
- Swift는 Clang 모듈을 사용해 Objective-C에서 API를 가져옴
- 타입 및 변수에 대한 정보 확인 시 LLDB가 디버깅 컨텍스트에 표시되는 모든 Swift 및 Clang 모듈을 가져와야 함
- 때때로 Clang 모듈 가져오기가 컴파일 시간에 실패할 수 있음

**현재**
LLDB는 DWARF 디버그 정보에서 Swift 디버깅 목적으로 C 및 Objective-C 타입을 가져올 수 있음
<br>

### 플랫폼
![](https://velog.velcdn.com/images/juyoung999/post/94f902df-d26c-46c6-9fb6-4e5e116b3078/image.png)

**Swift는 훌륭한 범용 언어**
Apple 플랫폼에서 앱을 구축 시에도 적합하지만 다른 작업에도 적합
때문에 Swift 크로스 플랫폼 지원이 매우 중요

#### Swift 지원 플랫폼
- Apple 플랫폼
- Ubunto
- CentOS 8
- Amazon Linux 2
- Windows (coming soon)
<br>

## AWS Lambda
서버리스 기능은 클라이언트 애플리케이션 개발자가 애플리케이션을 클라우드로 확장할 수 있는 쉬운 방법

![](https://velog.velcdn.com/images/juyoung999/post/c0fe272f-fa46-4d96-8d52-8a60dfdb73eb/image.png)
이제 오픈 소스 Swift AWS 런타임을 사용하여 쉽게 수행할 수 있다.
<br>

## Language and Libraries

> 위에 논의한 개선사항 외에도 12개 이상의 새로운 기능이 추가됨
> SE 번호는 SWift Evolution 웹사이트에서 기능 문서를 조회할 수 있음
 
 
### Mutiple trailling closure syntax
> **후행 클로저** 
> = 메서드에 대한 마지막 인수를 괄호 밖으로 꺼낼 수 있는 구문 sugar

명확성 손실 없이 간결하게 중첩을 줄일 수 있어 호출 사이트를 쉽게 읽을 수 있지만 마지막 매개변수에 대해서만 제한되어 있었음
![](https://velog.velcdn.com/images/juyoung999/post/82db3e16-ca91-4449-ba0f-ee6bf0659adc/image.png)

중간에서 사용 시 역할이 명확하지 않아 코드를 읽기 어려움
![](https://velog.velcdn.com/images/juyoung999/post/b82af7d0-9d7f-4467-9ad5-515848d8536d/image.png)

클로저 인수를 추가해야 하는 경우 코드 재조정이 필요
![](https://velog.velcdn.com/images/juyoung999/post/af986b3f-b9e3-4129-aa2d-613cfc5291e9/image.png)

#### API 디자인에서의 후행 클로저
![](https://velog.velcdn.com/images/juyoung999/post/804b9e66-624d-4a3a-90d4-40b043691b0e/image.png)

take 이후 코드의 의미를 파악하기 어려움

![](https://velog.velcdn.com/images/juyoung999/post/515bd501-38ec-48f2-a2f1-cded4f058f87/image.png)

사람들이 인수 레이블을 삭제할 수 있다고 가정하고 메서드 이름을 지정하기
> ex) take -> prefix

메서드의 기본 이름이 첫 번째 후행 클로저의 역할을 명확히 하는 것이 중요
<br>

### KeyPath expressions as functions
Swift 4.1에서 기본 값을 get set할 수 있는 프로퍼티에 대해 호출되지 않은 참조를 나타내는 **KeyPath**를 도입

**KeyPath**는 간결하고 중첩이 적어 매개변수의 매력적인 대안
![](https://velog.velcdn.com/images/juyoung999/post/d0069c3a-9b3f-4f6a-a1ab-0cf8f89cf045/image.png)

![](https://velog.velcdn.com/images/juyoung999/post/16d79ce2-c836-4a7c-bbd0-b419842e3807/image.png)

![](https://velog.velcdn.com/images/juyoung999/post/0cdf0a20-8705-4982-955a-90fac9e2c724/image.png)
접근할 호출 사이트를 모두 복제하지 않고 서명이 일치하는 모든 함수 매개변수에 **KeyPath** 인수를 전달할 수 있다.
![](https://velog.velcdn.com/images/juyoung999/post/e4ec53e6-fe38-4f88-a8b2-3f2815017ec7/image.png)

<br>

### @main
모든 프로그램은 시작 지점이 필요

라이브러리 작성자 경우 사용자가 진입접으로 파생할 것으로 예상되는 프로토콜 또는 수퍼클래스에서 정적 기본 메서드를 선언하기만 하면 된다.

사용자가 @main으로 해당 타입에 태그를 지정할 수 있고 컴파일러가 사용자를 대신하여 main.swift를 생성할 수 있다.
![](https://velog.velcdn.com/images/juyoung999/post/d05e6138-ec78-4a77-bf4f-0cdb7d278d73/image.png)

```swift
@main
class MyAppDelegate: UIResponder, UIApplicationDelegate {
//...

@main
struct MyApp: App {
//...
```
<br>

### Increased availability of implicit self in clousuers
**클로저에서 암시적 self의 가용성 증가**

Swift는 캡처하는 escape 클로저에서 self를 명시적으로 사용할 것을 요구
하지만 연속적으로 self를 포함해야 하는 경우 중복되는 느낌

![](https://velog.velcdn.com/images/juyoung999/post/9029bc67-f083-4402-8fd1-6a1a2a9b32fe/image.png)

Swift 5.3부터는 캡처 목록에 `[self]`를 포함하면 클로저 본문에서 생략 가능 

self가 값 타입인 경향이 있는 SwiftUI에서 마찬가지로 참조 순환 가능성이 훨씬 적기 때문에
마찬가지로 `self`가 **enum**이나 **struct**인 경우 클로저에서 완전히 생략할 수 있게 되었다!
<br>

### Multi-pattern catch clauses
과거)  `do-catch` 문은 **catch** 절에 **switch** 문을 중첩시켜 사용
![](https://velog.velcdn.com/images/juyoung999/post/05d19725-438c-4851-8b01-b005c3ae4fb8/image.png)


Swift 5.3) **catch** 절의 문법을 확장하여 **switch** 케이스의 권한을 가짐
![](https://velog.velcdn.com/images/juyoung999/post/230e7e4d-2f57-4619-b50f-e78826236b69/image.png)

do-catch 문으로 평면화하여 쉽게 읽을 수 있다.
<br>

### Enum Enhancements
Swift 4.1 이후 컴파일러는 다양한 타입에 대해 **Equatable** 및 **Hashable** 적합성을 가질 수 있었다.

![](https://velog.velcdn.com/images/juyoung999/post/0765669f-6247-44ba-8878-de9293b40eac/image.png)


Swift 5.3에서 컴파일러는 enum 타입을 한정하기 위해 **comparable** 적합성을 합성하는 방법을 배웠다.

![](https://velog.velcdn.com/images/juyoung999/post/584436da-1106-4349-a716-def0530cb2c6/image.png)

enum case를 프로토콜 case로 논의

![](https://velog.velcdn.com/images/juyoung999/post/933a46f3-3fa5-4285-ae2e-b4f88f3952b1/image.png)

케이스? 정적 함수? -> 호출 사이트가 동일
![](https://velog.velcdn.com/images/juyoung999/post/6733d09d-f69a-48da-b1c5-9920ef556f46/image.png)

Swift 5.3에서는 enum case를 개선하여 정적 var 및 정적 func 프로토콜 요구사항을 충족하는 데 사용할 수 있습니다.![](https://velog.velcdn.com/images/juyoung999/post/ba66c19e-ba82-40e7-9be7-f0a5fd74a028/image.png)

<br>

### Embedded DSL Enhancements
작년 내장 DSL에 대한 지원을 추가하여 SwiftUI의 선언적 구문을 강화했다.

Swift 5.3에서 DSL을 활장하여 if-let 및 switch와 같은 패턴 일치 제어 흐름 문을 지원하게 됐다.

![](https://velog.velcdn.com/images/juyoung999/post/59583ff2-9f61-46a6-ad9e-f0452d7f373f/image.png)

서로 다른 이미지 레이아웃을 switch 문을 사용하여 갤러리를 구성할 수 있다.

#### 빌더 추론
이전에는 최상위 수준에서 DSL 구문을 사용하려면 특정 빌더 속성으로 태그를 지정해야 했다.

![](https://velog.velcdn.com/images/juyoung999/post/4105f8d9-641a-4561-9789-0a49487bb183/image.png)

Swift 5.3에서는 프로토콜 요구사항에서 빌더 속성을 유추하는 것을 컴파일러가 알고 있기 때문에 Builder 속성이 더 이상 필요하지 않다.
<br>

## SDK
Library - 새로운 API

### Float16
- 4 바이트를 사용하는 float와 달리 2 바이트만 사용
- 크기가 절반이므로 메모리 페이지에 두 배 할당, 하드웨어 성능이 두 배 향상
- 데이터 타입이 작기 때문에 범위가 제한되어 있으므로 **Double** 또는 **Float**으로 구현된 코드 변환 시 주의
<br>

### Apple Archive
Apple이 OS 업데이트를 제공하는 데 사용하는 실전 테스트를 거친 기술을 기반으로 하는 새로운 모듈식 아카이브 형식
- 빠른 멀티스레드 압축에 최적화
- Finder 통합, 명령줄 도구 및 Swift API를 비롯한 여러 기능 제공

![](https://velog.velcdn.com/images/juyoung999/post/e855fcda-e6d6-4577-8d75-e19d1a2c582a/image.png)

새 라이브러리인 Swift System을 사용한 FileStream 생성자

**Swift System **
- Apple Archive와 같은 저수준 시스템 API에 대한 시스템 호출 및 콜 타입에 대한 관용적 인터페이스 제공
- RawReprsentable 구조체, 오류 처리, 기본 인수, 네임스페이스 및 함수 오버로딩 같은 기술을 사용하여 API 래핑을 통해 관용적인 SDK의 Swift 시스템 계층 토대 마련
<br>

### OSLog
> **OSLog**
> 최소한의 오버헤드를 갖도록 최적화되고 의도하지 않은 민감한 데이터 로깅을 방지하는 통합 로깅 API

Swift 5.2에서는 OSLog를 훨씬 빠르고 표현력 있게 하며, 문자열 보간 및 다입 지정 옵션 지원 추가

아직도 print 써? 지금부터 바꿔봐
<br>

### Packages
Swift Package Manager를 통해 SDK 외부에서 사용할 수 있는 API 증가

#### Numerics
Swift Numerics
- 복소수 및 산술 지원뿐 아니라 일반 컨텍스트에 유용한 방식으로 sin, log와 같은 수학 함수 정의
- 복소수는 C와 호환되는 레이아웃이지만 더 빠르고 정확
<br>

#### Swift Argument Parser
명령줄 인수 구문 분석을 위한 오픈 소스
<br>

#### Swift StandardLibraryPreview
Swift Evolution 프로세스를 통해 승인되었지만 공식 Swift 릴리즈로 제공되지 않은 기능에 대한 엑세스 제공

Swift Evolution 제안이 더 쉽게 검토를 진행하도록 했다
-> 과거에는 전체 컴파일러 스택을 구축했지만 이제 StandardLibrary 제안에 대한 구현을 SPM 패키지로 제공 가능

<br><br>


---

[What's new in Swift (2020)](https://developer.apple.com/videos/play/wwdc2020/10170/)
