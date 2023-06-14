# [WWDC19] Modern Swift API Design

## 💎 배경

> **Values and references, Protocols and Generics, Key path member lookup, Property wrappers을 중심으로 Swift 5.1의 새로운 기능들과 함께 API를 더욱 올바르고 사용하기 쉽게 만들어보자**
> 

## 💎 해결방안

- **Clarity at the point of use**
    - **Good naming and readability**
        
        <img width="565" alt="스크린샷 2023-06-01 오후 2 53 57" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/a0dd2bfa-f570-4b6f-af10-c4f7679673b6">

        
        - Swift-only API에서 prefix 사용 X
        - Swift Module System은 모듈 앞에 name을 추가하여 명확성 확보
        - 기존의 C 언어와 Objective-C에서는 모호성을 제거하고자 prefix 사용
            - 예시
                - UI → UIKit
                - AB → Address Book
                - CA → Core Animation

- **Values and references**
    - **Value Type**
        - 전체 내용을 복사하기 때문에 값을 변경하면 사본 하나만 변경됨
        - 값이 어디에서 왔고, 어떤 객체를 여전히 참조하는지 여부 걱정 X → Defensive Copy 불필요
    - **Reference Type**
        - 참조 주소값을 복사하기 때문에 값을 변경하면 두 변수가 참조하는 동일한 개체가 변경됨
    - **Value Type vs Reference Type**
        
        <img width="549" alt="스크린샷 2023-06-01 오후 3 09 55" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/83e62dda-8c2c-4102-933f-7aa9b3b1d2ce">
        
        - 객체 선정을 위한 일반적인 지침
            - 클래스를 사용할 타당한 이유가 없다면 일반적으로 구조체 사용
                - 단순 data-model로 사용하기에는 closure 내에서의 memory-capture 등 신경써주어야 할 일이 많음
                - 반대로 생각하면, reference semantics가 중요하다면 클래스 사용
            - 추가적으로 클래스를 고르기 좋은 조건은 다음과 같음
                - Reference Counting을 통한 리소스 관리(deinitialization)
                    - struct 에는 class 와 달리 deinit() 함수가 존재하지 않기 때문
                    - 이로 인해 struct 내부의 class property 로 인한 memory leak 이 발생했을 때 원인을 추적 어려움
                - 근본적으로 저장되고 공유되는 경우에 유용
                - 타입에 Identity가 있는 경우
                    - 해당 object instance를 사용하는 사용처들이 **instance 의 동일성**을 보장해야 할 경우를 의미
                    - struct의 copy-on-write 방식은  instance의 동일성 보장 X
    - **문제상황: Value Type 내 Class Type 공유 문제**
        
        <img width="584" alt="스크린샷 2023-06-01 오후 3 10 40" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/7f848e67-b950-4ccd-87b4-ec569d22c9c1">
        
        <img width="608" alt="스크린샷 2023-06-01 오후 3 10 54" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/a68b2cce-0072-424d-a87e-2dc867f9353b">
        
        - orientation과 position은 value type으로 모델링
        - 색 변경을 위하여 `material.tintColor = red` 코드 작성
        - 후속 박스인 smallBox의 색만 변경하기 위해서는 material의 타입이 과연 value type이어야 할까, reference type이어야 할까?
        - 두 모델 모두 API를 위한 합리적인 디자인이 될 수 있지만 다음의 근거로 value type을 선택
            - 코드에서 material 타입을 처음 만들어 사용한 시점과 변경한 시점 사이에 거리가 먼 경우 이전에 사용한 적이 있다는 사실을 잊어버릴 수 있음
            - 또한 예상하지 못했던 장면의 일부 변경 가능성 존재
            - 이를 해결하고자 value type의 이점을 활용
        
        <img width="278" alt="스크린샷 2023-06-01 오후 3 24 28" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/6996215a-98c6-4325-aa33-8c9d192e2694">
        
        - 값처럼 작동하고자 Material이라는 struct 생성
        - texture의 경우 reference counting을 통해 리소스를 관리한다고 가정 → class로 생성
        
        <img width="603" alt="스크린샷 2023-06-01 오후 3 27 53" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/67fe702d-e9d1-48fb-8e6f-eff50faab316">
        
        - value type은 copy될 때, stored property를 모두 복사
        - 그러나 reference type은 해당 참조를 복사
        - 따라서 두 타입은 동일한 texture 개체를 공유하게 됨
        - texture가 immutable하면 괜찮지만, mutable 타입이라면 reference나 value처럼 작동 X
        - 구조체의 property가 변경가능하게 됨
        - 따라서 구조체라고 해도 꼭 value 타입처럼 동작하지 않을 수 있음을 유의
        - value type으로 동작하기를 원한다면 reference 중 mutable 한 것이 있는지 확인 필요
        
    - **해결방안 1: Defensive Copy (Immutable Class)**
        
        <img width="312" alt="스크린샷 2023-06-01 오후 3 37 55" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/fbf0e23d-dd1c-446b-871e-bfd8e627a629">
        
        <img width="429" alt="스크린샷 2023-06-01 오후 3 38 26" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/9216a18c-18be-4422-8ce0-9880065f92a6">
        
        - Defensive Copy를 만들기 위해서 저장 프로퍼티인 texture를 먼저 private로 전환
        
        <img width="452" alt="스크린샷 2023-06-01 오후 3 39 59" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/37461564-deb1-4855-9d05-14833b7e69e7">
        
        - 대신 계산 프로퍼티 생성
        - setter 부분에 texture 개체의 copy를 만듦
        - 이를 통해 mutable subclass 문제 해결
        
        <img width="579" alt="스크린샷 2023-06-01 오후 3 42 03" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/00dfc94c-58c4-4e54-a455-1b40f4967774">
        
        - 이 방법은 위와 같이 texture가 immutable한 타입일 때는 확실한 방법
        - 그러나, texture가 근본적으로 mutable한 타입이라면 getter property를 통해서 mutate가 가능하기 때문에 반쪽짜리 해결책임
        - 따라서, reference type을 전혀 노출하지 않는 다른 해결책을 고려해보자
    - **해결방안 2: Defensive Copy (Mutable Class)**
        
        <img width="451" alt="스크린샷 2023-06-01 오후 3 47 15" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/67247fd4-afd3-4516-845c-b2ed515e1321">
        
        - reference type은 노출하지 않는(private) 대신
        - 객체에서 원하는 프로퍼티(`isSparkly`)를 material value type의 연산 프로퍼티로 노출
        - getter를 통해서 객체의 관련 property를 전달(`_texture.isSparkly`)
        
        <img width="589" alt="스크린샷 2023-06-01 오후 3 48 41" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/02f09a51-f12d-4b28-9b4b-730a3a336405">
        
        - setter에서 먼저 `isKnwonUniquelyReferenced` 를 통해 고유하게 참조되는지 확인
        - 그렇지 않을 경우, texture 개체의 전체 copy를 만든 후 계속해서 mutation 진행
        - `isKnwonUniquelyReferenced` 를 통해 uniqueness를 확인함으로써, reference type에서 원하는 프로퍼티를 계속 노출하면서, copy-on-write value semantics 구현
        

