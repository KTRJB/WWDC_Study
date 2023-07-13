## 배경
> Swift 5.5
> - Swift Concurrency 기능
>  - 동시 프로그래밍을 편리하고 효율적이며 안전하게 설계된 비동기 및 동시 프로그래밍
> - 패키지 경험의 발전 및 새로운 표준 라이브러리
> - 개발자 경험 향상

<br>

## Diversity
코드뿐만 아니라 Swift 프로젝트 목표를 향해 노력하는 사람들도 프로젝트의 핵심
-> Swift 커뮤니티 이니셔티브

> Swift 커뮤니티의 핵심 가치 = **Diversuty** 

Swift의 다양성 목표는 다양한 사람이 목소리를 높이고, 배경에 관계없이 개발자가 Swift 학습 또는 기여를 시작하도록 커뮤니티를 육성하는 것

이러한 일환으로 swift.org 블로그를 확장했다!
또한 비슷한 경험이나 문제에 직면한 사람들과 연결할 수 있도록 Swift 포럼에 커뮤니티 그룹을 생성

Swift 오픈 소스에 쉽게 기여할 수 있도록 Swift 멘토십 프로그램 발표
<br>

## Update Swift Packages
> **Package**
> - 소프트웨어 구축을 위한 기본 빌딩 블록
> - 오픈 소스 코드를 편리하게 활용할 수 있도록 함

#### Swift Package Index
- 패키지를 찾는 데 도움이 되는 솔루션
- **Swift Package Manager**를 지원하는 패키지를 찾는 데 도움이 되는 페키지

Swift 5.5에 및 Xcode 13에서는 개발 워크플로의 일부로 패키지를 더 빠르고 쉽게 사용할 수 있는 통합 Xcode 도구 지원
<br>

### Package Collections in Xcode
인터넷에서 패키지를 검색하거나 URL을 복붙할 필요 없이 컬렉션을 탐색하고 Xcode의 새 패키지 검색 화면에서 패키지를 추가하기만 하면 됨

#### Package Collection
- 어디에서나 게시할 수 있는 간단한 JSON 파일
- 누구나 사용 사례에 대한 패키지 목록을 작성할 수 있음
- ex) 컴퓨터 수업을 위한 패키지 목록

---

## Apple Packages
Apple은 계속 오픈 소스 패키지를 게시
올해 새로운 4개의 패키지 출시
<br>

### Swift Collections
> **Swift Colelctions**
> Swift 표준 라이브러리에서 사용하는 데이터 구조를 보완하는 새로운 오픈 소스 패키지

자주 요청되는 데이터 구조인 **Deque**, **OrderedSet** 및 **OrderedDictionary** 구현 제공

#### Deque
양쪽 끝에서 삽입 & 제거를 지원하는 것을 제외하면 배열과 동일

#### OrderedSet
Array와 Set의 하이브리드
Array처럼 순서를 유지하고 임의 엑세스 지원 + Set처럼 중복을 제외

#### OrderedDictionary
순서가 중요하거나 임의 엑세스가 필요할 때 Dictionaray의 대안
<br>

### The Algorithms package
**Sequence**와 **Collection** 알고리즘의 새로운 패키지

컬렉션의 모든 조합 또는 순열을 생성하거나 시퀀스 요소를 반복하거나 가장 큰, 가장 작은 또는 임의의 요소 그룹 등 다양한 알고리즘이 존재
<br>

### Swift System
지난 가을 시스템 호출의 관용적인 인터페이스를 제공하는 `Swift System 라이브러리`를 오픈 소스로 공개

Apple 플랫폼, Linux 및 Windows에서도 사용 가능

최근 일반적인 path 작업을 수행하기 위해 FilePath 타입에 새 API 추가
- 확장 쿼리, 구성 요소 추가 및 제거, 경로 정규화 기능이 포함

