# [WWDC20] Embrace Swift Type Inference

## 💎 배경

> **WWDC20에서 소개된 "Embrace Swift Type Inference" 강의는 Swift Programming Language의 타입 추론 기능을 효과적으로 활용하는 방법에 초점을 맞추었다. 이번 강의를 통해 코드의 간결성과 가독성을 높이는 타입 추론의 이점을 살펴보고, 추론과 explicit type annotation 작성의 선택에 대한 가이드라인을 제시하며, 타입 추론의 성능과 유지보수에 대한 영향을 알아보도록 한다.**
> 

## 💎 개요

- **Leveraging type inference**
    - 타입 추론을 활용할 수 있는 경우에 대하여 알아본다
- **How type inference works in compiler**
    - 컴파일러에서 타입 추론이 작동하는 방식에 대하여 알아본다
- **Using Swift and Xcode to fix comiler errors**
    - Swift와 Xcode를 사용하여 코드의 컴파일러 오류를 이해하고 수정하는 방법을 알아본다

## 💎 해결방안

- **Type Inference**
    - **개념**
        - 타입 추론을 사용하면 컴파일러가 주변 context에서 세부정보를 파악할 수 있을때, source code에서 explicit type annotation 및 기타 세부정보 생략 가능
            - Type annotation
                - 타입 어노테이션(type annotation)은 코드에서 변수, 함수 인자, 그리고 반환 값의 기대되는 데이터 타입을 명시적으로 선언하는 방법
                - 즉, 자료형을 지정하는 방법
                    
                    ```swift
                    let name: String
                    ```
                    
        - 타입 추론을 통해, 아래의 예시와 같이 변수의 자료형을 유추 가능
            - 예시
                
                ```swift
                let x = "" // variable x is String!
                
                // 타입 명시적 시정 방법 1
                
                let x: String = ""
                
                // 타입 명시적 시정 방법 2
                
                let x = "" as String
                ```
                

> **SwiftUI 프로젝트는 small & reusable View를 구성하여 크고 복잡한 인터페이스를 생성하기에 재사용 가능한 구성 요소의 호출 사이트에서 타입 추론에 크게 의존**
> 

