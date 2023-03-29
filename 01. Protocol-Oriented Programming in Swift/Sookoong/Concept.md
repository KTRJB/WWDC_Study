# [WWDC15] Protocol-Oriented Programming in Swift

## 💎 배경

- **Class의 장점**

    <img src = "https://user-images.githubusercontent.com/99063327/228453598-5720ff29-6a07-4d73-bd40-73f300a313fa.png" width="50%" height="50%">
    
    - 캡슐화
        - 상태와 행동 저장 및 은닉화 용이
    - 접근 제어
        - 코드 외부 및 내부 구분을 통한 접근 제어
        - 불변성 유지
    - 추상화
        - 공통점을 하나로 표현 용이
    - 네임스페이스
        - 소프트웨어가 커짐에 따라 충돌 방지 도움
        - 네임스페이스는 **연관된 값들을 한 공간에 이름을 지어 모아둔 공간**
        - 쉽게 예를 들면, 우리가 **'서랍'**에 물건을 보관할 때, 그 안에 뭐가 들었는지 **'라벨링'**하는 것과 비슷
        - 유사한 물건들을 모아둠으로써, **관리(유지보수)**가 쉬워지고 **재사용**도 편리
        - 네임스페이스를 통해서만 문자열에 접근할 수 있게 만드는 **캡슐화(Encapsulation)** 방법
        - 코딩을 할 때도 이런 **네임스페이스**를 잘 만들어두면, 하드코딩도 방지하고 코드 **가독성**도 좋아짐
        - (출처: [https://bicycleforthemind.tistory.com/26](https://bicycleforthemind.tistory.com/26))
    - 이해하기 쉬운 구문
        - 메서드 호출, 프로퍼티를 작성 및 연결 가능
        - subscript 작성 가능
        - 연산 프로퍼티 작성 가능
    - 확장성
        - 단일, 수직 확장 가능
        

> **그러나 이 모든 것은 Types, 특히 Struct, Enum 에서도 가능한 반면, Class는 아래의 문제점 존재**
> 

- **Class의 문제점**
    - **Implicit Sharing**
        
        <img src = "https://user-images.githubusercontent.com/99063327/228454468-de21020b-1048-4e46-992f-7fe64ef5254f.png" width="50%" height="50%">
        
        - 다중 스레드 환경에서 사용할 때 잘못된 참조로 인해 원본 데이터 변경 위험
            - 자식 클래스가 부모 클래스에 대한 의존성을 가지는 경우, 부모 클래스의 변경이 자식 클래스에 영향을 미칠 수 있음
            - 이는 부모 클래스의 변경으로 인해 자식 클래스의 동작이 예기치 않게 변경될 수 있으며, 이로 인해 디버깅이 어려워지고 코드의 예측성 저하 우려
        - 이로 인한 문제점음 다음과 같음
            - Too many copies → slow down
            - Thread = share in mutable state → 불안정 in race conditions → 이에 따른 Lock → slow down → Deadlock → Complexity → Bug
        - 반면, Value Type은 공유 X → 문제 미발생
    - **Inheritance All Up In Your Business**
        
        <img src = "https://user-images.githubusercontent.com/99063327/228454774-78963900-9606-4f9b-93f8-5fea1f25ffb0.png" width="50%" height="50%">
        
        - Monolithic(단일체의, 한 덩어리로 뭉친) - 단일 상속의 한계
            - 오직 하나의 superclass밖에 가지지 못함
            - extension으로 원하는 inheritance를 가지기 어려움
            - stored properties가 있을경우 무조건적으로 수용 → Initialization burden
            - 무엇을, 어떻게 override 해야할지 인지 필요
    - **Lost Type Relationships**
        - 예시
            
            <img src = "https://user-images.githubusercontent.com/99063327/228454933-237b71b3-f5fe-4aae-b976-c09757ce943e.png" width="50%" height="50%">
            
            - precedes(other:) 메서드 내 Body 필요
            
            <img src = "https://user-images.githubusercontent.com/99063327/228455032-bfc957bd-3f08-40c8-b6b5-b1160f81165c.png" width="50%" height="50%">
            
            - 해당 방법으로 밖에 해결 불가 → 이미 문제가 있음을 의미
            
            <img src = "https://user-images.githubusercontent.com/99063327/228455104-e5ea16bc-4c87-4704-bb72-c2260ee25060.png" width="50%" height="50%">
            
            - Ordered 클래스를 상속하는 Number 클래스 생성 및 구현
            
            <img src = "https://user-images.githubusercontent.com/99063327/228455209-28160e53-1883-4184-b582-2065b4ea00c2.png" width="50%" height="50%">
            
            - 오버라이딩하는 메서드의 파라미터인 other은 값 프로퍼티를 갖는지 알 수 없음
            
            <img src = "https://user-images.githubusercontent.com/99063327/228455409-6add2010-f13f-4b56-9121-3cc18dcab5cf.png" width="50%" height="50%">
            
            - 심지어 Double이 아닌 String 값을 가지는 객체일 가능성도 존재하여 위의 에러가 발생
            
            <img src = "https://user-images.githubusercontent.com/99063327/228455547-fb94aee0-e555-4952-b1ab-a9e188db18c3.png" width="50%" height="50%">
            
            - 다운 캐스팅을 통해서야 실제 값 접근
            - 그러나, 다운 캐스트 구조(as! ASubclass)는 사실 타입들간 관계에서 유실 발생 의미
        - 클래스는 자신의 타입과 다른 타입간의 중요한 관계를 표현 불가
        - 보통 클래스로 추상화를 표현할 때 문제 직면
        - Swift에서는 추상 클래스 지원 X → Protocol 해당 역할 수행
        
    

> **이를 해결하기 위한 좋은 추상화 메커니즘의 조건**
> 

- **A Better Abstraction Mechanism**
    
    <img src = "https://user-images.githubusercontent.com/99063327/228455665-f5cb605e-0c2a-4593-8fb1-479310964d17.png" width="50%" height="50%">
    
    - 클래스 뿐만이 아닌 값 타입 지원
    - 동적 디스패치뿐만이 아닌 정적 타입 관계 지원
    - Non-Monolithic
    - Retroactive modeling
        - 원본을 수정하지 않고 재사용하여 새로운 컨셉을 표현
    - 인스턴스 데이터를 모델에 부과 X
    - Initialization burden을 모델에 부과 X
        - Initialization burden은 위의 클래스에서 저장 프로퍼티 관련해서 나온 표현
    - 무엇을 구현할지 명확하게 제작
    

## 💎 해결 방안

- **Protocol Oriented Programming(POP)**
    - Swift는 OOP에 적합하지만, for 루프 및 문자열 리터럴이 작동하는 방식에서 제네릭에 대한 표준 라이브러리의 강조점에 이르기까지 Swift는 POP
    - OOP → POP 변환 예시
        
        <img src = "https://user-images.githubusercontent.com/99063327/228455759-856079f0-e7c1-4148-a6f5-5fa9c6630756.png" width="50%" height="50%">
        
        - 기존의 class로 구현된 Ordered를 protocol로 변경
        
        <img src = "https://user-images.githubusercontent.com/99063327/228455844-5f8af55e-f788-4c75-a525-1cadd2a132d6.png" width="50%" height="50%">
        
        - protocol은 구현부가 불필요하므로 삭제
        
        <img src = "https://user-images.githubusercontent.com/99063327/228455925-b9f27054-2200-452e-8142-a32471818d57.png" width="50%" height="50%">
        
        - 타입 변경으로 인하여 override 불필요하므로
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456070-e4ed8c07-03d7-409c-ad91-1056bfc04c59.png" width="50%" height="50%">
        
        - Number가 숫자처럼 행동하길 원하기 때문에, 타입을 struct로 변경하고, override 제거
        - fatalError는 제거했으나 other은 임의의 Ordered로 여전히 강제 다운캐스트 필요
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456223-450c5063-5ed6-48c3-bbf3-1b8f5d251fc1.png" width="50%" height="50%">
        
        - 이에 other 타입을 Number로 변경
        - 그러나, signature가 matching되지 않아 에러 발생
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456403-fa577221-17dd-45ec-bd42-e3763d69917a.png" width="50%" height="50%">
        
        - 문제 해결을 위해 protocol signature에서 Ordered를 Self로 변경
        - 이를, Self-Requirement라 칭함
        - 프로토콜을 준수할 모델 유형에 대한 placeholder 역할
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456504-c274f69c-1aff-4a08-9e95-a8dc65b10491.png" width="50%" height="50%">
        
        - 프로토콜을 작성하였으니, 이를 활용하는 것으로 넘어가보니, [Ordered]인 heterogeneous array 존재
        - 즉, 이 배열에는 숫자, 레이블 등이 혼재 가능
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456596-4b5dda8e-b09d-4c9f-b244-6f7fb10336a9.png" width="50%" height="50%">
        
        - Self-Requirement를 사용했으니 컴파일러는 이를  강제로 동질적(homogeneous)으로 만들려고함
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456691-be7da11f-867f-4917-b17b-2e5bbd3cece7.png" width="50%" height="50%">
        
        - 그에 따른 변경
        
        <img src = "https://user-images.githubusercontent.com/99063327/228456791-9dc914c3-35cd-4847-93f9-3123245c98b1.png" width="50%" height="50%">
        
        - 타입으로 사용 가능 vs 제네릭을 통해서만 사용가능
        - Heterogeneous vs Homogenous
            - Self Requirement를 통해 기능이 class보다 훨씬 덜 겹치게 됨
            - 즉, 컬렉션이 heterogeneous 하지 않고 homogeneous해짐
        - 인스턴스간 상호작용이 모든 모델 타입과 상호작용 가능 의미 vs 불가능 의미
        - Dynamic Dispatch vs Static Dispatch
            - Self Requirement를 통해 동적 다형성을 정적 다형성으로 교환
        - 덜 최적화 vs 더 최적화
            - Self Requirement은 컴파일러에서 제공하는 추가적인 type 정보를 통해 최적화
    - 장점
        - Dynamic Runtime Check → Static Check
            - 메서드가 모두 구현되어 런타임이 아닌 컴파일 타임에 명세된 메서드를 정적 체크 가능
        - 필요한 부분만 프로토콜로 분리해서 제작 가능
        - 다중 프로토콜 구현 가능
        - 확장성 유연
            - 상속은 class에서만 가능했지만, 프로토콜 채택은 class뿐만 아니라 struct, enum도 적용 가능
        - Self-Requirement 사용시, heterogeneous 함수를 homogeneous로 변환 가능
            - heterogeneous array
                - 배열 안의 객체들이 모두 다른 타입이지만, 공통으로 준수하는 프로토콜로 구성된 배열을 의미
            - homogeneous array
                - heterogeneous array의 역으로, 배열 내부 타입이 모두 같음을 의미
        - 비용 감소
        - 수평적 기능 확장 및 기능 모듈화 명확화

 - **Class 사용 시기**
    - 암시적 공유를 원하는 경우 → 참조 유형이 필요할 때
    - 인스턴스 수명이 파일과 같은 외부 부작용과 관련된 경우
    - 추상화 인스턴스가 "sink"인 경우 (ex. CGContext)
    - (출처: [https://github.com/Groot-94/WWDC_Study/blob/main/01. Protocol-Oriented Programming in Swift/Judy/Concept.md](https://github.com/Groot-94/WWDC_Study/blob/main/01.%20Protocol-Oriented%20Programming%20in%20Swift/Judy/Concept.md))       

## 💎 요약

> 객체 지향 프로그래밍과 프로토콜 지향 프로그래밍의 차이점과 이점에 대해 설명하고, Swift 언어의 프로토콜 기능을 살펴보았습니다.
> 

> 강의에서는 객체 지향 프로그래밍에서 상속을 사용하여 코드를 재사용하는 방법과 그에 따른 문제점을 다룹니다. 상속은 코드 재사용을 돕지만, 다중 상속을 지원하지 않고 상속 계층이 복잡해지면 유지보수가 어려워집니다. 또한, 자식 클래스가 부모 클래스에 대한 의존성을 가지는 경우, 부모 클래스의 변경이 자식 클래스에 영향을 미칠 수 있습니다.
> 

> 이러한 문제점을 해결하기 위한 대안으로 프로토콜 지향 프로그래밍을 제안합니다. 프로토콜은 인터페이스와 유사한 역할을 하며, 클래스나 구조체 등 다양한 타입에서 채택될 수 있습니다. 프로토콜을 채택하는 타입들은 프로토콜이 제공하는 기능을 모두 구현해야 하며, 이를 통해 코드의 일관성과 유연성을 높일 수 있습니다.
> 

> 또한 프로토콜 확장(Protocol Extension)의 개념과 활용 방법을 다루었습니다. 프로토콜 확장은 채택한 타입에 대해 기존 프로토콜에 새로운 기능을 추가할 수 있습니다. 이를 통해 코드 중복을 줄이고, 타입에 대한 확장성을 높일 수 있습니다.
> 

> 마지막으로, Swift의 기능 중 하나인 제네릭(Generic)에 대해 설명합니다. 제네릭은 타입에 대한 추상화를 제공하며, 타입 안정성과 재사용성을 높일 수 있습니다. Swift에서는 제네릭 함수, 제네릭 타입, 제네릭 프로토콜 등 다양한 방법으로 제네릭을 활용할 수 있습니다.
> 

## 💎 참고 자료

- Protocol-Oriented Programming in Swift - Apple Developer

[Protocol-Oriented Programming in Swift - WWDC15 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2015/408/)

- Protocol Oriented Programming in Swift - dudu velog

[[WWDC] - Protocol Oriented Programming in Swift](https://velog.io/@aurora_97/WWDC-Protocol-Oriented-Programming-in-Swift)

- Protocol Oriented Programming(POP) - JayB tistory

[[WWDC 15] - Protocol Oriented Programming(POP) {2편 - OOP를 POP로 변경해보기}](https://jayb-log.tistory.com/261)

- Protocol-Oriented Programming in Swift - Havi velog
