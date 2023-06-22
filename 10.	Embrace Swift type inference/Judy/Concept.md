## 배경
Swift는 코드의 안정성을 손상시키지 않고 간결한 구문을 달성하기 위해 **타입 추론**을 광범위하게 사용

#### 오늘 할 이야기
- 타입 추론을 활용할 수 있는 경우
- 컴파일러에서 타입 추론이 작동하는 방식
- Swift 및 Xcode를 사용하여 코드의 컴파일러 오류를 이해하고 수정하는 방법
<br>

## 타입 추론
> 컴파일러가 주변 컨텍스트에서 세부 정보를 파악할 수 있을 때 코드에서 명시적 타입 정보를 생략할 수 있다

#### 타입 추론
```swift
let x = ""
```
타입이 명시되어 있지 않지만 컴파일러는 제공된 값을 기반으로 String으로 유추

#### 명시적 표현
```swift
let x: String = ""
let x = "" as String
```
<br>

## SwiftUI의 타입 추론
SwiftUI 같이 코드가 타입 추론에 크게 의존할 때 더 흥미로움

SwiftUI는 `작고 재사용 가능한 뷰`를 구성하여 `크고 복잡한 인터페이스`를 생성
-> 재사용 가능한 구성 요소 호출에서 타입 추론의 크게 의존
<br>

