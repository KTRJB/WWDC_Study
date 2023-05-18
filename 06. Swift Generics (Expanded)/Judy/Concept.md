## 배경
> - 4.2 릴리즈 시점
> - Swift에선 Generic을 이용해서 표현력을 향상시켰음

<br>

### 오늘 소개할 제네릭 기능
> 1. What are generics?
> 2. Protocol design
> 3. Protocol inheritance
> 4. Conditional conformance
> 5. Classes and generics

<br>

## 1. What are generics?
예시로 표준 라이브러리의 Array와 유사한 `Buffer`라는 타입을 들어보자.

```swift
struct Buffer { 
	var count: Int
    
	subscript(at: Int) -> ??? { 
    	// get/set from storage
	} 
}
```

`???` - 인덱스에 대한 반환 타입을 뭐로 해야할까?
<br>

### Any
- Any = 다른 종류의 타입을 대신할 수 있는 유형
- 어떤 타입이든 사용할 수 있게 됨

#### Any 사용 시 문제
```swift
var words: Buffer = ["subtyping","ftw"] 
// I know this 	array contains strings
words[0] as! String
// Uh-oh, now it doesn’t!
words[0] = 42
```
- 실제로 사용할 때 특정 타입으로 캐스팅 해야 함 -> 불쾌한 사용자 경험
- 실수로 다른 타입을 넣은 경우 오류 발생 가능성
- 추적, 박싱 및 언박싱 하는데 많은 오버헤드 발생
- 들어오는 타입에 따라 때때로 간접 참조를 사용해야 함
- 어떤 타입을 사용하고 싶은지 컴파일 단계에서 명확하게 표현할 수 없음 -> 유연성 👎

➡️ 사용 편의성과 정확성 그리고 성능상의 이유로 해결하고자 함
<br>

## Parametric Polymorphism
Swift에서 제네릭이라고 부르는 다른 용어
<br>

### Buffer에 제네릭 적용
Any 대신에 `Element`라는 이름으로 타입 매개변수를 정해주자
> 타입의 제네릭 매개변수 이므로 매개변수 다형성(Parametric Polymorphism)이라는 용어를 가짐

```swift
struct Buffer { 
	var count: Int
    
	subscript(at: Int) -> Element { 
    	// get/set from storage
	} 
}

var words: Buffer<String> = ["generics","ftw"]
words[0]
```

#### 장점
- Any처럼 모든 타입에 사용 가능
- 타입 캐스팅 불필요
- 다른 타입을 넣으려고 하면 바로 컴파일 에러
- 컴파일 시점에 타입을 알기 때문에 오버해드 없이 인접한 메모리 블록에 모든 요소를 유지 가능
<br>

### 최적화
덧셈하는 메서드를 Buffer에 추가하고 싶다!
```swift
extension Buffer {
	func sum() -> Element {
		var total = 0
		for i in 0..<self.count {
			total += self[i]
		}	
		return total
	}
}
```
⚠️ 모든 타입에서 가능하지 않기 때문에 컴파일 에러 발생

이 방식을 사용하려면 Element가 가져야 하는 조건을 컴파일러에게 더 많이 알려야 함

#### 해결 방법
1. 가장 쉬운 방법 = Int와 같은 타입으로 제한하기
```swift
extension Buffer where Element == Int {
```

2. Double이나 Float도 사용하고 싶을 수 있으니 프로토콜을 준수하도록 설정
```swift
extension Buffer where Element : Numeric {
```
<br>

## 2. Designing a Protocol
### 공통 기능을 모두 캡처하는 프로토콜 만들기
ex) Buffer, Array, Data, String, Dictionary..

#### 1) 몇 가지 구체적인 유형으로 시작한 다음 프로토콜로 통합 시도
```swift
protocol Collection {

}
```
- 이 들의 공통점이 무엇인가? -> Element를 가짐
<br>

#### 2) associatedtype을 이용
```swift
protocol Collection {
	associatedtype Element
}
```
- associatedtype을 이용해 Element 표현
<br>

#### 3) subscript 연산 추가
```swift
protocol Collection { 
	associatedtype Element
	associatedtype Index 

	subscript(at: Index) -> Element
	func index(after: Index) -> Index 
	
    var startIndex: Index { get }
	var endIndex: Index { get } 
}
```
- Array 같은 경우에는 첨자를 Int로 제한하여 간단하게 구현할 수 있지만 Dictionary와 같은 경우에는 복잡한 구현이 필요
- Dictionary는 순서가 없기 때문에 Index로부터 다음 Index를 구할 수 있도록 구현
<br>

