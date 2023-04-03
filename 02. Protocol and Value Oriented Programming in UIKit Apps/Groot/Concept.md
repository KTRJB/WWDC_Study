# ****Protocol and Value Oriented Programming in UIKit Apps - 2016****

## MVC 구조에 프로토콜 지향 프로그래밍 적용하기

### 1. MVC에서 Model

- Model 을 클래스로 사용 시 참조 문제로 인해 복잡한 관계가 생겨서 원하지 않는 수정이 발생할 수 있다.
- 구조체로 변경하면 이러한  문제를 해결할 수 있다.

### 2. MVC에서 View

- 클래스로 구현한 cell의 레이아웃 부분을 구조체로 분리하기

```swift
class DecoratingLayoutCell: UITableViewCell {
  var content: UIView
  var decoration: UIView
  // Perform layout
}
```

```swift
레이아웃을 구현하는 방법만 알고있는 코드 

struct DecoratingLayout {
  var content: UIView
  var decoration: UIView

  mutating func layout(in rect: CGRect) {
    // Perform layout
  }
}

class DreamCell: UITableViewCell {
  // ...
  override func layoutSubviews() {
    var decoratingLayout = DecoratingLayout(content: content, decoration: decoration)
    decoratingLayout.layout(in: bounds)
  }
}
```

- 이 코드를 사용한 테스트 방법
    - 레이아웃을 따로 사용할 수 있으므로 단위 테스트를 작성하기에 좋다.

```swift
func testLayout() {
  let child1 = UIView()
  let child2 = UIView()

  var decoratingLayout = DecoratingLayout(content: content, decoration: decoration)
  decoratingLayout.layout(in: CGRect(x: 0, y: 0, width: 120, height: 40))

  XCTAssertEqual(child1.frame, CGRect(x: 0, y: 5, width: 35, height: 30))
  XCTAssertEqual(child2.frame, CGRect(x: 35, y: 5, width: 70, height: 30))
}
```

- 레이아웃을 여러개로 구현하기 위한 방법?
    - 프로토콜을 사용해서 추상화하고, 슈퍼클래스 대신 익스텐션을 활용해서 다형성을 사용하자.
    - 또 다른 이점은 DecoratingLayout이 더 이상 UIKit 또는 SpriteKit에 대한 종속성을 필요로 하지 않으므로 동일한 시스템을 AppKit에 쉽게 가져와서 NSView의 레이아웃을 지원할 수 있다는 것
    
    ```swift
    protocol Layout {
      var frame: CGRect { get set }
    }
    
    struct DecoratingLayout {
      var content: Layout
      var decoration: Layout
    
      mutating func layout(in rect: CGRect) {
        content.frame = ...
        decoration.frame = ...
      }
    }
    
    extension UIView: Layout {}
    extension SKNode: Layout {}
    ```
    

### **Generic types**

- 제네릭을 사용하는 방법으로 뷰에서 DecoratingLayout을 사용할 때 모든 콘텐츠를 하위 뷰로 추가할 수 있도록 만들자

```swift
struct DecoratingLayout<Child: Layout> {
  var content: Child
  var decoration: Child
  mutating func layout(in rect: CGRect) { ... }
}
```

- 제네릭의 좋은점
    - 유형에 대한 더 많은 제어 권한을 제공.
    - 컴파일러는 우리가 하는 일에 대한 더 많은 정보를 가지고 있기 때문에 컴파일 타임에 더욱 최적화될 수 있다.

### 코드 공유

- 만약 DecoratingLayout와 비슷한 CascadingLayout을 구현해야 한다면 상속의 방법이 있다. 하지만 단점이 많다.
    - 슈퍼클래스가 무엇을 하고 있는지, 어떤 서브클래스가 변경하거나 재정의하기를 원하는지 고려해야함.
    - 일반적으로 UIView와 같은 프레임워크 클래스에서 상속해야 하며 거기에는 고려해야 할 더 많은 코드가 있다.
