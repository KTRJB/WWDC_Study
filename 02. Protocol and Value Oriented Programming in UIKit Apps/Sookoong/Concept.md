# [WWDC16] Protocol and Value Oriented Programming in UIKit Apps

## 💎 배경

- **Local Reasoning**의 필요성
    - 독자가 코드가 어떻게 작동하는지 알아보는 수고를 들이지 않고, 독자가 바로 앞에서 코드(컨텍스트)를 이해할 수 있는 능력
    - 이번 강의에서는 UIKit 코드를 Local Reasoning을 통해 개선하는 과정을 다룸

## 💎 해결방안

- **Model**
    - Reference Semantics → Value Semantics
        
        <img src = "https://user-images.githubusercontent.com/99063327/229391599-87088d76-9db9-4f89-a495-79da7868b82b.png" width="50%" height="50%">
        
        - Reference Semantics로 인하여 변경 우려
        - 암시적 공유 때문
        
        <img src = "https://user-images.githubusercontent.com/99063327/229391704-addf9bdd-babc-4d1b-962b-9d66ed8db887.png" width="50%" height="50%">
        
        - 복잡한 관계는 덤…
        
        <img src = "https://user-images.githubusercontent.com/99063327/229391865-befc3534-03fe-42ce-8cc9-040feb1ad6e2.png" width="50%" height="50%">
        
        - struct로의 타입 변경을 통해 암시적 공유 문제 해결

> **value 타입을 모델뿐만 아니라 다양한 영역에 이르기까지 사용 가능**
> 

