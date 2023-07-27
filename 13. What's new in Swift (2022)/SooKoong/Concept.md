# [WWDC22] What's new in Swift

## 💎 배경

> **WWDC22에서 새롭게 등장하고 개선된 Swift 5.7의 기능들을 알아보는 시간을 가져본다.**
> 

## 💎 개요

- **Community update**
- **Swift packages**
- **Performance improvements**
- **Concurrency updates**
- **Expressive Swift**

## 💎 소개

- **Community update**
    - **커뮤니티 구성원 관리 및 지원**
        - 기존
            - Swift on Server
                - 
            - Diversity in Swift
        - New
            - Swift Website
                - 커뮤니티 리소스 반복 생성
            - C++ Interoperability
                - C++과 Swift 간 상호 운용성을 위한 모델 디자인 형성
    - **커뮤니티 내 관계 구축**
        - 멘토십 프로그램
            - 범위
                - 컴파일러
                - Language Design
                - Technical writing
                - Swift Package
                - …
    - **Diversity in Swift**
        - Cross-platform support
            - RPMs
                - Amazon Linux 2
                - CentOS 7
    - **Statically linked standard library**
        - 외부 유니코드 지원 라이브러리에 대한 종속성 삭제 및 더 빠른 기본 구현으로 대체
            - 독립 실행형 정적 연결 바이너리에 대한 표준 라이브러리를 더 작게 만들기 위함
        - Linux에서 정적 링크 얻음
            - 서버에 대한 컨테이너화된 배포를 더 잘 지원하기 위함
        - 크기 감소 → 제환된 환경에도 적합 → Apple의 Secure Enclave Processor에서 사용
        - Swift → 앱에서 서버, 제한된 프로세서에 이르기까지 유용한 패키지 생태계 구현

- **Swift packages**
    - **TOFU(Trust On First Use)**
        - 패키지가 처음 다운로드될 때 패키지의 지문이 기록되는 새로운 보안 프로토콜
        - 후속 다운로드는 해당 지문의 유효성을 검사하고, 다를 경우 오류 보고
    - **Command plugins**
        - Swift 개발자의 workflow를 개선할 수 있는 좋은 방법
        - 확장 가능하고 안전한 build tool을 제공하는 첫번째 단계
        - shell script에 automation 작성 및 별도의 workflow 유지 관리 대체
        - 모든 오픈 소스 툴을 Xcode 및 SPM에서 사용 가능
        - 사용 예시
            - 문서 생성
            - 소스 코드 reformat
            - 테스트 리포트 생성
            - …
        - **docC**
            - 문서를 소스 코드에 통합
            - Objective-C 및 C 지원 기능 추가
    - **Build Tool plugins**
        - 빌드 중 추가 단계를 삽입할 수 있는 패키지
        - 빌드 도구 플러그인 구현시, 빌드 시스템이 샌드박스에 실행할 명령 생성
        - 언제든지 직접 실행하고 패키지 파일을 변경할 수 있는 command plugin과 차이
        - 사용 예시
            - 소스 코드 생성
            - 특별한 타입의 파일에 대한 사용자 지정 처리
            - …
    - **Package plugins**
        - 패키지에 확장성을 제공하는 보안 솔루션
        - 패키지 확장으로 인한 모듈 충돌을 해결하기 위해 module disambiguation(모듈 명확성) 도입
            - 패키지 외부에서 모듈 이름을 바꿀 수 있는 기능

- **Performance improvements**
    - **Build Time**
        - **New Swift Driver Setting**
            - 2021년, Swift 소스코드의 컴파일을 조정하는 Swift Driver 재작성으로 인한 빌드 타임 감소
                - Integrated compiler
                - Eager compilation
                - Eager linking
            - 드라이버를 별도의 실행 파일이 아닌 Xcode 빌드 시스템 내 프레임워크로 직접 사용 가능
            - 빌드 타임 개선 → 최소 5% ~ 최대 25%
        - **Faster type checking of generics**
            - 타입 검사기 성능 개선
                - 프로토콜 및 where 절과 같은 항목에서 함수 signature 계산하는 제네릭 시스템의 핵심 재구현
                - 이전 구현 → 더 많은 프로토콜 관련 → 시간 & 메모리 사용량 기하급수적 증가
    - **Runtime**
        - Swift 5.7 이전 → 앱 시작 프로토콜 확인까지 4초 경과
            - 앱을 시작할 때마다 프로토콜 계산했기 때문
            - 추가한 프로토콜이 많을 수록 런타임 증가
        - cache 기능 도입 → iOS 16 기준 런타임 1/2 단축