- **Protocols and Generics**
    - **Protocol**
        - 서로 다른 타입 간에 일부 코드를 공유해야하는 경우, 꼭 class를 사용해야되는 건 X → protocol
        - protocol 유의사항
            
            <img width="501" alt="스크린샷 2023-06-01 오후 4 26 35" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/f72f5d8e-e5f0-4a49-845e-72580c33ce11">
            
            - protocol 먼저 작성하면서 시작하지는 않기
            - 구체적인 타입을 사용하여 use case를 탐색하기
            - 다른 유형에서 여러 기능을 반복한다면 공유하고 싶은 코드가 무엇인지 이해하기
            - generics을 사용하여 공유 코드 제거
            - 먼저 기존 protocol에서 필요한 것을 구성하기를 고려
            - 그런 다음 protocol을 설계 할 때 구성 가능한지 확인
            - 프로토콜을 만드는 대신 제네릭을 만드는 것이 더욱 좋음
        
    - **문제상황: protocol이 꼭 필요한가**
        
        <img width="351" alt="스크린샷 2023-06-01 오후 4 28 47" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/5b66314f-b73f-4d22-93e2-be10ca6795d2">
        
        - GeometricVector 프로토콜 생성
        
        <img width="455" alt="스크린샷 2023-06-01 오후 4 29 20" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/25a9a464-ea11-4c6d-8afd-07a4c202b626">
        
        - SIMD 프로토콜을 통해 벡터의 차원을 저장
        - SIMD 타입은 모든 요소를 한번에 효율적으로 계산하는 일종의 homogenous tuple
        - 기본 SIMD 타입에 Scalar SIMD에서만 작동하도록 제한하여 원하는 계산 수행 가능
        
        <img width="447" alt="스크린샷 2023-06-01 오후 4 35 02" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/02a4ca78-18b6-40ac-bd6b-6ac57e7a7103">
        
        - 프로토콜을 위와 같이 정의함으로써, 벡터에서 수행하려는 모든 작업에 대한 default implementation 구현 가능
        
        <img width="440" alt="스크린샷 2023-06-01 오후 4 36 04" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/08cee306-2738-4290-8bc9-9bbbf5317b4f">
        
        - 새로운 기능을 얻고자 하는 각 타입에 이 프로토콜에 대한 적합성을 제공하고자 함
        - “프로토콜 정의-Default Implementation-여러 타입에 적합성 추가” 프로세스에 대하여 고민 필요
            - 프로토콜이 정말 필요한 것인가?
            - 적합성 중 타입별 custom implementation이 없이 동일한 default implmentation 쓰는 건 프로토콜이 유용하지 않다는 일종의 경고 신호
    - **해결방안 1: extension**
        
        <img width="457" alt="스크린샷 2023-06-01 오후 4 39 23" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/26d8f505-4afe-4831-9265-b226a3267452">
        
        - 새 프로토콜을 작성하는 대신 동일한 제약 조건으로 기존의 SIMD 프로토콜에 직접 extension을 작성하면 더욱 효율적
            - 단일 코드 페이지에서 float을 포함하는 모든 SIMD 타입에 필요한 기능 자동 부여
            - 프로토콜이 없는 간단한 extension 접근 방식은 컴파일러에서 훨씬 빠르게 처리 가능
            - 불필요한 PWT가 없으므로 binary site가 더 작아지는 효과
        - 이러한 extension 방식은 소규모 단위에서는 효과적이나, 완전한 API 설계 시에는 확장성 문제 발생
    - **해결방안 2: struct with has-a relationship**
        
        ```swift
        // is-a relationship
        
        protocol GeometricVector: SIMD
        ```
        
        - 프로토콜 생성 목적은 기하 벡터를 정의하고 스토리지에 사용할 SIMD를 정제하기 위함이었음
        - 기하 벡터와 SIMD 타입간 관계를 다시 한 번 집중할 필요가 있음
            - **is-a 관계**
                - A는 B이다
                    - 호랑이는 동물이다
                - 추상화들 사이의 **포함 관계**
                - 하나의 클래스가 다른 클래스의 subclass 임을 의미
                - Specification
                - 상속 관계도 예시 중 하나
                - 밀접 결합
                    - 클래스 계층 구조에서 좀 더 안정적인 기반 마련 의미
                    - 상위 클래스 기능을 하위 클래스가 물려받아 사용 가능
                    - 부모 클래스 변경 시 코드 손상 위험 존재
            - **has-a 관계**
                - A는 B를 가지고 있다
                    - 학생은 연필을 가지고 있다
                    - 항공기는 모터를 가지고 있다
                - **구성(소유) 관계**
                - 하나의 오브젝트(구성된 객체, 부분/멤버 객체)가 다른 오브젝트(Composite type)에 속한다
                - 객체의 멤버 필드
                - 느슨한 결합
                    - 변경 발생시에도 구성 요소 쉽게 변경 가능(코드 손상 최소화)
                    - 더 많은 유연성 제공
        
        <img width="564" alt="스크린샷 2023-06-01 오후 4 57 41" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/233c2bc9-9174-480e-9b04-2dba5b95e091">
        
        - 벡터간 더하기 빼기는 가능하나, 곱셈은 불가능
        - 이러한 작업은 모든 SIMD 타입에서 사용 가능
        - 위와 같이, has-a 관계를 통해 구현하는 것이 더욱 합리적
        - 즉, 일반 구조체(GeometricVector) 안에 SIMD 값을 wrapping
        - 모든 FloatingPoint 타입과 다른 차원을 처리할 수 있도록, SIMD 스토리지 타입을 generic화
        
        <img width="508" alt="스크린샷 2023-06-01 오후 4 59 12" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/614a5246-62ba-4a2b-ae4f-703a4917ea23">
        
        <img width="424" alt="스크린샷 2023-06-01 오후 5 00 16" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d4656084-b6ee-4472-b20d-750f4d2c312a">
        
        - 이를 통해 extension 작성 가능
        
        <img width="389" alt="스크린샷 2023-06-01 오후 5 03 11" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8e6d14e9-d39d-4fff-a791-89a1bf3d1aa4">
        
        - 3차원 SIMD 타입에서만 정의하려는 외적 연산이 있는 경우도 SIMD3 타입만 extension을 통해 작성하면 제네릭을 여전히 사용 가능
        - 즉, 제네릭 타입이 프로토콜만큼 강력하고 확장 가능한 효과를 보여줌