- **Leveraging type inference at the call-site**
    - **문제상황: 타입 추론에 크게 의존하는 call-site**
        - 사용자가 스무디를 검색하는 앱을 만들려고 함
        - SmoothieList는 다음과 같이 구성
            
            ![스크린샷 2023-06-21 오후 5 53 32](https://github.com/Groot-94/WWDC_Study/assets/99063327/f9b8d0ea-0f5f-4052-8a2f-b8e116a03988)
            
            - body에서 각각의 스무디를 SmoothieRowView로 mapping한 Smoothie Array로부터 SwiftUI List를 생성
            
            ![스크린샷 2023-06-21 오후 5 59 11](https://github.com/Groot-94/WWDC_Study/assets/99063327/7cf39aa4-5a01-43e1-8a1c-7123d87e67f8)
            
            - 사용자 검색 String 기반으로 스무디를 필터링하기 위하여, String을 저장할 `@State` 프로퍼티 생성
            
            ![스크린샷 2023-06-21 오후 6 03 09](https://github.com/Groot-94/WWDC_Study/assets/99063327/cdcefda2-e79d-4fc6-b7be-bc279941e8e9)
            
            - List와 유사하게, FilteredList라는 재사용가능한 새로운 View를 생성
            - FilteredList는 스무디를 필터링하기 위하여 2개의 argument를 받을 수 있도록 초기화 방법 선언
                - filteredBy
                    - 필터링하려는 스무디의 프로퍼티에 대한 keyPath
                - isIncluded
                    - 해당 프로퍼티를 기반으로 list에 스무디를 포함해야하는지 여부 판단
                    - 스무디는 title로 필터링 되어, searchPhrase가 subString인 경우 포함시킴
            - **FilteredList 이니셜라이저에 대한 호출은 타입 추론에 크게 의존**

- **Solving the type inference puzzle**
    - **해결방안: 이니셜라이저의 파라미터 목록에 타입 파라미터를 사용**
        - **타입 추론에 의존하는 원인**
            
            ![스크린샷 2023-06-21 오후 6 08 34](https://github.com/Groot-94/WWDC_Study/assets/99063327/dae19632-7176-449b-b29d-e4e22746963d)
            
            - call-site에서 생략된 세부사항들을 파악하기 위해 FilteredList 선언부와 이니셜라이저를 살펴보아야함
            - 제네릭을 사용하여, call-site에서 실제 타입으로 대체될 placeholder인 3개의 타입 파라미터 소개
                - Element
                    - Data array의 element 타입에 대한 placeholder
                - FilterKey
                    - 데이터를 필터링할 Element의 특정 프로퍼티 타입에 대한 placeholder
                - RowContent
                    - List의 각 row에 표시될 View 타입에 대한 placeholder
            - 위 3개의 타입 파라미터의 실제 타입은 call-site에서 지정되거나 컴파일러에 의해 유추
        - **call-site의 더 나은 코드를 위한 타입 추론 활용 방법**
            
            ![스크린샷 2023-06-21 오후 6 16 42](https://github.com/Groot-94/WWDC_Study/assets/99063327/c5448ab0-0c92-41dc-aa12-073ded5d3e3d)
            
            - 3개의 타입 파라미터가 있으므로 이니셜라이저의 파라미터 목록에 사용 가능
                - 이니셜라이저의 파라미터 목록에 타입 파라미터를 사용함은 컴파일러를 통해 호출 사이트에서 타입 추론을 활용할 수 있는 기회
            - FilteredList는 초기화되면(initalize), 타입 파라미터가 구체적인 타입으로 대체
            
            ![스크린샷 2023-06-21 오후 6 19 01](https://github.com/Groot-94/WWDC_Study/assets/99063327/0068952b-d8b4-4830-8f30-6db72c5ecf8b)
            
            - call-site에서 작성된 explicit type annotaion은 없지만, 여전히 FilteredList의 각 타입 파라미터에 대해 구체적인 타입을 추론하는데 필요한 모든 정보를 컴파일러에 제공
                - 컴파일러가 타입을 추론하는 방법
                    - 모든 arguement 타입이 코드에 명시적으로(explicit) 지정된 경우 다음과 같음
                    
                    ![스크린샷 2023-06-21 오후 6 21 10](https://github.com/Groot-94/WWDC_Study/assets/99063327/d2ec2faf-d095-4d74-a9ae-7d9c0ddf6330)
                    
                    - 타입 추론을 사용하면 코드에서 위와 같이 모든 타입을 정확하게 알 필요가 없기에, source code를 더 빠르게 작성하는 데 도움이 됨

- **Understanding and resolving compiler errors**
    - **타입 추론 알고리즘은 퍼즐과 같음**
        - 퍼즐을 채워갈 수록 나머지 조각에 대한 더 많은 단서 발견 가능
            
            ![스크린샷 2023-06-21 오후 6 30 52](https://github.com/Groot-94/WWDC_Study/assets/99063327/eaefe6b9-c78d-4135-b37e-a30b864a82ff)
            
        - 컴파일러가 코드 전체에서 타입을 유추하는데 사용하는 전략은 다음과 같음
            - 문제상황
                
                ![스크린샷 2023-06-21 오후 6 25 43](https://github.com/Groot-94/WWDC_Study/assets/99063327/c926fb68-a3e8-454b-b100-428ef03eed0a)
                
            - 해결과정
                
                ![스크린샷 2023-06-21 오후 6 26 38](https://github.com/Groot-94/WWDC_Study/assets/99063327/cefbfd68-f17b-4d64-97e0-6ef213563543)
                
                ![스크린샷 2023-06-21 오후 6 27 19](https://github.com/Groot-94/WWDC_Study/assets/99063327/a7da26c2-b14f-44a5-97ac-ee18bccf1f5c)
                
                ![스크린샷 2023-06-21 오후 6 27 41](https://github.com/Groot-94/WWDC_Study/assets/99063327/97142d48-4a99-4f03-9dd1-758720c6eb3c)
                
                ![스크린샷 2023-06-21 오후 6 27 56](https://github.com/Groot-94/WWDC_Study/assets/99063327/3f7f3847-e81e-4401-8722-a675e3888ecd)
                
        - 사용자가 작성한 코드는 컴파일러가 사용할 단서를 제공
        - 알고리즘의 각 단계는 후속 단계에서 사용할 더 많은 정보 발견
        - source code의 단서 중 잘못된 하나로 인해 placeholder를 적절하지 않은 타입으로 채울 수 있는 위험 존재
            
            ![스크린샷 2023-06-21 오후 6 32 51](https://github.com/Groot-94/WWDC_Study/assets/99063327/6475fac9-6451-4826-997c-4f5b0672e6d0)
            
    - **컴파일러가 source code error가 있는 경우 타입 추론 전략을 수정하는 방법**
        - **Error 발생 및 포착**
            
            ![스크린샷 2023-06-21 오후 6 37 05](https://github.com/Groot-94/WWDC_Study/assets/99063327/bdedad4d-e4d9-42e9-8648-9ae776790868)
            
            - KeyPath Literal에서 Smoothie.title이 아닌 Smoothie.isPopular라는 잘못된 프로퍼티를 사용하는 error 발생
            - 컴파일러는 잘못된 프로퍼티 타입(Bool)으로 추론 시도
            
            ![스크린샷 2023-06-21 오후 6 39 03](https://github.com/Groot-94/WWDC_Study/assets/99063327/f8619687-25cb-477e-9c06-104e3ff7176c)
            
            - 그런 다음 잘못된 타입으로 동일하게 다른 FilterKey Placeholder를 채워나감
            
            ![스크린샷 2023-06-21 오후 6 39 46](https://github.com/Groot-94/WWDC_Study/assets/99063327/525b1563-8bdd-4dc5-b671-b16d26ecba05)
            
            - Bool에는 hasSubstring 메서드가 존재하지 않기에 오류 발생
            - 컴파일러는 이에 대하여 에러 보고
            - Swift 컴파일러는 Error Message에서 사용할 타입 추론 알고리즘에 error tracking을 포함하여(Integrated Error Tracking) 해당 실수를 포착하도록 설계됨
                - **Integrated Error Tracking**
                    - 컴파일러는 타입 추론 중 source code에 발생한 모든 오류 정보 기록
                    - 그런 다음 타입 추론을 계속하기 위해 휴리스틱을 사용하여 오류 수정
                        - 휴리스틱
                            - 불충분한 시간이나 정보로 인하여 합리적인 판단을 할 수 없거나, 체계적이면서 합리적인 판단이 굳이 필요하지 않은 상황에서 사람들이 빠르게 사용할 수 있게 보다 용이하게 구성된 간편추론의 방법
                    - 타입 추론이 완료되면 컴파일러는 수집된 모든 error 보고
                        - source code 오류를 자동으로 수정하기 위한 실행 가능한 수정 사항
                        - 컴파일러가 유추한 오류를 유발할 수 있는 구체적인 타입(concrete type)에 대한 메모
        - **해당 error를 수정하는 방법**
            - Build 실패시 프로젝트 전체 모든 오류 볼 수 있도록 설정
                
                <img width="819" alt="스크린샷 2023-06-21 오후 6 53 47" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/ec5b1a4d-5424-4098-b89f-d19417e5239e">
                
                - Xcode 상단 메뉴바 > Behaviors > Build > Fails > Show navigator Issues
                - build 단계에서 자동으로 issue navigator를 표시하기 위한 동작 추가
            - 예시) 예상 파라미터 타입에 맞지 않는 concrete type 사용
                - VStack List 위에 TextField 추가
                    
                    ![스크린샷 2023-06-21 오후 6 57 08](https://github.com/Groot-94/WWDC_Study/assets/99063327/96e141cc-55e9-47c4-b216-7d4ab501edc9)
                    
                    ![스크린샷 2023-06-21 오후 6 57 56](https://github.com/Groot-94/WWDC_Study/assets/99063327/4f6516f3-9595-4384-a76c-297cf4cceb3c)
                    
                - 유저가 사용한 String 타입은 Binding되는 TextField의 이니셜라이저의 예상 파라미터 타입에 맞지 않음
                - 에러 메시지에서 제공하는 $ 기호를 사용하여 Binding에 호환되는 타입으로 변경하면 에러 해결 가능
            - 예시) concrete type의 필수 프로토콜 미준수
                - 기존의 List를 FilteredList로 변경
                
                ![스크린샷 2023-06-21 오후 7 04 11](https://github.com/Groot-94/WWDC_Study/assets/99063327/f4c75400-6d89-42a3-a322-fa162c6d5244)
                
                ![스크린샷 2023-06-21 오후 7 05 23](https://github.com/Groot-94/WWDC_Study/assets/99063327/12bc32c3-e861-4edf-9295-1d5bec332edb)
                
                - FilteredList에서 Smoothie가 Identifiable 프로토콜을 준수하지 않고 있는 에러 보고
                
                ![스크린샷 2023-06-21 오후 7 05 51](https://github.com/Groot-94/WWDC_Study/assets/99063327/1b58f35f-7690-4ace-a629-47996fd61b3a)
                
                - Issue Navigator에 error에 대한 Compiler note 확인
                - 새로운 integrated error tracking을 통해, error 발생시 타입 추론 중 발생한 상황에 대한 정보를 기록하므로 컴파일러는 Compiler note를 통해 코드의 다른 부분을 보도록 안내하는 이동 경로 남기기 가능
                - Compiler notes는 source editor에 표시되는 error와 프로젝트의 다른 파일에 있는 필수 정보 사이의 접점을 파악하는데 도움
                
                ![스크린샷 2023-06-21 오후 7 09 31](https://github.com/Groot-94/WWDC_Study/assets/99063327/0d82879d-a803-48f4-8bd0-da8cc8c14019)
                
                - Compiler note를 확인해보니, 컴파일러가 Element의 구체적인 타입(concrete type)을 Smoothie로 유추했음을 보고받음
                - `where Element: Identifiable` 코드에 의하여 Smoothie 또한 Identifiable 프로토콜을 준수해야 하나 사용자 실수로 적합성 추가하지 않은 상황
                - 적합성 추가 완료
                    
                    ```swift
                    struct Smoothie: Codable, Identifiable {
                    	typealias ID = String
                    
                    	var id: ID
                    	...
                    }
                    ```
                    

## 💎 요약

> **SwiftUI 환경에서 재사용 가능한 view로 구성된 인터페이스의 코드는 타입 추론에 크게 의존한다. 또한, 소스 코드의 단서를 활용하여 타입 추론에 누락된 세부 정보를 파악하고 채우는 방법을 배울 수 있었다. 컴파일러의 Error Tracking 기능을 타입 추론 알고리즘에 통합하여 더 많은 정보를 기록하고 사용자 실수를 이해하고 수정하는데 도움이 되는 에러 메시지의 이동 경로를 제공하는 방법을 학습했다. 이를 통해 사용자 코드에서 발생한 오타나 실수에 대해 컴파일러가 실행 가능하고 유익한 에러 메시지를 제공하며, 컴파일러의 integrated error tracking 기능을 통해 실패에 대한 더 많은 정보를 수집하고 해당 정보를 note를 통해 제공하는 방법을 이해하였다.**
> 

## 💎 참고 자료

- **Embrace Swift Type Inference - Apple Developer**

[Embrace Swift type inference - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10165/)

- ****Swift) 타입 추론(Type Inference) vs 타입 어노테이션(Type Annotation) - 개발자 소들이 tistory****

[Swift) 타입 추론(Type Inference) vs 타입 어노테이션(Type Annotation)](https://babbab2.tistory.com/14)

- ****파이썬 타입 어노테이션 - Wikidocs****

[07-4 파이썬 타입 어노테이션](https://wikidocs.net/194289#_1)

- **휴리스틱 이론 - Wikipedia**

[휴리스틱 이론](https://ko.wikipedia.org/wiki/휴리스틱_이론)
