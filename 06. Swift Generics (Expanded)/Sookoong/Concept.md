# [WWDC18] Swift Generics (Expanded)

## 💎 배경

> **Generics은 타입에 독립적인 코드를 작성하는 프로그래밍 기법으로, 코드의 재사용성과 유연성을 높이는데 사용된다. Swift에서는 Generics을 사용하여 일반화된 알고리즘을 작성하거나 컬렉션 타입에 대한 유연한 작업을 수행할 수 있다. 아래의 예시와 함께, 함수와 타입에서 Generics을 사용하는 방법과 Generics 타입에 대한 제약 조건을 설정하는 방법을 알아보도록 한다.**
> 

## 💎 해결방안

- **Generics이란?**
    - **배경**
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/1a842c0f-d33f-4fd5-848f-c526fd8c6a86" width="50%" height="50%">
        
        - Generics이 없다면 return type으로 넣고자 하는 모든 경우의 수를 처리해야 함
        - Any 타입을 통해 다른 종류의 타입을 대신할 수 있음
        - 하지만 이는 사용 편의성, 정확성, 성능의 측면에서 문제 발생
            - 사용편의성 및 정확성
                
                <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/7cc397b6-d6d1-408f-8e07-ebeeced7c7f1" width="50%" height="50%">
                
                - 해당 값을 사용할 때, 다운 캐스팅 등 성가신 작업을 수반하며 오류 발생 가능성 존재
            - 성능
                
                <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/8d301677-cb56-41d8-8889-281d9aba24f4" width="50%" height="50%">
                
                <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/2547f967-6820-43c1-be5c-c2312d48deb3" width="50%" height="50%">
                
                - 타입이 지정되지 않는 접근 방식은 미리 어떤 타입이 포함되지 알지 못해, Any로 Wrapping이 될 것임
                - 이는 타입을 추적, 박싱, 언박싱하는데 많은 overhead 초래
                    - 유연성을 원치 않음에도 비용 지불
                    - Large Type의 경우 자체 내부 저장소에 들어가지 못하여, 간접 참조(indirection) 필요
                    - Indirection으로 인하여 값에 대한 포인터 또한 필요시
    - **기대효과**
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/a90b7376-2bbb-454d-94a0-0ff7517572f7" width="50%" height="50%">
        
        - 이를 해결하고자 **Parametric Polymorphism(=Generics)** 사용
        - 해당 타입이 포함할 타입을 나타내기 위해 `< >` 안에 더 많은 정보(element) 입력
            - Element는 타입의 generic parameter 의미
            - 이때문에 Parametric Polymorphism이라 명명
            - 즉, Element는 해당 타입이 포함할 내용을 알려주는 **컴파일 타임 인수(compile-time argument)**
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/0c88b76a-467e-45a6-85e0-cafc6b39190b" width="50%" height="50%">
        
        - 컴파일러가 컨텍스트에서 element 타입이 무엇인지 추론 가능할 경우 element 생략 가능
        - 이에 대한 정보는 컴파일 타임, 런타임 타임 모두에 적용
        - 컴파일러는 버퍼에 정확히 어떤 element 타입이 포함되는지 알기 때문에 최적화(Optimization) 또한 가능
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/29e7d4d5-0558-431b-8a78-18069f59053f" width="50%" height="50%">
        
        - Generics를 사용하면 오버헤드 없이 인접한 메모리 블록에 모든 요소 유지 가능
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/953695dd-541d-4f73-b462-1a773a6eec55" width="50%" height="50%">
        
        <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/6a73ba96-6b1e-4555-9b9b-86b7ef3a5615" width="50%" height="50%">
        
        - 공통적으로 사용하는 메서드를 작성하는 가운데, 특정 조건에서만 사용하고 싶다면 extension을 할때 특정 타입으로 제한을 하면 됨