- **Concurrency updates**
    - 2021 WWDC
        - Actor & async/await을 결합한 새로운 동시성 모델 도입
            - callback, manual queue management(수동 대기열 관리)보다 안전하고 쉬움
    - 2022 WWDC
        - forefront에서 data race safety로 모델을 더욱 구체화
        - **Back deployed**
            - 동시성은 앱의 코드 베이스에 대한 근본적이고 중요한 개선 사항
            - 이때문에 아래의 버전까지 다시 배포할 수 있도록 설정
                - macOS 10.15
                - iOS 13
                - tvOS 13
                - watchOS 6
        - **Extensions to the model**
            - **Data race avoidance**
                - 데이터 경합 방지
                - memory safety → thread safety
                - 잠재적인 data race를 식별하는 새로운 opt-in 안전 검사
                    - 빌드 설정에서 활성화하여 더 엄격한 동시성 검사 가능
            - **Distributed actors**
                - 분산 액터
                - 서로 다른 두 액터는 각각의 외딴 섬
                - 이러한 섬을 네트워크를 통해 서로 다른 시스템에 배치
                - 이는 분산 시스템 개발을 훨씬 간단히 함
                - 원격 시스템에 있을 수 있는 액터에서 호출할 것으로 예상되는 함수에 distributed 키워드 추가
                - 일반 액터 호출과 유일한 차이는 네트워크 오류로 인한 잠재적 실패 가능성 존재뿐
                    - 네트워크 장애 → 액터 메서드 오류 발생
                    - 이때문에 액터 외부에서 함수 호출시 await 키워드와 함께 try 키워드 추가 필요
                - 위의 core language primitives 기반으로, Swift에서 서버 측 클러스터 분산 시스템 구축에 중점을 둔 오픈 소스 Distributed Actors package 구축
            - **Async algorithms**
                - AsyncSequence 처리시 일반 작업에 대한 기본 솔루션 제공을 위한 새로운 오픈 소스 알고리즘 세트 출시
                - 해당 API를 패키지로 릴리스 → 개발자가 플랫폼과 운영 체제 버전간 유연 배포 가능
                - 여러 async sequence를 결합하고 값을 컬렉션으로 그룹화하는 방법 마련
                    - zip()
                    - merge()
                    - debounce()
                    - chuncked()
                    - …
        - **Concurrency optimizations**
            - **Actor prioritization**
                - 액터가 가장 우선순위가 높은 작업을 우선 실행
                - 우선순위 역전 방지 기능을 통한 덜 중요한 작업의 더 높은 우선순위 작업 차단 불가
                - 운영체제 스케줄러와의 긴밀한 통합 지속
            - **Using the Swift concurrency instruments**
                - 앱에서 동시성이 성능에 미치는 영향 시각화 도구 도입
                    - Swift Tasks
                    - Swift Actors instruments

