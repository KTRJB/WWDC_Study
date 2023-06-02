## 배경
**Swift 5.1**
- 2016에 API Design Guidelines 도입
- API 이름을 지정하고 문서화하는 유용한 조언

> 목표 = 사용 시점의 명확성(**Clarity at the point of use**)
> 새로운 사항 - Swift 전용 API의 유형에 접두사를 사용하지 않을 것!

<br>

## 1. Values and references
타입 생성의 기본 개념 
- Class
- Struct
- Enum
<br>

### 참조 타입 vs 값 타입
#### 참조 타입
- 클래스
- 변수가 값을 보유하는 개체를 참조
- 복사할 때 해당 **참조를 복사** -> 변경 시 영향

#### 값 타입
- 구조체, 열거형
- 복사 시 **내용을 복사** -> 변경 시 영향 없음
<br>

### 사용 기준
1. 클래스를 사용할 타당한 이유가 없다면 구조체를 사용
2. 참조 카운팅으로 리소스를 관리해야 하는 경우 클래스가 필수적
3. 무언가 근본적으로 저장하고 공유되는 경우 클래스를 사용 
<br>

### RealityKit
- Entity를 중심
- Scene에 나타내는 객체를 표현
- RealityKit 엔진에 위치
- 개체의 모양 변경이나 이동 시 해당 엔진에서 개체를 직접 조작
=> 정체성이 있다
=> 참조 유형의 완벽한 사용

- 상자를 또 만들고 색상을 변경하면 이전 상자도 적용이 되어야 할까?
-> RealityKit은 값 타입으로 구현


```swift
struct Material {
	public var roughness: Float
	public var color: Color
	public var texture: Texture
}

class Texture { ... }
```

