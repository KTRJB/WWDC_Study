# **Protocol-Oriented Programming in Swift - 2015**

### OOP는 굉장하다!

- 캡슐화
- 접근제어
- 추상화
- 소프트웨어가 커질 때 네임스페이스를 사용해서 데이터를 구분할 수 있다?
- 여러가지 표현구문
- 확장성

### 하지만, 위의 모든 내용은 구조체로도 할 수 있다!

### 기존 객체지향은 클래스와 상속이 중요했다. 클래스는 좋지만 안좋다?

- 비용이 많이든다
    - 여기저기서 참조될 수 있다.
    - 동기화 문제가 있다.
- 단일 상속 문제 때문에 비대해진다
    - 슈퍼클래스의 모든 프로퍼티를 서브 클래스에서 받아들어야 한다.
    - 메소드들이 어떤식으로 override되고 체이닝 될지 알 수 없다
- 타입추론에서 문제가 생길 수 있다.

### 추상화를 프로토콜로 구현할 수 있다.

- Supports value types (and classes)
- Supports static type relationships (and dynamic dispatch)
- Non-monolithic
- Supports retroactive modeling
- Doesn’t impose instance data on models
- Doesn’t impose initialization burdens on models
- Makes clear what to implement

### Swift의 핵심은 프로토콜 지향이다.

- 프로토콜 + 익스텐션을 사용하면 ovveride를 대체 할 수 있다.
- 제약조건을 걸어줘서 익스텐션, 제네릭을 제한할 수 있다.

### 클래스를 사용해야 하는 부분

- 참조타입이 필요할 때?
- 인스턴스의 수명이 외부의 효과와 연결될 때
- ??