- **View**
    - 전개
        
        <img src = "https://user-images.githubusercontent.com/99063327/229391965-22600c63-bfd1-44a4-9fd0-f9b382d9be83.png" width="50%" height="50%">
        
        - 현재 UITableViewCell은 재사용 가능
        - but DreamDetailView는 재사용되지 않는 상태
        - 이는 같은 Layout을 사용하지 않았기 때문
        
        <img src = "https://user-images.githubusercontent.com/99063327/229392010-413e8cb4-c320-4c03-af6e-410ffa62e5a3.png" width="50%" height="50%">
        
        - Layout 재사용할 수 있도록 변경
        
        <img src = "https://user-images.githubusercontent.com/99063327/229392057-bdc087c8-ee58-4bd5-9c5d-d4e3c6580bbb.png" width="50%" height="50%">
        
        - 기존 Cell 구현부
        - 현재 Cell은 UIView들이 있을 수 있고, SKNode 있을 수 있음
        
        <img src = "https://user-images.githubusercontent.com/99063327/229392108-350cb3dd-3cc9-4b99-9b01-707d28410976.png" width="50%" height="50%">
        
        - DecoratingLayout이라는 struct 생성
        - 두 개의 UIView를 변수로 가짐
        - layout(in:) 메서드를 통해 해당 부분에서 알 수 있도록 설정
        
        <img src = "https://user-images.githubusercontent.com/99063327/229392163-05edd8f8-0e73-408e-9c3d-f018d85838bf.png" width="50%" height="50%">
        
        - DreamCell과 DreamDetailView에 DecoratingLayout 적용
        - layoutSubviews 내에 struct 인스턴스 생성 및 메서드 호출
        - 이를 통해, 다음의 효과를 발휘
            - layout 영역을 tableViewCell과 분리
            - 다른 곳에서도 사용 가능 → 확장성
            - Test 용이
                
                <img src = "https://user-images.githubusercontent.com/99063327/229392220-516020a3-f02e-4cd6-b2eb-3542ee165af8.png" width="50%" height="50%">
                
            
        
    - 중복 코드 문제
        - protocol 사용
            
            <img src = "https://user-images.githubusercontent.com/99063327/229392359-ed68e51b-7149-4cbf-9981-bb5e15d7aac5.png" width="50%" height="50%">
            
            - View Chapter에서 만든 해당 DecoratingLayout은
            
            <img src = "https://user-images.githubusercontent.com/99063327/229392435-3b1c2b74-1aa0-40a7-9030-1c052e09c736.png" width="50%" height="50%">
            
            - ViewDecoratingLayout으로 이름으로 변경
                - content, decoration을 UIView 타입으로 가지고 있기 때문
            - UIView뿐만 아니라 특수효과를 담당하는 SKNode를 처리할 수 있는 Layout 필요
                - content, decoration을 SKNode 타입으로 가짐
            - 프로퍼티의 타입만 다르지 중복되는 코드
            - 따라서, protocol을 통해 합치기
            
            <img src = "https://user-images.githubusercontent.com/99063327/229392488-2fed1ae1-72e3-45e2-9eb6-fb11093cce36.png" width="50%" height="50%">
            
            - Layout 프로토콜 생성
            - frame을 변수로 가짐
                - layout 설정해주기 위해서 필요
            - content, decoration의 타입을 Layout으로 변경
            - UIView, SKNode의 extension으로 Layout을 채택
            - 이를 통해, 중복 코드를 줄이고, 두 타입을 하나로 합침
    - 프로토콜 내 다른 타입 사용 문제
        - Generics 사용
            
            <img src = "https://user-images.githubusercontent.com/99063327/229392553-ed618563-ece8-4f5e-bcef-13682ec3ec58.png" width="50%" height="50%">
            
            - content, decoration은 UIView면 UIView로, SKNode면 SKNode로 같은 타입이 들어와야함
            - 그러나, 위에서는 다른 타입이 들어올 가능성 존재
            
            <img src = "https://user-images.githubusercontent.com/99063327/229392592-6a74de2c-3003-4ee9-9ba6-981f8494c119.png" width="50%" height="50%">
            
            - ****Generics****을 사용해 content, decoration의 타입을 하나로 정해줌
            - 다음의 효과 발생
                - 이전보다 타입 컨트롤 용이
                - compile 타임에 좀 더 최적화
                    - [참고](https://www.notion.so/WWDC15-Protocol-Oriented-Programming-in-Swift-54f2e2c286964bb58e9f01fdb40433f7)
            

- **Sharing Code**
    - 기존
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393209-86055c42-716d-4f7c-a337-d101274eca0a.png" width="50%" height="50%">
        
        - 동일한 레이아웃에 대하여 공유하기 위해 상속 사용
        - 그러나, 코드 복잡도 증가 및 비용 비쌈(heap allocation)
    - **Composition 활용**
        - 조각조각 분리하여 하나의 집합으로 만들어 사용
        - 효과
            - 합치더라도 조각 하나하나에 대한 이해 수월
            - 추상화 시, 상위 혹은 하위 클래스 생각할 필요 X
            - struct 활용을 통한 비용 절감
            - 캡슐화
        - 예시
            
            <img src = "https://user-images.githubusercontent.com/99063327/229393259-ef3d44dc-46aa-46d3-a664-93096001d1eb.png" width="50%" height="50%">
            
            <img src = "https://user-images.githubusercontent.com/99063327/229393302-878ef9ce-4e1d-4b3a-a4d0-9fa2ee907b94.png" width="50%" height="50%">
            
            - 두 개의 Layout 구조체  생성
            
            <img src = "https://user-images.githubusercontent.com/99063327/229393341-d3d570c3-22ee-432b-b75f-645a47b21386.png" width="50%" height="50%">
            
            - 위의 구조체 사용

- **Contents**
    
    <img src = "https://user-images.githubusercontent.com/99063327/229393396-501872db-3157-4bcc-a5bc-3b9be4a88cd3.png" width="50%" height="50%">
    
    - contents 통일 필요
    - **associatedtype** 사용
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393445-f455db8d-286d-4ada-8dc3-4942ad027b23.png" width="50%" height="50%">
        
        - Layout 프로토콜 내 associatedtype 선언
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393494-297b4b23-c928-41d6-8cc1-b355a331e456.png" width="50%" height="50%">
        
        - 각각의 DecoratingLayout에서 typealias를 통해 원하는 타입 사용
        - 제너릭을 활용해 두 개의 Layout을 하나의 Layout으로 해결 가능
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393538-9b3dbb22-8958-4933-926b-ed1beb81fd69.png" width="50%" height="50%">
        
        - View, NodeDecoratingLayout을 DecoratingLayout로 병합
        - typealias를 Child.Content로 변경
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393591-0de8b681-3cae-45f5-832e-ee18f18372a2.png" width="50%" height="50%">
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393620-55f499e2-6102-4390-856d-f61065154f4e.png" width="50%" height="50%">
        
        - CascadingLayout 존재
        - where 절을 통해 동일 타입으로 제한
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393650-0c1bc04d-955e-473d-8242-7985c6156d5a.png" width="50%" height="50%">
        
        - 최종본

- **중간요약**
    
    <img src = "https://user-images.githubusercontent.com/99063327/229393672-606db06d-ab76-45af-9bac-71f84dca1968.png" width="50%" height="50%">
    
    - value type을 통한 Local Reasoning
    - 제네릭을 활용한 빠르고 안전한 다형성 구현
    - value composition

- **Controller**
    
    <img src = "https://user-images.githubusercontent.com/99063327/229393711-d9aeeba5-83fe-4be6-81be-27c19ff54d02.png" width="50%" height="50%">
    
    - 복수의 model property를 Controller에서 그대로 사용중
    - 이에 따른 side effect 우려
    - **하나의 모델 타입을 사용하여 해결**
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393882-81d5234c-093e-41d8-99d7-f8fd290f9f47.png" width="50%" height="50%">
        
        - 복수의 모델 프로퍼티 → 하나의 code path로 통합
        - 방향성 면에서도 good
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393918-972d8182-860f-4a96-a23f-84786435a326.png" width="50%" height="50%">
        
        - MVVM의 ViewModel을 생각하면 편함
        - 장점
            - Single code path
                - Better local reasoning
            - Values compose well with other values

- 개선 결과
    - 기존 구조
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393750-929f44be-b972-46ec-a082-fee8af430ad2.png" width="50%" height="50%">
        
    - 개선 구조
        
        <img src = "https://user-images.githubusercontent.com/99063327/229393782-450eb710-7a44-4ca9-b34c-125bd839a732.png" width="50%" height="50%">
        

- **장점**
    - 비용 감소
        - heap allocation이 상당히 줄음
    - Local Reasoning 용이
        - Recap - Model
        - Focus - View and Controller
    - 테스팅 용이
    
- 단점
    - 자주 사용되는 Delegate, DataSource 등 프레임워크 프로토콜에 기본구현 불가

- **기억할 점**
    - Customization through composition
    - Protocols for generics, reusable code
    - Taking advantage of value semantics
    - Local reasoning
    

## 💎 요약

> 이 세션에서는 UIKit 애플리케이션에서 프로토콜과 Value-Orientied 프로그래밍을 사용하여 코드의 유지보수성과 재사용성을 높일 수 있는 방법에 대해 다룹니다.
> 

> 프로토콜을 통해 다형성을 구현할 수 있어, 유연하고 확장성 있는 코드를 작성할 수 있습니다. 그리고 Value-Orientied 프로그래밍은 구조체나 열거형과 같은 값 타입을 사용하는 코드작성 패러다임입니다.
> 

> 예제를 통해 이러한 프로토콜과 Value-Orientied 프로그래밍을 UIKit 애플리케이션에서 어떻게 사용할 수 있는지를 보여줍니다. 예를 들어, UIViewController를 상속하는 여러 클래스에서 공통으로 사용되는 코드가 있다면, 이를 프로토콜로 추상화하여 추후에 새로운 클래스를 추가하거나 기존 클래스를 수정할 때 코드의 재사용성과 유지보수성을 높일 수 있습니다. 또한 값 지향 프로그래밍을 사용하여 데이터 모델을 구성하면, 객체지향 프로그래밍에서 발생하는 클래스 계층 구조의 복잡성을 줄일 수 있습니다.
> 

> 마지막으로 영상에서는 프로토콜과 Value-Orientied 프로그래밍을 적용할 때 고려해야 할 사항들과 이를 적용하는 데 있어서의 장단점에 대해 논의합니다. 예를 들어, 프로토콜을 사용하면 코드의 유연성과 재사용성을 높일 수 있지만, 추상화 수준이 높아져 코드의 가독성이 떨어질 수 있다는 것이 있습니다. 값 지향 프로그래밍을 사용하면 클래스 계층 구조의 복잡성을 줄일 수 있지만, 객체지향 프로그래밍에서 제공하는 상속 등의 기능을 사용할 수 없습니다.
> 

## 💎 참고 자료

- Protocol and Value Oriented Programming in UIKit Apps - Apple Developer

[Protocol and Value Oriented Programming in UIKit Apps - WWDC16 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2016/419/)

- Protocol and Value Oriented Programming in UIKit Apps - Eddy velog

[Protocol and Value Oriented Programming in UIKit Apps](https://velog.io/@kkh3/Protocol-and-Value-Oriented-Programming-in-UIKit-Apps#sharing-code)

- [Protocol and Value Oriented Programming in UIKit Apps - gaonK github](https://github.com/mashup-ios/WWDC/blob/master/gaonK/WWDC16/Protocol%20and%20Value%20Oriented%20Programming%20in%20UIKit%20Apps.md)

- Protocol Oriented Programming in Swift - JoSeongGyu slideshare

[Protocol Oriented Programming in Swift](https://www.slideshare.net/JoSeongGyu/protocol-oriented-programming-in-swift)
