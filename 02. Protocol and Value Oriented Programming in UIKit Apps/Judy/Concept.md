> 앱을 개선하기 위해 **값 타입**과 **프로토콜**을 사용하는 방법

---

➡️ MVC 패러다임의 맥락에서 로컬 추론이 UIKit 앱을 개선할 수 있는 방법을 알아보자

> **Local Reasoning** (로컬 추론)<br>
: 바로 앞에 있는 코드를 볼 때 나머지 코드가 해당 기능과 상호작용 방식을 생각할 필요가 없음을 의미<br>
- 유지보수, 구현, 테스트 작성을 더 쉽게 만들어 줌

<br>

## 2. Model
**모델 타입에서 값 타입이 좋은 이유**

**Class**
```swift
class Dream {
	var description: String
    var creature: Creature
    var effects: Set<Effect>
    ..
}

var dream1 = Dream(...)
var dream2 = dream1
dream2.description = "Unicorn all over"
```
- 참조 시맨틱이 있음 = 동일한 인스턴스에 대한 참조가 스토리지를 공유
- 같은 인스턴스에 대한 참조가 공유되어 값이 변할 수 있어 로컬 추론이 어려움
- 뷰 컨트롤러와 다른 타입과 관계를 맺으며 매우 복잡해질 수 있음
<br>

**Struct**

➡️ Dream을 struct로 만들어서 이 문제를 해결 가능
- 독립적인 값을 가져 하나의 값을 변경해도 다른 값은 변경되지 않음
<br>

**뷰와 컨트롤러에서 값 타입을 사용하는 방법**

모델 외에도 값 타입을 적용해서 이점을 보고싶다!

## View 

다른 곳에서도 재사용하기 위해 셀을 `DecoratingLayoutCell`이라는 **UITableViewCell**의 추상 하위 클래스로 작성하고, `DreamCell`로 구체적인 하위 클래스를 만들었다고 해보자.

> UIView -> UITableViewCell -> DecoratingLayoutCell -> DreamCell


```swift
class DecoratingLayoutCell: UITableViewCell {
	var content: UIView
    var decoration: UIView
    
    // Perform layout
}
```

다른 셀에서 레이아웃을 재사용하는 데는 도움이 될 수 있지만 테이블 뷰 외부에서 사용하기는 어려움
<br>

> 🤔 레이아웃을 테이블 뷰 셀과 함께 사용하면서 뷰에서도 사용할 수 있는 구조는 없을까?

```swift
struct DecoratingLayout {
	var content: UIView
    var decoration: UIView
    
    mutating func layout(in rect: CGRect) {
    	// Perform layout
    }
}
```
- 레이아웃 로직을 호출할 수 있는 메서드를 배치
- 레이아웃 수행 방법을 알고 있는 고립된 코드 조각 완성 ⭐️
<br>

```swift
class DreamCell: UITableViewCell {
	...
    
    override func layoutSubView() {
    	var decoratingLayout = DecoratingLayout(content: content, decoration: decoration)
        decoratingLayout.layout(in: bounds)
    }
}
```
- 구조체를 사용하여 드림셀을 업데이트할 수 있음
- 로직이 **UITableVeiwCell**에서 분리되었기 때문에 모든 **UIView**에서 사용 가능!
- 레이아웃을 따로 사용할 수 있으므로 단이 테스트 용이
	- 테이블뷰를 만들거나 콜백을 기다릴 필요 없음
- 레이아웃이 작고 집중적 = 로컬 추론이 쉬워짐
<br>

> 🤔 다른 타입에서도 사용하고 싶은데 UIView의 하위 클래스가 아니라 공통 슈퍼클래스가 없네?

이 레이아웃이 하는 유일한 일은 프레임 설정뿐 -> 프로토콜 요구사항으로 가지게 하자!

```swift
struct DecoratingLayout {
	var content: Layout
    var decoration: Layout
    
    mutating func layout(in rect: CGRect) {
    	// Perform layout
    }
}

protocol Layout {
	var frame: CGRect { get set }
}

extension UIView: Layout {}
extension SKNode: Layout {}
```
~> 레이아웃이 더 이상 **UIKit**에 종속되지 않음
<br>

### Generic
문제) content와 decoration이 다른 타입을 가질 수 있음 (ex. `content: UIVIew, decoration: SKNode`)
➡️ 제네릭을 사용

```swift
struct DecoratingLayout<Child: Layout> {
	var content: Child
    var decoration: Child
    ...
}
```

> **Generic Type**
- 코드의 타입을 더 많이 제어할 수 있음
- 컴파일러가 코드에 대한 더 많은 정보를 갖게 됨 = 최적화

<br>

> 🤔 비슷한 다른 레이아웃을 가지고 싶으면 어떻게 할까