- **Designing a Protocol**
    - **목표**
        - **공통 기능을 모두 포괄하는 Protocol을 생성해보자**
        - **Collection Protocol의 축소 버전을 만들어보자**
    - **방법**
        - **각각의 구체적인 타입들의 공통점을 추출하기**
            
            <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/932de250-6ea7-44e6-afe9-b07c19795cfb" width="50%" height="50%">
            
        - `**associatedtype` 사용하기**
            
            <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/8376c570-54d4-4aa4-afbf-f213f7988741" width="50%" height="50%">
            
            - 각각 conform하는 타입들은 element를 적절히 설정해야 함
            - `associatedtype` 은 protocol에서 사용될 임의의 타입 이름
            - 간단히 생각하면 protocol을 위한 Generics으로 이해
        - **Subscript 기능 구현**
            
            <img width="391" alt="스크린샷 2023-05-17 오후 8 16 29" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/6b659191-a50f-48a4-95b8-71af64ef8c37">
            
            - 해당 collection의 크기를 나타내는 count 프로퍼티와 Int 값에 따른 요소를 반환하는 subscript를 구현
            - Array 타입에서는 정상 작동하겠으나 Dictionary의 경우는 구조가 더욱 복잡하여 적용 불가
            <img width="457" alt="스크린샷 2023-05-17 오후 8 18 12" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/b9eac05c-397d-4a99-bf87-5766d71c2fed">
            
            - Dictionary 타입도 해당 Protocol을 준수할 수 있도록, Index를 이용해 subscript를 구현
            - 이를 위해, index를 추론할 수 있는 메서드와 startIndex, endIndex 프로퍼티 생성
            
            <img width="407" alt="스크린샷 2023-05-17 오후 8 19 49" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/59f3ac83-1436-40ca-ba06-ede3be529efb">
            
            - Collection 프로토콜로 돌아와 Index를 나타내는 associatedtype 정의
            - 이를 통해, Array나 Data 타입은 Index 타입으로 Int를 제공하고, Dictionary는 자체 내부 로직을 처리하기 위한 custom implementation 제공
        - **Count 기능 구현**
            
            <img width="603" alt="스크린샷 2023-05-17 오후 8 25 09" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8858396a-ab25-4d08-bb57-4cdd03ad90e9">
            
            - count 값은 endIndex에 도달하기 까지 숫자를 1씩 더해서 카운팅하는 방식
            - 기존의 Int로 구현되었던 것이 Index 타입으로 변경되면서 컴파일 에러 발생
            
            <img width="560" alt="스크린샷 2023-05-17 오후 8 26 44" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/4d29d1a1-8172-4eb3-b825-bba69caef9d7">
            
            - Index가 Equatable할 때만 준수하도록 extension에 제약을 설정하면 해결 가능
            - 그러나, 모든 extension에 제약을 설정하는 것은 번거로움
            - 거의 항상 두 개의 인덱스는 비교 가능해야하는 상황
            
            <img width="492" alt="스크린샷 2023-05-17 오후 8 29 53" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/0107e5cb-a566-4e8e-8279-534540540344">
            
            - Protocol에 제약을 설정하면 해당 프로토콜을 준수하는 모든 타입에 적용함으로써 extension에 일일이 제약 설정하지 않아도 됨

- **Customization Points**
    - **Count 기능 최적화**
        - 위의 Count는 전체 Collection을 살펴보면서 요소의 수를 계산하는 방법이었음
        
        <img width="473" alt="스크린샷 2023-05-17 오후 8 36 16" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/4c27f252-6300-439e-8323-10aa3eddd519">
        
        - Dictionary는 자체적으로 보유하고 있는 요소의 수를 내부적으로 유지한다 가정
        - 이 정보가 있으면 자체 count 구현에 제공하면 효율적
        - 즉, 특정 유형에 overload를 추가함으로써 성능 개선 기대 가능
        
        <img width="500" alt="스크린샷 2023-05-17 오후 8 38 27" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d17dc9bb-de8f-4242-90d5-967dfc4e72c4">
        
        - map 메서드의 generic context는 위와 같음
        - 새로운 Array를 만들고 collection 내부를 순차적으로 이동하며 각 요소를 변환하고, 이를 배열에 추가하는 방식
        - 요소를 추가할수록 메모리 할당은 새롭게 다시 이루어져야 하는데, 이는 비싼 비용
        
        <img width="630" alt="스크린샷 2023-05-17 오후 8 44 37" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/e602f461-80df-455f-b2e3-480b25a83ed1">
        
        - 이를 최적화하는 방법으로 mapping을 끝마친 최종 배열의 크기는 원래의 컬렉션의 크기와 동일함을 이용
        - 요소를 추가하기 전에 Array를 위한 정확한 양의 공간을 예약함으로써 속도를 빠르게 할 수 있음
        - 여기서의 self.count의 count는 일전에 만든 더 나은 버전의 count가 아닌 Array, Dictionary 등에 이미 존재하는 count를 사용한 것임
        
        <img width="411" alt="스크린샷 2023-05-17 오후 8 49 24" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/5e614e7c-7896-47f4-9d70-8175409c2c6f">
        
        - 이와 같은, 사용자 지정 메서드 혹은 프로퍼티를 generic context에서 호출하기 위해서는 프로토콜 자체의 요구사항으로 선언해야 함
        - 프로토콜에 요구 사항을 추가하고, 이와 함께 extension을 통해 default implementation을 추가하는 것을 customization point라고 함
        
        <img width="608" alt="스크린샷 2023-05-17 오후 8 49 57" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/3cb8b8b2-0a48-4123-b25b-578047f767ea">
        
        - customization point를 통해 컴파일러는 사용할 수 있는 메서드 혹은 프로퍼티의 더 나은 구현이 잠재적으로 있음을 알 수 있음
        - 따라서, Generic Context에서는 프로토콜을 통해 해당 구현으로 **동적 디스패치(Dynamic Dispatch)**
        
    

