# [WWDC20] What's new in Swift

## 💎 배경

> **WWDC20에서 새롭게 등장하고 개선된 Swift의 기능들을 알아보는 시간을 가져본다.**
> 

## 💎 개요

- SwiftUI와 같은 새로운 API의 등장
- SPM을 통한 Xcode 내 오픈 소스 라이브러리 사용
- Cross-platform 지원 강화를 통한 여러 도메인간의 문제 해결

## 💎 소개

- **Code Size**
    - **Binary Size(Clean Memory)**
        - 기능
            - 다운로드 시간과 같은 항목에 필수적
            - But 앱을 실행할 때 **클린 메모리**로 부르는 것의 일부
                - 필요할 때 다시 로드 가능하기 때문에 제거 가능 메모리
                - 이때문에 어플리케이션이 런타임에 할당하고 조작하는 메모리인 더티 메모리보다 덜 중요
        - 개선사항
            - Swift 5.3 기준, code size optimization setting을 통한 Swift와 Objective-C 간 코드 크기 비율을 약 1.5:1로 축소
                - 안정성을 위하여 어느 정도의 차이는 불가피
            - SwiftUI 또한 Xcode12에 다다르면서 로직 코드 크기 40% 절감
    - **Dirty Memory**
        - **Value Type**
            - 개선사항
                - 일부 문자열 제외, 모든 값 타입은 인접한 메모리 블록 내 유지 → 메모리 이점
                    - Objective-C와 달리, 값 유형에 관하여 포인터 사용 필요 X
                    - 객체 내 값 보관 가능
                    - Swift String은 non-ASCII 문자 포함 최대 15개의 code unit 저장 가능
                    - 객체 또한 array storage 내 직접 할당 가능
        - **Heap Usage**
            - 문제상황
                - 런타임 오버헤드로 인해 Objective-C 보다 여전히 더 많은 heap 메모리 사용
                    - Swift는 시작시 많은 캐시와 메모리 생성
                        - 캐시
                            - 프로토콜 준수
                            - 기타 type information 저장
                            - Objective-C로 타입을 연결하는데 사용되는 데이터 저장
            - 개선사항
                - Swift 5.3에서 기존 릴리즈에 사용한 힙 메모리의 1/3 미만으로 오버헤드 감소
                    - 전제조건 → 최소 배포 기준 iOS 14
    - **기대효과(Lowering the Swift runtime in the userspace stack)**
        - 메모리 사용이 중요한 low-level OS 서비스에서 Swift를 더 많이 활용 가능
        - System Stack에서 Foundation 아래에 위치하도록 Swift Standard Library 이동
            - 이전에 C를 사용해야 했던, Objective-C 수준 아래에 있는 프레임워크를 실제로 구현하는데 사용 가능
    
