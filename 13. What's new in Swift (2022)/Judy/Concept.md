## 배경
**Swift 5.7**

## Community update
작년에 발표된 `docC`와 `Swift.org` 웹사이트가 오픈 소스로 제공되어 커뮤니티의 사용성 증가

커뮤니티를 구성원에게 관리 및 지원을 제공하기 위해 `Swift on Server` 및 `Diversity in Swift`에 대한 작업 모델을 사용해왔는데 잘 작동 👍

그래서 두 개의 새로운 작업 그룹 추가
> - Swift Website : 커뮤니티 리소스로 만들기
> - C++ Interoperability : C++ 상호 운용성을 위한 모델 디자인 형성

작년에 구성원을 지원하기 위해 Swift Diversity 작업 그룹은 **Swift Mentorship Program**을 도입해 잘 성공했고 올해도 새롭게 진행할 예정
<br>

### Cross-platform support
Linux 패키지 형식에 대한 지원 추가
-> Linux 플랫폼용 Swift 도구 체인 배포 프로세스 간소화

새로운 기본 도구 체인 설치 프로그램을 통해 `Amazon Linux 2` 및 `CentOS 7용 RPM`을 다운로드 가능

Swift는 주로 앱 빌드용이지만 여러 수준에서 사용되기 위해 변경 사항을 거침
<br>

#### Statically linked standard library
바이너리에 대한 표준 라이브러리를 적게 만들기 위해 외부 유니코드 지원 라이브러리에 대한 종속성 삭제
- 더 빠른 기본 구현으로 대체
- 더 작고 빠른 바이너리는 이벤트 기반 서버 솔루션 실행 시 이점
- 서버에 대한 컨테이너화 된 배포를 잘 지원하기 위해 Linux에서 정적 링크를 얻는데 크기 감소를 통해 제한된 환경에서도 적합하여 Secure Enclave Processor에서 사용 가능

=> Swift는 앱에서부터 서버, 제한된 프로세서까지 유용하게 사용
<br>

## Swift Package
워크플로를 사용자 지정하는 데 도움이 되는 새로운 도구 

### TOFU 도입
> **Trust On First Use**
패키지 다운로드 시 패키지 지문이 기록되는 보안 프로그램

이후 다운로드는 지문의 유효성을 검사하고 만약 다른 경우 오류를 보고 
<br>

### Command plugins
명령 플러그인은 Swift 개발자의 작업 흐름을 개선할 수 있는 좋은 방법

> 사용 예시
> - 문서 생성
> - 소스 코드 재포맷
> - 테스트 보고서 생성

쉘 스크립트에 자동화를 작성하고 별도의 워크플로 유지 대신 Swift를 사용할 수 있음

명령 플러그인은 오픈 소스 도구와 Swift Package Manager 사이 접착제 기능
=> 이제 모든 오픈 소스 도구를 Xcode 및 Swift Package Manager에서 사용 가능
<br>

### docC
문서를 소스 코드에 통합하는 도구
Objective-C 및 C 지원으로 좋아짐

#### docC로 플러그인 만들기
플러그인은 단순한 Swift 코드