- **Expressive Swift**
    - **Optional unwrapping**
        - if let, guard let 공통 패턴에 대한 축약 가능
            
            ```swift
            // previous optional unwrapping
            
            if let workingDirectoryMailmapURL = workingDirectoryMailmapURL {
            	...
            }
            
            // current optional unwrapping
            
            if let workingDirectoryMailmapURL {
            	...
            }
            ```
            
        - closure type inference 또한 마찬가지
    - **Permitted pointer conversion**
        - Swift
            - type & memory safety 매우 중요
            - 자동변환 X
                - 포인터 타입이 다른 포인터 간
                - raw 포인터와 typed 포인터 간
        - C
            - 특정 변환 허용
        - Swift calling C
            - Swift에서 포인터는 각기 다른 타입이므로 다른 타입 포인터로 액세스 시 위험 → 명시적 설명 필요
            - 포인터를 C에 직접 전달하는 경우 무의미 → C에서는 포인터 불일치에 너그러움
            - 따라서, Swift는 import한 메서드 호출에 별도의 규칙 세트를 가짐
            - 일반적으로 Swift에 없지만 C에서는 합법적인 포인터 변환 허용
    - **String processing**
        - 문자열 정보 추출 도구
            - 기존
                - 문자열 검색 및 분할 난잡 → 정규식을 통한 코드 축약
                - 정규식의 불명확성 및 해석 비용 존재
            - New(Swift Regax)
                - 기호 대신 단어를 통한 규칙 작성
                - SwiftUI와 유사한 스타일 언어 제공
                - 기존 구문보다 사용하기 쉽고 읽기 쉬움
                - 정규식 리터럴과 조합 가능
                - Foundation date-format style과 같은 타입들은 custom parsing logic를 regex builder와 통합 가능
                - 데이터를 캡처하기 전 더 풍부한 타입으로 변환 가능
                - 어떤 구문을 사용하든 정규식은 유용한 일치 바업과 사용하기 쉬운 강력한 타입 캡처 지원
    - **Generic code clarity**
        - 두 프로토콜 간 상자를 사용하는지 아닌지 불분명한 순간이 있음
            
            ![스크린샷 2023-07-11 오후 7 40 19](https://github.com/Groot-94/WWDC_Study/assets/99063327/78d0136f-5c9b-43a9-bfe2-a0d66c5d08a2)
            
            - 전자의 프로토콜
                - 프로토콜을 준수하는 인스턴스
                    - 상속 목록
                    - generic parameter 목록
                    - generic 적합성 제약 조건
                    - 불투명한 result 타입
            - 후자의 프로토콜
                - 프로토콜을 준수하는 인스턴스를 포함하는 상자
                    - 변수 타입
                    - generic argument
                    - generic same-type constraint
                    - function parameter
                    - result type
                - 상자의 특성
                    - 일반적으로 더 많은 공간을 사용
                    - 작업하는데 더 많은 시간이 걸림
                    - 그 안에 있는 인스턴스의 모든 기능을 가지고 있지 않음
        - Swift 5.7 → 적합한 타입을 포함하는 상자 중 하나를 사용하는 경우 any 키워드 작성
            
            ![스크린샷 2023-07-11 오후 7 44 55](https://github.com/Groot-94/WWDC_Study/assets/99063327/adecc57b-6ece-46a3-8286-e9f2c276ac57)
            
            ![스크린샷 2023-07-11 오후 7 45 46](https://github.com/Groot-94/WWDC_Study/assets/99063327/a31b5a1a-2fd6-4dc5-b615-16ba23d2bb07)
            
            - 필수 사항은 아니나, 명시적으로 작성하지 않아도 생성된 인터페이스와 오류 메시지에서 이를 볼 수 있도록 권장
            
            ![스크린샷 2023-07-11 오후 7 46 15](https://github.com/Groot-94/WWDC_Study/assets/99063327/8cfc2c6f-0f35-4ecb-9e97-e7f8660139a6)
            
            - 이를 통해 첫번째 메서드의 프로토콜은 generic 타입으로 사용되고, 두번째 메서드의 프로토콜은 any 타입으로 사용됨을 알 수 있음
        - 또한 protocol<Element> 형태를 통하여 프로토콜의 기본 associated type을 제한 가능
        - AnyCollection vs any Collection
            
            ![스크린샷 2023-07-11 오후 7 51 48](https://github.com/Groot-94/WWDC_Study/assets/99063327/489b5a95-3669-47f5-a655-da28293531ad)

            
            - AnyCollection은 type-erasing wrapper
            - AnyCollection 구조체는 가장 지루한 상용구 코드의 한 줄 뒤에 위치
            - 반면 any 타입은 기본적으로 동일한 작업을 무료로 수행하는 기본 제공 언어 기능
            - AnyCollection 구조체는 이전 버전과의 호환성을 위해, 그리고 어떤 타입도 아직 완전히 일치시킬 수 없는 몇 가지 기능을 가지고 있기 때문에 계속 사용할 예정
            
            ![스크린샷 2023-07-11 오후 7 52 20](https://github.com/Groot-94/WWDC_Study/assets/99063327/081d4799-03e2-4fde-88d0-25c1e41b3cfe)
            
            ![스크린샷 2023-07-11 오후 7 52 38](https://github.com/Groot-94/WWDC_Study/assets/99063327/d4fc0bdc-772e-4968-8ac0-4380a3c541e5)
            
            ![스크린샷 2023-07-11 오후 7 52 54](https://github.com/Groot-94/WWDC_Study/assets/99063327/5a9b27d3-3dae-43b7-b05b-8dd2f7909a65)
            
            - any 키워드를 도입하여 사용 중인 위치 확인 가능
            - generic argument에 전달 가능
            - 많은 프로토콜을 사용하지 못하게 하는 제한 삭제
                - supports Self and associated types
            - 모든 타입의 primary associated type 제한 가능
        - 타입 개선이 많이 이루어졌지만 여전히 기능과 성능 모두에서 중요한 제한 존재
            - 그렇기 때문에 대부분의 경우 any 타입을 활용하기 보단 제네릭 사용 권장
                
                ![스크린샷 2023-07-11 오후 7 56 48](https://github.com/Groot-94/WWDC_Study/assets/99063327/6232bb8b-c00c-4c7f-a40b-f1379e85d250)
                
                - 제네릭 사용이 any 타입보다 좀 더 코드가 긺
                
                ![스크린샷 2023-07-11 오후 7 57 26](https://github.com/Groot-94/WWDC_Study/assets/99063327/9de08cf3-f946-4246-852a-60665c866edf)
                
                ![스크린샷 2023-07-11 오후 7 58 05](https://github.com/Groot-94/WWDC_Study/assets/99063327/ccfd8984-38ca-43a3-a09c-3a0124d0a85d)
                
                - generic paramter가 한 곳에서만 사용되는 경우 some 키워드를 통한 제네릭 속기 지원

## 💎 참고 자료

- **What's new in Swift - Apple Developer**

[What's new in Swift - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/110354/)