- **Developer Experience**
    - **Diagnostics**
        - 기능
            - 릴리즈 주기 내 컴파일러의 진단, 오류, 및 경고 개선
        - 개선사항
            - Swift Compiler는 문제가 발생한 소스 코드의 정확한 위치를 가리키는 오류 생성
            - 오류로 이어지는 문제의 원인을 진단 및 문제 해결 지침 제공을 위한 휴리스틱 사용
                - [https://www.notion.so/sookoong/WWDC20-Embrace-Swift-Type-Inference-158a5763d422438ba9e5b52d7e215ff9](https://www.notion.so/WWDC20-Embrace-Swift-Type-Inference-158a5763d422438ba9e5b52d7e215ff9?pvs=21) 참고
    - **Code Completion(코드 완성 기능)**
        - 개선사항
            - 코드 완성을 위한 후보 추론 개선
                - 완성되지 않은 dictionary literal 내에서 삼항 식의 값 유추
                    - 예시
                        
                        ![스크린샷 2023-06-28 오후 7 12 18](https://github.com/Groot-94/WWDC_Study/assets/99063327/45df3a3f-de33-4a09-91e7-4a4046cf2193)
                        
            - KeyPath를 함수로 사용하는 것과 같이, dynamic feature 기대 가능
                - 예시
                    
                    ![스크린샷 2023-06-28 오후 7 14 09](https://github.com/Groot-94/WWDC_Study/assets/99063327/a169c892-3da0-4a36-a501-a038916f5955)
                    
            - 코드 완성 퀄리티뿐만 아니라 퍼포먼스 또한 15배 상승
    - **Code Indentation(코드 들여쓰기)**
        - 개선사항
            - 오픈소스인 SourceKit 엔진으로 구동되는 Xcode의 code indentation 능력 향상
                - Chained Method Call
                - Call Arguments
                - Tuple Elements
                - Collection elements that span multiple lines
                - Multi-line if, guard, and while conditions
    - **Debug**
        - 개선사항
            - 명확하지 않은 ‘잘못된 명령’ 표시 → Swift runtime failure trap에 대한 이유 표시
            - Swift debugging support 기능 향상
                - 기존 Swift
                    - Clang 모듈을 사용하여 Objective-C에서 API import
                    - 타입 및 변수 확인을 위해 LLDB는 현재 debugging context에 표시되는 모든 Swift 및 Clang 모듈 import 필요
                    - 모듈 파일 내 타입에 대한 정보 담김
                    - but LLDB에는 전체 프로그램과 모든 동적 라이브러리에 대한 global view가 있음
                    - 이로인한 컴파일 시간 내 Clang 모듈 import 실패 가능성
                        - 일반적인 실패 시나리오로, 서로 다른 동적 라이브러리 search pass 충돌
                - 개선 swift
                    - 이를 해결하고자, LLDB는 DWARF debug information에서 Swift debugging 모적으로 C 및 Objective-C 타입을 가져올 수 있음
                    - 이를 통한, Xcode variable view 및 expression evaluator 기능의 안정성 향상
    - **Cross-platform Support**
        - 개선사항
            - 공식 지원 범위 확대
                - Apple platforms
                - Ubuntu 16.04, 18.04, 20.04
                - CentOS 8
                - Amazon Linux 2
                - Windows (coming soon)
            - AWS Lambda
                - Serveless 기능 제공
                    - 어플리케이션을 클라우드로 확장하는 쉬운 방법
                    - 오픈소스인 Swift AWS runtime을 사용하여 해당 작업 쉽게 수행
    
- **Swift Language**
    - **요약**
        - 12개 이상의 새로운 언어 기능 추가
    - **API Design**
        - **Multiple Trailing Closure Syntax(다중 후행 클로저 구문)**
            - 기존의 후행 클로저 구문 이점을 여러 클로저 인수가 있는 호출로 확장 및 추가 인수를 추가하는데 필요한 재조정 노력 X
                - 예시
                    
                    ```swift
                    // Multiple trailing closure syntax
                    // 기존
                    
                    UIView.animate(withDuration: 0.3, animations: {
                    	self.view.alpha = 0
                    }, completion: { _ in
                    	self.view.removeFromSuperview()
                    })
                    
                    // 개선
                    
                    UIView.animate(withDuration: 0.3) {
                    	self.view.alpha = 0
                    } completion: { _ in
                    	self.view.removeFromSuperview()
                    }
                    
                    ```
                    
            - DSL(Domain Specific Language)에도 적용 가능
                - 
        - **Trailing Closure Syntax(후행 클로저 구문)**
            - 후행 클로저로 인한 argument label이 삭제될 수 있으므로, 이를 가정하여 메서드 이름 지정
        - **KeyPath expression as functions**
            - KeyPath
                - call-site가 단순 프로퍼티 액세스인 경우, 더 간결하고 중첩이 적으므로 매력적인 함수 파라미터 대안으로 사용됨
                    - 예시
                        
                        ```swift
                        // KeyPath expressions as functions
                        // 기존
                        
                        extension Collection {
                        	func chuncked<Key>(by keyForValue: @escaping (Element) -> Key) -> Chuncked<Self, Key>
                        }
                        
                        for (shoeSize, group) in contacts.chuncked(by: { $0.shoeSize }) {
                        	...
                        }
                        
                        // 개선
                        
                        extension Collection {
                        	func chuncked<Key>(by keyForValue: KeyPath<Element, Key>) -> Chuncked<Self, Key>
                        }
                        
                        for (shoeSize, group) in contacts.chuncked(by: \.shoeSize) {
                        	...
                        }
                        ```
                        
                - 단순 프로퍼티 액세스 이외에도, sinature가 일치하는 모든 함수 매개변수에 KeyPath argument 전달 가능
                - KeyPath를 수락하기 위해 과거에 추가한 중복 선언 또한 삭제 가능
        - **@main**
            - 기능
                - 타입 기반 프로그램의 entry-point(진입점)을 위한 도구
                - 앱 실행을 위해 필요한 boilerplate 제거
                    - 선언적 프로그래밍의 일관성 보장
                    - 사용자가 진입점을 derive할 것으로 예상되는 프로토콜 혹은 super class에 static main method 선언만 하면 됨
                    - @main으로 해당 타입에 대한 태그 지정 및 컴파일러가 사용자를 대신하여 암시적 main.swift 생성
                    - command line tool, 기존 application, 새로운 application, 혹은 다른 어떤 작업을 하든 관계없이 쉽게 실행 시작
        - **boilerplate 제거 및 표현력을 향상시킨 language 개선 사항들**
            - **Implicit Self in Closures**
                - 클로저 내 self 중복을 막기 위해, capture list 내 `[self]` 선언을 통한 비용 절감
                - self가 한 번 쓰이는 상황에서 self가 struct 혹은 enum 타입이면 생략 가능
                
            - **Multi-pattern catch clauses**
                - catch 절 내 중첩 switch 사용시, catch 절을 여러번 사용하여 분리 가능
            - **Enum Enhancements**
                - enum 타입 한정을 위해 복수의 비교 연산자 사용 대신 comparable 적합성 추가
                - Enum cases as protocol witnesses
                    - enum case를 static var 및 static func 프로토콜 요구사항을 충족하는데 사용 가능
                        - 예시
                            
                            ![스크린샷 2023-06-29 오전 12 57 22](https://github.com/Groot-94/WWDC_Study/assets/99063327/ef4ec634-de44-49d0-b32c-2929a619c94b)
                            
            - **Embedded DSL Enhancements**
                - embedded DSL에 대한 지원을 추가하여 SwiftUI의 Declarative syntax 강화
                - embedded DSL을 확장하여 if-let 및 switch와 같은 pattern matching control flow 지원
            - **Builder Inference**
                - 기존 SwiftUI body의 최상위 수준에서 DSL 구문을 사용하려면 특정 빌더 속성으로 태그 지정 필요
                    - ex) @SceneBuilder
                - Swift 5.3에서는 프로토콜 요구 사항에서 빌더 속성을 유추하는 방법을 컴파일러에 가르쳐줘 더이상 builder 속성 불필요 → 태그 지정 안해도 됨
                

- **Swift’s Standard Library**
    - **SDK**
        - **Float16**
            - 4 bytes를 사용하는 Float가 달리 2 bytes만 사용
            - SIMD 레지스터 또는 메모리에 페이지에 기존 보다 2배 더 많이 넣을 수 있음
            - 지원되는 하드웨어에서는 일반적으로 두 배의 성능 향상
            - but 데이터 유형이 더 작기 때문에 더 낮은 정밀도와 더 제한된 범위임을 망각 X
            - 
        - **Apple Archive**
            - OS 업데이트를 제공하는데 사용하는 실전 테스트를 거친 기술을 기반으로 하는 새로운 모듈식 아카이브 형식
            - 빠르고, 멀티스레드 압축에 최적화
            - Finder 통합
            - Command Line Tool 및 Swift API를 비롯한 여러 강력한 기능 제공
            - Swift System
                - Apple Archive 같은 low-level 시스템 API에 대한 시스템 호출 및 currency 타입에 대한 최신 관용적 인터페이스(modern idiomatic interface) 제공
        - **OSLog**
            - High Performacnce & Privacy-sensitive Logging
                - 최소한의 오버헤드를 가지도록 최적화되고 의도하지 않은 민감한 데이터 로깅을 방지하도록 제작된 통합 로깅 API
            - 보다 정교한 컴파일러 최적화를 통해 OSLog를 훨씬 더 빠르고 expressive하게 만듦
            - 문자열 보간 및 타입 지정 옵션에 대한 지원 추가
    - **Packages**
        - **Swift Numberics**
            - 복소수 및 산술 지원뿐만 아니라 일반 컨텍스트에서 훨씬 더 유용한 방식으로 sin, log와 같은 모든 기본 수학 함수 정의
            - C와 호환되는 모듈이면서 빠름
        - **Swift ArgumentParser**
            - command-line argument 파싱을 위한 새로운 오픈 소스 Swift Package
            - 풍부하게 문서화된 도움말 화면을 포함해 사용자에게 올바른 사용법 안내
        - **Swift StandardLibraryPreview**
            - 새로운 StandardLibrary 기능에 대한 early access
                - Swift Evolution 프로세스를 통해 승인되었지만, 아직 공식 Swift 릴리즈의 일부로 제공되지 않는 기능에 대한 엑세스 제공
            - Swift Evolution 승인 프로세스가 더 쉽게 검토를 진행할 수 있도록 수정
            - SE-0270 기능 seed
                - 컬렉션 하위 범위 및 지원 범위 set 타입에 대한 작업 포함

## 💎 참고 자료

- **What's new in Swift - Apple Developer**

[What's new in Swift - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10170/)