![](https://velog.velcdn.com/images/juyoung999/post/ddc4656a-58d6-4a3b-ab64-3ca5c0d6b271/image.png)

**CommandPlugin** 프로토콜을 준수하는 구조체로 플러그인을 정의

이후 호출할 도구를 플러그인에 알려주는 함수를 추가하면 끝
<br>

### Build tool plugins
빌드 도구를 위한 플러그인으로 빌드 중에 추가 단계를 삽입할 수 있는 패키지로 언제든지 직접 실행하고 패키지 파일을 변경할 수 있는 명령 플러그인과 다름

> 사용 예시
> - 소스 코드 생성
> - 사용자 지정 처리

![](https://velog.velcdn.com/images/juyoung999/post/0d5b776c-b515-4c1f-910a-c7cc21cd3418/image.png)

빌드 시스템에 실행 가능한 명령과 결과로 예상되는 출력을 알려주는 빌드 명령(buildCommand)를 정의하여 플러그인을 구현
<br>

### Package plugins
> 패키지에 확장성을 제공하는 보안 솔루션

패키지 사용을 확장하면서 모듈 충돌이 발생할 수 있음
ex) 두 개의 패키지가 동일한 이름의 모듈을 정의하는 경우

Swift 5.6에서는 모듈 명확성을 도입
- 모듈을 정의하는 패키지 외부에서 모듈 이름을 바꿀 수 있는 기능

패키지 매니페스트의 종속선 섹션에 `moduleAliases` 키워드만 추가하면 다른 이름을 사용하여 같은 이름을 가졌던 모듈을 구별 가능
<br>

## Performance improvements
내부 개선 사항

### New Swift driver settings
작년에 소스 코드 컴파일을 조정하는 **Swift Driver** 소개

이제 드라이버를 별도의 실행 파일이 아닌 Xcode 빌드 시스템 내에서 직접 프레임워크로 사용 가능
-> 빌드 시스템과 빌드를 밀접하게 조정하여 병렬화 작업 허용
<br>

### Faster type checking of generics
프로토콜 및 `where 절`과 같은 항목에서 제네릭 시스템의 타입 체크 성능 향상

이전에는 관련된 프로토콜이 많아 시간과 메모리 사용량이 확장되는 문제를 개선하여 타입 체크 속도 향상
<br>

### Runtime improvements
이전에는 앱을 시작할 때마다 프로토콜을 계산하여 필요한 프로토콜이 많을 수록 실행 시간이 길었음


이제 **캐시**를 적용하여 iOS16에서 실행할 때 앱 시작 시간을 절반으로 줄일 수도 있음
<br>

## Concurrency updates
> 스레드 안정성을 포함하는 최신 동시성 모델

작년) 콜백 및 수동 대기열 관리보다 안전하고 쉬운 **Actor**와 **async/await**을 결함한 새로운 동시성 모델을 도입

동시성은 앱의 근본적이고 중요한 개선 사항이므로 iOS 13 및 macOS Catalina까지 배포 가능하도록 적용
<br>

### Data race avoidance
Swift의 중요한 기능 중 하나는 메모리 안전!

값을 수정하는 동안 값을 읽는 동작은 수행할 수 없음
![](https://velog.velcdn.com/images/juyoung999/post/d867ff3f-df46-4aba-9316-aceb88312c09/image.png)

ex) 3을 제거하고나면 count가 줄어서 2도 제거?
-> 배열을 수정하는 동안 count에 접근하는 것이 안전하지 않아 방지

스레드에서도 안전을 위해 예측할 수 없는 동작을 유발할 수 있는 동시성 버그를 방지하자!