#### 4) 컬렉션의 요소 수를 구하는 count 프로퍼티 추가
![](https://velog.velcdn.com/images/juyoung999/post/d527f9a3-6841-47b7-8002-b8bd062e9dd1/image.png)

- Collection을 start부터 end까지 이동하며 개수를 구함
-> count를 구하기 위해서는 Index를 비교할 수 있어야 함
```swift
extension Collection where Index: Equatable 
```
- 사용하기 쉬운 프로토콜을 위해 Collection이 아닌 Index가 준수하도록 지정
```swift
protocol Collection {
	associatedtype Element
	associatedtype Index : Equatable
}
```
- 사용자 지정을 사용하여 count를 최적화로 구하는 방법
	- 이미 존재하는 count를 사용하자 -> 프로토콜에 요구사항으로 작성해야 함
	- 이미 구현이 되어 있기 때문에 채택하여 따로 구현할 필요는 없음
    
> 프로토콜에 요구사항을 추가하고 extension을 통해 기본 구현을 추가하는 것을 사용자 정의 지점(Customization Points)이라고 함
> -> 클래스의 상속 및 override와 동일한 이점을 얻을 수 있는 강력한 방법
> -> 상속과 달리 Enum과 Struct에도 적용 가능 👍

<br>

## 3. Protocol Inheritance
때로는 타입을 분류하기 위해 단일 프로토콜 이상이 필요

프로토콜 상속은 Swift 시작부터 있었음

### 추가로 구현하고 싶은 알고리즘
- `lastIndex(where:)` - 마지막 요소를 얻고 싶을 때 뒤에서부터 하면 되지만 그럴 수 없음
- `suffle` - 임의로 섞고 싶을 때 mutation이 필요하고 그럴 수 없음

Collection 프로토콜이 잘못된 것이 아니라 이러한 알고리즘을 하기 위해서는 많은 것이 필요하며 이것이 **프로토콜 상속**의 요점
<br>

### BidirectionalCollection
```swift
protocol BidirectionalCollection: Collection {
	func index(before idx: Index) -> Index 
}
```
**BidirectionalCollection** = Collection을 상속받은 프로토콜 
- BidirectionalCollection을 준수하는 타입은 Collection 역시 준수
- BidirectionalCollection에는 뒤로 이동할 수 있는 요구사항을 추가
- 모든 Collection이 추가 알고리즘을 사용할 수 있는 것은 아님 -> 알고리즘을 구현한 특수한 프로토콜을 구현
<br>

### Fishser-Yates Shuffle
> #### Shuffle 과정
> 1) 첫 번째 요소에 대한 인덱스로 시작
> 2) 첫 번째 이후에서 임의의 다른 인덱스를 선택
> 3) 이 두 요소를 교환
> 4) 두 번째(그 다음 요소) 인덱스를 선택하고 교환
> 5) 마지막 요소까지 위 과정을 반복


```swift
extension ShuffleCollection { 
	mutating func shuffle() {
		let n = count
		guard n > 1 else { return }
		for (i, pos) in indices.dropLast().enumerated() {
			let otherPos = index(startIndex, offsetBy: Int.random(in: i..<n)) // 시작 인덱스부터 특정 위치의 인덱스를 얻는 작업
			swapAt(pos, otherPos) // 두 인덱스 위치를 교환하는 작업 
        }
	} 
}
```
- `ShuffleCollection`이라는 새로운 타입을 만들지 말자

<br>

### 프로토콜 상속 장점
하나의 알고리즘을 표현하는 프로토콜을 만들면 의미없는 프로토콜이 많아지게 됨

- shuffle()은 랜덤 접근 가능 + mutating 함
- 두 개를 별도의 프로토콜로 추출할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/87382dba-aec9-4ca9-a728-ab22248746f0/image.png)

`RandomAccessCollection` - 인덱스를 빠르게 이동하면서 컬렉션을 건너뛸 수 있게 함
`MutableCollection` - 임의 접근을 제공

```swift
extension RandomAccessCollection where Self: MutableCollection {
	mutating func shuffle() {
		// 알고리즘 구현
	} 
}
```
➡️ **RandomAccessCollection**이 **MutableCollection**을 준수하게 하면 `shuffle` 알고리즘을 구현할 수 있음
<br>

### Collection 프로토콜의 계층
준수하는 타입이 많고 제네릭 알고리즘이 많으면 프로토콜 계층 구조가 형성됨

