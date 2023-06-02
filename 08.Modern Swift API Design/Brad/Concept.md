# Modern Swift API Design

관련 내용

- API 설계에 기본 개념을 다루고 API 설계에 어떤 영향을 미치는지 이해해보자
- Swift5.1의 몇 가지 새로운 기능에 대해 알아보자
- API를 더욱 표현력 있게 만드는데 어떻게 도움이 되는지 살펴보자
- SwiftUI 및 RealityKit을 포함한 일부 최신 Swift 프레임워크의 예제도 보자


---
### 1. 2016 Swift API 디자인 가이드라인

**사용 시점의 명확성**은 API 디자이너로서 가장 중요한 목표이다.
- API를 사용하여 코드를 읽을 떄 수행하는 작업이 명확하도록 만들고 싶을 것
- API를 올바르게 사용하기 쉽게 만들고 싶습니다.
- 좋은 이름과 가독성도 중요한 부분

새로운 사항) Swift 전용 API의 Swift 유형에 접두사를 사용하지 않는다.
- C, Objective-C 전역 이름 공간에 있기 떄문에 접두사를 사용. -> 접두사 규칙을 지켰어야 했음
- 하지만 Swift의 모듈 시스템은 타입 앞에 모듈 이름을 추가하여 명확성을 허용함.

---
### 2. 값과 참조, 프로토콜 및 제네릭

#### 2-1. 값과 참조

Swift는 타입을 생성하기 위한 세 가지 기본 개념인 Class, Struct, Enum이 있음.

Class = 참조 타입
-> 변수가 있을 떄 실제로 값을 보유하는 개체를 참조한다는 뜻