![](https://velog.velcdn.com/images/juyoung999/post/76e5f5ac-b4d6-4c1b-ba9b-93f59b632964/image.png)

- 0을 추가하고 배열의 마지막 요소를 제거
- 마지막 요소 제거가 0을 추가 전이나 후에 발생하는가?
- 둘 다 아님. Actor와 같이 엑세스를 동기화하지 않고 백그라운드에서 배열 수정을 위험하기 때문에 이를 차단
<br>

#### Actor
Actor는 Data Race를 제거하는 첫 번째 단계
![](https://velog.velcdn.com/images/juyoung999/post/24bcfe42-cfe2-4b48-9f12-a54628c31ba5/image.png)

각 **actor**는 동시성 바다에서 다른 것과 격리된 섬으로 생각할 수 있음

이때 서로 다른 스레드가 **actor** 각각이 저장한 정보를 읽으려 한다면?
다음 세션에서 자세히 설명~

> **Memory safety**에서 **Thread safety**으로. 
\- Swift 6의 목표

이를 위해 `Robust concurrency model`과 `Opt-in safety checks`를 개선

> **Opt-in safety checks**
> - 잠재적인 data race를 식별하는 새로운 안전 검사
> - 빌드 설정에서 활성화 가능

<br>

#### distributed actor
`distributed actor`는 섬을 네트워크를 통해 다른 시스템에 배치
이제 Swift에서 백엔드를 쉽게 작성할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/bd82c715-c6e4-4aee-afc5-98f82b7e02a2/image.png)

`distributed`는 원격 시스템에 있을 수 있는 액터에서 호출이 예상되는 함수에도 추가

![](https://velog.velcdn.com/images/juyoung999/post/978754e9-06fd-4630-948c-b956978ce01a/image.png)

endOfRound 메서드 추가 
- player를 반복하면서 makeMove를 호출
- 플레이어 중 일부는 로컬이나 원격일 수 있지만 신경 쓸 필요가 없다

일반 actor와 차이점은 호출이 네트워크 오류로 인해 잠재적으로 실패할 수 있다는 점
따라서 액터 외부에서 함수 호출 시 필요한 **await** 키워드와 **try** 키워드를 추가해야 함

서버 측 클러스터 분산 시스템 구축에 중점을 둔 오픈 소스 `Distributed Actors` 패기지도 구축함 (자세한 내용은 관련 세션)
<br>

### Async Alogorithms package
**AsyncSequenece**를 처리할 때 간편한 솔루션을 제공하기 위해 오픈 소스 알고리즘 세트를 출시

![](https://velog.velcdn.com/images/juyoung999/post/8edce65f-0104-400f-a732-5eaed61ffe5c/image.png)

여러 비동기 시퀀스를 결합하고 컬렉션으로 그룹화하는 방법을 여러 가지가 있고 이는 일부일 뿐 자세한 내용은 관련 세션~
<br>

### Concurrency optimizations
동시성에 새로운 측면

#### Actor prioritization
Actor 중 가장 우선순위가 높은 것부터 실행

#### Priority-inversion avoidance
운영 체제 스케줄러와 긴밀한 통합을 유지하면서 운선순위 모델 역전 방지 기능이 내장되어 있어 덜 중요한 작업이 중요한 작업을 차단하는 것을 방지
<br>

### Using the Swift concurrency instruments
이전까지는 앱에서 동시성 성능이 미치는 영향을 시각화하기 어려웠지만 새로운 도구가 생김

Instruments의 `Swift Concurrency 보기`는 성능 문제를 조사하는데 도움
- Swift Tasks 및 Swift Actors 도구는 동시성 코드를 시각화하고 최적화하는 데 도움이 되는 도구 모음 제공
- 동시에 실행 중인 작업 수와 해당 시점까지 생성된 작업 수 등 유용한 통계 제공
- 동시 코드에서 작업 간의 부모-자식 관계를 그래프로 표시
<br>

## Expressive Swift
단순하고 명확한 제네릭 및 강력한 문자열 처리 등 언어 개선

코드에서 원하는 것을 표현하기 위해 도구 여러 면에서 개선됨

![](https://velog.velcdn.com/images/juyoung999/post/4519f62f-9a09-49fc-b44f-e388ec084120/image.png)

예를 들어 `if let` 구문에서 변수명을 그대로 사용하는 경우가 일반적
하지만 이름이 길면 사용하기 번거롭고 축약하기엔 문제가 될 수 있다.

![](https://velog.velcdn.com/images/juyoung999/post/37f58d59-89ee-4a10-ab5a-735b2f98a30d/image.png)

Swift 5.7은 이러한 패턴에 대한 속기를 도입하여 옵셔널 언래핑 시 이름을 드롭하면 같은 이름을 갖게 됨 + `guard`에서도 작용

![](https://velog.velcdn.com/images/juyoung999/post/83cbfb33-7dcf-40f9-ab47-068458b26963/image.png)

또한 이제 여러 명령문 또는 제어 흐름 기능이 있는 복잡한 클로저에서도 클로저의 결과 타입을 수동으로 지정하지 않고도 사용 가능
<br>

### Permitted pointer conversions
Swift는 타입 및 메모리 안전에 유의하기 때문에 포인터 타입이 다른 포인터 간에 자동으로 변환하지 않음

하지만 C에서는 특정 변환을 허용하기 때문에 이런 차이가 C API를 Swift로 가져올 때 문제가 될 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/9ce9ad59-2d5f-4908-8240-1eb6d1a216cd/image.png)

Swift에서는 한 타입의 포인터에서 다른 타입처럼 엑세스하는 것은 위험하므로 명확하게 표현하지만 C에서는 무의미한 작업

![](https://velog.velcdn.com/images/juyoung999/post/3810b990-3168-448b-a15a-240f7effbfc4/image.png)

이제 Swift는 가져온 함수 및 메서드 호출에 대한 별도의 규칙을 가져 API를 원활하게 사용 가능
<br>

### String processing
올해 문자열에서 정보를 추출하는 새로운 도구 등장

![](https://velog.velcdn.com/images/juyoung999/post/599e07cd-15cf-4f8c-b6f1-4e4468efece1/image.png)

이전에는 일부 정보를 얻기 위해 찾고, 쪼개고, 자르는 구문을 작성해야 했음

일부 구문을 줄인다 해도 작업이 복잡하여 파악하기 어려움

우리가 해야할 것은 코드가 원하는 문자열을 그리고 이를 수행하는 방법을 파악하는 것
-> 명령형 접근 방식이 아닌 선언적 접근 방식

Swift 5.7에서는 이제 정규식을 통해 해결할 수 있음

> **정규식**
> 문자열의 패턴을 설명하는 방법

![](https://velog.velcdn.com/images/juyoung999/post/0c35e49c-3cf7-4095-a1ae-d1ca79752949/image.png)

이 구문은 Swift의 정규식 리터럴에서 지원되며 다른 개발자 도구에서와 마찬가지로 작동

![](https://velog.velcdn.com/images/juyoung999/post/ab4c5979-e299-46bd-bf9b-8033d754ce8b/image.png)

정규식 리터럴은 기호와 니모닉으로 작성되어 규칙이 조합으로 나타냄 -> 복잡한 리터럴을 이해하는데 1분도 걸릴 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/4fb7dc99-4787-4e5c-be2c-1274f26e6fc6/image.png)

기호 대신 단어로 규칙을 작성할 수 있으면 이해하기 쉬울 것

![](https://velog.velcdn.com/images/juyoung999/post/4a4baf65-4398-4345-8a39-b1ec667e646d/image.png)

이 모든걸 합치면 SwiftUI와 유사한 결과를 얻을 수 있음
-> 이것이 정규식 리터럴의 훌륭한 대안이 될 것

`RegexBuilder 라이브러리`는 기존 구문보다 사용하기 쉽고 읽기 쉬운 새로운 SwiftUI 스타일 언어를 제공

![](https://velog.velcdn.com/images/juyoung999/post/b8ff3805-5f38-436f-9e3c-e8bee708ebc0/image.png)

SwiftUI 뷰 계층 구조를 뷰로 전환하듯 정규식을 재사용 가능한 정규식 구성 요소로 전환 가능

특별한 이스케이프 없이 문자열 리터럴은 내부 텍스트 (ex `"<"`)와 일치하기만 하면 되고 빌더 중간에 정규식 리터럴을 사용할 수도 있음

![](https://velog.velcdn.com/images/juyoung999/post/e7b2fc9f-2e1b-4170-862c-199d4280b4d0/image.png)

어떤 구문을 사용하든 강력한 타입의 캡처를 지원
<br>

### Swift Regex
- 새로운 오픈 소스 엔진
- 리터럴 구문은 유니코드 정규식 표준과 호환 및 정확성을 가짐
- macOS 13 또는 iOS 16과 같이 Regex 엔진이 내장된 OS에서 사용 가능 
<br>

### Generic code clarity
![](https://velog.velcdn.com/images/juyoung999/post/fc7c9ebe-9388-46ef-8298-5180ed408d8b/image.png)

**Mailmap** 프로토콜을 사용하는 두 가지 방법
![](https://velog.velcdn.com/images/juyoung999/post/6fa20236-6586-40f4-99cb-b0d78ca299bd/image.png)

![](https://velog.velcdn.com/images/juyoung999/post/886f19f6-cf7a-46b8-859a-e60f66122e61/image.png)

- 상속, 매개변수, 제약 조건 또는 불투명한 타입에 프로토콜을 지정 -> "이 프로토콜을 준수하는 인스턴스"를 의미
- 변수, 인수, 매개변수 또는 결과 타입 -> "이 프로토콜을 준수하는 인스턴스를 포함하는 컨테이너" 의미

컨테이너의 경우 더 많은 공간을 차지하고 작업하는 데 시간이 걸리기 때문에 이러한 구분이 중요

Swfit 5.7에서 컨테이너를 사용하는 경우 **any** 키워드를 작성
**any** 키워드를 표시하여 두 함수의 차이를 쉽게 설명 가능

![](https://velog.velcdn.com/images/juyoung999/post/d4d0f960-a209-402b-a4d3-6c0155dd7bbe/image.png)

이전에는 프로토콜 자체를 타입으로 사용할 수 없었지만 이제 `Collection`과 같은 프로토콜도 모든 타입으로 사용 가능

![](https://velog.velcdn.com/images/juyoung999/post/004b2222-9083-4a03-8e89-bb5b446e8212/image.png)

associatedtype이 있는 경우 프로토콜 이름 뒤에 `<>`에 넣어 `기본 연관 타입`으로 만들어 제한할 수 있음

근데 이미 **AnyCollection**이 있는데? 
- AnyCollection 구조체는 지루한 상용구 대신 any는 기본 제공 언어로 동일한 작업을 무료로 수행
- 그래도 이전 버전과 호환성을 위해 AnyCollection도 계속 사용될 것


![](https://velog.velcdn.com/images/juyoung999/post/5354a7ee-136d-4d7b-987c-f2b730bb79fe/image.png)

-> 박스 클래스나 클로저 대신 내장된 타입을 사용하여 구현
![](https://velog.velcdn.com/images/juyoung999/post/25ded52d-7a78-4bd2-8d17-f8c93cac6b63/image.png)

-> typealias로 대체

![](https://velog.velcdn.com/images/juyoung999/post/5099dea6-297c-467c-be78-5382ed7f1d5a/image.png)

#### 개선사항
- any 키워드
- 프로토콜 사용 범위 확대
- 기본 연관 타입

그럼에도 여전히 Mailmap이 Equatable을 준수할 때 Mailmap을 사용해도 == 연산자를 사용 못하는 듯 제한이 있음

그렇기 때문에 대부분의 경우 Generic을 사용해야 함

![](https://velog.velcdn.com/images/juyoung999/post/b909d778-22f0-4090-8625-ff94150dd6c6/image.png)
동일한 작업이지만 상단은 제네릭 타입을 사용, 하단은 모든 타입을 사용
제네릭이 더 효율적이고 기능성이 높음 하지만 모든 타입이 읽고 쓰기가 쉬움

제네릭 작성시 `<제네릭 이름: 매개변수 형식>`으로 사용해야 해서 any보다 길다
-> **some**으로 대체

![](https://velog.velcdn.com/images/juyoung999/post/68dff323-8c8d-402b-9785-d946f89a00e7/image.png)
제네릭과 모든 타입 중 선택하는 경우 `any` 대신 `some`을 쓰면 됨
이제 더 이상 제네릭을 피할 이유가 없다!
<br>

---

<br><br>

[What's new in Swift - 2022](https://developer.apple.com/videos/play/wwdc2022/110354/)