![](https://velog.velcdn.com/images/juyoung999/post/3fce8ed0-2806-4bf2-aa7b-de2bf93923e4/image.png)

이러한 계층구조가 너무 크거나 너무 세분화되어도 안됨

- 프로토콜 계층 구조에서 아래에서 위로 갈수록 요구사항이 더 적은 프로토콜
- 반대로 위에서 아래로 갈수록 고급 기능이 필요한 복잡하고 전문화된 알고리즘을 구현
<br>

## 4. Conditional Conformance
Swift의 새로운 기능

### Slice
컬렉션에 대해 특정 인덱스 범위로 slice를 만들 수 있음
```swift
struct Slice<Base: Collection>: Collection { ... }
```
Slices는 제네릭 어댑터 타입 -> 기본 컬렉션에서 수행할 수 있는 작업을 Slice에 수행할 수 있다

#### 문제
반드시 Slice가 **BidirectionalCollection**이라는 보장이 없기 때문에 `lastIndex(before:)`를 사용할 수 없음

#### 해결
- Sllice가 **BidirectionalCollection**을 준수하도록 확장
![](https://velog.velcdn.com/images/juyoung999/post/e10b95eb-4669-4dcc-8718-43bd7eb655f1/image.png)
- `index`가 없는데? -> Slice가 아닌 **Base**가 **BidirectionalCollection**을 준수하도록 변경

➡️ 이것이 **Conditional Conformance**
<br>

### 표준 라이브러리에서 Conditional Conformance을 적용한 예시
#### Ranges
typealias는 Range를 셀 수 있게 만드는 모든 추가 요구사항을 적용
기본 Range 타입의 대체 이름일 뿐

다루고 있는 타입 세트를 단순화하는 데 도움
Range와 같은 기존 핵심 타입을 보다 구성 가능하고 유연하게 만듦
<br>

## Recursive Constraints
> 프로토콜과 관련 타입(associatedtype) 간의 관계를 설명

동일한 프로토콜을 언급하는 프로토콜 내의 제약
```swift
protocol Collection { 
	// ...
	associatedtype SubSequence: Collection 
}.
```
**SubSequence** 자체가 **Collection**

왜 이런게 필요할까? 🧐
<br>

### Insertion into a Sorted Collection
➡️ 정렬된 컬렉션에서 정렬을 유지하며 새 값을 삽입할 인덱스 찾기

삽입 지점 찾기는 `이진 탐색`으로 구현됨
- 이진 탐색은 고전적인 **분할 정복 알고리즘** 

> **분할 정복 알고리즘** 
각 단계에서 문제 크기를 줄일 수 있는 결정을 내려 빠른 속도로 찾음

<br>

#### 이진 탐색 알고리즘
>1) 중간 값을 삽입하려는 값과 비교
2) 삽입 하려는 값이 더 크다면 절반 후반부에서 다시 검색 (만약 작다면 전반부)
3) 적절한 삽입 지점을 찾을 때까지 계속해서 반으로 나누며 반복

<br>

#### 이진 탐색 알고리즘 코드에서의 문제
```swift
extension RandomAccessCollection where Element: Comparable { 
	func sortedInsertionPoint(of value: Element) -> Index {
		if isEmpty { return startIndex }
		let middle = index(startIndex, offsetBy: count / 2) // 중간 요소의 인덱스를 찾기
		if value < self[middle] { // 중간 값 앞에 오는지 확인
			return self[..<middle].sortedInsertionPoint(of: value)
		} else {
			return self[index(after: middle)...].sortedInsertionPoint(of: value) // 크다면 중간 뒤의 인덱스에서 컬렉션 Slice를 가져와서 다시 재귀적으로 호출
        }
	} 
}
```

- `self[index(after: middle)...]`에서 일부 컬렉션은 Slice 타입을 원하지 않을 수 있음
- ex) **String**은 Slice가 아닌 **Substring**이 반환됨
<br>

### Slicing을 Collection에 적용하기
슬라이싱 작업 = Range 범위의 새로운 인스턴스를 반환

컬렉션을 준수하는 다양한 타입 간의 변형을 캡처하기 위해 컬렉션 프로토콜에 새로운 요구사항을 도입할 수 있다

```swift
extension Collection {
	subscript (bounds: Range<Index>) -> Slice<Self> {
		return Slice(base: self, bounds: bounds) 
    }
}

--->

protocol Collection { 
	// ...
	associatedtype SubSequence
	subscript (range: Range<Index>) -> SubSequence { get }
}
```

슬라이싱을 제공하는 `subscript`를 컬렉션 프로토콜의 요구 사항으로 가져옴