> **정리하면, extension을 통한 default implementation과 함께 Customization Point을 추가하면 Generics의 장점도 챙기면서, Class, implementation inheritance, method overwriting를 통해 얻을 수 있는 동일한 이점을 챙길 수 있음! 이는 Class 뿐만 아니라, Struct, Enum에서도 작동

  그렇다고 모두 이와 같이 최적화는 불가능하고, 또한 customization point는 binary 크기, 컴파일러의 런타임 성능에 작긴 하지만 0은 아닌 영향을 미치므로, 확실한 경우에만 customization point를 추가하는 것이 합리적**
> 

- **Protocol Inheritance**
    - **배경**
        
        <img width="538" alt="스크린샷 2023-05-17 오후 9 30 40" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/065bfcd8-3dc0-4b47-923a-519711242c0a">
        
        - 때로는 type 무리를 분리하기 위해 단일 프로토콜로는 부족한 경우도 존재
            - lastIndex(where:)의 경우 컬렉션에서 마지막 요소의 인덱스를 찾기 가장 좋은 방법은 끝에서부터 시작해서 뒤로 걷는 것인데, Collection Protocol은 적용 불가
            - shuffle()을 하려면 Collection이 mutable해야하는데, 일반적인 Collection Protocol은 그렇지 않음
        - 즉, 추가적인 generic 알고리즘을 설명하기 위해 **프로토콜 상속**이 필요
    - **예시 1: BidirectionalCollection**
        
        <img width="639" alt="스크린샷 2023-05-17 오후 9 34 17" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/39f4f4cd-23b3-4655-995c-f43b34cc6038">
        
        - Collection Protocl에 명시된 기능뿐만 아니라, 컬렉션에서 뒤로 이동할 수 있는 추가 요구 사항을 명시
        - SinglyLinkedList와 같이, Collection이지만 BidirectionalCollection 프로토콜을 준수하지 못하는 경우 존재
        
        <img width="616" alt="스크린샷 2023-05-17 오후 9 38 43" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/949a3c33-e325-4635-9df3-f55687f851e8">
        
        - 즉, protocol inheritance를 한 이후에는, 프로토콜을 준수하는 타입을 제한하지만 새로운 알고리즘을 구현하도록 허용
    - **예시 2: Shuffle**
        
        <img width="603" alt="스크린샷 2023-05-17 오후 9 39 59" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d55db922-8ffd-4557-bcba-9dd00988f0ad">
        
        <img width="581" alt="스크린샷 2023-05-17 오후 9 40 46" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/5578ad2e-5274-4c51-84b8-cd222712601c">
        
        - Fisher-Yates Shuffle 알고리즘을 통해 컬렉션의 처음부터 끝에 이르기까지 요소를 무작위로 선정하여 바꾸는 방식
        
        <img width="607" alt="스크린샷 2023-05-17 오후 9 42 59" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/0331013e-192c-4e92-8ffc-028b42b055b2">
        
        - random 기능을 통해 현재 컬렉션에 있는 위치와 컬렉션 끝 사이에 임의의 숫자를 가져옴
        - 이는 Int값이므로, offsetBy를 이용해 인덱스 값을 추출
        - 다음으로, swaptAt()을 사용하여 교환
        
        <img width="590" alt="스크린샷 2023-05-17 오후 9 45 11" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/ff568f8d-89df-4b51-a545-42e298fbbb78">
        
        - 위의 가능을 모두 명시한 후, 이를 ShuffleCollection으로 명명하는 것은 좋은 방법이 아님
        - 즉, 요구 사항을 찾은 다음 단지 그 하나의 알고리즘을 설명하기 위한 프로토콜로 패키지화하는 방법은 좋지 못한 방법임
            - 좀 극단적인 예시를 들면
                
                > “이 프로토콜은 과일을 자르고, 과일을 믹서에 넣으며, 쥬스로 만들고, 손님에게 파는 알고리즘을 담았습니다!”
                “프로토콜로 만들었으니 다른 비슷한 경우에 쓰세요!!”
                > 
            - 과연 이것이 재사용 되기 편한 프로토콜일까….? No!
        
        <img width="579" alt="스크린샷 2023-05-17 오후 9 46 46" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/be63afad-a64c-4fed-8aa9-6978de01c83e">
        
        - 다시, shuffle()로 돌아가 중요한 점을 캐치해보자
        - shuffle()은 random access와 element mutation을 사용하고 있음
        - 이는 두 개의 기능이므로, **각각 별도의 프로토콜로 분리 가능(상속 계층 분할)**
            - RandomAccessCollection
                - 컬렉션 내 jump 가능 → 인덱스를 빠르게 이동
                - random access를 제공하는 unsafeBufferPoint와 같은 타입이 있음
                - 단, mutation은 허용 X → 별개의 영역임!
            - MutableCollection
                - mutation 기능 제공
                - 단, random access는 허용 X
                - 예시) 단반향 연결 리스트(Singly Linked List)
        
        <img width="474" alt="스크린샷 2023-05-17 오후 9 54 49" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/1f1266dc-e57d-4fc4-9a6a-8ae682562de3">
        
        - 상속 계층을 분할함으로써, 클라이언트 자체가 수행 중인 generic 알고리즘을 구현하기 위해 여러 프로토콜을 구성하여 기능을 통합
        
        <img width="608" alt="스크린샷 2023-05-17 오후 9 56 44" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/1e5ba376-3290-4d13-a54b-ec36e1e04db1">
        
        - 준수하는 타입이 많고 generic 알고리즘이 많으면 **프로토콜 계층 구조(Protocol Hierachy)**가 형상되는 경향이 있음
        - 이러한 계층 구조는 너무 커도, 너무 세분화되어서도 안됨
        - 계층 `하단 → 상단` = 요구사항이 더 적은 프로토콜로 이동
        - 계층 `상단 → 하단` = 고급 기능이 필요한 보다 복잡하고 전문화된 알고리즘 구현

