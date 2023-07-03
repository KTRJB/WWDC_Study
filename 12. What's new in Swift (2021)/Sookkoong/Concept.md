# [WWDC21] What's new in Swift

## 💎 배경

> **WWDC21에서 새롭게 등장하고 개선된 Swift의 기능들을 알아보는 시간을 가져본다.**
> 

## 💎 개요

- **Diversity**
- **Update on Swift packages**
- **Update on Swift on server**
- **Developer experience improvements**
- **Ergonomic improvements**
- **Asynchrnous and concurrent programming**
- **Looking ahead to Swift 6**

## 💎 소개

- **Diversity**
    - Swift 커뮤니티의 핵심 가치
    - 커뮤니티 내 다양한 개발자들의 참여 및 흥미 고취
    - 비슷한 문제를 직면한 상황에 대한 해결책 제시
    - Apple 프로젝트에만 국한 X
    - Swift package 및 open source tool의 전체 생태계 포함

- **Update on Swift packages**
    - **Package**
        - 소프트웨어 구축을 위한 기본 빌딩 블록
        - 지속적으로 증가하는 오픈 소스 코드 배열을 편리하게 활용 가능케 함
    - **Swift Package Index**
        - SPM을 지원하는 패키지를 찾는데 도움이 되는 페이지
    - **Swift Package Collections**
        - 인터넷 검색없이, Swift Package Index 기능 지원
        - command line tool & Xcode 13에서 package 검색 및 사용 가능
        - 간단한 JSON 파일
        - 누구나 다양한 use case에 대한 패키지 목록을 작성하기 위함
    - **Swift Collections**
        - Swift Standard Library에서 사용할 수 있는 데이터 구조 보충 오픈 소스 패키지
        - 주로 요청되는 데이터 구조
            - Deque
                - 배열과 유사
                - 차이로 양쪽 끝에서 효율적인 삽입 및 제거 기능 지원
                    - prepend
                        - 앞에서 요소 삽입
                    - append
                        - 뒤에서 요소 삽입
                    - popFirst
                        - 앞의 요소 제거
                    - popLast
                        - 뒤의 요소 제거
            - OrderedSet
                - Array와 Set의 조화
                - Element를 순서대로 유지하고 임의 액세스 지원
                - 각 요소가 한 번만 나타나는 Set의 특성 유지
            - OrderedDictionary
                - 순서가 중요하거나 요소에 대한 임의 액세스가 필요할 때 사용
    - **Swift Algorithms**
        - Sequence and Collection 알고리즘의 새로운 오픈 소스 패키지
    - **Swift System**
        - 시스템 콜에 대한 관용적인 low-level 인터페이스를 제공하는 오픈 소스 라이브러리
        - Apple platform, Linux 및 Windows 지원
        - 일반적인 path 조작 작업을 위해 시스템의 FilePath 타입에 대한 새로운 API 추가
            - extension을 query 및 set
            - components 추가 및 제거
            - path normalization(경로 정규화) 수행
        - path는 root와 관련 구성 요소로 분해
            - Mac
                
                ![스크린샷 2023-07-03 오후 7 50 57](https://github.com/Groot-94/WWDC_Study/assets/99063327/3ba00c97-e84d-470d-b123-ea1cbc8e6d5f)
                
                ![스크린샷 2023-07-03 오후 7 51 13](https://github.com/Groot-94/WWDC_Study/assets/99063327/95d4c4ee-d8e0-42e5-8e21-a39159596e34)
                
            - Windows
                
                ![스크린샷 2023-07-03 오후 7 51 33](https://github.com/Groot-94/WWDC_Study/assets/99063327/9ca1f9d8-8dce-4296-a44d-072ec030d66c)
                
    - **Swift Numerics**
        - Apple Silicon Mac에 Float16 지원 및 Float16 기반 복소수를 만드는 기능 추가
        - log, sin, cos 등과 같은 기본 함수에 대한 복소수 지원
            - Swift로 작성되어 기존 C 라이브러리보다 더 효율적
            - 최적화 허용
    - **Swift ArgumentParser**
        - 기능 개선
            - Fish shell용 코드 완성 스크립트 생성
            - joined short option (-Ddebug)
            - 에러 메세지

- **Update on Swift on server**
    - WWDC20에서 진행된 Amazon Linux를 비롯한 여러 플랫폼에 대한 지원에 대한 후속조치
    - 즉, Swift 서버 어플리케이션 성능 및 기능에 투자
        - Static linking on LInux
            - 시작 시간 개선
            - 단일 파일로 배포할 수 있는 서버 애플리케이션 배포 단순화
        - Improved JSON peformance
            - Linux에서 사용되는 JSON 인코딩 및 디코딩이 처음부터 다시 구현되어 성능 향상
        - Enhanced AWS Lambda runtime
            - AWS Lambda 런타임 라이브러리 자체 성능 개선 및 최적화
                - AWS Lambda에서 실행되는 Swift 프로그램은 33% 더 빨리 시작
                - AWS API Gateway를 통해 라우팅되는 Lambda의 호출시간은 40% 더 빨라짐
            - 클로저 대신 새로운 async/await 모델을 사용하도록 리팩토링

- **Developer experience improvements**
    - **Swift DocC**
        - Xcode 13 내부에 깊숙히 통합된 documentation compiler
        - 개발자에게 Swift Framework 및 Package 사용 방법 소개
        - Swift 지원 모든 플랫폼에서 문서 작성 및 공유가 쉬워짐
    - **Build Improvements**
        - Type Checker의 품질 및 성능 개선
        - Array literal 타입 검사 성능 개선
        - 이번 릴리즈를 통해 incremental build 속도를 높이를 3가지 주요 개선 사항으로 개발자 생산성 향상
            - Faster builds when changing imported modules
                - Incremental Import 지원
                - 모듈 변경시, 모듈을 가져오는(import) 모든 소스 파일을 더 이상 rebuild X
            - Faster startup time before launching compiles
                - Module Dependency Graph 미리 계산
                - 변경된 항목에 대해서만 incremental import 빠르게 시작
            - Fewer recompilations after changing an extension body
                - extension과 함께 작동하도록 selective recompilation(선택적 재컴파일) 확장
                - extension의 body를 변경할 때, 더 적은 재컴파일
        - Incremental Import 성능 향상을 통해 빌드 성능에 큰 불이익 없이 프로젝트 모듈화 및 import한 모듈 변경 가능
        - Swift Driver에 의해 가능했음
            - Swift 소스 코드의 컴파일을 조정하는 프로그램
    - **Memory Managements**
        - Swift 클래스 인스턴스는 ARC를 사용하여 특정 객체에 대한 reference 추적
        - 기존 문제
            - 새로운 reference 생성될 때마다 retain 작업 삽입
            - 새로운 reference 사용 중지할 때마다 release 작업 삽입
        - 해결책
            - 컴파일러의 retain, release 작업을 크게 줄일 수 있도록 새로운 reference 추적 방법 도입
            - 이를통해 성능 및 code size 개선
            - Xcode Setting 내 Optimize Object Lifetimes를 추가하여 확인 가능

- **Ergonomic improvements**
    - **Result Builders**
        - SwiftUI를 위해 고안
        - 복잡한 객체 계층 구조를 빠르고 쉽게 사용할 수 있는 새로운 syntax
        - Swift Evolution 프로세스에 의해 해당 syntax가 표준화되고 개선되어 다양한 상황에서 보다 쉽게 사용
    - **Codable**
        - enum 타입 Codable 프로토콜 준수를 위한 상용구 자동 구현 기능 제공
    - **Swift’s type checker(Flexible static member lookup)**
        - Swift에서 타입 추론은 중복 타입 정보 생략 가능했음
        - 프로토콜을 준수하는 type collection이 있고, API에서 해당 타입의 인스턴스를 사용하려는 경우, 몇가지 static property를 선언하여 enum에서 사용하는 바와 같이, 점 표기법(.propertyName)을 사용하여 해당 유형의 인스턴스 참조 가능
            - 예시
                
                ```swift
                // enum
                
                enum Coffee {
                	case regular
                	case decaf
                }
                
                func brew(_: Coffee) {...}
                
                brew(.regular)
                
                // previous protocol
                
                protocol Coffee {...}
                struct RegularCoffee: Coffee {}
                struct Cappuccino: Coffee {}
                
                func brew<CoffeeType: Coffee>(_: CoffeeType) {...}
                
                brew(Cappuccino().regular)
                
                // recent protocol
                
                protocol Coffee {...}
                struct RegularCoffee: Coffee {}
                struct Cappuccino: Coffee {}
                extension Coffee where Self == Cappucino {
                	static var cappucino: Cappucino = { Cappucino() }
                }
                
                func brew<CoffeeType: Coffee>(_: CoffeeType) {...}
                
                brew(.cappucino.large)
                ```
                
        - 이를통해 라이브러리 저자는 자연스럽고 사용하기 쉬운 enum-like API로 정교한 데이터 모델 구축 가능
    - **Property Wrappers on parameter**
        - 기존에는 struct에 @propertyWrapper 주석을 사용하여 고유한 property wrapper 구현
            - 예시
                
                ```swift
                @propertyWrapper
                struct NonEmpty<Value: Collection> { ... } 
                ```
                
        - 이번 업데이트를 통해 동일한 property wrapper를 함수 및 클로저의 매개변수에도 사용 가능
            - 예시
                
                ```swift
                func LogIn(@NonEmpty _ username: String) { ... }
                ```
                
    - **Ergonomic improvements in SwiftUI code**
        - 예시 SwiftUI 코드
            
            ![스크린샷 2023-07-03 오후 9 40 38](https://github.com/Groot-94/WWDC_Study/assets/99063327/690d1e1c-0979-4a6f-9be4-5e62dc063077)
            
        - 중복이 필요한 상황에서, 접미사 표현식을 둘러싸도록 #if 사용을 완화하여 중복성 제거 가능
            
            ![스크린샷 2023-07-03 오후 9 40 55](https://github.com/Groot-94/WWDC_Study/assets/99063327/65a3f7e4-9c1f-4fb3-abf7-348def5d31e3)
            
        - 새로운 type checker 개선 상황을 활용한 점 표기법 사용 가능
            
            ![스크린샷 2023-07-03 오후 9 41 10](https://github.com/Groot-94/WWDC_Study/assets/99063327/64562489-98bd-4a00-95e4-dbb08262a3dd)
            
        - setting 배열에 대한 인덱스를 지정한 다음 클로저 내에서 배열을 인덱싱 하는 것은 어색 → 배열 값을 반복할 수 있는 list constructor로 바인딩을 직접 전달
            
            ![스크린샷 2023-07-03 오후 9 44 40](https://github.com/Groot-94/WWDC_Study/assets/99063327/f4781bb7-4c8c-4460-b11d-639c4a4105a0)
            
        - CGFloat과 Double간에 투명하게 변환하므로 많은 중복 숫자 변환 제거
            
            ![스크린샷 2023-07-03 오후 9 46 13](https://github.com/Groot-94/WWDC_Study/assets/99063327/5efa4c45-8681-46b6-8983-a52f0d89b7c7)
            

- **Asynchrnous and concurrent programming**
    - **문제상황: 기존의 네트워킹 비동기 코드**
        
        ![스크린샷 2023-07-03 오후 9 48 36](https://github.com/Groot-94/WWDC_Study/assets/99063327/d2b62b53-0cf0-4a68-867e-24c7e15335b3)
        
        - 작업 순서 다소 어색
            - 초기 settings
            - dataTask 메서드에 의한 task handle
            - resume()을 통한 task handle 재개 및 백그라운드작업 시작
            - 실제 fetchImage는 이 시점에서 반환
            - 네트워크 작업 완료후 위의 클로저가 이제야 결과 처리
            - 최종 결과로 completion handler 호출
        - completion handler 사용시 try/catch 에러 핸들링 불가
    - **해결방안: async/await**
        - HTTP를 다루기 때문에 response metadata로 캡처
            
            ```swift
            let (data, response) = URLSession.shared.data(for: request)
            ```
            
        - try/catch 에러 핸들링 사용하여 이전 예제에서의 상용구 제거
            
            ```swift
            let (data, response) = try URLSession.shared.data(for: request)
            ```
            
        - data 메서드가 시작되는 즉시 함수를 일시중지하고, 해당 작업이 완료될때까지 할당을 완료할 수 없도록 컴파일러에 알리는 구문 필요 → await
            
            ```swift
            let (data, response) = try await URLSession.shared.data(for: request)
            ```
            
        - 개선된 fetchImage 메서드
            
            ![스크린샷 2023-07-03 오후 9 57 02](https://github.com/Groot-94/WWDC_Study/assets/99063327/d45e27fc-a208-4dfe-a9dd-2795ff8e97a7)
            
            - 제어 흐름은 위에서 아래로 깔끔
            - 더 이상 중첩 클로저 필요 X
            - try/catch 에러 핸들링 가능
            - await을 통해 일시중단된 비동기 함수는 일시 중장된 리소스 사용 X
            - 특히, 스레드 차단 X
            - 이를 통해 Swift 런타임은 해당 함수가 다른 작업을 위해 실행 중인 스레드 재사용 가능
            - 이는 많은 비동기 프로세스 간 매우 적은 스레드 공유 실현
            - async는 함수가 일시중단을 지원하도록 컴파일되어야 함을 나타내기 위해 함수 선언을 장식
    - **문제상황: 3가지 다른 이미지 렌더링 후 결합**
        - 순차적인 기존의 코드
            
            ```swift
            func titleImage() throws -> Image {
            	let background = try renderBackground()
            	let foreground = try renderForeground()
            	let title = try renderTitle()
            
            	return merge(background, foreground, title)
            }
            ```
            
            - background, foreground, title 순서로 렌더링
            - 이전 이미지가 완료된 후에만 시작
    - **해결방안: async/await**
        - 렌더링 작업을 병렬로 진행
        - 다른 스레드를 사용하는 것 뿐만 아니라 3가지 결과가 나올때까지 merge 작업 보류 필요
        - 다른 스레드에서 계산되는 결과를 기다려야하므로 일시 중단할 수 있도록 async 선언
            
            ```swift
            func titleImage() async throws -> Image { ... }
            ```
            
        - async let 구문을 사용하여 처음 두 작업을 병렬로 실행
            
            ```swift
            func titleImage() async throws -> Image {
            	async let background = renderBackground()
            	async let foreground = renderForeground()
            	...
            }
            ```
            
            ![스크린샷 2023-07-03 오후 10 07 12](https://github.com/Groot-94/WWDC_Study/assets/99063327/7d0f839c-9db3-4e11-83b2-2259b1450120)
            
        - Background, Foreground가 async let으로 초기화되어 Swift Runtime은 해당 값이 준비될때까지 merge 일시 중단하기 위해 await 키워드 표시
            
            ```swift
            func titleImage() async throws -> Image {
            	async let background = renderBackground()
            	async let foreground = renderForeground()
            	let title = try renderTitle()
            
            	return try await merge(background, foreground, title)
            }
            ```
            
        - 해당 함수는 두 개의 백그라운드 작업 중 하나가 여전히 실행중인 경우 반환되지 않음
    - **문제상황: 2개의 개별 스레드의 데이터 공유시 데이터 불일치 혹은 손상 위험**
        - 기존 동시성 코드
            
            ```swift
            // Concurrent Code
            
            class Statistics {
            	private var counter: Int = 0
            	
            	func increment() {
            		counter += 1		
            	}
            }
            ```
            
            - increment() 호출시마다 counter 업데이트 필요
            - 다중 스레드 시스템에서는 제대로 작동 X
    - **해결방안: actor**
        - class를 actor로 변경하여 손상 방지
            
            ```swift
            // Concurrent Code with Swift `actor`
            
            actor Statistics {
            	private var counter: Int = 0
            	
            	func increment() {
            		counter += 1		
            	}
            }
            
            var statistics = Statistics()
            await statistics.increment()
            ```
            
            - actor는 특정 변경을 수행하는 것이 안전할 때까지 데이터 손상을 유발할 수 있는 모든 작업 일시 중단
            - actor 외부에서 actor 메서드 호출시 일반적으로 await 사용
        - actor는 async/await과 원활히 호환
            
            ```swift
            // Concurrent Code with Swift `actor`
            
            actor Statistics {
            	private var counter: Int = 0
            	
            	func increment() {
            		counter += 1		
            	}
            
            	func publish() async {
            		await sendResults(counter)
            	}
            }
            ```
            
            - 해당 publish 메서드를 async 표시하면 네트워크 작업을 기다리는 동안 일시 중지 가능
            - 일시 중단된 동안 네트워크 작업 완료될 때까지 기다리지 않고 데이터 손상 위험 없이 해당 액터에서 다른 메서드 실행 가능
        - actor는 class와 같은 reference type이지만 멀티 스레드 환경에서 actor를 안전하게 사용할 수 있도록 설계된 여러 규칙을 따름

- **Looking ahead to Swift 6**
    - Safe concurrency
        - 컴파일러가 개발 프로세스 초기에 더 많은 종류의 동시성 실수를 포착하고 문제를 수정하는데 더 자세한 오류와 가이드라인을 제공하는 방법 이미 연구
        - 목표는 일반적인 종류의 동시성 버그를 완전히 제거하여, 비동기 및 동기 프로그래밍을 다른 종류의 프로그래밍보다 복잡하지 않게 만들기

## 💎 참고 자료

- **What's new in Swift - Apple Developer**

[What‘s new in Swift - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10192/)