=> String과 Range 모두 요구사항을 충족할 수 있음
- String - `typealias SubSequence = Substring`
- Range - `typealias SubSequence = Range<Bound>`
<br>

#### associatedtype의 기본값과 기본 구현
```swift
protocol Collection { 
	// ...
	associatedtype SubSequence = Slice<Self>
	subscript (range: Range<Index>) -> SubSequence { get } 
}

extension Collection {
	subscript (bounds: Range<Index>) -> Slice<Self> {
		return Slice(base: self, bounds: bounds) 
    }
}
```
SubSequence를 사용하지 않으려는 다른 컬렉션의 경우 Slicing의 기본 구현을 제공할 수 있음
- associatedtype은 기본값을 가질 수 있음
- 모든 컬렉션에서 따로 구현하지 않아도 슬라이싱을 사용할 수 있게 됨
<br>

```swift
extension Collection where Self.SubSequence == Slice<Self> {
```
where 절을 통해 기본 구현의 적용 가능성을 제한할 수 있음
- 기본 SubSequence 타입을 선택한 경우 기본 슬라이싱 `subscript` 사용
- 기본 구현이 SubSequence를 사용자 지정 Collection 타입에 대한 오버로드로 표시되는 것을 방지 ex) String, Range
- 기본 구현인 슬라이싱을 받거나 원하는 경우 custom해서 사용할 수 있음
<br>

### SubSequence 측면에서의 sortedInsertionPoint 알고리즘
우리의 목표는 컬렉션 프로토콜에 대한 분할 정복 알고리즘 작성하기

재귀적인 알고리즘
```swift
extension RandomAccessCollection where Element: Comparable { 
	func sortedInsertionPoint(of value: Element) -> Index {
		if isEmpty { return startIndex }
		let middle = index(startIndex, offsetBy: count / 2) 
		if value < self[middle] { 
			return self[..<middle].sortedInsertionPoint(of: value)
		} else {
			return self[index(after: middle)...].sortedInsertionPoint(of: value) 
            // -> SubSequence인 Slice 형성
            // 이후 해당 Slice에서 삽입 지접을 재귀적으로 호출
            // (1) 반환된 SubSequence 타입이 Collectin인 경우에만 의미가 있음
            // (2) 사용하는 Element도 동일해야 함
            // (3) 결과로 반환되는 인덱스 역시 현재 Collection에서 유효한 인덱스여야 함
        }
	} 
}
```

![](https://velog.velcdn.com/images/juyoung999/post/71018ae5-cc18-4d44-8d25-ae159dc8a845/image.png)

1) **Collection**의 **SubSequence** 자체가 **Collection**이도록 제약
- 이것이 재귀 제약 조건(Recursive Constraints)
- associatoedtype이 자체 프로토콜인 Collection을 준수

2) **SubSquence의 Element**가 **Collection의 Element**와 같도록 제약
3) **Index** 역시 같도록 제약
<br>

SubSequence의 SubSequence도 가능해짐 -> `SubSequence의.SubSequence의.SubSequence의...` 
- 무한으로 가능? ㅇㅇ 가능 -> 런타임 시점에 종료만 되면 괜찮음
- 분할 정복 알고리즘을 비재귀적으로 만들어 효율적으로 구현할 경우도 많음
<br>


### 비재귀적 분할 정복 방법
![](https://velog.velcdn.com/images/juyoung999/post/1361a6df-152a-4131-af17-5256d61e3285/image.png)

- while 루프를 사용하여 반복
- 하지만 **SubSequence**에 **SubSequence.SubSequence**를 할당하는데 동일하다는 보장이 없음
-> **String**과 같이 SubSequence 타입이 다른 경우는 불가
<br>

#### Slicing 어댑터가 동작하는 방법
Slice의 Slice를 새롭게 적용하는 것이 아닌 같은 Index를 사용하므로 새로운 Index를 적용하는 방식

> **방식 1)** Slice의 [i, j] -> Slice.Slice의 [i2, j2] -> Slice.Slice.Slice의 [i3, j3] ... ❌
> **방식 2)** Slice의 [i, j] -> Slice의 [i2, j2] ✔️

- 재귀를 효과적으로 묶을 수 있음
- **SubString** 방식과 동일하여 적용 가능
<br>

### Protocol Inheritance
Collection이어야 한다고는 했지만 `index(offsetBy:)` 작업을 하려면 **RandomAccessCollection**이어야 함
```swift
protocol BidirectionalCollection: Collection
	where SubSequence: BidirectionalCollection {
// ...
}
 
protocol RandomAccessCollection: BidirectionalCollection 
	where SubSequence: RandomAccessCollection {
// ...
}.
```

