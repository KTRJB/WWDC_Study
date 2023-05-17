# WWDC
## Swift Generics (Expanded) - 2018
### What are generics?
#### Why Generics?
- 새로운 타입 Buffer를 만드는 예시를 기반으로 설명.

![](https://hackmd.io/_uploads/S1p9xLfr3.png)

![](https://hackmd.io/_uploads/ryz6xUMH2.png)

- 위의 예제에서 Buffer에 들어오는 데이터 타입은 범용적이여야 한다.

- 그러기 위해 타입을 Any로 설정하면 실제 사용 시 데이터 타입에 대한 캐스팅을 필요로 하기 때문에 타입 추정에 많은 오버헤드가 있다.
- 이러한 편의성과 성능의 이유로 Generics을 사용한다.

#### Parametric Polymorphism

![](https://hackmd.io/_uploads/HktJbLzr3.png)

- Generics을 사용하여 매개변수에 다형성을 줄 수 있다

- Element는 특정 타입이 정해지고 난 후다른 타입을 사용할 수 없다.
- 컴파일 단계에서 이 부분을 확인하게 된다.
- 컴파일러가 버퍼에 정확히 어떤 타입이 들어있는지 항상 알고 있기 때문에 최적화가 된다.

![](https://hackmd.io/_uploads/rkKEbLMB3.png)

- 만약 여기서 모든 원소의 합을 구하는 함수를 만든다고 할 때 문제가 생긴다.
- 모든 요소가 숫자처럼 더해지는 형식이 아니기 때문에 컴파일러는 오류를 뱉는다.

- 아래와 같이 Generics의 유형을 제한하는 방법으로 수정하면 사용이 가능함.

![](https://hackmd.io/_uploads/B14HbLzHn.png)

- 가능하면 필요한 모든 타입을 제공하는 가장 일반적인 프로토콜 타입을 따르는 방법이 좋다.

![](https://hackmd.io/_uploads/rkIPZUzSn.png)

### Protocol design
#### Designing a Protocol

![](https://hackmd.io/_uploads/H1LMMIMB2.png)

- 여러가지 컬렉션 타입에서 사용하기 위한 프로토콜을 만들기
- 몇 가지 공통점을 찾고 그걸 이용해서 설계하자(추상화를 말하는 듯)

- 유연하고 확장성을 가질 수 있도록 프로토콜을 설계하자.

![](https://hackmd.io/_uploads/rygtfIfB2.png)

>swift 4.2 부터 Element 타입이 적용되어 있기 때문에 이를 통해 T 유형에 대한 표시를 하지 않을 수 있다. 

#### Customization Points
- 프로토콜에서 요구하는 사항을 추가하고 이와 함께 익스텐션을 통해 기본 구현을 추가하는 것을 Customization Points 라고함
- 프로토콜 기본구현에 제네릭을 함께 사용해서 기존 타입을 커스텀 할 수 있다

- 상속과 오버라이딩과 같이 이점을 얻을 수 있다.
- 하지만 제네릭 사용 시 런타임 성능에 작은 영향을 줄 수 있다. 그러니 확실히 필요하면 사용해라.

![](https://hackmd.io/_uploads/HywT48Grn.png)

### Protocol inheritance
- 단일 프로토콜로 구현할 수 없을 때 사용하는 방법

![](https://hackmd.io/_uploads/B1F3vUfrn.png)

- lastIndex(where:)와 같은 메서드는 뒤부터 확인하는게 효율적이고, shuffle()은 교체해야 하는 작업이 필요하지만, 기존 컬렉션 프로토콜로는 충분하지 않다.

- 이렇게 추가적인 알고리즘을 구현하기 위해 더 많은 조건이 필요한데 이럴 때 사용할 수 있는게 프로토콜 상속임

![](https://hackmd.io/_uploads/Sk3hd8zBn.png)

- 컬렉션 프로토콜을 상속받은 BidirectionalCollection 프로토콜에서 기존 컬렉션 프로토콜에 있는 기능을 활용해 lastIndex 메서드를 구현하고 있다.

![](https://hackmd.io/_uploads/B1SpOUGH2.png)

- 이번엔 Shuffle을 통해 알아보기

![](https://hackmd.io/_uploads/HJoatLfBh.png)

- 이 프로토콜이 Shuffle을 한다고 해서 단지 ShuffleCollection 이라는 이름을 붙이면 좋지 않다.

- 여기엔 하나의 기능만 존재하는게 아니라 여러가지 기능들(랜덤으로 요소에 접근하는 기능, 요소를 교체하는 기능)을 조합하고 있다.

- 그 기능들을 프로토콜로 분리하고 상속하자

![](https://hackmd.io/_uploads/rJ4P58GHn.png)

![](https://hackmd.io/_uploads/SyuGoLMS2.png)

- 준수하는 타입이 많고 제네릭 알고리즘이 많으면 프로토콜은 계층을 형성한다.

![](https://hackmd.io/_uploads/r1SmsUzrn.png)

- 너무 크면 좋지 않다.
- 아래에서 위로 향하면 요구사항이 더 작아진다.
- 위에서 아래로 향하면 요구사항이 더 많아진다.
    - 더 복잡하고 전문화된 알고리즘을 구현하게 된다.
### Conditional conformance
![](https://hackmd.io/_uploads/BkSV3IMS3.png)

- 위에서 slice는 collection을 준수하기 때문에 우린 collection의 모든 기능을 사용할 수 있기를 원한다.
- 하지만 `slice.lastIndex(where: { $0.isEven })` 부분에서 문제가 생겼다. 

- 이 문제를 해결해보자
![](https://hackmd.io/_uploads/SkJW6LzH3.png)

- slice가 BidirectionalCollection를 준수하도록 확장했지만, base가 index 메서드를 갖지 못함.

- Conditional conformance을 사용하는 방법으로 수정
    - extension의 base가 BidirectionalCollection이어야 한다는 요구사항을 추가하는 방법

- 아래와 같이 여러 프로토콜 계층 구조에서 사용하면 좋다.

- 이런 extension에 대한 요구 사항이 다르기 때문에 Conditional conformance는 중요하다.

![](https://hackmd.io/_uploads/SkEn3UGHn.png)

- 이 Conditional conformance는 표준 라이브러리에서도 볼 수 있음.
- swift의 좋은 예시임.

![](https://hackmd.io/_uploads/BJ8408Grn.png)

- 만약 Range가 RandomAccessCollection을 준수하게 만들면 어떨까

- RandomAccessCollection가 준수하는 프로토콜 계층 모두를 준수해야 됨을 swift에서 알려준다.

![](https://hackmd.io/_uploads/S1iw1vzS2.png)

- 아래와 같이 설정해줘야 문제가 해결됨
 
![](https://hackmd.io/_uploads/Hk9T1vMrn.png)

#### Recursive Constraints

- Recursive Constraints는 프로토콜과 관련 유형 간의 관계를 설명함.

![](https://hackmd.io/_uploads/B1gSxvfBn.png)

- 위 그림에서 SubSequence은 그 자체로 Collection임 이런게 왜 필요할까?

![](https://hackmd.io/_uploads/SJdbWPzrh.png)

- 위의 코드에서 `sortedInsertionPoint`를 위한 방법으로 이진탐색을 활용해보자.

![](https://hackmd.io/_uploads/H1zmbDzB3.png)

- 위에 있는 이진탐색을 위해선 코드를 슬라이싱 해야한다.

![](https://hackmd.io/_uploads/HyP0-DGHn.png)

- 이처럼 슬라이싱을 할 수 있지만, 모든 타입에서 이 방법을 바라지 않는다. 

- 아래처럼 커스텀한 슬라이싱을 사용해야 하는 예시들이 있다.
    - 반환 타입이 다르다.

![](https://hackmd.io/_uploads/SkNbfwMH3.png)

- 이러한 커스텀한 슬라이싱을 지원하기 위해서 `associatedtype SubSequence: Collection` 을 작성한 것.

![](https://hackmd.io/_uploads/HkOczPfrh.png)

![](https://hackmd.io/_uploads/S1ysGPMB2.png)

- 이것으로 인해 슬라이싱 동작을 따로 구현하지 않고 사용할 수 있게 된다.

![](https://hackmd.io/_uploads/rJlwmwzHh.png)

- 기본 구현도 할 수 있음.
- 기본 구현을 활용하여 제한도 할 수 있다.
    - SubSequence를 커스텀한 컬렉션 유형이 기본 구현을 오버로딩 하는 것을 방지한다.

- Recursive Constraints 조건도 계층구조를 모두 지켜야 한다.

![](https://hackmd.io/_uploads/B1qSSvGrh.png)

### Classes and generics

#### Class Inheritance
- 클래스의 상속을 활용한 계층구조

![](https://hackmd.io/_uploads/SJvzhDzB3.png)

- Vehicle을 상속받은 Taxi는 Vehicle을 대체할 수 있어야함. drive() 를 실행가능해야 함.

![](https://hackmd.io/_uploads/HydE3PMrn.png)

- 리스코프의 치환 원칙
- S가 T의 하위 유형인 경우 유형 T의 모든 인스턴스는 S의 인스턴스로 대체될 수 있다.

#### Protocol Conformances and Classes
- 리스코프 원칙과 프로토콜 적합성

![](https://hackmd.io/_uploads/B1ozpwGBh.png)

![](https://hackmd.io/_uploads/rkXl6wGSn.png)

- Required initializers를 갖는 프로토콜을 채택한다면 하위 클래스도 모두 구현해야 한다.

![](https://hackmd.io/_uploads/rkZlNOzSh.png)

![](https://hackmd.io/_uploads/HJJz4dzrh.png)

- 하지만, 서브클래스를 가지지 않는 경우 Required initializers를 요구하지 않는다.

- 그러니 상속을 안하면 final을 붙이자 그러면 성능에도 좋다.

![](https://hackmd.io/_uploads/S1rQEuMHh.png)

### Summary
- **Swift의 generics은 정적 유형 정보를 유지하면서 코드 재사용을 제공한다.**
- **generic algorithms과 준수 유형 간의 push-pull 설계를 허용한다.**
    - Protocol inheritance은 일부 준수 유형의 특수 기능을 캡처
    - Conditional conformance은 이러한 기능에 대한 구성을 제공
- **클래스 사용 시 Liskov Substitution Principle을 적용한다**