![](https://velog.velcdn.com/images/juyoung999/post/557a831a-beb8-43c0-bf31-69112c3184d5/image.png)

값 타입은 내용을 복사 -> 내용이 참조라면?<br>
-> 참조 사본을 복사하게 되는 것으로 texture를 공유하게 됨<br>
-> Texture가 불변(let)이라면 괜찮지만 아니라면 참조도 값도 아니게 동작함 

➡️ 구조체와 같은 값 타입이라고 무조건 값 처럼만 동작하는 것은 아니다

값 처럼 동작하고 싶다면 노출하는 참조 중 변경 가능한 것이 있는지 확인 ❕
<br>

#### 문제를 피하는 방법
- 방어적인 복사본 만들기
![](https://velog.velcdn.com/images/juyoung999/post/29b3f32e-8419-4cf8-b799-3422e14d56a8/image.png)

1. Texture를 비공개(private)로 전환
2. 연산 프로퍼티로 setter 내부에서 Texture 개체의 복사본을 만듦
3. 객체에서 원하는 프로퍼티를 연산 프로퍼티로 노출
![](https://velog.velcdn.com/images/juyoung999/post/edc22051-8c00-4057-ad6e-0f06f5b3e105/image.png)

4. getter를 통해 setter에서 개체가 고유하게 참조되는지 확인하기
5. 고유하지 않다면 해당 시점에서 Texture의 복사본을 만들기

=> 고유성 검사를 통해 참조 타입에서 원하는 프로퍼티를 노출하면서 복사 값 체계를 구현
<br>

## 2. Protocols and Generics
값 타입은 Objective-C에도 있었지만 Swift에서는 enum과 같은 값 타입에도 프로토콜을 적용할 수 있다는 것이 다름
또한 제네릭을 사용하면 다양한 타입에서 코드를 공유할 수 있음

### 프로토콜로 시작하기
그렇다고 다짜고짜 프로토콜부터 만들라는 것은 아님<br>
✅ 먼저 구체적인 타입을 사용해 사용 사례를 탐색하고 다른 타입에서도 같은 기능을 반복할 때 공유하고 싶은 코드를 찾고 제네릭을 사용해 공유 코드 제거<br>
✅ 새로운 프로토콜을 만들기 보다 이미 존재하는 프로토콜을 확장하기<br>
✅ 프로토콜 보다는 제네릭으로 만들기
<br>

### 예시
기하학 API 만들기 (벡터 관련 작업을 하고 싶다)
> **SIMD**
모든 요소에 대해 한 번에 효율적인 계산을 수행할 수 있는 튜플 프로토콜.
기하학 계산에 훌륭

프로토콜에 정의하면 모든 작업에 대한 기본 구현을 할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/80bfb8eb-0002-4a64-8ccf-8a5e8b112dc7/image.png)

새로운 기능을 얻고자 하는 경우 각 타입에 해당 프로토콜 적합성을 제공

일반적인 3단계 프로세스 `프로토콜을 정의 -> 기본 구현을 제공 -> 여러 유형에 적합성을 추가` 는 지루하다!

프로토콜이 정말 필요했을까?
새로운 사용자 정의 구현이 없다 = 프로토콜이 유용하지 않다

![](https://velog.velcdn.com/images/juyoung999/post/f664691f-2f47-486a-b9a9-694e36e083fe/image.png)

새 프로토콜에 기본 구현하는 대신 해당 제약 조건에 직접 확장해서 기본 구현하기


---


```swift
struct GeometricVector<Storage: SIMD> where Storage.Scalar: 	FloatingPoint {
	typealias Scalar = Storage.Scalar
	var value: Storage
    
	init(_ value: Storage) { self.value = value }
}
```
프로토콜 없이 확장 기반으로 작업 시 감시 테이블이 없어 컴파일러가 더 빠르게 처리할 수 있다

```swift
protocol GeometricVector: SIMD
```
프로토콜 생성 = GeometricVector를 정의하고 SIMD를 정제한다
-> 이게 is-a 관계인가? GeometricVector이 SIMD 타입이다 라고 할 수 있나?

GeometricVector와 SIMD는 구현과 맥락적으로 다른 부분이 있음
(예를 들어 곱하기가 안 된다던지 모든 SIMD 타입에서 사용할 수 없음)

사용하기 쉬운 API 설계 시 has-a 관계로 구현하는 것이 좋음 => 구조체 안에 SIMD를 래핑하기

![](https://velog.velcdn.com/images/juyoung999/post/e9369c30-a6b9-461d-885b-02394a288ec6/image.png)

- API를 보다 세밀하게 제어
- 기본 구현은 여전히 적용 가능

---

![](https://velog.velcdn.com/images/juyoung999/post/2ae39e2e-dddc-496a-a636-7dd06224d786/image.png)

x, y, z에 대한 연산 프로퍼티 사용 넘 복잡하다
~~> **Key path member lookup**
<br>

## 3. Key path member lookup
하나의 타입에서 여러 연산 프로퍼티를 한 번에 노출하는 단일 subscript를 작성

![](https://velog.velcdn.com/images/juyoung999/post/5c2a43d6-ca1d-4fcb-9bd9-26a1dc200b98/image.png)

- `@dynamicMemberLookup` 표시
- KeyPath를 취하는 subscript 구현
- 해당 KeyPath를 통해 접근할 수 있는 프로터티가 자동으로 연산 프로퍼티로 노출

![](https://velog.velcdn.com/images/juyoung999/post/a64217fb-0878-4a9f-8d23-756b522a75d5/image.png)

<br>

### KeyPath로 참조 타입 방어 복사
프로퍼티 전달 외에도 유용하게 쓰일 수 있음

이전 예제 (COW 값 시맨틱을 사용해 Texture에서 특정 프로퍼티를 노출한 예제)에서 하나의 프로퍼티에서 작동하고 있음
-> 다른 프로퍼티에도 적용하고 싶다면 매번 같은 코드를 써야함 😇

모든 프로퍼티를 노출하고 싶다면? => Key path member lookup

![](https://velog.velcdn.com/images/juyoung999/post/c504e3bf-343b-4e1b-8a03-53e02fab40ff/image.png)

1. 타입에 @dynamicMemberLookup 추가
2. subscript 구현
3. 프로퍼티를 get set할 수 있도록 KeyPath를 사용하도록
4. 다른 타입을 가져올 수 있도록 제네릭 적용
5. get set 구현
6. setter에서 변경하기 전에 고유한 참조 확인 및 사본 추가
=> Material 타입에 대한 완전한 COW 의미 체계를 사용해 모든 프로퍼티를 노출
<br>

## 4. Property wrappers
Property wrappers는 Swift 5.1의 새로운 기능
> Property wrappers의 기본 아이디어 = 연산 프로퍼티에서 코드를 효과적으로 재사용하자!

![](https://velog.velcdn.com/images/juyoung999/post/27979b9c-75b9-4e70-a03e-7457f7a79eb3/image.png)


`image` 프로퍼티를 노출했지만 모든 사용자, 클라이언트가 값을 쓰는걸 원하지 않음

- 실제 저장소는 `imageStorage`라는 내부 프로퍼티로 또 존재
- 해당 프로퍼티에 접근은 getter, setter로 제어됨
- 문제) 코드가 넘 길다 => 사실 **lazy var**와 같은 코드

```swift
public lazy var image: UIImage = loadDefaultImage()
```
<br>

### LateInitialized

![](https://velog.velcdn.com/images/juyoung999/post/b7820c3d-f92c-40ef-9e73-3d1ad3ba5ae3/image.png)

- 위와 비슷하지만 논리가 좀 다른 일종의 늦은 초기화 패턴
- get하기 전에 초기화해야 함

이런 걸 간단하게 하고 라이브러리로 사용하고 싶다 => Property wrapper로 만들자
<br>

#### 구현 예시
```swift
public struct MyType {
	@LateInitialized public var text: String
}
```
`@LateInitialized`는 이전 예시와 같은 방식으로 구현되어 있음
- 문서화 됨
- `@propertyWrapper`로 표시해 속성 래퍼임을 알림
- 제네릭으로 구현됨
<br>

#### 결과
- lazy와 유사하며 같은 이점을 제공하면서 모든 상용구를 제거
- 복잡하지 않고 읽고 추론하기 쉬움
<br>

### 속성 래퍼의 요구사항
- `value` 프로퍼티 갖기
-> 해당 정책이 구현됨
- 매개변수 없는 init 선언
-> 선택 사항이지만 선언 시 해당 래퍼를 적용하는 속성이 무료로 암시적 초기화를 얻음
<br>

### 속성 래퍼 사용하기
컴파일러는 개별 프로퍼티로 변환
![](https://velog.velcdn.com/images/juyoung999/post/2bcae3ab-b18b-4852-a77a-fde3cccd2fc3/image.png)

속성 래퍼를 적용하여 사용하면 컴파일러는 해당 코드를 두 개의 개별 속성으로 변환
1) $ 접두사로 백업 저장소 프로퍼티 = 속성 래퍼 타입의 인스턴스
2) 연산 프로퍼티로 변환된 저장소 프로퍼티
<br>

### DefensiveCopying
참조 시맨틱과 mutable한 상태를 다룰 때 방어적인 복사를 수행하게 됨
수동으로 할 수 있지만 속성 래퍼로 구축하면 편리

![](https://velog.velcdn.com/images/juyoung999/post/6e88113d-f68a-4db0-8a68-00fc529b168d/image.png)

- 새 값을 얻을 때 값을 복사 
- 초기 값 init을 제공 -> 속성 래퍼에 포함할 필요는 없지만 래핑된 속성에 기본값을 제공할 수 있음
<br>

#### 적용
```swift
public struct MyType {
	@DefensiveCopying public var path: UIBezierPath = UIBezierPath()
}
```

![](https://velog.velcdn.com/images/juyoung999/post/d5696735-5c13-486e-8a87-a435fe6d6cc4/image.png)
- 컴파일러가 백업 저장 속성인 $path와 연산 프로퍼티 path로 변환
- getter, setter 모두 $path.value를 통과
<br>

#### 속성 래퍼 확장
최적화를 위해 DefensiveCopying를 확장할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/0e7df253-6338-4a2c-ab51-9a1692be4f6d/image.png)

추가 사본을 피할 수 있도록 Copying 초기화 없이 $path에 할당하기

```swift
public struct MyType {
	@DefensiveCopying(withoutCopying: UIBezierPath()) 
	public var path: UIBezierPath
}
```

상용구를 더 없애기 위해 위와 같이 표현도 가능

---

프로퍼티 래퍼는 강력해서 데이터 저장 방법, 데이터 접근 방법을 결정할 수 있음

### 속성 래퍼의 다양한 용도
- `@UserDefault` - UserDefault를 사용하기 위한 논리 지정
- `@ThreadSpecific` - 스레드 특화
- `@Option` - 명령줄 옵션을 매우 간결하게 선언
<br>

### SwiftUI에서 속성 래퍼
SwiftUI 전체에서 속성 래퍼를 광범위하게 사용해 View의 데이터 종속성을 설명

> **@State** - 뷰의 로컬 상태를 도입
> **@Binding** - 다른 곳에 있음을 알림

#### 속성 래퍼의 역할
선언한 위치에서 이 데이터의 위치와 접근 방법에 대한 정책을 명시
당신은 데이터 위치를 신경쓰지 않아도 시스템이 이를 관리
<br>

#### Binding
```swift
struct SlideViewer: View {
	@State private var isEditing = false 
    @Binding var slide: Slide
    
	var body: some View {
    	VStack {
			Text("Slide #\(slide.number)")
       	 	if isEditing {
				TextField($slide.title) 
        	}
            //..
        }
	} 
}
```

텍스트필드에서 slide.title을 편집할 수 있도록 전달하고 싶어!
- `$slide.title` -> 이 형태 = 백업 저장소 프로퍼티
- `slide` 프로퍼티에 **Binding** 래퍼를 적용했으므로 컴파일러가 합성해줌
<br>

#### Property Wrapper + KeyPath Member Lookup
그건 Binding이고 title을 가지진 않음. title은 내 데이터 모델(Slide)의 일부임
-> **KeyPath Member Lookup**

접근 방식은 어차피 프레임워크에 의해 처리되니 우리에겐 중요하지 않음
Binding은  KeyPath Member Lookup도 지원

![](https://velog.velcdn.com/images/juyoung999/post/496a518a-5d13-403d-809e-33b742eb7e99/image.png)

- 우리가 취하는건 특정 값 타입에 근본을 둔 KeyPath로 Slide 내의 모든 속성에 접근
- 외부 바인딩의 특정 속성 하나에만 초점을 맞춘 새 바인딩을 반환하고 종속성을 유지
<br>

#### 작동 방식
![](https://velog.velcdn.com/images/juyoung999/post/9a2b2297-67c7-4795-a951-225d5a1e324b/image.png)

- `$sllide`하면 해당 바인딩 인스턴스를 가져옴 -> Binding<Slide\>
- `$slide.title` -> Binding<String\>

➡️ 바인딩을 통해 클래스 참조를 전달하려면 접두사 $를 붙이면 됨
<br>

## 정리
오늘 한 이야기
- 값 의미, 참조 의미 -> 사용하는 시기와 함께 작동하게 하는 방법
- 제네릭, 프로토콜 -> 프로토콜은 강력하지만 재사용을 위해 사용해라
- 속성 래퍼를 사용해 데이터 접근을 추상화하는 방법
<br><br>

---

[WWDC - Modern Swift API](https://developer.apple.com/videos/play/wwdc2019/415/?time=1064)