![](https://velog.velcdn.com/images/juyoung999/post/e192e9f8-9392-480c-bb56-db7ceffb84d2/image.png)

재귀 제약 조건(Recursive Constraints)과 조건부 적합성(Conditional conformance)은 모두 **프로토콜 계층 구조**를 추적하는 경향이 있음

associatedtype 기본값이 계층 구조 내의 모든 프로토콜에 대해 작동하는 이 방법은 응집력 있는 디자인의 좋은 예시

associatedtype 및 where 절을 함께 사용하면 분할 정복 알고리즘을 일반 코드로 자엽스럽게 표현하는 요구사항을 작성하는 데 도움
<br>

## 5. Generics and Classes
Swift는 **다중 패러다임 언어**

Swift는 OOP도 지원 => 제네릭과 클래스의 상호 작용에 대해 알아보자

### 상속
![](https://velog.velcdn.com/images/juyoung999/post/368e5316-48ee-4e91-9bdf-607e499469f2/image.png)

> **Vehicle** - 상위 클래스
> **Taxi**, **PoliceCar** - Vehicle을 상속받은 하위 클래스
> drive() - 상위 클래스의 메서드

- 상위 클래스를 상속하여 하위 클래스에서도 상위 클래스의 메서드를 호출할 수 있음 -> `리스코프 치환 원칙`

> 리스코프 치환 원칙 
> _상위 클래스는 상위 타입을 참조하는 하위 클래스로 대체할 수 있어야 한다_

<br>

### Generic
![](https://velog.velcdn.com/images/juyoung999/post/1ab340e2-cf55-4135-8fc7-0d9bdc7d15a4/image.png)
 
> **Drivable** - 프로토콜
> **Vehicle** - Drivable 채택
> sundayDrive() - Drivable의 기본 구현 메서드


**Drivable**을 채택한 타입이 `drive`를 지원하고 `sundayDrive()`를 사용할 수 있음
<br>

### 하위 클래스에 요구 사항을 구현해야 하는 경우
하위 클래스에서 새로운 요구 사항을 추가하는 경우가 있음 -> **initializer**

![](https://velog.velcdn.com/images/juyoung999/post/acf21c7b-51ee-4898-b422-ace0667bbb53/image.png)

1) 왜 **Self**를 사용할까?
- static 메서드를 사용하는 것과 동일한 이유
- **Vehicle**이 아닌 **Vehicle**을 준수하는 타입
- [Self vs self](https://www.hackingwithswift.com/example-code/language/self-vs-self-whats-the-difference)


2) 구현 방법
- 디코딩 가능한 타입의 인스턴스를 반환하기 위해 **self**의 `init`을 호출
`* self -> 해당 타입의 인스턴스`
<br>

![](https://velog.velcdn.com/images/juyoung999/post/0f1e5105-9e43-4507-acf3-3aec4fd8c085/image.png)

상속되면서 다른 init을 호출하게 될 수도 있는거 아닌가? 🧐

**Vehicle** protocol을 채택하는 시점에서 `init` 구현 문제를 알려줌 
-> `required`로 표시하고 모든 하위 클래스에서 구현되어야 함
<br>

### Final Classes
> **final** 
> 현재 클래스가 상속되지 않음을 의미를 나타내는 키워드

하위 클래스가 없음을 알기에 `required`을 붙일 필요 없음

- 규칙에서 자유롭기 때문에 상속 매커니즘을 사용할 필요가 없다면 final을 적용하는 것이 좋음
- 시스템과 상호 작용을 단순화할 수 있으며 런타임 시 컴파일러에 대한 최적화도 가능
<br>

## 결론
> #### Swift 제네릭의 기본 아이디어
> = **정적 타입**을 유지하면서 **코드를 재사용**할 수 있는 기능 제공
> -> 올바른 프로그램을 더 쉽게 작성, 효율적으로 실행되는 프로그램으로 컴파일

<br>

### Generic 알고리즘과 준수 타입 간 설계
- 준수하는 하위 집합에서만 지원되는 알고리즘을 구현하기 위해 특수화된 기능이 필요한 경우 프로토콜 상속을 도입
- 프로토콜 계층 구조로 작업할 때 잘 구성될 수 있도록 **조건부 적합성(Conditional Conformance)**을 유지
- 클래스와 함께 사용 시에는 `리스코프 치환 원칙`을 적용하기
<br><br>

---

[WWDC - Swift Generics (Expanded)](https://developer.apple.com/videos/play/wwdc2018/406/)