### Leveraging type inference at the call-site
예시 앱) 스무디를 주문하는 Fruta 
![](https://velog.velcdn.com/images/juyoung999/post/0842aef0-b459-43bb-acf6-2ca388f5acc3/image.png)

💡 사용자가 스무디를 검색하는 기능을 추가하고 싶다

검색한 문자열로 스무디를 필터링하기 위해 **String** 타입의 **State** 프로퍼티 추가 - `searchPhrase`

![](https://velog.velcdn.com/images/juyoung999/post/d64caabc-e6c5-46e1-aadb-ab7b92f2b7dd/image.png)

FilterdList에 다음 두 가지 속성을 전달
- 필터링하려는 스무디 프로퍼티에 대한 **KeyPath** => title
- 해당 프로퍼티를 기반으로 List에 스무디를 포함할지 계산하는 함수 => title에 검색 문자열(searchPhrase)가 포함돼있는지

➡️ 호출 사이트에서 타입 추론에 크게 의존
<br>

#### 타입 추론에 의존하는 이유
FilteredList는 범용 뷰이므로 클라이언트가 리스트에 표시해야 하는 모든 타입에서 작동해야 함 
➡️ 제네릭으로 이러한 유연성이 제공됨

![](https://velog.velcdn.com/images/juyoung999/post/17ba8b7c-18de-42e4-be40-ec11105e71bc/image.png)

구체적 타입이라고 하는 실제 타입은 호출 사이트에서 지정되거나 컴파일러에 의해 유추됨
> - **Element** : 데이터 배열 요소
> - **FilterKey** : 데이터를 필터링할 Element의 특정 프로퍼티 타입
> - **RowContent** : 표시할 뷰 타입

이 세 타입을 이니셜라이저의 매개변수로 사용할 수 있음
이니셜라이저의 매개 변수의 위치는 해당 타입이 대체해야하는 항목에 대한 단서를 컴파일러를 제공하여 호출 사이트에서 형식 유추에 대한 기회
<br>

#### 매개변수
- `FilteredList` - 매핑할 data로 초기화
- `KeyPath<Element, FilterKey>` - 필터링 기준이되는 요소의 특성
- `isInclude` - Filtered가 속성에서 저장해야 하므로 @escaping
- `rowContent` - 데이터 요소를 뷰에 매핑하기 위한 @escaping 클로저, **@ViewBuilder**(SwiftUI DSL)

> **SwiftUI DSL - Domain-Specific Language**
> : 특정 분야에서 가독성 및 사용성을 향상시킨 High-level 언어
>
> **@ViewBuilder**
> : 클로저의 본문에 나열하여 여러 하위 뷰를 선언할 수 있으며 ViewBuilder는 상위 뷰가 작업> 할 수 있도록 하위 뷰를 튜플로 수집

<br>

[ 제네릭 구현부 / 호출 사이트 ]
![](https://velog.velcdn.com/images/juyoung999/post/60feb18d-2ef4-421f-8952-e9933d14609e/image.png)
- 호출 사이트는 Clean!
- 호출 사이트에는 명시적 타입 주석이 없지만 각 타입 매개변수에 대한 구체적 타입 추론을 위한 정보를 컴파일러에 제공
<br>

#### 명시적 타입 주석을 표시한 경우
![](https://velog.velcdn.com/images/juyoung999/post/6a9f5a4d-4be6-4779-ac72-54baa4220d0c/image.png)

타입 유추는 코드 작성 시 위와 같은 정확한 타입을 알 필요가 없어 작성 속도 빠름
<br>

### Solving the type inference puzzle
컴파일러가 placeholder를 대세하는 대상을 파악하는 방법

- 타입 추론은 퍼즐과 같다
- 소스 코드의 단서로 타입을 추론하여 연쇄적으로 추론

![](https://velog.velcdn.com/images/juyoung999/post/6a9f5a4d-4be6-4779-ac72-54baa4220d0c/image.png)

1. smoothies - Element에 무엇을 채울지 알려줌 
- `Element ~~> Smoothie`
2. filterBy - Element 즉 Smoothie의 title이 String 타입
- `FilterKey ~~> String`
3.  rowContent - 클로저 본문에 하나의 뷰만 있음
- `RowContent ~~> SmoothieRowView`가 됨


소스 코드 단서에서 컴파일러가 퍼즐의 다른 부분과 맞지 않는 타입으로 추론할 수도 있음 -> 소스 코드의 오류
<br>

### Understanding and resolving compiler errors
소스 코드에 오류가 있는 경우 타입 유추 전략을 수정하는 방법

(컴파일러가 FilterKey에 대한 타입 추론을 하던 상황)

![](https://velog.velcdn.com/images/juyoung999/post/ab1dad37-9b48-434d-ad35-46d59db1c874/image.png)

KeyPath로 \.title이 아닌 \.isPopular 즉 Bool 값을 사용하는 실수를 하면 컴파일러는 잘못된 타입으로 유추하려고 시도

이후 모든 FilterKey를 Bool로 유추하다 Bool은 `hasSubstring` 메서드를 가지지 않기 때문에 컴파일러는 오류를 보고
<br>

#### Integrated error tracking
컴파일러는 타입 추론 알고리즘에 오류 추적을 통합하여 이러한 실수를 포착하도록 설계됨
- 컴파일러는 타입 추론 중에 발생하는 모든 오류 정보를 기록
- 타입 추론을 계속하기 위해 오류를 수정 (휴리스틱 사용)
- 타입 추론이 완료되면 수집한 모든 오류를 보고
- 오류를 수정하기 위한 수정 사항 또는 오류를 유발하는 타입에 대한 정보를 포함
<br>

#### 통합 오류 추적 기능 사용 방법
`Xcode > 메뉴 > 동작 편집 > 빌드가 문제 탐색기를 표시하지 못하는 경우 동작 추가`
=> 빌드에 실패할 때마다 프로젝트 전체의 오류를 볼 수 있음

option + 클릭 -> Quick Help 사용
- 추론한 타입을 알 수 있음
<br>

## 결론
- Xcode 12에서 Swift 5.3 사용 시 오류를 찾을 수 있는 개선 사항이 있다.
- 인터페이스가 재사용 가능한 뷰로 구성될 때 SwiftUI 코드가 타입 추론에 크게 의존한다.
- 소스 코드를 통해 타입이 생략된 정보를 채우는 방법을 통해 타입 추론을 한다.
- 컴파일러가 오류 추적에 타입 추론 알고리즘을 통합하여 많은 정보를 기록하고 수정에 도움이 되는 방법을 제공한다.
<br><br>

---

[WWDC - Embrace Swift Type Inference](https://developer.apple.com/videos/play/wwdc2020/10165/)
