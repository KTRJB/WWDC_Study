# 🐣 Swift Generics



###  Swift 4.2

![](https://hackmd.io/_uploads/BJc43OMHh.png)

- Swift 4.2는 Swift의 API 안정성이라는 목표를 달성하는 데에 중요한 역할을 한다.

### 오늘 얘기할 주제

![](https://hackmd.io/_uploads/SJiXh_Grn.png)

### 제너릭이 Swift에서 중요한 이유?

![](https://hackmd.io/_uploads/BkxUp_Mrh.png)

제너릭이 없다면 모든 걸 포괄할 수 있는` Any`를 넣으면 됨
➡️ 그것은 사용자에게 불쾌한 경험을 선사함

이유 ex)
![](https://hackmd.io/_uploads/r1NjpuGr3.png)

> Any의 단점
- 해당 Any 타입이 뭔지 추적하고 언래핑하는 데에 엄청난 오버헤드가 발생한다.
- 너무 커서 자체 내부 저장소에 들어갈 수 없는 유형은 간접 참조를 사용해야 함 => 메모리 낭비

> Swift의 Generics (= Parametric Polymorphism)

![](https://hackmd.io/_uploads/ry4_JKfHn.png)


- 제너릭, 즉 Element는 버퍼에 포함할 내용을 알려주는 컴파일 타임 인수와 비슷하다.
- ![](https://hackmd.io/_uploads/HJOsktMS2.png)
    
- 컴파일 타임에 오른쪽 요소를 통해 타입을 추론할 수 있다.
- 오버헤드 없이 연속적인 메모리 블록에 모든 요소를 가지고 있을 수 있게 됨

➡️ 컴파일러는 Buffer에 정확히 어떤 element 타입이 있는지 항상 알고 있기 때문에 이것이 간응하다.


![](https://hackmd.io/_uploads/Hy6pgtzrh.png)

![](https://hackmd.io/_uploads/rkTjgKGr2.png)

- numbers의 요소들을 더하고 싶을 때 Buffer를 extension해서 메서드로 만드는 것이 효과적임
    - 단위 테스트하기 좋고, 가독성 좋아짐

그러나 위와같이 코드를 작성하면 모든 element type을 알 수 없기 때문에 컴파일 에러가 발생하기 때문에 아래와 같이 바꿔줘야 함

![](https://hackmd.io/_uploads/SkxFWYzSn.png)


![](https://hackmd.io/_uploads/rJ8gMKGSh.png)
=>숫자를 더할 수 있는 기능을 가진 **Numeric 프로토콜**을 사용하면 다른 float 등의 타입도 사용 가능해진다.

즉, 사물을 이런 식으로 생각하는 것이 중요하다.

- 몇 가지 구체적인 유형으로 시작 => 그 다음 그들의 공통점을 계속 생각하며 프로토콜로 통합하려고 시도하기

#### subscript 기능

![](https://hackmd.io/_uploads/Byj30uQrn.png)

- 해당 collection의 크기를 나타내는 count 변수와 Int를 인수로 사용한 subscript를 구현
- 배열 타입에서는 적합하나 딕셔너리의 경우에는 구조가 복잡하여 적용하기 힘들 것임.

![](https://hackmd.io/_uploads/SJcleFmSn.png)

- Dictionary 타입도 해당 Protocol을 준수하기 위해서 subscript를 구현해주어야 하는데, 이때 Index를 이용함


![](https://hackmd.io/_uploads/BJDpeYQBh.png)

- 이제 Index 타입으로 Int를 사용하지 않는다.

#### count 기능

![](https://hackmd.io/_uploads/SJi4-K7S3.png)

![](https://hackmd.io/_uploads/Hy29btmH2.png)
- 기존의 Int로 구현되었는데 그게 Index 타입으로 변경되면서 컴파일 에러 발생함

그래서 아래와 같이 바꿔주니 

![](https://hackmd.io/_uploads/ByDz6tMSn.png)

모든 Index가 계속 equtable해야해서 불편함

![](https://hackmd.io/_uploads/SJZETKzHn.png)

=> 그럴 땐 프로토콜의 요구사항으로 표현하는 것이 낫다. 위와 같이 associatedtype을 사용한다.

![](https://hackmd.io/_uploads/S19nx5fSn.png)

Swift 4.2에서는 이렇게 사용할 수도 있다.


결론:
- 제네릭 인자는 associatedtype으로 지정한다.
- 이후 구현하는 쪽에서 typealias로 이 인자를 제공한다.
- 즉, 필요한 프로토콜이 있다면, associatedType 단에서 이를 지정할 수 있다.

### Customization Points

![](https://hackmd.io/_uploads/SJkRGtXS3.png)

프로토콜에서 요구하는 사항을 추가하고 이와 함께 확장을 통해 기본 구현을 추가하는 것을 Customization Points 라고 함

![](https://hackmd.io/_uploads/HJVaTuQB3.png)

`Customization Points` 을 통해 컴파일러는 잠재적으로 사용할 수 있는 메서드 또는 속성의 더 나은 구현이 있음을 알 수 있음

모든 방법을 이와 같이 최적화할 수 있는 것은 아님. 그리고 Customization Points은 바이너리 크기, 컴파일러 런타임 성능에 작지만 영향을 미치므로 커스터마이즈할 기회가 확실히 있을 때만 커스터마이징 지점을 추가하는 것이 합리적임.

### Protocol Inheritance

- 기존 프로토콜의 기능을 다 가져가면서 다른 기능을 추가하고 싶을 때 사용한다.

![](https://hackmd.io/_uploads/SkEXNtQS2.png)

- Collection Protocoal is Not Enough
    - lastIndex(where:)는 컬렉션에서 마지막 요소의 인덱스를 찾으려는 경우에 사용하는데, 가장 좋은 방법은 끝에서 시작하여 뒤로 걷는 것이다. 하지만 컬렉션 프로토콜은 그렇게 할 수 없다.
    - shuffle()을 하려면 Collection이 mutable해야하는데, 일반적인 Collection Protocol은 그렇지 않음

즉, 추가적인 Generic 알고리즘을 설명하기 위해서는 더 많은 것이 필요하고, 이것이 **프로토콜 상속**의 중요 포인트이다.

> BidirectionCollection 예시

![](https://hackmd.io/_uploads/SJApNFXr2.png)

상속을 하고, 그 후에 lastIndex를 추가 구현해주면 끝

![](https://hackmd.io/_uploads/BJjgBYXSh.png)

> Shuffle 예시
- Swift 4.2에서 해당 기능 만들어놨음

![](https://hackmd.io/_uploads/ByB_rYQS3.png)

- 교체할 다른 요소를 무작위로 선택하여 컬렉션을 통과하는 선형 행진이다.

- ![](https://hackmd.io/_uploads/HyBQUY7H3.png)
- 그렇다고 이런식으로 이름에 Shuffle을 붙이진 마라. 많은 프로토콜이 생겨서 좋지 못하다!
- 프로토콜 이름은 최대한 일반적으로 지어야 한다.

#### 상속 계층구조 분할

![](https://hackmd.io/_uploads/r15XDtmS3.png)

- shuffle 내부의 기능을 위와 같이 각각 다른 프로토콜로 분리할 수 있음


![](https://hackmd.io/_uploads/Hy2hDKmH3.png)

- 준수하는 타입이 많고 generic 알고리즘이 많으면 프로토콜 계층 구조가 형성되는 경향이 있음
- 이제 이러한 계층 구조는 너무 커서도, 너무 세분화되어서도 안됨

#### Conditional Conformance
- 프로토콜 채택을 특정 조건을 만족하는 경우에만 하는 것

![](https://hackmd.io/_uploads/H16PAtmH3.png)

- 뒤에서부터 찾을 때 타입이 존재하지않는다는 문제가 발생한다.
- 이제 여기에서 where를 통해서 이 Collection의 타입을 제한적으로 넣어줌으로써 해결할 수 있다.

![](https://hackmd.io/_uploads/Hy1_9YQS2.png)

- 근데 slice가 BidirectionalCollection를 준수하도록 확장했지만, 작동 전까지 base가 실행하기 전에는 index를 가지지 않는다는 문제 발생

![](https://hackmd.io/_uploads/HkcT9tQS3.png)

- 이때 Conditional conformance을 사용하는 방법으로 수정


![](https://hackmd.io/_uploads/ry_QtFQS3.png)

extension의 base가 `BidirectionalCollection`이어야 한다는 요구사항을 추가하여 해결함


> 또 다른 예시

![](https://hackmd.io/_uploads/B1AakqQBh.png)

이걸 conditional conformance를 사용해 바꿔주면 아래와 같ㅇ ㅣ 바꿀 수 있다.

randomAccessCollection에 대한 적합성을 선언하는 것은 그것이 상속하는 모든 프로토콜에 대한 적합성을 의미한다.

![](https://hackmd.io/_uploads/Hk97yc7S3.png)
![](https://hackmd.io/_uploads/BJ2Hkq7B3.png)

이렇게 하면 될 것 같지만, 계층 구조의 여러 레벨에서 서로 다른 제약이 필요하기 때문에 에러가 난다.


![](https://hackmd.io/_uploads/SJHbZ5QS2.png)

이보다 좋은 것은 typealias를 사용해 바꿔주는 것이다.
Range가 CountableRange가 수행하는 모든 작업을 하기 때문데 CountableRange는 버릴 수도 있다.

#### Recursive Constraints

- 프로토콜의 associatedtype이 자기 자신을 채택하는 것
- 동일한 프로토콜을 언급하는 프로토콜 내의 제약에 지나지 않음

![](https://hackmd.io/_uploads/rkjJM9mH3.png)


.....더는 못하겠다....