- **Conditional Conformance**
    - **예시 1: Slice**
        
        <img width="564" alt="스크린샷 2023-05-17 오후 10 06 29" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d4f4fd94-988d-444d-8a59-041481146fd7">
        
        - 모든 컬렉션은 특정 인덱스 범위를 첨자(..<)를 통해 subscripting하여 컬렉션 조각(slice)를 생성할 수 있음
        - 해당 slice는 컬렉션의 일부에 해당하며, Slice 타입으로 지정
        - Slice는 generic adaptor 타입임
        - 따라서, base collection 타입에서 매개변수화(parameterized)되며, 그 자체로 collection임
        
        <img width="594" alt="스크린샷 2023-05-17 오후 10 06 42" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/f996a889-cd96-4472-bc3f-2d809fdaee43">
        
        - 이를 통해, Slice 또한 Collection에 기대하는 모든 작업을 수행할 수 있기를 기대
        - 실제로 Collection 프로토콜에 명시된 기능인 index(where:)는 잘 수행하나, BidirectionalCollection의 기능인 lastIndex(where:)은 에러 발생
        - 이는 그 slice가 BidirectionalCollection임을 모르기 때문
        
        <img width="578" alt="스크린샷 2023-05-17 오후 10 08 00" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/5a39fc88-470c-4862-97de-a6a60913b7d1">
        
        - BidirectionalCollection을 준수하도록 Slice의 extension 생성
        - base collection 측면에서 구현할 수 있는 작업 전에 이 index를 구현해야 함
        - 이때 컴파일 에러가 발생하는데, base collection에 대해 우리가 유일하게 아는 것은 그것이 collection이라는 사실뿐, 실행하기 전에는 index를 가지지 않음
        
        <img width="605" alt="스크린샷 2023-05-17 오후 10 11 38" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/a89d497d-2617-4c29-8fc6-06757f18f172">
        
        - 이를 해결하기 위해 extension에 base가 bidirectionalCollection이어야 한다는 요구사항을 추가
        - 이것이 **조건부 적합성(conditional conformance)**임
        - 프로토콜에 대한 적합성(conformance)를 선언하는 extension
        - 효과
            - 조건부 적합성을 통해 프로토콜 계층이 있을때 잘 쌓일 수 있음!
            - extension 기능을 작성하고 하나의 프로토콜을 따르게 하여, 해당 확장 기능의 목적과 의미 분명
            - composability 허용 → 기본 컬렉션이 수행하는 작업은 무엇이든 Slice 타입도 수행 가능
    - **예시 2: Ranges**
        
        <img width="388" alt="스크린샷 2023-05-17 오후 10 19 32" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/ae8262c4-2ba4-439e-880d-611375e15316">
        
        - `..<`를 통해 범위 형성 가능
        - Int Range는 Loop에 사용도 가능
        - 이는 Int Range가 Collection을 준수하기 때문
        
        <img width="628" alt="스크린샷 2023-05-17 오후 10 21 39" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/3b10cfb7-40fa-41f2-9156-a50dbe3c424a">
        
        - Swift 4.2 이전에는 다른 타입 integer range를 가져올 수 있었음
        - 이것이 바로 CountableRange 타입임
        - Range 타입과 구조적으로 동일
        - 차이점은 Bound 타입에 몇 가지 요구사항 추가 유무
            - Strideable 프로토콜을 통해 요소를 살펴보고 열거할 수 있음을 의미
            - 이것이 CountableRange가 RandomAccessCollection을 준수하도록 만드는데 필요한 기능
        
        <img width="626" alt="스크린샷 2023-05-17 오후 10 28 51" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/b54d8dbe-67e6-474b-920e-2f520cfd9d9a">
        
        - 조건부 적합성을 사용하면 더 잘 표현 가능
        - 위의 예시는 Random Access Collection만을 준수하고 있는데, 무조건적인 성능이면 괜찮음
            - Random Access Collection에 대한 적합성을 선언하는 것은 그것이 상속하는 모든 프로토콜[ex) BidirectionalColection과 Collection]에 대한 적합성을 암시하기 때문
        - 그런데 계층 구조의 여러 레벨에서 서로 다른 제약이 필요로하기 때문에 에러가 발생
        
        <img width="623" alt="스크린샷 2023-05-17 오후 10 34 48" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/b3d911a9-cea2-41eb-aa30-838e245aebda">
        
        - 따라서, 위와 같이 명시적으로 작성
        - Range가 CountableRange가 수행하는 모든 작업을 하니, CountableRange는 버릴 수도 있음
        - 그러나, Swift Standard Library에서 CountableRange을 사용하는 경우가 많으므로, Generic TypeAlias로 유지 → 소스 호환성 측면
            - Generic TypeAlias는 Range를 셀 수 있게 만드는 데 필요한 모든 extra 요구 사항을 추가
            - 컬렉션으로 전환하는데 필요한 요구 사항이지만, 기본 range 타입의 대체 이름에 불과