- **Key Path Member Lookup**
    - **문제상황: value storage 간접 지정**
        
        <img width="510" alt="스크린샷 2023-06-01 오후 5 12 02" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/e6cd583e-2b4d-41b1-ac2e-23f6f90d7750">
        
        - x, y, z 좌표값을 얻기 위해 value storage를 통해 계속 간접 지정하고 있는 상황
        
    - **해결방안: Key Path Member Lookup**
        - Key Path Member Lookup를 사용하여 하나의 타입에서 여러 가지 연산 프로퍼티를 모두 한 번에 노출하는 single subscript 작성 가능
        
        <img width="529" alt="스크린샷 2023-06-01 오후 5 15 19" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/524023d1-10a3-4cf2-8192-c80964b13f78">
        
        - `@dynamicMemberLookup` 태그 지정
        
        <img width="492" alt="스크린샷 2023-06-01 오후 5 16 04" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8c72baed-ffe6-4e4a-8080-bd491e15225d">
        
        - 컴파일러의 special dynamic member subscript 작성하라는 메시지 표시
        - 해당 subscript는 keypath를 취함
        - subscript를 구현함으로써, key path를 통해 접근할 수 있는 모든 프로퍼티가 자동으로 GeometricVector 타입에서 연산 프로퍼티로 노출
        - SIMD Storage 타입에 대한 keypath를 가져와서 Scalar 반환하는 구조
        - 해당 기능은 Swift 5.1에 들어서 완전히 type-safe 해졌고, 훨씬 더 많은 작업이 컴파일 타임에 수행하게 되었음
        
        <img width="509" alt="스크린샷 2023-06-01 오후 5 20 38" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/a06cf9cc-8b00-4743-83c9-2b39ce529a79">
        
        - 결과 화면은 위와 같음
    - **Reference 타입의 프로퍼티에 대한 copy-on-write semantics 적용**
        - Key Path Member Lookup은 프로퍼티 전달뿐만 아니라 복잡한 로직을 subscript에 넣을 수도 있음
        
        <img width="557" alt="스크린샷 2023-06-01 오후 5 23 41" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/eae86976-40de-492f-b792-f862a298c51b">
        
        - 일전의 예시를 토대로, copy-on-write semantics를 사용하여 texture의 모든 속성을 material type의 프로퍼티로 노출하고 싶다면 key path member lookup 사용
        
        <img width="436" alt="스크린샷 2023-06-01 오후 5 24 52" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/617947c0-5f12-47b7-bb8a-8369f412df95">
        
        - `@dynamicMemberLookup` 태그 지정
        
        <img width="573" alt="스크린샷 2023-06-01 오후 5 25 26" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8d54ad0f-3859-4c30-8974-428d868d5065">
        
        - subscript 작성시, 프로퍼티를 get & set하기 위해 `ReferenceWritableKeyPath` 사용
        - texture에서 다른 타입을 가져오고 싶기 때문에, 반환 유형은 generic화
        
        <img width="577" alt="스크린샷 2023-06-01 오후 5 26 59" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d16666f0-d852-4826-ac45-5d97238eb908">
        
        - getter 와 setter은 일전에 했던것과 동일하게 구현
        - 이를 통해 one subscript method로 Material 타입에 대한 완전한 copy-on-write semantics를 사용하여 texture의 모든 single property 노출 성공