- 더 나은 솔루션은 **Composition**, 즉 작은 조각을 결합하여 더 큰 조각을 만드는 것
- 캐스케이딩을 처리하는 UIView와 데코레이팅 레이아웃 동작을 처리하는 DecoratingLayout을 사용하여 CascadingLayout을 작성할 수 있다. 그런 다음 이 둘을 UITableViewCell의 하위 View로 추가할 수 있다.
    - 하지만, 새 클래스의 인스턴스는 비용이 크다. 특히 View는 더 큼.

### **Composition of value types**

- 코드를 분리해서 나누지만, 타입을 값 타입으로 하는 것이 좋다.
    - 구조체는 비용이 작다
    - 값 표현은 캡슐화가 더 잘되기 때문에 복사본의 수정에 대해 걱정하지 않아도 된다.

```swift
struct CascadingLayout<Child: Layout> {
  var children: [Child]
  mutating func layout(in rect: CGRect) {
    ...
  }
}

struct DecoratingLayout {
  var content: Layout
  var decoration: Layout

  mutating func layout(in rect: CGRect) {
    content.frame = ...
    decoration.frame = ...
  }
}
```

- 하지만, 이렇게 구현하면 레이아웃은 UIView, SKNode 인 자식만 가질 것으로 예상된다. (frame 때문인듯)
- 현재 레이아웃 프로토콜에는 프레임 속성이 필요하지만 프레임만 설정, 하위 뷰에 프레임이 있는지 여부는 실제로 신경 쓰지 않는다.
- 레이아웃을 사용하고 함께 구성할 수 있도록 이를 일반화하자.

```swift
protocol Layout {
  mutating func layout(in rect: CGRect)
}
```

### **Associatedtypes**

- **Associatedtypes을 사용해서 프로토콜에서 사용할 타입(**contents)**을 명확하게 정해줄 수 잇다.**

```swift
protocol Layout {
  mutating func layout(in rect: CGRect)

  associatedtype Content
  var contents: [Layout] { get }
}

struct DecoratingLayout<Child: Layout>: Layout {
  // ...
  mutating func layout(in rect: CGRect) { ... }

  typealias Content = Child.Content
  var contents: [Content] { get }
}
```

### **Heterogeneous layouts**

- layout 프로토콜에 대해 모든 콘텐츠가 동일한 유형을 갖을 수 있도록 조건을 붙여줄 수 있다.

```swift
struct DecoratingLayout<
  Child: Layout, Decoration: Layout where Child.Content == Decoration.Content
>: Layout {
  var content: Child
  var decoration: Decoration

  mutating func layout(in rect: CGRect) { ... }

  typealias Content = Child.Content
  var contents: [Content] { get }
}
```

### 완성된 프로토콜

```swift
protocol Layout {
  mutating func layout(in rect: CGRect)

  associatedtype Content
  var contents: [Content] { get }
}
```

### 정리

1. 값 유형으로 로컬 추론 개선
2. 빠르고 안전한 다형성을 위해 generic 유형 사용
3. Composition of values 은 복잡한 동작을 사용자 지정/구축할 수 있는 좋은 방법

### 3. MVC에서 **Controller**

- 실행 취소 오류분석
    - 컨트롤러에서 여러가지 모델을 사용하면 각각 취소를 구현해줘야 해서 버그가 생길 수 있다.
    - 두개의 모델을 하나의 값타입 모델로 구현하자
    - 하나의 모델을 사용함으로써 상태의 변화를 관리하기가 쉽다.
    - 로컬 추론이 쉽다.
- View의 상태를 enum으로 관리하자
    - view의 상태를 관리하는 프로퍼티를 나누게 되면 모든 상태를 관리하기가 어렵다.
    - enum을 사용하면 동시에 발생할 수 없는 상태를 관리하기에 좋다.
    
    ### 결론
    
    - 값 유형을 활용하기 위해 상속 대신 composition을 시도
    - 일반적이고 재사용 가능하며 테스트 가능한 코드를 위한 프로토콜 사용
    - 로컬 추론(코드를 이해하기 위해 다른 코드를 찾지 않고, 바로 그 코드의 자리에서 이해하는 것)은 모든 프로그래밍 작업에 정말 중요
        - 로컬 추론에는 값 유형이 도움을 준다.