![](https://velog.velcdn.com/images/juyoung999/post/9ef9abf5-fe35-49c8-898d-f38e57b2e169/image.png)
- path는 루트와 구성 요소로 분해
- FilePath의 ComponentView는 구조화된 경로 구성 요소의 모음
- 즉시 사용한 많은 Swift 알고리즘을 지원


![](https://velog.velcdn.com/images/juyoung999/post/a31c3a03-8136-4d3c-a0e5-a39a02eed339/image.png)

Windows를 대상으로 복잡한 루트 구성 요소가 있는 경로 역시 새로운 FilePath API에서 지원

### Swift Numerics pagkages
작년에 Float16을 도입

올해
- `Apple Silicon Mac`에 **Float16** 지원
- **Float16** 기반 복소수 생성 기능 추가
![](https://velog.velcdn.com/images/juyoung999/post/549fc8de-63fe-40fb-af42-1220a2bce1db/image.png)
- log, sin, cos 같은 기본 함수에 대한 복소수 지원
<br>

### Swift ArgumentParser package
**개선 사항**
- Fish Shell 코드 완성 스크립트 생성 기능
- 결합된 짧은 옵션 
- 향상된 오류 메세지
- Swift Package Manager 명령줄 도구 사용 시 `Swift ArgumentParser` 사용
<br>

## Update on Swift on server
작년) Amazon Linux를 비슷한 여러 플랫폼 지원을 추가
올해) Swift 서버 애플리케이션의 성능과 기능에 투자

- Linux Static 연결 활성화

> Linux의 이점
> - 애플리케이션 실행 시간을 개선
> - 단일 파일로 배포할 수 있는 서버 애플리케이션의 배포를 단순화

- JSON 인코딩 및 디코딩 성능 향상
- AWS Lambda 런타임 라이브러리 성능 개선 및 최적화
	+ 클로저 대신 새로운 async/await 모델을 사용하도록 리팩토링
<br>

## Developer experience improvements
개발자 경험 개선

### Swift DocC
훌륭한 문서를 제공하는 것은 프레임워크 사용자에게 좋은 경험을 제공하는 핵심

> **DocC**
> Swift 프레임워크 또는 패키지 사용법을 가르치는 데 도움이 되는 Xcode 13 내부 통합 문서 컴파일러

- 마크다운 주석처럼 문서를 쉽게 작성하고 비교할수 있도록 구축
<br>

### Build Impovenments
1) imported module 빌드 속도 향상
모듈이 변경될 때 모듈을 가져오는 모든 소스 파일을 다시 빌드하지 않아도 됨
2) 모듈 종속성 그래프를 미리 계산하여 변경된 항목에 대해서만 빠르게 빌드
3) extension과 함께 작동하도록 선택적 재컴파일 확장
확장의 본문을 변경할 때 적은 재컴파일을 진행

=> 빌드 성능에 불이익 없이 프로젝트를 모듈화하고 모듈을 변경할 수 있음

이러한 성능 향상의 일부는 **Swift Driver**의 의해 가능해짐

> **Swift Driver**
> Swift 소스 코드의 컴파일을 조정하는 프로그램

- 현재 Xcode 13에서 Swift 컴파일의 기본값
<br>

## Memiory Management
클래스 인스턴스는 ARC를 사용하여 특정 개체에 대한 참조 수를 추적하고 해당 인스턴스가 더 이상 필요하지 않을 때 사용하는 메모리를 자동으로 해제

