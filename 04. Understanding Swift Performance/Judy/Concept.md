## 배경
어떤 코드를 사용할지 성능을 고려했을 때 보다 관용적인 솔루션을 찾을 수 있음
=> **"성능"**에 초점을 맞추자


## 성능의 요점
> 1. **Allocation** - Stack vs Heap
> 2. **Reference Counting** - Less vs More
> 3. **Method Dispatch** - Static vs Dynamic

<br>

## 1. Allocation
Swift는 자동적으로 메모리를 할당/해제

#### Stack ✔️
- 단순한 구조(FILO)
- 스택 할당/해제가 간결하고 빠름

#### Heap 
- 동적 할당
- 할당 시 thread safe를 위한 lock 매커니즘을 통해 무결성을 보호해야 함 -> **큰 비용**
<br>

![](https://velog.velcdn.com/images/juyoung999/post/0cf21344-0c2f-4bf8-88f0-8036858d32b4/image.png)

> #### 구조체 선언<br>
-> Stack에 할당 = 실제 값을 저장<br>
\- 다른 인스턴스로 복사<br>
-> Stack에 복사한 값을 할당<br>
-> 원본을 변경해도 복사한 값엔 영향 없음<br>
-> 모두 사용하고 나면 스택 포인트를 다시 올려서 간단하게 해제

<br>

![](https://velog.velcdn.com/images/juyoung999/post/1060e9a6-a5b1-4851-9ce8-78ee5f4b042f/image.png)

> #### 클래스 선언<br>
-> Stack에 메모리 할당 = 힙에 할당한 참조 값을 저장<br>
\- 다른 인스턴스에 전달 시 참조를 복사<br>
-> 원본을 변경 시 그대로 변경된 값이 공유됨<br>
-> 모두 사용 시 Swift가 메모리를 할당 해제하며 블록 위치 조정<br>
-> Stack을 해제

<br>

### 결론
> ➡️ Class는 Heap 할당이 필요하기 때문에 Struct보다 비용이 많이 든다<br>
➡️ Class의 특성이 필요하지 않다면 Struct를 사용하는 것이 좋다 ❕

<br>

### Struct의 Heap
**String**은 구조체니까 Stack 영역만 사용?
**No** => String도 간접적으로 힙을 사용

ex) key로 **String**을 사용하는 경우 대신 새로운 Struct 타입을 정의해 사용
<br>

## 2. Reference Counting
> 🤔 Swift는 Heap에 할당한 메모리를 언제 해제할까?

=> Heap 인스턴스에 대한 참조 수를 세고 있음
- 참조 여부에 따라 참조 카운트가 증가/감소
- 0이 되면 아무도 해당 인스턴스를 가리키지 않음을 알고 해당 메모리를 Heap에서 할당 해제

❗️ 중요한 것은 이 작업이 매우 빈번하며 많은 비용이 필요
- 증가/감소와 관련된 간접 참조
- 카운트 조정 시 스레드 안전성 고려(원자적으로 변경해야 함)
<br>

### Struct의 RC
Struct는 참조 카운트를 가지지 않음
하지만 반드시 그런 것은 아님!

#### 1) Struct지만 Heap을 사용하는 경우
String은 내용을 Heap에 저장 = 참조 카운트 필요

#### 2) Struct 내부에 참조 타입을 갖는 경우
![](https://velog.velcdn.com/images/juyoung999/post/c124d4b9-8c55-463d-89c6-c0b0c2508035/image.png)

참조가 포함된 Struct라면 역시 참조 카운팅에 대한 오버헤드 발생
ex) Struct 내부에 둘 이상의 참조를 가진 경우 클래스보다 더 많은 오버헤드 유지

#### 적용 예시
- String으로 갖던 uuid --> UUID 타입을 사용
- String으로 구분하던 타입 --> Enum으로 case로 구분

이런 식으로 참조가 필요한 타입의 사용을 자제하기
<br>

## 3. Method Dispatch

### **정적 디스패치** 
- 컴파일 타임에 실행할 구현을 결정할 수 있는 경우
- 컴파일러가 구현부를 알고 있고 최적화 가능

### **동적 디스패치** 
- 런타임에 실제 구현을 조회한 후 해당 구현으로 이동
- 수퍼 클래스의 메서드를 재정의할 경우
- V-Table을 통해 다형성 제공
- 실제 코드에서 특정 가상 함수를 호출 -> 컴파일러는 해당 클래스의 타입 정보를 통해 V-Table에서 올바른 구현을 찾아 호출

### 동적 ~> 정적
클래스는 기본적으로 메서드를 동적으로 전달 
-> `final` 표현을 통해 하위 클래스가 없음을 전달할 수 있음 
= 컴파일러가 해당 메서드를 정적으로 디스패치

이외에도 클래스를 서브클래싱하지 않음을 추론할 수 있는 경우 정적 디스패치로 전환
<br>

## Swift가 프로토콜 타입을 관리하는 매커니즘
구조체를 사용해 다형성 코드를 작성하는 방법 => **POP**

![](https://i.imgur.com/uWKWzeB.png)

- 프로토콜을 사용하면 다형성을 구현할 수 있음
- 다른 점 ➡️ `V-Table` 디스패치를 수행하는 상속 관계를 공유하지 않음
- **Protocol Witness Table**(PWT) -> `V-Table`과 비슷한 매커니즘
- 구현 타입마다 크기가 다를 텐데 어떻게 테이블에 넣지? 🤔
-> **Existential Container**이라는 특별한 스토리지 레이아웃 사용
<br>

### Existential Container
![](https://i.imgur.com/bhj3KfO.png)

- 프로토콜을 채택한 타입이 얼마나 큰 메모리를 차지할 줄 모르기 때문에 컨테이너를 사용
- `word` : 프로퍼티 하나의 단위
- `Value Buffer` : 값을 저장하는 공간
- 5칸의 word = `Buffer(3) + VWT + PWT`
- word를 넘어가는 경우 Heap 영역을 사용하게 됨 -> 메모리 주소를 `Value Buffer`에 저장

> 프로토콜을 채택하고 규모가 넘 커서 `Value Buffer`에 담기지 않으면 **힙 영역**을 사용하게 된다

<br>

### VWT
힙을 사용하는 것과 아닌 것을 어떻게 구분하여 관리?
=> **Value Witness Table**
- 컨테이너의 생명주기를 관리

![](https://i.imgur.com/EhCcAAj.png)

> allacate : 할당<br>
> copy : 실제로 값을 가져옴<br>
> destruct : RC을 관리<br>
> deallocate : 할당 해제

<br>
프로토콜 타입의 수명이 시작될 때 Swift는 해당 테이블에서 할당 함수를 호출

> `"프로토콜을 사용하면 구조체라도 여전히 다이나믹 디스패치를 사용할 수도 있구나..!"` <br>
-> 그럼에도 클래스보다는 비용이 저렴

큰 구조체인 경우 복사 시 계속 힙 할당이 아니라 Value Buffer가 같은 참조값을 가지게 됨 
=> 그럼 클래스처럼 공유 문제가 발생하나?
<br>

### Copy on Write
> 값을 무조건 복사하지 않고 주소만 참조하고 있다가 값이 변경되면 복사

- 참조 카운트가 1보다 큰 경우 복사본을 만들고 이를 변경하는 방식
- 새롭게 힙을 할당하는 것보다 훨씬 저렴
- 너무 큰 구조체라면 값을 복사하면서 메모리를 많이 사용할 수 있음

> 구조체를 사용하더라도 **RC**를 사용할 수 있다

<br>

### 결론
> 구조체가 크다 -> 힙을 사용 (CoW로 문제 해결)<br>
> 구조체에 참조가 포함되어 있다 -> RC 사용<br>
> PWT -> 동적 디스패치로 동작

<br>

## Generic
제네릭과 프로토콜의 차이점 = 제네릭은 Parametric Polymorphism 라고 하는 정적인 형태의 다형성 지원
Swift는 제네릭 타입 T를 호출에서 사용하는 타입으로 바인딩

- 내부 작업을 수행하기 위해 프로토콜 및 VWT 사용
- 호출 컨텍스트당 하나의 타입이기 때문에 Existential Container는 사용하지 않음
-> 대신 스택에 valueBuffer를 할당

- Static polymorphism
- 정적 디스패치로 사용할 수 있음
- 코드상에서 타입을 직접적으로 주입하니까 동적으로 알아낼 필요가 없다
<br>

### Whole Module Optimization
- 전체 모듈 최적화
- 예전에는 스위프트 파일 단위로 컴파일 했음
- 그래서 한 파일에 구현된 제네릭이 있지 않으면 바로 알 수가 없었음 (=Unspecialized Generics)
- Xcode 8 이후
- 전체 파일을 한 번에 모듈단위로 컴파일하며 최적화
- 현재는 모듈 단위라 크게 신경쓰지 않아도 Specialized Generics을 사용할 수 있음
- 모듈이 다르다면? -> 정적인 다형성을 보장받을 수 없음
<br>

## 요약
동적 런타임 요구 사항이 가장 적은 추상화를 선택하기
- Struct, Enum과 같은 값 타입 사용하기
- OOP Polymorphism - Class
- Static Polymorphism - Generic
- Dynamic Polymorphism - Protocol

프로토콜 또는 제네릭에서 큰 값을 사용할 때 Heap을 사용 -> CoW로 해결
<br><br>

---

[Understanding Swift Performance](https://developer.apple.com/videos/play/wwdc2016/416/)