이전에는 **상속**을 사용했지만 수퍼클래스의 작업과 서브클래스가 재정의할 수 있는 작업을 모두 고려해야 함
-> 앱 전체에 분산되어 있는 많은 양의 코드를 함께 가져와야 함
-> 대부분 UIView와 같은 프레임워크 클래스에서 상속하고 많은 코드가 있음
-> 상속은 로컬 추론 능력을 저하시킴
<br>

### Composition of Value
> 코드를 재사용하거나 일부 동작을 사용자 지정해야 할 때 사용

- 클래스의 인스턴스는 비용이 크다 (힙 할당, 그리기 및 이벤트 처리같은 필요한 많은 작업이 있음)
- 구조체는 매우 가벼움 + 값 타입은 복사에 대한 수정 걱정이 없어 조각을 사용하기 용이

```swift 
protocol Layout {
	mutating func layout(in rect: CGRect)
}

extension UIView: Layout {...}
extension SKNode: Layout {...}

struct DecoratingLayout<Child: Layout, ...>: Layout {...}
struct CascadingLayout<Child: Layout, ...>: Layout {...}

let decoration = CascadingLayoutLayout(children: accessories)
var composedLayout = DecoratingLayout(content: content, decoration: decoration)
composedLayout.layout(in: rect)
```
<br>

### associatedtype
서브뷰들이 올바른 순서로 배치되도록 하려면

```swift 
protocol Layout {
	mutating func layout(in rect: CGRect)
    associatedtype Content
    var contents: [Content] { get }
}

struct DecoratingLayout: Layout {
	...
    typealias Content = UIView
}
struct CascadingLayout: Layout {
	...
    typealias Content = SKNode
}

```
**UIView** 또는 **SKNode**로 혼합될 수 있으므로 **associatedtype**을 사용
associatedtype은 type placeholer로 준수하는 타입이 구체적인 타입을 선택해서 사용하도록 함


```swift 
struct DecoratingLayout<Child: Layout, Decoration: Layout
						where Child.Content == Decoration.Content> : Layout {
	var content: Child
    var decoration: Decoration
    
    typealias Content = Child.Content
}
```

> UIView 대신 Layout을 사용하는 단위 테스트 가능
Layout은 간단한 구조체에 프레임을 설정 
-> 테스트가 UIView와 완전히 분리되어 있고, 자체 레이아웃 및 테스트 논리에만 의존함을 의미

<br>

## 2. Controller
앱의 실행 취소 기능
(Dream에 대한 실행취소 기능은 구현했지만 FavoritCreature에 대한 실행 취소를 구현하지 않은 버그 상황)

FavoritCreature와 관련된 실행 취소 구조를 추가할 수 있지만 다른 코드 경로 추가로 유지보수의 어려움 발생
<br>

### Model 분리
```swift
class DreamListViewController: UITableViewController {
	//var dreams: [Dream]
    //var favoritCreature: Creature
--> var model: Model 
}

struct Model: Equatable {
	var dreams: [Dream]
    var favoritCreature: Creature
}
```

모델과 뷰 업데이트 사이의 대응 관계를 추론할 수 있는 곳이 하나도 없던 문제
-> 작은 변경 사항을 기록하는 대신 완전히 새로운 모델, 새로운 값이면 모델에서 실행 취소 수행이 간단
= UI를 업데이트하기 위한 단일 코드 경로가 있고, 작업은 순서 독립적이 됨
= UI 업데이트 코드에 대한 로컬 추론에 도움
<br>

### UIState
공유하기 위해 선택 상태로 변경했다가 취소 했지만 선택 상태에서 일부 속성이 지워지지 않는 상황
(상새 변경 중에 일부 상태 속성이 완전히 지워지지 않는 상황)

Enum은 상호 배타적인 값에 완벽 ❕
```swift
class DreamListViewController: UITableViewController {
	//var isInViewingMode: Bool
    //var sharingDreams: [Dream]?
	//var selectedRows: IndexSet?
    // -> UI State
    
    var state: State
    ...
}

enum State {
	case viewing
    case sharing(dreams: [Dream])
    case selecting(selectedRows: IndexSet)
}
```
중간 상태의 존재 가능성 없이 상태가 한 번에 모두 변경됨을 의미
<br>

## 결론 
> 
**1. 상속 대신 Composition을 이용한 사용자화**<br>
	- 상속 대신 composition으로 해결하는 방법 생각해보기<br>
**2. 프로토콜의 generic과 재사용 가능한 코드**<br>
	- 프로토콜에서 제네릭과 재사용 가능한 코드를 적용해 로컬 추론과 테스트하기 쉬운 작은 구성 요소 만들기<br>
**3. 값 타입의 장점**<br>
	- 값 타입으로 구성된 값인 경우 더 큰 값도 의미가 있다<br>
**4. 로컬 추론**<br>
	- 코드가 로컬 추론을 얼마나 잘 지원하나 생각해보자
    
<br>

---

[Protocol and Value Oriented Programming in UIKit Apps](https://developer.apple.com/videos/play/wwdc2016/419/)
