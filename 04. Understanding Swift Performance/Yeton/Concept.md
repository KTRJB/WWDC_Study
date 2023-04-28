## 1. Understanding Swift Performance

### 📚 성능에 영향을 미치는 요소들
- `Allocation`, `Reference Counting`, `Method Dispatch`
- 왼쪽과 가까울 수록 성능에 좋다.  (힙보단 스택에 할당, 참조 카운팅 적을수록, 동적 디스패치보단 정적 디스패치가 성능에 좋음.)
-
![](https://i.imgur.com/4QfI6O1.png)


### 📚 1. Allocation

> Stack

- LIFO 구조
- O(1)시간으로 매우 빠름

> Heap

- 동적 구조이지만 효율은 스택보다 덜 함
- 동적 메모리를 할당할 수 있음
- 힙에 메모리를 할당하려면 실제로 Heap의 데이터 구조를 검색하여 사용되지 않는 적당한 크기의 블록을 찾아야함 => 복잡

> class 메모리 할당 예시

![](https://i.imgur.com/tLM5H8J.png)
- Point 인스턴스를 만들면, Swift는 무결성 보호를 위해 Heap을 lock하고 해당 크기의 메모리 블록을 검색한다.
- 여기서 **무결성 보호**란 `여러 스레드가 동시에 힙에 메모리를 할당할 수 있기 때문에, Heap은 locking 또는 기타 동기화 메커니즘을 사용하여 무결성을 보호한다.` 라는 뜻이다. => 비용 ⬆️
- 공간을 찾고 난 후, 아래와 같이 두 인스턴스는 같은 곳을 참조하게 된다.

![](https://i.imgur.com/d9e0FlN.png)


- 함수 실행을 마치면 스택 포인터를 이 함수를 호출하기 전의 위치로 다시 증가 시켜서 메모리를 해제할 수 있다. 
    - 힙을 lock한 뒤, 스택을 pop하여 마무리한다.
    
![](https://i.imgur.com/77weDKg.png)



> 또 하나의 예시 (String)

![](https://i.imgur.com/Ay1jlgx.png)

* string을 key값으로 사용하는 것은 적절하지 않다. (= 안전하지 않다.) 
* String은 실제로 문자의 내용을 힙에 간접적으로 저장한다.
* 그래서 Struct를 사용하는 것이 더 safe하다.

Struct는 Swift에서 first class type이기 때문에 dictionary의 key로 사용 할 수 있다. 더 안전하고 더 빠르다!

### 📚 2. Reference Counting

>Swift는 힙의 인스턴스에 대한 총 참조 수를 유지한다.
- Reference Count가 0에 도달하면 Swift는 더 이상 힙에서 이 인스턴스를 가리키고 있지 않고 할당된 메모리를 해제한다.
- 증가 및 감소를 실행하기 위해 몇 가지 수준의 `간접적인(Indirection) 지시`가 있다.
    - ![](https://i.imgur.com/0nVcjMG.png)
    
        - Retain은 기준 카운트를 원자적으로 증가
        - Release는 기준 카운트를 원자적으로 감소


- `UIFont`: 참조 카운트 +1, `String`: 참조 카운트 +1

![](https://i.imgur.com/C1Nk08i.png)

- label2를 만들 때 

![](https://i.imgur.com/tA6iFo0.png)
- 참조 카운트 오버헤드는 2배로 늘어남

결론:
struct일지라도 내부에 참조가 포함되어 있으면 참조 카운트 오버헤드도 지불해야한다. 
따라서 2개 이상의 참조가 있으면 클래스보다 더 많은 참조 계산 오버 헤드가 유지된다.

>예시

![](https://i.imgur.com/4Dbjby5.png)

- 총 3번의 참조 카운트 오버헤드가 발생.
- 해결방법은 uuid는 String -> UUID 타입으로 변경, mimeType은 String -> Enum 타입으로 변경해주면 된다.

```swift
enum MimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
}
```

### 📚 3. Method Dispatch

> 정적 디스패치 (static dispatch)
  
- Compile time에 실행할 구현을 결정
- 컴파일러가 실제로 어떤 구현이 실행 될지에 대한 가시성을 가질 수 있기 때문에 코드를 최적화 할 수 있다.
- 컴파일 타임에 컴파일러가 어떤 메소드를 실행할지 주소값을 알고 있기 때문에, 별도의 과정이 필요없고 런타임에 inline으로 빠르게 수행된다. 
> iniline: 함수를 따로 호출하는 과정이 아니라 그냥 구현부 그자체를 호출하는 것  

> 동적 디스패치 (dynamic dispatch)

- "런타임"에 호출될 함수를 결정한다
- 때문에 Swift에서는 클래스마다 함수 포인터들의 배열인 vTable(Virtual Methon Table)이라는 것을 유지한다.
- 하위 클래스가 메서드를 호출할 때, 이 vTable을 참조하여 실제 호출할 함수를 결정한다.
- 이 과정들이 "런타임"에 일어나기 때문에 성능상 손해를 보게 된다.

![](https://i.imgur.com/KDIoXGC.png)

- 모든 하위 클래스에는 고유한 상위 클래스의 vTable 복사본이 있고, 이 vTable에는 이 클래스에서 오버라이딩 한 모든 메서드들을 가리키는 함수 포인터가 있음
- 런타임 시점에 Point란 클래스의 vTable을 탐색하여, 실제 불릴 draw의 함수 포인터를 찾아 실행

###  📚 Protocol의 dispatch

> **Protocol Witness Table (PWT)**

class의 vTable과 달리, protocol은 `Protocol Witness Table`을 사용한다.
타입별로 테이블이 존재하고, 테이블의 항목은 타입의 구현부와 연결된다.

![](https://i.imgur.com/kodZO1w.png)

1.  배열의 요소에서 테이블로 어떻게 갈까?

![](https://i.imgur.com/ftLsJ1y.png)

2.  배열의 고정된 오프셋에서 요소를 균일하게 저장하는 방법은 무엇인가? 

![](https://i.imgur.com/vagcsMG.png)

똑같은 사이즈일 필요가 없는데 배열은 고정된 오프셋에 저장하려고 한다.

=> 이때 바로 `The Existential Container`을 사용한다.

Swift는 이때 Existential Container라는 특수한 저장 레이아웃을 사용한다.

- 아래와 같이 생김. 
- 이 컨테이너의 처음에는 이렇게 3 word가 valueBuffer용으로 예약돼있음.

![](https://i.imgur.com/ArMUVf4.png)

`valueBuffer`라는 것을 사용하려면 3words까지 가능한데,
Point는 2words, Line은 4words이기 때문에 
Point는 valueBuffer에 저장하고, Line은 아래와 같은 방법으로 저장할 수 있다.

![](https://i.imgur.com/Ry7hfZa.png)


(* 여기서 word는 한번에 저장할 수 있는 데이터의 크기이다.)


지금까지 우리가 알 수 있는 사실은 Point와 Line은 서로 다른방식으로 저장된다. 이다.

그럼 `Existential Container`는 이 **차이**를 관리 할 필요가 있다.
그럼 이 관리를 어떻게 하냐?
table 기반 메커니즘인 `Value Witness Table`를 통해 관리를 한다.


<br>

> #### The Value Witness Table (VWT)

과정: Allocation ➡️ Copy ➡️ Destruction ➡️ Deallocation

1. Allocation

Protocol Type의 지역 변수의 lifetime이 시작될 때 Swift는 해당 테이블 내부에서 `Allocate 함수`를 호출한다.

Allocate 함수는 Line Value Witness Table을 가지고 있기 때문에
힙에 메모리를 할당하고 Existential Container의 valueBuffer 안에 해당 메모리에 대한 포인터를 저장한다.

(타입마다 Value Witness Table가 있음)

![](https://i.imgur.com/FlzKIcv.png)

2. Copy 

local 변수를 초기화하는 assignment소스에서 Existential Container로 값을 복사해야한다. 

3. Destruction

지역 변수의 수명이 다하면 destruct 함수를 호출하여 값에 대한 레퍼런스 카운트를 감소시킨다.

4. Deallocate

할당 해제!


⭐️ 정리
![](https://i.imgur.com/7xMwluE.png)

1. Swift컴파일러는 d.draw()에서, 어떤 struct의 draw가 불려져야될지 어떻게 아는걸까??에 대한 것을 지금까지 공부한것이다.
2. 먼저, Swift는 existential container라는 것을 Stack에 만든다. 
3. existential container는 inline valueBuffer (공간 3개), value witness table(vwt)의 레퍼런스, protocol witness table(pwt)의 레퍼런스를 갖고 있다.
4. vwt는 위에서 말했다시피 4가지의 엔트리를 가지고 있다.
5. 그리고 우리가 draw라는 메소드를 호출하는데, draw는 Protocol메소드였기 때문에 pwt를 조회한다.
6. 이 pwt를 조회해서 draw를 찾으면 게임끝!
7. 그 draw주소로 가서 구현을 찾아서 실행시키면 됨
8. 이제 draw가 끝나면 vwt에 있는 destruct를 호출하규 deallocate에서 Heap할당을 해제하고 stack메모리도 해제하면 진짜 끝 


### 📚 Generic의 dispatch

![](https://i.imgur.com/xzL6F6s.png)
- 이번에는 generic 코드를 사용하여 구현된 애플리케이션으로 돌아가보자.
- 이제 drawACopy 메서드는 Drawable이라는 generic 매개변수 제약 조건을 취하고 있으며 나머지 부분은 이전과 동일하다.
- 이것은 프로토콜 타입과 비교할 때 무엇이 다를까?


> 구체타입 변경 > 프로토콜 O, 제네릭 X


- 프로토콜을 쓴 경우, 구체타입을 바꿀 수 있다.

![](https://i.imgur.com/6miVQNW.png)

- 제네릭을 쓴 경우, 구체타입을 못바꾼다. 

![](https://i.imgur.com/8DRUOH7.png)


그 이유는 다음과 같다.
 
✓ Protocol - Dynamic polymorphism 
✓ Generic - Static polymorphism 


![](https://i.imgur.com/Vqfn3FV.png)
![](https://i.imgur.com/JcpO8uX.png)

> Protocol

dynamic dispatch 방식. 하지만 클래스처럼 v-table을 쓰는 것은 아니고 protocol witness table 을 사용한다.
(추가적으로 existential container, Value Witness Table 등이 등장함) 

> Generic

컴파일러 최적화를 가능하게 하는 정적형태의 다형성.  
existential container 를 안쓰는 등 프로토콜과 dispatch 방식이 다르다고 함. 


- 2개의 Line 인스턴스가 Pair라는 타입에 묶이게 된다.
- `specialization`을 통해, Pair라는 struct의 T를 Line으로 바꾸어서 이 구조가 가능하게 된 것이다.
- 그러면 existential container가 필요없고, 바로 stack의 inline에 프로퍼티들을 저장 할 수 있게 되는 것이다.

![](https://i.imgur.com/64X9Iqh.png)

1. struct타입의 값을 복사할 때, Heap할당이 필요하지 않으며 레퍼런스가 포함되지 않은 경우, 레퍼런스 카운팅이 필요하지 않다.
2. 그리고 위에서 언급했다시피 새로운 버전의 메소드를 만들어내기 때문에 (타입당 하나) static method dispatch가 가능해진다.
3. 그래서 성능이 굉장히 좋다! 👍



## 요약

![](https://i.imgur.com/hVsSVCV.png)
