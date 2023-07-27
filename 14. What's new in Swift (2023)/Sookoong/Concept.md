# [WWDC23] What's new in Swift

## 💎 배경

> **WWDC23에서 새롭게 등장하고 개선된 Swift 5.9의 기능들을 알아보는 시간을 가져본다.**
> 

## 💎 개요

- **Create more expressive APIs**
- **Tune low-level performance**
- **Intereoperate with existing C++ code bases**
- **Adapt concurrency to your environment**

## 💎 소개

- **Expressive code**
    - **if/else 및 switch**
        - 문제상황1: 복잡한 조건에서의 상수 초기화
            - 복잡한 삼항 표현식과 같은 트릭 사용
                
                ![스크린샷 2023-07-17 오후 11 56 07](https://github.com/Groot-94/WWDC_Study/assets/99063327/07f4f3b6-0b79-4bb3-9daa-04ff5d9de92a)
                
        - 해결방법1: if 표현식 사용
            - if문 chain을 통한 가독성 향상
                
                ![스크린샷 2023-07-17 오후 11 56 46](https://github.com/Groot-94/WWDC_Study/assets/99063327/0790c468-433d-4540-80b3-955799b0364f)
                
        - 문제상황2: 전역 변수 및 저장 프로퍼티 초기화
            - 단일 표현식은 잘 작동하나, 조건을 원하는 경우 클로저 래핑 필요
                
                ![스크린샷 2023-07-17 오후 11 59 04](https://github.com/Groot-94/WWDC_Study/assets/99063327/4907700a-2007-4691-8bc1-1a79ea96b1b7)
                
        - 해결방법2: if 표현식 사용
            - if 표현식 사용을 통한 복잡함 제거 및 깔끔한 코드 생성
                
               ![스크린샷 2023-07-18 오전 12 00 04](https://github.com/Groot-94/WWDC_Study/assets/99063327/4cd9dc9f-1c40-45c9-86a0-220613f6a3ee)
                
    - **Result builders**
        - 개선사항
            - 최적화된 type checking
            - code completion 기능 향상
            - 더욱 정교해진 에러 메시지
        - invalid code에 위의 개선사항 초점
            - 이전에는 오류가 있는 result builder 코드는 실패하는데 오랜 시간 지불
                - type checker가 가능한 많은 유효하지 않은 경로를 탐색했기 때문
            - Swift 5.8 이후 invalid code type check 속도 향상 및 오류 메시지 정확성 향상
    - **Type Parameter Pack**
        - 부제: Generics system for improvement to framework
        - 대부분의 Swift은 제네릭 활용중
        - Type Inference 사용시, 내장된 고급 기능 이해 없이 해당 타입 사용 가능
        - 예시) Array<Element>
            - Array 타입은 제네릭을 사용하여 모든 유형의 데이터와 함께 작동하는 배열 제공
            - 배열 사용을 원하면 요소(element)만 제공하면 됨
            - 요소 값에서 타입 추론이 가능하므로 타입에 대한 명시적 인자 지정 필요 X
        - 제네릭은 구체적인 타입에서 원할하게 작동하도록 타입 정보를 보존하는 natural API를 활성화
        - 예시) Request<Result> API
            
            ![스크린샷 2023-07-18 오전 12 10 19](https://github.com/Groot-94/WWDC_Study/assets/99063327/c26e351e-f804-400a-ab5a-2b514120bca4)
            
            - request 타입을 사용하여, 이를 평가해 typed value를 생성하는 API
            - 예시로, Bool 값을 요청하고, Bool 값을 return 받을 수 있음
            
            ![스크린샷 2023-07-18 오전 12 12 22](https://github.com/Groot-94/WWDC_Study/assets/99063327/8cc2bc83-280c-48e1-acc2-a7ff3fff0b10)
            
            - concrete type뿐만 아니라 전달하려는 argument에 대해서도 추상화하고자 할 때
            
            ```swift
            let value = RequestEvaluator().evaluate(request)
            let (x, y) = RequestEvaluator().evaluate(r1, r2)
            let (x, y, z) = RequestEvaluator().evaluate(r1, r2, r3)
            ```
            
            - 요청의 수에 따른 각각의 요청을 반환할 수 있으려면 여러 argument 길이들을 처리하는 메커니즘과 함께 제네릭 시스템을 사용해야 함
            
            ![스크린샷 2023-07-18 오전 12 15 40](https://github.com/Groot-94/WWDC_Study/assets/99063327/e78ec020-e30e-43b3-b240-55e6f587d70b)
            
            - Swift 5.9 이전에는 API가 지원하는 특정 argument 길이에 대한 overload 추가밖에 없었음
            - 하지만, 이 방법은 인위적인 상한이 적용되어 유연하지 않은 구조
            
            ![스크린샷 2023-07-18 오전 12 17 33](https://github.com/Groot-94/WWDC_Study/assets/99063327/aadcf744-98a1-4ba7-b6f5-e4142cf5d1e3)
            
            - 따라서 Swift 5.9에서는 argument 길이에 대한 제네릭 추상화를 활성화하여 API 패턴에 대한 first-class support를 얻고 있음
            - 이는 **type parameter pack**으로, 함께 “패키징”되는 여러 개별 타입 파라미터를 나타내는 새로운 언어 개념으로 수행
            
            ![스크린샷 2023-07-18 오전 12 19 44](https://github.com/Groot-94/WWDC_Study/assets/99063327/7257938b-949e-409e-b454-0f02be1b1892)
            
            - 각 argument 길이에 대한 개별 오버로드가 있는 API를 단일 함수로 축소 가능
    - **Swift macros**
        - 매크로를 사용하면 언어 자체의 기능을 확장하여 상용구를 제거하고, Swift의 표현력을 더 많이 활용 가능
        - 예시) assert
            
            ```swift
            assert(max(a,b) == c)
            ```
            
            - 조건이 참인지 확인하는 assert 함수
            - 조건이 거짓이면 프로그램이 중지되지만 무엇이 잘못되었는지는 파악 X
                - file과 line number 정보만 제공함
                    
                    ![스크린샷 2023-07-18 오전 12 26 57](https://github.com/Groot-94/WWDC_Study/assets/99063327/93bd12d0-10a8-4de5-bee6-dc9522e3f14a)
                    
            - 자세히 알아보려면 디버거에서 일부 로깅을 추가하거나 프로그램 트랩 필요
            
            ```swift
            XCAssertEqual(max(a,b) == c)
            ```
            
            - 이를 개선하고자 XCAssertEqual 함수 사용
            - 두 값을 개별적으로 사용하는 assert-equal 작업을 제공하므로 문제가 발생하면 적어도 두 값이 같지 않단 사실은 확인 가능
                
                ![스크린샷 2023-07-18 오전 12 26 57](https://github.com/Groot-94/WWDC_Study/assets/99063327/93bd12d0-10a8-4de5-bee6-dc9522e3f14a)
                
            - 그래도 여전히 어떤 값이 잘못된 것인지는 모름
            
            ```swift
            import PowerAssert
            
            #assert(max(a,b) == c)
            ```
            
            - hash-assert(#assert) 구문을 통한 assert 매크로 확장
            - 함수처럼 보이지만 매크로이기에 실패 시 더욱 풍부한 경험 제공
                
                ![스크린샷 2023-07-18 오전 12 28 45](https://github.com/Groot-94/WWDC_Study/assets/99063327/8c92e089-cef3-4db0-8af0-bf6915bda53d)
                
            - Swift에서 매크로는 타입이나 함수와 마차가지로 API이므로, 매크로를 정의하는 모듈을 가져와 액세스 필요
            - 다른 API들처럼 매크로는 패키지로 배포
            
            ```swift
            public macro assert(_ condition: Bool) = #externalMacro(
            	module: "PowerAssertPlugin",
            	type: "PowerAssertMacro"
            )
            ```
            
            - 패키지를 보면, 위와 같이 macro 키워드를 제외하고 함수처럼 정의
            - 대부분의 매크로는 string을 통해 매크로 구현을 위한 모듈 및 타입을 지정하는 externalMacro로 정의
            
            ![스크린샷 2023-07-18 오전 12 33 25](https://github.com/Groot-94/WWDC_Study/assets/99063327/a539e718-7ad3-4c3a-a44e-b7dddb7af278)
            
            - externalMacro 타입은 컴파일러 플러그인 역할을 하는 별도의 프로그램에서 정의됨
            
            ```swift
            @freestanding(expression)
            public macro assert(_ condition: Bool) = #externalMacro(
            	module: "PowerAssertPlugin",
            	type: "PowerAssertMacro"
            )
            ```
            
            - 매크로 선언에는 하나의 추가 정보가 있음(`@freestanding(expression)`)
            - 여기서 assert 매크로는 독립된 식 매크로임(freestanding expression macro)
            - hash 구문을 사용하고, 해당 구문에서 직접 작동하여 새 코드를 생성하기 때문에 독립형(freestanding)이라 함
            - 그리고 값을 생성할 수 있는 모든 곳에서 사용할 수 있기 때문에 식 매크로(expression macro)임
        - 예시) enum
            
            ![스크린샷 2023-07-18 오전 12 38 12](https://github.com/Groot-94/WWDC_Study/assets/99063327/7b61360e-4098-43a4-9b48-5beaa9197067)
            
            - 컬렉션에서 모든 absolute path를 필터링하여 특정 case를 확인해야하는 경우
            - isAbsolute 검사를 computed property으로 사용 가능
            
            ![스크린샷 2023-07-18 오전 12 38 28](https://github.com/Groot-94/WWDC_Study/assets/99063327/db44d425-a75e-478c-a9a5-a2d8eb0ccb5a)
            
            - 그러나 위와 같은 지루한 추가 코드 필요
            
            ![스크린샷 2023-07-18 오전 12 39 20](https://github.com/Groot-94/WWDC_Study/assets/99063327/e1681bfe-b286-4db3-ad56-5ce9db963037)
            
            - 매크로를 통해 상용구를 생성 가능
            - 대소문자 감지(`@CaseDetection`)는 property wrapper와 동일한 custom-attribute syntax를 사용하여 작성된 attched macro
            - attched macro는 적용되는 선언 구문(여기서는 enum 선언 자체)을 입력으로 사용하여 새 코드를 생성
            
            ![스크린샷 2023-07-18 오전 12 41 27](https://github.com/Groot-94/WWDC_Study/assets/99063327/cf7055ef-4065-4c9b-b6a1-f565167ec85f)
            
            - 이 매크로 확장 코드는 컴파일러가 프로그램에 통합되는 일반적인 Swift 코드
            - 편집기에서 매크로 생성 코드를 검사, 디버깅 및 커스터마이징하려는 경우 복사하는 등의 작업을 수행 가능
        - **Attatched macro roles**
            
            ![스크린샷 2023-07-18 오전 12 47 54](https://github.com/Groot-94/WWDC_Study/assets/99063327/e7b843b2-8719-445d-be78-68048d4f70c2)
            
            - 첨부된 선언을 확장하는 방법에 따라 다섯 가지 역할로 분류
                - `@attatched(member)`
                    - 타입 또는 extension에서 새 멤버를 생성
                    - 위의 @CaseDetection 예시가 이에 해당
                - `@attached(peer)`
                    - 연결된 선언과 함께 새 선언을 추가
                        - 비동기 메서드의 completion handler 버전 생성
                        - 그 반대의 경우도 마찬가지
                - `@attached(accessor)`
                    - 저장 프로퍼티를 계산 프로퍼티로 전환 가능
                    - 프로퍼티 액세스에 대한 특정 작업을 수행
                    - property wrapper와 비슷하지만 더 유연한 방식으로 실제 저장소를 추상화하는데 사용
                - `@attached(memberAttribute)`
                    - 타입의 특정 멤버에 대한 속성 도입
                - `@attached(conformance)`
                    - 새로운 프로토콜 적합성 추가 가능
        - Swift 매크로는 코드에서의 상용구를 제거하여, 보다 표현력이 풍부한 API를 사용 가능케 함
        - 매크로는 입력들을 type check하고, 일반 swift 코드를 생성하며, 프로그램의 정의된 지점에 통합하므로 그 효과를 쉽게 추론 가능
        - 매크로가 수행한 작업을 이해해야할 때마다 확장된 소스 코드가 editor에 있음

- **Swift everywhre**
    - **Swift Foundation**
        - 성능향상
            - Calendar 계산 → 20% faster
                - Swift’s value semantics를 더 잘 활용하여, 중간 할당을 피함
            - Date Foramming → 150% faster
                - 주요 성능 업그레이드
                - 표준 날짜 및 시간 템플릿을 사용한 formatting benchmark에서 엄청난 성능 개선
            - JSON coding → 200~500% faster
                - JSONDecoder 및 JSONEncoder를 위한 새로운 Swift implementation 제공
                - Objective-C 컬렉션 타입을 오가는 비용이 많이 드는 왕복 제거
                - Codable 타입을 초기화하기 위해 Siwft에서 JSON 파싱을 긴밀하게 통합하면 성능 향상
        - 이러한 성능 향상은 Objective-C 구현에서 Swift로의 연결 비용을 줄이는 것 뿐만 아니라 새로운 Swift 기반 구현이 더 빠르기 때문
    - **Ownership**
        - Low-level 시스템에서 작동할 때 필요한 수준의 성능을 달성하기 위해 더욱 세밀한 제어 필요한 경우 존재
        - Swift 5.9에서는 이를 위한 새로운 opt-in 기능 도입
        - 해당 기능은 소유권 개념, 즉 애플리케이션에서 값을 전달할 때 코드의 어떤 부분이 값을 **소유**하는지에 초점
        - 문제상황: Simple Wrapper in low-level system call
            
            ![스크린샷 2023-07-18 오전 1 25 42](https://github.com/Groot-94/WWDC_Study/assets/99063327/b7347305-10c9-45b4-9de3-219b48e139ff)
            
            - low-level 시스템 호출에 더 나은 Swift 인터페이스를 제공할 수 있는 FileDescriptor에 대한 간단한 wrapper
            - 해당 API를 사용할 때 발생하기 쉬운 실수 몇가지가 존재
            - 예시로, close 메서드 호출 시 파일에 write 시도할 수 있음
            - 그리고 타입이 범위를 벗어나기 전에 close 메서드를 호출하여 항상 수동으로 닫도록 주의해야함 → 그렇지 않으면 resource leak
        - 해결방안1: deinit가 있는 class 생성
            
            ![스크린샷 2023-07-18 오전 1 29 12](https://github.com/Groot-94/WWDC_Study/assets/99063327/98fdfc0d-445e-487b-b744-d27021b4c50b)
            
            - 타입이 범위를 벗어날 때 자동으로 close하는 deinit이 있는 클래스 생성
            - 하지만, 이는 일반적으로 추가 메모리 할당과 같은 사소한 단점 존재
            - 클래스에는 reference semantics가 있음
            - 실수로 쓰레드 간 FileDescriptor 타입을 공유하게 되어 race condition이 발생하거나 실수로 저장될 가능성 존재
        - 해결방안2: Non-copyable type
            
            ![스크린샷 2023-07-18 오전 1 32 45](https://github.com/Groot-94/WWDC_Study/assets/99063327/d917c232-efd1-4504-82a2-74fc408a1fab)
            
            - 해당 구조체는 open file인 true 값을 참조하는 정수를 보유하기 때문에 참조 타입처럼 작동
            - 해당 타입의 copy를 만들면 앱 전체에서 mutable한 상태가 의도치 않게 공유되어 버그 발생 가능
            - 우리가 필요한 건 해당 구조체의 copy를 만드는 기능을 억제하는 것
                - 구조체든 클래스든 Swift 타입은 기본적으로 복사 가능
                - 지나친 불필요한 복사본은 코드 병목 현상 될 수 있음
                - 그러나 복사본에 대해 명시적으로 요구하는 컴파일러에 의해 지속적으로 귀찮게 하는 것보단 때때로는 계측기에서 병목 현상을 찾는게 더욱 편함
                - 하지만 중요한건 암시적 복사가 원치 않을 때도 존재
                - 특히, value의 copy를 만들때 위의 FileDescriptor wrapper와 같이 정확성 문제가 발생할 수 있음
            
            ![스크린샷 2023-07-18 오전 1 37 01](https://github.com/Groot-94/WWDC_Study/assets/99063327/f9fbbe4f-6df2-46cb-9e76-45554301602d)
            
            - Swift 5.9 에서는 struct 및 enum 선언에 적용 가능하고 타입을 복사하는 암시적 기능을 억제하는 새로운 구문(`~Copyable`)을 사용하여 이를 수행 가능
            - 타입이 복사 불가능하면 타입이 값의 범위를 벗어날 때 클래스와 마찬가지로 deinit 지정 가능
            - consuming 메서드 또는 argument를 호출하면 호출한 메서드에 대한 값 소유권을 포기
            - 타입 복사가 불가능하기에 소유권 포기는 곧 더 이상 그 값을 사용하지 않음을 의미!
    - **C++ interop**
        
        ![스크린샷 2023-07-18 오전 1 42 05](https://github.com/Groot-94/WWDC_Study/assets/99063327/57f456f0-a6a5-4f4e-9878-286ddb0454d6)
        
        - Swift 5.9부터 Swift에서 직접 C++ 타입 및 함수와 상호 작용하는 기능 도입
        - C++ interoperability(상호 운용성)은 항상 Objective-C interoperability와 마찬가지로 작동하여 C++ API를 Swift 코드에서 직접 사용할 수 있도록 Swift에 mapping
        
        ![스크린샷 2023-07-18 오전 1 42 23](https://github.com/Groot-94/WWDC_Study/assets/99063327/f3fdaf83-2b45-456d-8537-8c6f19b7f18b)
        
        - C++는 클래스, 메서드, 컨테이너 등과 같은 고유한 아이디어 개념을 가진 대규모 언어
        - Swift 컴파일러는 일반적인 C++ 관용구를 이해하므로 많은 타입을 직접 사용 가능
        - 예시로, 위의 Person 타입은 C++ value 타입에서 예상되는 특수 멤버 함수(복사 및 이동 생성자, 할당 연산자 및 소멸자)를 정의
        - Swift 컴파일러는 이것을 값 타입으로 취급하고, 적시에 올바른 특수 멤버 함수를 자동으로 호출
        - 또한 vector, map과 같은 C++ 컨테이너는 Swift 컬렉션으로 액세스
        
        ![스크린샷 2023-07-18 오전 1 45 21](https://github.com/Groot-94/WWDC_Study/assets/99063327/55db0a55-156f-45c2-bbd6-7b9cc267134b)
        
        - 이 모든 결과는 C++ 함수 및 타입을 직접 사용하는 간단한 Swift 코드로 작성 가능
        - C++ 멤버 함수를 호출하고 데이터 멤버에 직접 액세스하여, Person 인스턴스의 백터를 필터링 가능
        
        ![스크린샷 2023-07-18 오전 1 46 25](https://github.com/Groot-94/WWDC_Study/assets/99063327/f5f224ac-f59f-49b8-9de2-c366cd2379a7)
        
        - C++의 Swift 코드를 사용하는 것은 Objective-C와 동일한 메커니즘을 기반으로 함
        - Swift 컴파일러는 Swift API에 대한 C++ view를 포함하는 “generated header”를 생성
        - 그러나 Objective-C와 달리 objc 속성으로 주석이 달린 Swift 클래스만 사용하도록 제한할 필요 X
        - C++은 bridging overhead 없이 대부분의 Swift 타입과 프로퍼티, 메서드 및 이니셜라이저를 포함한 전체 API를 직접 사용 가능
        
        ![스크린샷 2023-07-18 오전 1 48 51](https://github.com/Groot-94/WWDC_Study/assets/99063327/556c15fe-eec6-4fd6-826a-847181410db4)
        
        - C++이 Point 구조체를 사용하는지를 확인할 수 있음
        - generated header를 포함한 후, C++은 Swift 코드 자체를 변경하지 않고도 Swift Initializer 프로그램을 호출
        - Point 인스턴스를 만들고, mutating method를 호출하고, 저장 및 계산 프로퍼티 모두 액세스 가능
        - 정리하면,
            - Swift의 C++ 상호 운용성은 Swift를 기존 C++ 코드 베이스와 통합하는 것을 그 어느때보다 쉽게 만듦
            - 많은 C++ 관용구는 종종 자동으로 Swift에서 직접 표현될 수 있지만, 원하는 semantics를 나타내기 위해 일부 주석 필요
            - Swift API는 C++에 직접 액세스 가능하며 주석이나 코드 변경 불필요 → C, C++, Objective-C를 혼합하여 코드 기반 전체에서 점진적으로 Swift 채택 가능
    - **Actors and concurrency**
        - Swift’s concurrency model은 다양한 환경과 라이브러리에 적용할 수 있는 추상 모델
            - 구성
                - Tasks
                    - 어디에서나 실행 가능한 순차적인 작업 단위
                    - 프로그램에 await이 있을때마다 작업 일시 중단
                    - 작업을 계속할 수 있게 되면 resume
                - Actors
                    - 격리된 상태에 대한 상호 배타적인 액세스를 제공하는 동기화 메커니즘
                    - 외부에서 액터를 입력하면 작업을 일시 중지할 수 있으므로 await 필요
            - 특징
                - Tasks in different environments
                    - Task와 Actor는 추상 언어 모델에 통합되지만 해당 모델 내에서 다양한 환경에 맞게 다양한 방식으로 구현 가능
                    - Task는 global concurrent pool에서 실행됨
                    - global concurrent pool이 스케줄을 결정하는 방법은 environment에 달림
                    - 추상 모델은 다양한 런타임 환경에 매핑할 수 있을만큼 유연하기에 동일한 Swift 코드가 두 환경에서 모두 작동
                        - Apple 플랫폼의 경우
                            - Dispatch 라이브러리는 전체 운영 체제에 최적화된 일정을 제공하며 각 플랫폼에 대해 광범위하게 조정
                        - 보다 제한적인 환경
                            - multi-thread scheduler의 오버헤드가 허용되지 않을 수 있음
                            - Swift concurrency model은 single-threaded cooperative queue로 구현
                    - 콜백 기반 라이브러리와의 상호운용성은 처음부터 Swift의 async/await 지원에 내장
                    - withCheckedContinuation operation을 통해 작업을 일시 중단한 다음 나중에 콜백에 대한 응답으로 다시 시작 가능
                        
                        ![스크린샷 2023-07-18 오전 2 18 28](https://github.com/Groot-94/WWDC_Study/assets/99063327/9dc06bb2-96b6-41b0-8292-d5196767daae)
                        
                - Actors
                    - Actors can be implemented in different ways
                        - Swift concurrency runtime에서 액터의 표준 구현은 액터에서 실행할 task의 lock-free queue이지만 그것이 유일한 구현은 아님
                        - 보다 제한적인 환경에서는, atomic가 없을 수 있으며 대신 spinlocks와 같은 다른 동시성 프리미티브를 사용 가능
                        - 해당 환경이 단일 스레드인 경우 동기화가 필요하지 않지만, 액터 모델은 관계없이 프로그램에 대한 추상 동시성 모델 유지
                        - 동일 코드를 다중 스레드인 다른 환경으로 계속 가져올 수도 있음
                    - Swift 5.9에서는 커스텀 액터 실행기를 통해 특정 액터가 자체 동기화 메커니즘 구현 가능
                        - 이를 통해 액터는 기존 환경에 더욱 유연하고 적응 가능한 상태
                    
        - 추상 모델 자체는 매우 유연하여 iPhone, Apple Watch, 서버 및 그 이상에 이르기까지 다양한 실행 환경에 적용 가능
        - Swift Concurency를 완전히 채택하지 않은 코드와 상호 운용할 수 있도록 주요 지점에서 커스터마이징 허용
        
    - **FoundationDB: A case study**
        - 상용 하드웨어에서 실행되고, MacOS, Linux 및 Windows를 포함한 다양한 플랫폼을 지원하는 매우 큰 key-value 저장소를 위한 확장 가능한 솔루션을 제공하는 분산 데이터베이스
        - C++로 작성된 대규모 코드 베이스가 포함된 오픈 소스 프로젝트
        - 코드는 테스트 목적으로 매우 중요한 결정론적 시뮬레이션 환경을 제공하는 고유한 형태의 분산 액터 및 런타임을 사용하여 매우 비동기적
        - 코드 기반을 현대화하려고 했고, Swift가 성능, 안전 및 코드 명확성에 적합하다는 사실을 깨달음
        - `C++ → Swift`로 완전히 재작성하기에는 크고 위험한 노력이므로, 대신 Swift의 상호 운용성을 활용하여 기존 코드베이스에 통합

## 💎 참고 자료

- **What's new in Swift - Apple Developer**

[What’s new in Swift - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10164/)