- **Recursive Constraints**
    - **문제상황**
        - 재귀 제약 조건(Recursive Contstraints)은 프로토콜과 associated types 간의 관계를 설명
        
        <img width="613" alt="스크린샷 2023-05-17 오후 10 42 02" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/6ca6006e-e284-411a-a00f-315e9f0b8a8f">
        
        - Recursive Constraint는 동일한 프로토콜을 언급하는 프로토콜 내 제약에 불과
        - 연관값인 SubSequence는 그 자체로 Collection인데 왜 필요할까?
        - 연관값에 의존하는 generic 알고리즘을 살펴보자!
        
        <img width="550" alt="스크린샷 2023-05-17 오후 10 42 45" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/af9ea1c7-41b6-414b-85b0-2fa1a310732f">
        
        - 특정 숫자를 삽입하되, 이미 정렬된 배열 내 숫자들과 비교하여 오름차순을 유지하고자 함
        
        <img width="611" alt="스크린샷 2023-05-17 오후 10 46 57" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/b72490c1-b6ce-4f0e-9618-c182acde667d">
        
        - 이를 위한 분할-정복 이진 검색 알고리즘은 위와 같음
        
        <img width="591" alt="스크린샷 2023-05-17 오후 10 46 40" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/faa93a88-9b94-4c65-868b-e34424295f73">
        
        - Collection의 적절한 Slice를 추출하여 재귀적으로 작업을 수행
        - Slice Adapter는 위에서 설명한 바와 같이 모든 컬렉션에서 작동
        
        <img width="599" alt="스크린샷 2023-05-17 오후 10 49 08" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/ccca1c98-b25b-4ca3-bdd4-a41c48bdfb8c">
        
        - 문제는 일부 Collection에서 특정 Slice 타입을 원하지 않을 수 있음
            - 일례로, String은 Substring을 Slice로 반환
            - Range 타입의 Slicing 작업은 새로운 bounds와 정확히 동일한 range 타입의 인스턴스를 반환
        - 따라서, Collection을 준수하는 다양한 타입 간의 variation을 캡처하기 위해서는 Collection 프로토콜에 새로운 요구 사항을 도입
        
        <img width="626" alt="스크린샷 2023-05-17 오후 10 52 26" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/973efc5a-9b1d-4074-9c3d-79df150d3f2e">
        
        - 요구 사항으로 slicing subscript를 Collection 프로토콜 자체로 가져옴
        - subscript 결과 타입이 새로운 associatedType인 SubSequence로 설명됨
        - String과 Range 모두 새로운 Collection 요구 사항을 충족
        
        ![스크린샷 2023-05-17 오후 10 55 39](https://github.com/Groot-94/WWDC_Study/assets/99063327/74d8ab01-bc4e-455a-b350-30a7919614c6)
        
        - String의 경우 SubSequence 타입이 SubString임
        
        <img width="543" alt="스크린샷 2023-05-17 오후 10 56 17" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/86c530be-e12d-4cf1-8278-0cea6a6f6880">
        
        - Range의 경우 SubSequence 타입이 Range 자체임
        
        <img width="607" alt="스크린샷 2023-05-17 오후 10 59 16" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/fe3775a0-01c7-456d-a63e-6fedf4f38421">
        
        - 실제 SubSequence 유형을 커스터마이징 하지 않으려는 다른 Collection 타입의 경우에는 Slicing 기본 제한 사항 설정 가능
        - associatedType은 default value 가질 수 있음
        
        <img width="498" alt="스크린샷 2023-05-17 오후 10 59 50" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8c4aa3c8-2be8-43ab-9e60-7501b2b590e1">
        
        - 뿐만 아니라, Default Subsequence 타입을 선택한 경우, Default slicing subscript 구현 적용을 제한할 수도 있음
        - 이 패턴은, default implementation이 SubSequence를 위의 String과 Range 예시처럼 커스터마이징한 Collection 타입에 대한 오버로드로 표시되는 것을 방지
        
        <img width="607" alt="스크린샷 2023-05-17 오후 11 08 01" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/04629db4-9550-41e8-ae09-600a45e69d43">
        
        - 다시 알고리즘으로 돌아와서, Subscript를 통해 Self.Subsequence를 반환
            - SubSequence 타입인 Slice를 형성할 것임
        - 그런 다음, 해당 Slice에서 sortedInsetionPoint를 재귀적으로 호출
        - 이 로직은 SubSequence 타입이 Collection 그 자체(Self.Element 부분)일 때 의미가 있음
        - 메서드가 호출되면 Collection의 element 타입의 값이 전달됨
        
        <img width="614" alt="스크린샷 2023-05-17 오후 11 09 37" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/901f0673-f0ae-4dd6-a0b7-32bb1c0f256f">
        
        - 그런데, 재귀 호출 자체는 SubSequence의 element 타입의 값을 기대
        - 이것이 정상 작동하려면 해당 Element 타입이 동일해야함
        
        <img width="604" alt="스크린샷 2023-05-17 오후 11 09 58" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/5f6ec618-dfbf-4f0e-95d2-393855a8510a">
        
        - 이제 재귀 호출에서 인덱스를 반환할 때 동일한 문제가 발생
        - SubSequence 관점으로 계산되기 때문
        - 그런데 반환되는 해당 인덱스는 현재 컬렉션에 대하여 유효한 인덱스여야 함
        - 다행히, Collection 프로토콜 자체에서는 이러한 모든 요구 사항을 캡처 가능
    - **해결방법: Recursive Constraints**
        
        <img width="623" alt="스크린샷 2023-05-17 오후 11 13 22" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/49b30c5e-7da3-4495-8fdb-7611b522a197">
        
        - 그러므로, 가장 먼저 할 일은 Collection의 SubSequence 자체가 Collection 임을 명시
        - 이를 **Recursive Constraint(재귀 제약 조건)**이라 함
        
        <img width="621" alt="스크린샷 2023-05-17 오후 11 15 52" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/a4e3f0ef-05c3-48ee-aff5-418df371d77c">
        
        - 다음으로, where 절을 사용하여 SubSequence를 추가로 제한 설정
        - 각각 Element 타입을 가지고 있으므로, 두 Element 타입이 동일해야 함을 보장
        
        <img width="571" alt="스크린샷 2023-05-17 오후 11 16 56" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/462016d6-f133-4f42-9bdb-b5a0ac3f5b1f">
        
        - 같은 맥락으로 Index에도 똑같이 적용 가능
        
        <img width="623" alt="스크린샷 2023-05-17 오후 11 18 18" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/1085cd68-15c7-4af5-a056-c64bcfb6a967">
        
        - SubSequence는 Slicing 할 수 있을까?
        
        <img width="639" alt="스크린샷 2023-05-17 오후 11 19 02" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/01287d6a-9a7a-4efe-bde4-a19b9e4a3e6f">
        
        - 물론 가능!
        - 각 지점에서 완전힌 새로운 타입을 가짐
        - 재귀가 결국 런타임에 종료되는 한 문제는 없지만 효율적으로 개선할 수 있음
        
        <img width="613" alt="스크린샷 2023-05-17 오후 11 20 05" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/13a43198-34b2-45a3-8c30-4b70d4bddd0c">
        
        - 분할 정복 알고리즘을 비재귀적으로 만들면 더 효율적인 경우가 많음
        - 위의 예시는 기존의 재귀 방식을 while Loop를 통해 비재귀적으로 변경
        - 코드를 살펴보면, 먼저 전체 Collection의 Slice를 가져옴
        - 그런 다음, Slice 중간 요소에 대해 삽입할 값과 비교
        - 결과에 따라, 다음 Loop로 가기 전에 slice의 값을 재정의하여 검색 범위를 좁힘
        - 문제는 서로 다른 타입임에서 발생
        - 반드시 두 유형이 동일함을 보장하지 않기 때문에 컴파일 에러 발생
        
        <img width="531" alt="스크린샷 2023-05-17 오후 11 25 04" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/675b6601-560e-49cd-97e5-2656edcba510">
        
        - 그런데, 반드시 저렇게 Slice<Slice<Slice…>>>로 타야할까?
        - Slice 타입은 기본 Collection(Self)과 동일한 인덱스 사용
        - 그리고 기본 Collection(Self)도 알고 있음
        
        <img width="551" alt="스크린샷 2023-05-17 오후 11 26 44" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/3c3da46a-c1e9-4c08-a50b-0ed7688ad047">
        
        - 따라서 Slice를 Slice 할 때 알게된 새로운 인덱스를 기본 Collection으로 다시 가져와, 기본 컬렉션에서 새로운 Slice를 만들면 됨
        - SubString 작동방식이 위와 같음
        
        <img width="610" alt="스크린샷 2023-05-17 오후 11 28 41" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/93d03e7b-2e6f-4df4-b048-3d6811027c6b">
        
        - Collection의 프로토콜 요구사항으로 명시하여 모델링
            - SubSequence와 SubSequence.SubSequence가 동일한 유형임을 명시
            - 따라서, Slice를 Slice를 하면 아까의 Self.SubSequence.SubSequence….과 달리 Self.SubSequence 타입임
        
        <img width="578" alt="스크린샷 2023-05-17 오후 11 30 33" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/4d50728f-eee1-4e72-b609-0aef0f2d6b3e">
        
        <img width="558" alt="스크린샷 2023-05-17 오후 11 31 35" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/9acb03c9-464a-4c14-869a-52997c32b782">
        
        - 마지막 문제로 index offset 작업을 하기 위해서는 SubSequence 타입이 Random Access Collection 이어야 함
        
        <img width="592" alt="스크린샷 2023-05-17 오후 11 31 57" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/530d4719-7a62-4946-b2eb-21f99f97a27e">
        
        - 이를 설명하기 위해, protocol에 where 절 사용
            - BidirectionalCollection이 Collection에서 상속될 때, SubSequence에 새로운 제약 조건을 추가하여 해당 BidirectionalCollection Protocol을 준수하도록 요구
            - RandomAccessCollection 또한 마찬가지
            - 이는 다시 Recursive Constraint이지만, 이제는 BidirectionalCollection, RandomAccessCollection 프로토콜에서 표현됨
        
        <img width="627" alt="스크린샷 2023-05-17 오후 11 34 54" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/83059144-2636-4741-9940-af6b586e0be9">
        
        - Recursive Contraints 또한 Conditional Conformance와 같이 프로토콜 계층 구조를 추적하는 경향이 있음
        - 그리고 기능을 서로 지원함

- **Generics and Classes**
    - **문제상황**
        - 클래스의 상속은 리스코프 치환 법칙에 따라 부모 클래스의 행동 규약을 자식 클래스가 위반 X
        - 프로토콜 적합성 또한 하위 클래스에 효과적으로 상속됨
        - 그러나, 실제 subclass에 새로운 요구 사항을 추가하는 경우, 일반적으로 initializer requirements의 경우에는 문제가 발생할 수 있음
        
        <img width="562" alt="스크린샷 2023-05-17 오후 11 56 23" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/78d56529-b625-43e2-9565-fd890fb1cd37">
        
        - Decoder에서 conforming 타입의 새로운 인스턴스를 생성하기 위한 Initializer Requirement(초기화 요구사항)
        
        <img width="445" alt="스크린샷 2023-05-17 오후 11 57 33" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/043f9a0b-f491-4515-81f3-8ba2148d4376">
        
        - Decoding 가능한 프로토콜에 convenience method 추가
        - 이는 기본적으로 Initializer의 Wrapper인 Decoder에서 새로운 인스턴스를 생성하여 사용하기 쉽게 만드는 static method임
        - 주목할 점은 다음의 두가지 사항임
            - 대문자 S로 Self를 반환함
                - 이것은 conforming 타입이므로 static method를 호출하는 것과 동일한 유형임
            - 이것을 어떻게 구현하고 있는가
                - Decodable한 타입의 완전히 새로운 인스턴스를 생성하고 반환하기 위해 initializer를 호출
        
        <img width="621" alt="스크린샷 2023-05-18 오전 12 02 15" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/0ce9355c-3373-4aae-b4c7-dc3186cd03ee">
        
        - 리스코프 치환 법칙을 적용할 때, Vehicle의 모든 subclass를 사용할 수 있다고 기대
        - 즉, Taxi에서도 decode(from:)을 호출할 수 있음
        - 여기서 반환되는 것은 임의의 Vehicle 인스턴스가 아닌 Taxi 인스턴스인 Taxi임
        - 어떻게 이렇게 작동하는지 다시 살펴보자!
        
        <img width="602" alt="스크린샷 2023-05-18 오전 12 04 18" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/19a27f35-c3b9-4890-878a-0c0e11b2101d">
        
        - Taxi 클래스는 hourlyRate을 가지고 있으며, Taxi.decode를 호출할 때 Protocol을 거쳐, 프로토콜 초기화 요구사항(protocol initializer requirement)를 거치게 됨
        - 실제로 호출할 수 있는 initializer는 하나뿐임
        - 이는 superclass에서 Vehicle 클래스 내부에 선언된 initializer임
        
        <img width="614" alt="스크린샷 2023-05-18 오전 12 08 37" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/1f4f6d22-04de-4d77-aa8c-a41f9b2b305e">
        
        - initializer는 Vehicle의 모든 상태를 decode하는 법을 알고 있음
        - 그러나 Taxi subclass에 대해서는 모름
        - 따라서, 이 initializer를 직접 사용하면 실제로 hourlyRate가 완전히 초기화되지 않는 문제 발생
    - **해결방안: Requried Init, Final Class**
        
        <img width="622" alt="스크린샷 2023-05-18 오전 12 08 51" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/f675b859-60c0-47f8-b451-22424af3683e">
        
        - 물론, 이런 문제에 빠지기 전에 컴파일 에러로 경고를 날림
        - Vehicle이 Decodable 프로토콜을 준수하도록 하는 시점에서 실제로 이 initializer에 문제가 있다고 진단
        
        <img width="565" alt="스크린샷 2023-05-18 오전 12 10 05" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/2f39fb38-3101-4b43-b0e0-cfecc5d9f1a7">
        
        - 따라서 이는 required로 표시해야함
        - 필수 이니셜라이저(required initalizer)는 모든 subclass에서 구현되어야 함
        - 단지 지금의 subclass뿐만 아니라, subclass의 subclass, 현재 알지 못하는 미래의 subclass 또한 마찬가지!
        
        <img width="596" alt="스크린샷 2023-05-18 오전 12 11 45" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/60401e4c-e31d-4463-9c24-c98ab019e874">
        
        - 이를 통해 Taxi 또한 required init 구현
        
        <img width="611" alt="스크린샷 2023-05-18 오전 12 12 20" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/87cd89ff-4618-41e1-af5d-d3e3f55679f9">
        
        - final class는 subclass가 없을것이므로 예외
        - 따라서, class를 사용할 때, reference semantics를 위해 더 이상 상속 메커니즘을 통해 클래스를 커스터마이징할 필요가 없으면 final 키워드 사용 권장
            - 그렇다고 나중에 클래스를 커스터마이징 못한다는 의미는 X
            - extension은 여전히 작성 가능
            - 같은 방법으로 struct, enum 확장 가능
            - 더 많은 dynamic dispatch를 위해 적합성 추가도 가능
            - 그럼에도 final 키워드는 generic 시스템과의 상호작용을 단순화하고, 런타임 시 컴파일러에 대한 최적화 기회도 가질 수 있음

## 💎 요약
<img width="605" alt="스크린샷 2023-05-18 오전 12 16 24" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/4caa1895-cf60-41ef-b14b-d40172727257">

> **Swift Generics은 기본적으로 static type 정보를 유지하면서 코드 재사용 기능 제공**
> 

> **올바른 프로그램을 더 쉽게 작성하고, 효율적으로 실행되는 프로그램으로 컴파일하기 위해 프로토콜을 설계할 때, 프로토콜에 작성하려는 Generic 알고리즘간 push-pull을 허용

- conforming 타입의 하위 집합에서만 지원되는 새로운 generic 알고리즘을 구현하기 위해 좀 더 특수화된 기능이 필요한 경우, protocol inheritance 도입
- 특히, 프로토콜 계층 구조로 작업할 때 잘 구성될 수 있도록 generic 타입을 작성할 때 conditional conformance 유지**
> 

> **마지막으로, 클래스 상속과 generic 시스템 간 까다로운 상호 작용에 대하여 추론할 때, 리스코프 치환 원칙으로 돌아가 conformance를 작성한 superclass가 아닌 subclass를 도입하면 어떤 일이 발생할지 생각해보기**
> 

## 💎 참고 자료

- **Swift Generics (Expanded) - Apple Developer**

[Swift Generics (Expanded) - WWDC18 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2018/406/)

- **AssociatedType - WoongiOS Tistory**

[associatedType](https://woongsios.tistory.com/97)
