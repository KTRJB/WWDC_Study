# Modern Swift API Design

## 오늘 배우는 것


![](https://hackmd.io/_uploads/SkfHhoB83.png)

- API 잘 설계하는 법
- Swift 5.1의 새로운 기능들

### 🐣 이름을 잘 짓자
- 문맥과 목적에 맞게 명확한 이름 짓기
- Swift는 명확성을 추구하기 때문에, Swift만의 라이브러리는 prefix를 가지지않는다.


---

## 1. Values and references

- Classes (Reference Types)

![](https://hackmd.io/_uploads/rkgTnjHL3.png)

- **참조**를 통해 값을 변경하면 두 변수가 참조하는 동일한 객체가 변경되기 때문에 동시에 변경된다. 

- Structs and Enums (Value Types)

![](https://hackmd.io/_uploads/HJ6UajS8n.png)

- API에서 **값 타입**을 사용하면 **명확성 측면**에서 많은 이점이 있다.
- **복사**를 통해 값을 변경하면 사본인 하나의 객체만 변경되기 때문에 이 객체가 어디서 왔는지, 어떤 참조를 가졌는지에 대해 걱정할 필요가 없다.

### ☑️ 값 타입 vs 참조 타입?

![](https://hackmd.io/_uploads/HJAG0sSLn.png)

- 클래스를 사용할 타당한 이유가 없다면 구조체 사용하기.
- 그치만 클래스를 사용해야 하는 경우?
    - 참조 타입이 중요할 때
    - reference counting을 통해 리소스를 관리해야 할 때
    - **값을 중앙에서 가지고 있고, 이를 공유해야 할 때**
    - type이 identity를 가져야할때는 class를 사용한다. 🤔
        - struct의 equality와는 다른 것이다.

### 🐣 구조체 안에 참조타입이 있는 경우

>예시

![](https://hackmd.io/_uploads/Sku87hSLn.png)


![](https://hackmd.io/_uploads/S1To73SI2.png)

여기서는 Material 구조체 내부에 texture라는 참조타입의 변수를 가지고 있다.

![](https://hackmd.io/_uploads/Bkx1NnS8h.png)

- 결국 Material을 볼 때, 구조체는 값 타입이라 복사가 되지만, 내부에 texture는 동일한 객체를 참조하고 있기 때문에 궁극적으로 참조타입도 값타입도 아닌, 모호한 상태가 되어버린다. 
- 이를 해결하기 위해서 어떻게 해야할까?

### 🐣 해결 방법

#### 1️⃣ 참조 타입을 방어적으로 복사한다.

![](https://hackmd.io/_uploads/rJ4ENnrIh.png)
![](https://hackmd.io/_uploads/rkerN3rI3.png)

- texture 변수를 public -> private으로 변경

![](https://hackmd.io/_uploads/r1ldNnBIn.png)

- 그다음 연산프로퍼티로 구현한다.
- 하지만 이 방법은 texture을 get한 다음 texture 내부의 특정 프로퍼티를 변경하게 되면 결국 공유되는 것이기 때문에 완벽한 해결법이 아니다. 

#### 2️⃣ isKnownUniquelyReferenced 메소드 사용하기

![](https://hackmd.io/_uploads/Syrkr3BI2.png)

- 이미 copy가 되었는지 아닌지 확인
- 객체가 하나의 참조만 가지고 있을 때 true 반환, 아닐 시 false 반환
- 이 메서드를 사용하면 불필요하게 항상 전체 복사를 하지 않아도 된다.

---

### 2. Protocols and Generics

☑️ 서로 다른 타입간에 어떤 코드를 공유해야 할 때, 항상 클래스로 이를 구현해야 하는 것은 아니다. 

=> **구조체에 프로토콜을 채택**하는 방식을 사용할 수 있다. 

![](https://hackmd.io/_uploads/HyYOT3H83.png)

- 프로토콜로 시작하지 마라.
    - 구체적인 use case로 시작해라. ➡️ 구체적인 비즈니스 로직을 생각해보라는 뜻인듯
    - 이미 존재하는 Protocol로 해결하려고 시도해봐라.
    - Protocol 대신 Generic을 고려해봐라.

>예시

![](https://hackmd.io/_uploads/SySMAhBLh.png)

- 기하학적 벡터에 대한 작업을 하는 프로토콜이다.
- 내적이나 두 벡터 사이의 거리와 같이 내가 정의하고 싶은 연산을 줄 수 있다.

![](https://hackmd.io/_uploads/B1FiRnBI2.png)

- 이 프로토콜에 Swift 5.1에 나온 SIMD 타입을 준수해줄 것이다. 

![](https://hackmd.io/_uploads/H1fM1pSIn.png)

- 그 다음 protocol-extension을 통해 기본 구현을 해준다.   

![](https://hackmd.io/_uploads/Hk33JaHL3.png)

그런데 이렇게 구조체(SIMD2, SIMD3..)마다 프로토콜을 채택하면 번거롭다.
protocol 없이 extension하는 게 컴파일러가 처리하는 데에 더 쉽다.

따라서 아래와 같이 프로토콜 자체가 아닌, 프로토콜을 채택하고 있는 SIMD 프로토콜 타입을 extension 해주는 것이 좋다.

![](https://hackmd.io/_uploads/rktyxaHL2.png)

>장점

- 단순한 접근 방식
- 프로토콜 수를 줄임으로써 컴파일 시간을 줄일 수 있다.
- ☑️ 그러나 확장성 문제가 발생함.
    - GeometricVector는 SIMD라고 할 수 있나? ❌ 
    - 즉, is-a 관계가 성립되지 않는다.

사용하기 쉬운 API를 설계하는 경우 is-a 관계 대신 **has-a **관계로 구현하는 것도 고려해볼 수 있다.

➡️ 즉, 구조체 안에 SIMD 타입의 값을 래핑하는 것이다. SIMD를 has 하게 되는 것.

![](https://hackmd.io/_uploads/rkPY6bU82.png)

이렇게 Storge가 SIMD 프로토콜을 따르도록 구현해주면 된다. 

>바뀐 점
- 원래 프로토콜이었던 GeometricVector가 구조체가 됐다.
- SIMD 타입을 채택하고 있는 것이 아니라 가지고 있다. 




![](https://hackmd.io/_uploads/SkX-gzUU2.png)
 
- 이부분 이해가 잘 안감

### SIMD 구조

![](https://hackmd.io/_uploads/SyKceGLUn.png)


![](https://hackmd.io/_uploads/rJrRlMII3.png)

- SIMD3에서만 사용할 수 있는 기능인 X 연산 기능을 위와같이 정의할 수 있다.

![](https://hackmd.io/_uploads/BJg-c-GLU3.png)

이렇게 정의할 수도 있다. 그러나 위의 코드는 x,y,z 좌표를 얻기 위해 value에 계속 간접 접근을 해야하기 때문에 코드가 지저분해보인다는 단점이 있다. 

➡️ 이 문제를 해결하기 위한 새로운 기능인  **Key Path Member Lookup** 가 나왔다. 


### Key Path Member Lookup
- Swift 5.1부터 생겼다.
- 연산 프로퍼티의 선언 횟수를 줄일 수 있다.
- GeometricVector에 있는 모든 속성을 한번에 노출할 수 있다. 

![](https://hackmd.io/_uploads/HyJqQzU82.png)

사용하는 방법은 
1. 타입 앞에 @dynamicMemberLookup을 붙인다.
2. subscript 어쩌구를 작성한다.
    - Storage에 대한 키 경로를 가져와서 Scalar를 반환하도록 하려고 한다. 그런 다음 해당 키 경로를 사용하여 value 타입으로 값을 전달하고 x,y,z등등 속성을 검색하여 반환한다. 
3. 그러면 이제 자동으로 GeometricVector가 SIMD가 가진 모든 속성을 가져올 수 있게 된다. (x,y,z)


> Key Path Member Lookup 적용 

![](https://hackmd.io/_uploads/SkwbSG8Un.png)

- value에 접근하지 않아도 x,y,z를 자동으로 가져와주기 때문에 기존에 비해 이렇게 간단해졌다. 

### 🐣 Property wrappers

> 기존 코드

![](https://hackmd.io/_uploads/ryLlpf8U2.png)

> 개선한 코드

![](https://hackmd.io/_uploads/B1h-6GLU3.png)

- 긴 코드, 짧은 코드 둘이 같은 기능을 함. (가독성 차이...!)
- 이 코드는 생각보다 일반적인(흔한) 문제이다. 
- 그래서 lazy 등의 프로퍼티 초기화, 접근 규칙을 언어 수준에서가 아닌, 코드 수준으로 높여야겠다고 생각하여 만든 것이 **Property Wrapper**라고 함.

> @LateInitialized 

![](https://hackmd.io/_uploads/HyJJCz883.png)

> 내부 코드

![](https://hackmd.io/_uploads/HkKVRf882.png)

- lazy 키워드와 매우 유사하다.
- 하지만 복잡한 코드보다 훨씬 읽기 쉽고 추론이 쉽다.
- value 프로퍼티가 역할을 해준다. 

![](https://hackmd.io/_uploads/r1LJmMDUn.png)

이렇게 사용한다면, 컴파일러는 아래와 같이 두개의 프로퍼티로 해석한다.

![](https://hackmd.io/_uploads/SJlRl7zw8n.png)

- LateInitialized으로 초기화하는 $text 저장 프로퍼티와, 그 안에 구현된 value에 접근하는 연산프로퍼티로 나누어진다.

### SwiftUI의 Property Wrapper


> Property Wrapper로 사용되는 @Binding, @State


![](https://hackmd.io/_uploads/HJijSGDI2.png)

>@Binding 내부

![](https://hackmd.io/_uploads/rkoIIGv8h.png)

- Dynamic Member Lookup도 구현한 상태이다.
    - Keypath를 받아 새로운 Binding을 반환한다. (내가 지정한 모델 내부 프로퍼티인 title에 접근할 수 있게 됨)
- $를 붙이면 Binding 타입의 인스턴스가 된다. 


### 요약

![](https://hackmd.io/_uploads/SJj4FMD8n.png)

> 배운 것

- 값 의미론, 참조 의미론을 사용하는 시기와 함께 작동하는 법
- 코드의 재사용을 위해 프로토콜을 사용하자.
- 프로퍼티 래퍼 내부에서 연산 프로퍼티를 사용하고 있는 것