- **Property wrappers**
    - **문제상황 1: 연산 프로퍼티 코드 재사용 1**
        - Property Wrapper의 기본 아이디어는 작성한 연산 프로퍼티에서 코드를 효과적으로 재사용하기 위함에서 기원
        
        <img width="470" alt="스크린샷 2023-06-01 오후 6 06 04" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/200b870f-5e18-4210-97e6-30aab02b28ee">
        
        - 위의 예시는 프로퍼티인 image를 노출시키되(public)
        - 모든 user, client가 해당 프로퍼티에 가서 값을 write하기를 원치 않음
        - 연산 프로퍼티임과 동시에 실제 storage는 내부 imageStorage 프로퍼티에 있음
        - imageStorage 프로퍼티에 대한 접근은 getter 및 setter를 통해 제어
    - **해결방안 1: lazy 키워드 사용**
        
        <img width="415" alt="스크린샷 2023-06-01 오후 6 10 18" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/106a4449-fbe7-4747-be58-53d56a04d341">
        
        - lazy 키워드를 사용하여 위와 같이 간단히 표현 가능
    - **문제상황 2: 연산 프로퍼티 코드 재사용 2**
        
        <img width="469" alt="스크린샷 2023-06-01 오후 6 12 50" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d961834a-93cc-4617-b4e1-76e2ca663202">
        
        - 위와 유사한 경우나, getter 및 setter에서 구현되는 정책이 다름
            - get에 mutating 존재 X
            - 값이 있는경우에만 받을수있고, 없는경우는 fail
            - 이는 한 번 set하거나 read하기 전에 한 번 초기화 필요
            - 일종의 late initialization pattern
        - 위의 boilerplate를 제거하고 더욱 expressive한 API를 만들기 위해 property wrapper 등장
    - **해결방안 2: Property Wrapper 사용**
        
        <img width="629" alt="스크린샷 2023-06-01 오후 6 18 42" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/e9fbfd7b-bcc6-4716-a152-9b0ca0ff3847">
        
        - Property Wrapper는 프로퍼티를 선언한다는 개념을 포착하고 싶다는 아이디어에서 출발
        - 위의 text란 public property는 `@LateInitialized` 를 적용하여 특정 semantics와 policy를 제공
        - 코드 관점에서 볼 때 이는 `lazy`와 매우 유사 → 동일한 이점들을 제공
            - boilerplate 제거
            - 선언하는 시점에서 실제 semantics가 무엇인지 문서화
                - 복잡한 코드보다 읽기 및 추론 용이
                - LateInitialized → Lazy함과 동시에 초기화전에 사용하면 fail
        
        <img width="465" alt="스크린샷 2023-06-01 오후 6 22 28" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/c6b55997-5292-4bb4-9ef9-bf1638700538">
        
        - `@LateInitialized` 의 policy pattern은 위와 같음
        - getter와 setter 존재
            - setter에서 storage update
            - getter에서 적어도 한 번 설정했는지 확인한 다음 설정한 값을 반환
        - `@propertyWrapper` 태그 지정
        - value 프로퍼티를 가짐
            - late initialized property에 대한 모든 접근은 여기를 통과
        - 특이한 점으로 매개변수를 사용하지 않는 초기화 프로그램(`public init()`) 선언
        
        <img width="633" alt="스크린샷 2023-06-01 오후 6 27 44" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8566c307-689a-424f-b587-7379c43138bb">
        
        - 다시 예시로 돌아와, Property Wrapper를 특정 프로퍼티에 사용하면 컴파일러는 해당 코드를 **두 개의 개별 프로퍼티로 변환**
        
        <img width="618" alt="스크린샷 2023-06-01 오후 6 30 46" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/90797b93-15a8-44e7-932c-a6164ee5f0ff">
        
        1. $ prefix가 있는 백업 storage 프로퍼티 (`$text`)
            - property wrapper 타입의 인스턴스
            - 스토리지 제공
            - 앞서 보았던 `public init()` (no parameter initializer)을 호출하여 컴파일러에 의해 암시적 초기화
        2. text를 연산 프로퍼티로 변환
            - getter에서 $text에 접근하여 value를 검색
            - setter에서 $text.value에 newValue를 작성
            - 따라서, property wrapper 타입이 자체 storage를 가질 수 있지만, 로컬 또는 다른 곳에 저장하려고 함
    - **Defensive Copying (Reference Semantics and Mutable State)**
        
        <img width="462" alt="스크린샷 2023-06-01 오후 6 37 43" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/c220a3f2-60e1-46f0-970c-516095aa89fe">
        
        - 앞서 value & reference semantics를 배움으로써
        - 이제 **reference semantics와 mutable state를 다룰때, defensive copying을 수행할 것임**
        - 기본적인 패턴은 이전과 동일
            - storage, value 프로퍼티 존재
            - property wrapper에 대한 policy는 setter에 존재
                - newValue를 얻으면 value를 copy
                - NSCopying을 사용하여 copy하고 있기 때문에, 계속해서 해당 copy method 호출
        - **Defensive copy의 특이한 점은 initial value initializer 제공**
            - no parameter initializer와 동일
            - property wrapper에 포함할 필요 X
            - 그러나 있으면 이 property wrapper로 warpping된 모든 프로퍼티에 기본값 제공
        
        <img width="638" alt="스크린샷 2023-06-01 오후 6 52 42" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/f3d0d84b-dd8e-4c8e-9239-479a60ec452f">
        
        - UIBezierPath를 defensive copying하면 위와 같음
        - Initializer를 통해 path를 생성할때마다 기본값은 UIBezierPath임
            - created empty instance
        
        <img width="612" alt="스크린샷 2023-06-01 오후 6 54 28" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/209fb658-1006-46c6-afe4-a6b98eac665b">
        
        - 백업 stored property인 `$path`
            - defensive copy할 수 있도록 initialValue를 initial value initializer에 제공
        - 연산 프로퍼티 `path`
            - getter와 setter은 동일
            - $path.value를 통과할 뿐
        - 이니셜라이저에서 `storage = value.copy() as! Value` 와 같이 value가 계속 copy되고 있는데 이것이 필요없는 작업이라면?
    - **Defensive Copying (Without Copying New Instance)**
        
        <img width="617" alt="스크린샷 2023-06-01 오후 7 08 51" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/fa10f8aa-261b-4590-81f4-2f6f840ea618">
        
        - Default Value를 copy하지 않기 위하여 defensive copying에 대한 extension 작성
        - extra copy를 피하기 위해 withoutCopying 이니셜라이저를 호출해 $path에 할당
        
        <img width="563" alt="스크린샷 2023-06-01 오후 7 11 11" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/ec523543-8abb-4298-ba77-eb9c0d44cf42">
        
        - 위의 예시도 약간의 boilerplate가 있으니 위와 같이 간결화 가능
    - **API Design with Property Wrapper**
        
        <img width="614" alt="스크린샷 2023-06-01 오후 7 15 53" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/7e29d4c2-d9f1-411b-8001-775b243154e4">
        
        - Property Wrapper는 데이터에 접근하기 위해 policy들을 추상화함
        - 따라서, 데이터 저장 방법, 접근 방법을 결정할 수 있음
        - 뿐만 아니라, property wrapper와 관련하여 custom attribute syntax를 사용하여 시스템과 연결해야 함
        - Data Access 관련 Property Wrapper의 다양한 용도들
            - UserDefault
            - ThreadSpecific
            - Command Line Tool
    - **Property Wrappers in SwiftUI**
        
        <img width="618" alt="스크린샷 2023-06-01 오후 7 21 05" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/05d4d7ea-c84e-4c34-96ac-106c60f4dc65">
        
        - Data Dependency 설명
            - `@State`
                - View Local State 설명
            - `@Binding`
                - 일급 참조(first class reference)를 위한 바인딩
        - 이들을 통해 데이터가 어디에 있든 상관없이 시스템에 의해 관리됨
        - 편집이 하고 싶다면 `$` 를 사용하여 실제 binding으로 get back
        - 데이터 처리, 데이터 업데이트 감시, 데이터 저장 논리는 모두 property wrapper policy에 의해 처리
        - `$slide`
            - 백업 storage property
            - binding property wrapper를 사용했기 때문에 컴파일러가 user 대신 종합해줌
            - 그런데 binding이라 title 존재 x
            - title은 custom data model의 일부
            - **이는 Property Wrapper와 Key Path Member Lookup 기능의 조합임**
    - **Property Wrapper & Key Path Member Lookup**
        
        <img width="558" alt="스크린샷 2023-06-01 오후 7 29 30" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/e5a15750-6aca-4df1-9622-90cc2f1cc655">
        
        - generic subscript를 통해 key path member lookup 지원
        - key path는 특정 Value 타입에 기저
        - 그래서 slide와 같이 특정 entity 내의 프로퍼티에 바인딩 및 접근 가능
        - return value는 현재 추론한 그 value(`Property`)가 아닌 **특정 프로퍼티를 포커싱하고 있는 새로운 binding을 반환하여 data dependency 유지(**`Binding<Property>`**)**
        
        <img width="518" alt="스크린샷 2023-06-01 오후 7 41 44" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/37e59787-945c-4387-bc72-d85a03715fd6">
        
        - Slide 타입인 Binding되는 slide가 있다고 했을때
        - 이는 보통 value로 인식
        - slide를 참조할 수 있기 때문에 Slide 인스턴스를 얻음
        - 그리고 slide.title을 참조하여 해당 String 인스턴스를 얻을 수 있음
        
        <img width="514" alt="스크린샷 2023-06-01 오후 7 37 47" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/76644714-f130-4847-a56c-5d4d95f24f75">
        
        - $slide의 경우는 Binding된 Slide 인스턴스(`Binding<Slide>`)를 가져옴
        - $slide.title을 입력하면 Binding에 없는 프로퍼티를 찾고 있기 때문에, 컴파일러는 dynamic number subscript로 rewrite하여(`$slide[dynamicMember: \Slide.title]`) key path로 전달
        
        <img width="505" alt="스크린샷 2023-06-01 오후 7 37 57" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/02735685-3e28-4334-8f4a-b8da059f37ed">
        
        - 이러한 key path member lookup을 통해 Binding된 String 인스턴스를 얻을 수 있음
        - 정리하면, **Binding을 통해 first class reference를 전달하려면** `$` **키워드를 맨 앞에 붙여 사용**하면 됨