![](https://velog.velcdn.com/images/juyoung999/post/46bd763f-95e2-4140-85c0-244fc9929358/image.png)

대부분 메모리 관리는 Swift에서 작동하며 직접 생각할 필요가 없음

올해 컴파일러가 유지 및 해제하는 작업 수를 줄일 수 있도록 컴파일러 내부에서 참조를 추적하는 방법 도입!

Xcode 설정으로 `Optimize Object Lifetimes`를 추가하여 새로운 ARC 최적화가 코드에 미치는 영향을 확인할 수 있음

---

## Ergonomic improvements

### Result Builders
SwiftUI 발표 시 복잡한 객체의 계층 구조를 빠르고 쉽게 설명하는 구문 도입
+ `Swift Evolution 프로세스`를 통해 구문이 표준화되어 다양한 상황에서 쉽게 사용 가능
<br>

### Enum Codable synthesis
**Codable** 프로토콜은 데이터 직렬화의 편리한 방법이지만 오랫동안 어려움을 겪음

**Codable**을 준수하도록 하려면 `decode`, `encode` 등 모두 수동으로 구현해야 했음 -> 이제 **Codable** 준수 선언만 하면 컴파일러가 모두 수행
<br>

### Flexible static member lookup
타입 검사기에 주요 개선 사항 적용

Swift 타입 추론 = 중복되는 타입 정보를 생략할 수 있음을 의미

![](https://velog.velcdn.com/images/juyoung999/post/1ebe71f0-0163-41b3-875a-1953d6174d90/image.png)

프로토콜을 준수하는 타입이 static 프로퍼티를 선언하면 Enum 처럼 dot 표현법으로 인스턴스 참조 가능
<br>

### Property wrappers on parameters
**Property wrappers** = 의미 체계를 프로퍼티에 적용하는 편리한 도구

`@propertyWrapper` 주석을 사용하여 고유한 속성 래퍼를 구현해왔음

![](https://velog.velcdn.com/images/juyoung999/post/29a9b75b-5832-4f55-9f43-888a0a8d18b1/image.png)

이제 동일한 속성 래퍼를 함수 및 클로저 매개변수에 사용할 수 있음
![](https://velog.velcdn.com/images/juyoung999/post/f9470901-7cae-46a6-ac69-55b6a74edf81/image.png)

#### 예시

![](https://velog.velcdn.com/images/juyoung999/post/c89e5b60-37fc-4e4b-a1a6-c71b50507e0c/image.png)

**1) Toggle 초기화의 중복 제거**

![](https://velog.velcdn.com/images/juyoung999/post/64ccbd70-1c90-4439-b78b-275257a60701/image.png)

`toggleStyle` 수정자 같은 접미사 표현식을 둘러싸도록 `#if` 사용을 완화하여 중복성 제거

**2) 타입 검사기의 개선 사항을 활용하여 자연스러운 dot 표기법**

![](https://velog.velcdn.com/images/juyoung999/post/bac2870b-3474-4216-8730-979b122deba3/image.png)


**3) 배열의 인덱스를 지정한 다음 클로저 내에서 배열을 인덱스 하는 것이 어색**
-> 배열 값을 반복할 수 있는 List 생성자로 바인딩을 직접 전달 가능

![](https://velog.velcdn.com/images/juyoung999/post/14885662-691c-411c-965e-63d22cfe6ef9/image.png)

**4) Swift 컴파일러가 `CGFloat`과 `Double` 간의 변환을 지원하여 많은 중복 변환을 제거 가능**
<br>

## Asynchronous and concurrent programing

### 비동기 vs 동시
소프트웨어 프로젝트는 어떤 순서로 실행되는 코드 블록으로 구성

![](https://velog.velcdn.com/images/juyoung999/post/253e1abe-8aa9-49a7-921f-a3bfe8f9dc96/image.png)

1) 일반적으로 블록이 차례대로 실행
2) 네트워킹 API는 종종 **비동기식(Asynchronous)**으로 설계
원격 서버에 요청을 보낸 후 응답을 받고 작업을 수행할 때까지 오랜 지연이 있을 수 있음
3) **동시(Concurrent)** 코드는 동시에 실행하려는 코드 블록이 두 개 이상 있는 경우 
ex) 비디오의 여러 프레임을 처리, 결과 집합으로 UI 업데이트와 동시에 다음 반복 실행

### 새로운 기능 사용 전
![](https://velog.velcdn.com/images/juyoung999/post/18d109ce-805a-4b35-98fb-ace35776bcd6/image.png)

- Foundation의 **URLSession** 클래스를 통해 네트워크 호출
- **dataTask** = 비동기 작업
- 결과를 클로저로 처리

> 초기화 -> resume -> 백그라운드 작업 -> fetchImage 함수 반환 -> 네트워크 작업 완료 후 결과를 처리 -> 완료 핸들러 호출

작업 순서가 다소 어색
<br>

### Swift 5.5 개선 방법
![](https://velog.velcdn.com/images/juyoung999/post/57966dea-f82b-4e41-8c3d-c52a5a99e2ad/image.png)

HTTP를 다루기 때문에 `response` 메타데이터도 캡처
이를 데이터 반환 함수 호출로 구성하여 `try/catch` 오류 처리를 통해 많은 상용구를 제거할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/6631292f-300c-4266-be50-ba97da608dca/image.png)

해당 작업이 완료될 때까지 할당을 완료할 수 없음을 컴파일러에게 알리는 구문이 필요 
=> **await**

![](https://velog.velcdn.com/images/juyoung999/post/df86653c-e680-4a38-9967-a800dbcc15d3/image.png)

> 개선 사항
> - 제어 흐름이 위에서 아래로
> - 중첩 클로저가 필요하지 않음
> - `try/catch`로 오류 처리
> - **await** 키워드로 fetchImage 함수를 일시 중지할 수 있는 지점을 나타냄

**URLSession**이 요청을 시작하면 다른 곳에서 수행되는 Swift 런타임에 의해 기능이 일시 중지
-> 이후 성공/실패든 최종 결과가 준비되면 기능이 재개
> - 성공 -> data 및 response 변수의 초기화 완료
> - 오류 -> 호출한 사람(구문)에게 다시 전달

비동기 함수는 일시 중단된 동안 리소스를 사용하지 않고, 스레드를 차단하지 않음
-> Swift 런타임은 해당 함수가 다른 작업을 위해 실행 중인 스레드를 재사용 가능

문법적으로 `async/await`은 `throws/try`와 유사하게 사용

![](https://velog.velcdn.com/images/juyoung999/post/65cd4bca-f377-439f-bb74-a3cc3c92aba2/image.png)

- **async**: 해당 함수가 일시 중단할 수 있도록 컴파일되어야 함을 나타냄
- **await**: 비동기 함수, 메서드 또는 클로저 호출을 표시
<br>

### Structed Concurrency
**async/await**으로 **Concurrency** 지원하는 방법

예시) 세 가지 이미지를 렌더링 후 결합하는 기능으로 순차적으로 진행

![](https://velog.velcdn.com/images/juyoung999/post/393f7416-535e-4e7b-9bcc-1806600a1e3c/image.png)

렌더링 작업이 병렬로 진행되기를 바람
![](https://velog.velcdn.com/images/juyoung999/post/35199844-9fad-4f55-a4ae-b29135144270/image.png)

- 서로 다른 스레드 진행으로는 충분하지 않음
- 세 결과가 모두 나올 때까지 결합 작업은 보류해야 함

#### 1) 다른 스레드의 작업 결과를 기다리며 일시 중단할 수 있도록 "async"로 표시

![](https://velog.velcdn.com/images/juyoung999/post/3097405c-b4b0-4fb8-b5a3-74ed2acb6e36/image.png)

#### 2) async let 구문으로 처음 두 작업을 병렬로 실행
초기화 구문과 비슷하여 초기화 결과를 사용하기 전까지 병렬로 실행됨
-> 두 변수가 초기화될 때까지 merge 작업을 중단
이를 나타내기 위해 merge 함수를 **await**으로 표시


Swift 런타임은 반응성을 유지하기 위해 오류 발생 시 완료되지 않은 작업에 신호를 보내 조기 완료할 수 있는 기회를 제공
<br>

### Actor
두 개의 스레드가 데이터를 공유할 때 데이터가 일치하지 않거나 손상 위험
=> **Actor**를 통해 데이터를 보호할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/4b1917eb-1d8b-493a-89eb-0aac0069a248/image.png)

둘 이상의 스레드가 동시에 증가 메서드를 호출하면 손상되어 끝날 수 있음 
-> 다중 스레드 시스템에서 제대로 동작 불가

**Actor**는 특정 변경을 수행하는 것이 안전할 때까지 데이터 손상을 유발할 수 있는 작업을 일시 중단
-> **Actor** 외부에서 **Actor** 메서드를 호출할 때 일반적으로 **await** 사용

일시 중단된 동안 네트워크 작업이 완료될 때까지 기다리지 않고 데이터 손상없이 해당 **Actor**에서 다른 메서드 실행 가능
<br>

## Swift 6
> 우리의 목표
> = 가장 일반적인 종류의 동시성 버그를 완전히 제거하여 비동기 및 동시 프로그래밍을 복잡하지 않게 만드는 것

<br>

---

[What's new in Swift - 2021](https://developer.apple.com/videos/play/wwdc2021/10192/)