![](https://hackmd.io/_uploads/SyaOmX8Ih.png)

Struct, Enum = 값 타입
-> 복사할 떄 전체 내용을 복사, 즉 변경할 떄 해당 사본 하나만 변경

![](https://hackmd.io/_uploads/BksaXmU8n.png)

#### 질문) 특정 코드에서 참조 또는 값 타입을 사용해야하는가?

-> 모든 사용 사례는 다르다. 하지만 일반적인 지침은 있다.

1. 클래스를 사용할 타당할 이유가 없다면 구조체를 사용하는 것이 좋습니다.
2. 무언가를 근본적으로 저장하고 공유되는 경우 클래스가 유용합니다.

---
#### RealityKit

![](https://hackmd.io/_uploads/BJjHr7I83.png)

- RealityKit API는 엔티티라고 하는 항목을 중심으로 되어 있다.
- 화면을 구성하는데 되어 있고 이것은 엔진 내부 중앙에 저장됨, 그것들은 identity를 가지고 있음.
- 만약 개체의 모양을 변경하거나 이동하여 장면을 조작하려고 하면 해당 엔진에서 직접 개체를 조작함.
- RealityKit에 저장된 실제 객체에 대한 핸들과 같은 참조 타입으로 생각할 수 있음.

따라서 이것은 참조 타입에 대한 완벽한 사용

그러나 위치나 방향과 같은 엔티티의 속성은 값 타입으로 모델링 되어 있음.

예제 코드
![](https://hackmd.io/_uploads/HJn9I7882.png)

이러한 참조 타입에 대해 작업을 수행하면서 직접 조작함.

색 변경 시

질문
- 둘 다 생성된 변수를 변경했기 떄문에 두 상자가 모두 변경되어야 하는지?
- 후속 상자만 새로운 사항에 변경되어야 하는지

정리
- 참조 타입 또는 값 타입처럼 작동해야하는지? 값 타입처럼 작동
- 이전에 사용했던 사실을 잊거나, 예상치못한 장면의 일부를 변경할 수도 있어서.

---
참조 타입을 복사하면 해당 참조를 복사하는 것
![](https://hackmd.io/_uploads/HJFGdmU8n.png)

따라서 두 타입은 동일한 텍스처 개체를 공유하게 됨

구조체의 속성을 변경할 수도 있음. 그리고 그것은 변수 중 하나에 영향을 미침, 그러나 객체에 대한 참조를 통해 변경하면 두 변수 모두에 영향을 미침

이것은 참조 의미 체계를 끝까지 고수한 경우보다 더 혼란스러울 수 있음.

값과 참조 유형, 구조체와 클래스, 값과 참조 시맨틱 사이의 주요 차이점, 타입이 작동하는 방식, 무언가가 구조체와 같은 값 타입이라고 해서 반드시 값 동작을 자동으로 얻는다는 의미는 아님.
유일한 방법은 아니지만 공개 API의 일부로 변경 가능한 참조 타입을 포함하는 것

무언가가 값 타입처럼 동작하기를 원하는 경우 노출하는 참조 중 변경 가능한 것이 있는지 확인하고, 그것이 항상 분명한 것은 아니라고 점을 명심

---
최종 클래스가 아닌 클래스를 다루는 경우 실제로 가질 수 있는 것은 변경 가능한 하위 클래스
이와 같은 문제점을 피하기 위한 몇 가지 기술
- 방어적 복사본을 만드는 것
    - 저장 속성을 비공개(private)로 선언
    - 계산 프로퍼티로 복사본을 만듬

#### 값 타입안에 참조 타입이 있는 경우

객체를 복사하게되면 다 복사하지만, 내부 참조 타입은 참조를 복사함.
-> 내부 참조타입은 공유가 된다는 뜻.

이것을 방지하기 위해서는 참조를 체크하여 COW를 구현
- 참조 타입프로퍼티를 가지고 있으면서 완벽하게 값을 갖도록 하게함.


객체에서 원하는 타입을 재료 값 타입의 계산된 타입으로 노출시킴
getter에서 개체의 관련 속성으로 전달
setter에서 개체가 고유하게 참조되고 있는지 확인

![](https://hackmd.io/_uploads/r1WVaSvUn.png)

고유성을 확인하기 위해 이 한줄을 추가함으로써 참조 타입에서 원하는 속성을 계속 노출하면서 전체 쓰기 중 복사 값 의미 체계를 구현

값 타입이 API사용 시점에서 명확성을 추가하는 방법을 살펴보았음.


#### 프로토콜과 제네릭

- Swift에서는 Class뿐만 아니라 Struct, Enum에도 프로토콜을 적용하는 기능이 있음.
- 이는 제네릭을 사용하여 다양한 유형에서 코드를 공유할 수 있음을 의미

무조건적으로 protocol을 사용하면서 시작하지는 말자.
- 구체적인 타입을 사용하여 사용 사례 확인
- 다른 타입에서 여러 기능을 반복하는 코드를 보고 제네릭을 통해 공유 코드를 제거
- 프로토콜에서 필요한 것을 구성
- 프로토콜을 만드는 대신 제네릭 형식을 만드는 것도 고려

기존의 타입들을 extension하여 구현된 protocol을 모두 채택하는 것보다, prtocol없이 extension 하는게 컴파일러가 처리하는데 있어 훨씬 가볍다.
그 이유는 프로토콜 witness table을 만들 필요가 없기 떄문.

#### protocl witness table??

- table기반 메커니즘??

### 3. 새로운 기능) 키 경로 멤버 조회 및 속성 멤버

Swift5.1부터 생겨서 정의한 타입의 모든 프로퍼티에 접근할 수 있게됨.

먼저 `@dynamicMemberLookup attribut` 태그를 지정
![](https://hackmd.io/_uploads/SyoPAHwU2.png)

그런다음 `subscript` dynmic memerr subscript를 작성하도록 요구
- 구현시 키 경로를 통해 액세스할 수 있는 속성이 자동으로 computed property로 노출되어짐.
- Scalar를 반환하려고 함. SIMD가 가진 모든 속성을 가져옴.

![](https://hackmd.io/_uploads/SkGjCSDI2.png)

아래 그림처럼 모든 프로퍼티를 가질 수 있게 됨.
- Swift5와 비교했을 때 타입이 안전하다.
- 훨씬 더 많은 작업들이 컴파일 타임에서 실행된다.

![](https://hackmd.io/_uploads/HJV_J8vLn.png)

이제 x, y, z 프로퍼티에 액세스할 수 있으므로 연산을 정리할 수 있게 됨.

![](https://hackmd.io/_uploads/SkxkeUwL2.png)

이러한 멤버 기능은 프로퍼티에 전달하는데만 유용한 것은 아님.
복잡한 계산에 대해서 subscript를 넣을 수 있음.

![](https://hackmd.io/_uploads/BkofeLvI3.png)

### 참조 타입의 모든 프로퍼티에 대해 COW 적용

![](https://hackmd.io/_uploads/B11ax8w82.png)

COW를 사용해서 Texture타입의 모든 프로퍼티를 노출시키고 싶다면 어떻게 해야하나?

dyanmic member attribute 추가하고
WritableKeyPath 만듬
- Texture에서 다른 타입들을 가져오고 싶기 때문에 제네릭 타입으로 반환

![](https://hackmd.io/_uploads/B17Eb8DI2.png)

그다음 get, set을 구현

getter는 keyPath 반환
setter는 고유값 참조 하고 복사본을 추가함.

![](https://hackmd.io/_uploads/r1l0-Uv82.png)

이렇게 하게 되면 이 타입에 대한 COW 의미 체계를 사용하여 Texture의 모든 단일 프로퍼티를 노출시킬 수 있음.
- 이것은 값 의미를 갖는데 정말 유용한 방법

### Property Wrapper

- 프로퍼티 래퍼는 Swift5.1의 새로운 기능과 잘 구성된다.

Swift는 명확하고 간결한 코드와 풍부한 API로 구축되어있고 설계되어있다. 코드 재사용을 위해 존재함.

프로퍼티 래퍼의 기본은 작성된 계산 프로퍼티에서 코드를 효과적으로 재사용하는 것


![](https://hackmd.io/_uploads/SJdHXIDL3.png)

이 코드들을 

![](https://hackmd.io/_uploads/S1b_mLvIn.png)

lazy var를 써 구현한 것

이것을 쓰는 것은 사용자가 직접적인 코드 접근을 막으면서, 호출할 경우에만 인스턴스를 반환하는 것

![](https://hackmd.io/_uploads/Skta7UP8n.png)

이 코드들도 비슷해 보이지만

getter, setter에서 다름.

mutating을 붙이지 않았다. 즉 값이 있는 경우에만 받을 수 있고, 없는 경우 fail하게 됨.
-> 한번 set을 하거나, 읽기전 이니셜라이즈되야 한다.

![](https://hackmd.io/_uploads/HkTNNUD83.png)

이 코드는 lazy var와 매우 유사함. 이점을 모두 제공해줌
- 제네릭 사용
- 어떤 타입이든지 늦게 이니셜라이저되게 할 수 있다.

![](https://hackmd.io/_uploads/SyRCNIPIn.png)

propertyWrapper를 적용하면

몇 가지 요구사항이 생김.
- 값 속성을 가짐
- 이니셜라이저에 파라미터가 없다.(암시적 초기화를 얻는다는 의미)

![](https://hackmd.io/_uploads/SkJpHIPUn.png)

이처럼 사용한다면 컴파일러는 두개의 프로퍼티로 해석

![](https://hackmd.io/_uploads/H1v-IIv83.png)

저장프로퍼티와 계산 프로퍼티로 해석..
초기화하는 $text 프로퍼티와 그 안에 구현된 value를 접근하는 get, set 연산 프로퍼티로...

![](https://hackmd.io/_uploads/Hk_0ULPUn.png)

init에 파라미터를 주었는데, 파라미터가없는 init과마찬가지인거다.
만약 Init에 파라미터를 준다면, default로 value를 넣어준다 ?

여튼, 특정 인스턴스를 넣어주면, 새롭게 복제하도록 했다.

![](https://hackmd.io/_uploads/rJixwUPIn.png)

새로운인스턴스를 카피할필요 유무?
없음 아래와같이 extension으로 PropertyWrapper하여, 새로운 Init을 만들어줌

이를사용할때는, 이니셜라이저를 아래와같이, 직접적으로 DefensivCopying( withoutCopying: ) 을 적어주도록한다.

주의할점 $path를 이용
-> 컴파일러가 $path 저장프로퍼티를 생성하기때문

![](https://hackmd.io/_uploads/SyRQDIv82.png)

위의 코드도 더 줄일 수 있음.

![](https://hackmd.io/_uploads/BJsVvIvLn.png)

즉, property wrapper는,
데이터접근에 대해 policy를 정의한다.
어떻게 데이터가 저장될지,
어떻게 접근할지를 정의할수있다.

property wrapper를 통해 다양하게사용될 수 있음.

![](https://hackmd.io/_uploads/HJzvvLwIn.png)

특정 스레드에서도 정의할 수 있음.

### SwiftUI에서의 property Wrapper

SwiftUI에서는 굉장히 PropertyWrapper을 많이사용한다.
SwiftUI에는 몇몇 정의된 propertywrapper가 있다.

![](https://hackmd.io/_uploads/S115vIv82.png)

재밌는 건 $slide.title 이다.
$는 컴파일러가만들어낸 backing stored property이다.
Slide는원래 title을 가지고있지않는데, 다른 데이터모델과 binding되어있는상태

![](https://hackmd.io/_uploads/ByuoPLwIn.png)

아래와같이 DynamicMemberLookup도 구현한상태이다.
Keypath를받는다.
그리고새로운 Binding< > 을반환한다.

![](https://hackmd.io/_uploads/ByX3wUv8h.png)

실제사용예는,
$를붙이면 Binding타입으로 접근하게되고,

![](https://hackmd.io/_uploads/Hyjnv8D8h.png)

$slid.title은 keyPath를 통해접근하여, Binding의인스턴스가된다

![](https://hackmd.io/_uploads/SJFpP8vUh.png)

다른View에서도 공통적으로사용된다????