## 💎 요약

<img width="460" alt="스크린샷 2023-06-01 오후 7 52 59" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/8d7bceb7-a22c-4bf7-bb0e-47f352ffe1d2">
94/WWDC_Study/assets/99063327/1ad00bf8-04e2-4005-9473-8581ca01c33d">

> **Value Semantics와 Reference Semantics란 무엇이고, 각각을 사용하는 시기 및 함께 작동하게 만드는 법을 숙달하자. 다음으로 Generics와 Protocol을 통해, protocol은 매우 강력하나 코드 재사용을 위해 사용하고, Classification과 큰 계층 구조를 구축할 때에는 지양해야 한다. 마지막으로 Property Wrapper를 사용하여 Data Access에 대한 추상화 방법을 연습하자.**
> 

## 💎 참고 자료

- **Modern Swift API Design - Apple Developer**

[Modern Swift API Design - WWDC19 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/415/)

- **WWDC 19 - Modern Swift API Design - Vapor3965 Tistory**

[WWDC 19 - Modern Swift API Design](https://vapor3965.tistory.com/15)

- ****객체 지향적 관점에서의 has-a와 is-a 차이점 - Minusi Tistory****

[객체 지향적 관점에서의 has-a와 is-a 차이점](https://minusi.tistory.com/entry/객체-지향적-관점에서의-has-a와-is-a-차이점)

- **Properties - Swift Language Guide**

[프로퍼티 (Properties)](https://jusung.gitbook.io/the-swift-language-guide/language-guide/10-properties)

- **Swift: Struct vs Class - Jay Kim Medium**

[Swift : Struct vs Class (1)](https://showcove.medium.com/swift-struct-vs-class-1-68cf9cbf87ca)

- **[Objective-C] 1. Prefix와 메소드 선언, 호출 - JBee Tistory**

[[Objective-C] 1. Prefix와 메소드 선언, 호출](https://asfirstalways.tistory.com/285)
x
