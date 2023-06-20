# WWDC Embrace Swift type inference
- 유형 추론을 활용할 수 있는 경우에 대한 이야기
- 컴파일러에서 타입 추론이 작동하는 방식
- Swift 및 Xcode를 사용하여 코드의 컴파일러 오류를 이해하고 수정하는 방법

### 타입 추론이란??
- 코드에서 명시적 타입 주석이나 장황한 세부 정보들을 컴파일러가 알아서 유추 하는것
    - 불필요한 내용들을 생략할 수 있다.
```swift
    let x: String = ""
    // 이 부분에서 String을 생략해도 빌드가 가능함.
```

###  추론을 활용하는 경우
- 아래 예시에서 FilteredList 부분에서 타입 추론을 활용하고 있다.
```swift
import SwiftUI

struct SmoothieList: View {
    var smoothies: [Smoothie]
    
    @State var searchPhrase = ""

    var body: some View {
        FilteredList(
            smoothies,
            filterBy: \.title,
            isIncluded: { title in title.hasSubstring(searchPhrase) }
        ) { smoothie in
            SmoothieRowView(smoothie: smoothie)
        }
    }
}

extension String {
    /// Returns `true` if this string contains the provided substring,
    /// or if the substring is empty. Otherwise, returns `false`.
    ///
    /// - Parameter substring: The substring to search for within
    ///   this string.
    func hasSubstring(_ substring: String) -> Bool {
        substring.isEmpty || contains(substring)
    }
}
```

- 어떤 부분인지 알기 위하여 FilteredList를 까보자
```swift
import SwiftUI

public struct FilteredList<Element, FilterKey, RowContent>: View
        where Element: Identifiable, RowContent: View {
    private let data: [Element]
    private let filterKey: KeyPath<Element, FilterKey>
    private let isIncluded: (FilterKey) -> Bool
    private let rowContent: (Element) -> RowContent

    public init(
        _ data: [Element],
        filterBy key: KeyPath<Element, FilterKey>,
        isIncluded: @escaping (FilterKey) -> Bool,
        @ViewBuilder rowContent: @escaping (Element) -> RowContent
    ) {
        self.data = data
        self.filterKey = key
        self.isIncluded = isIncluded
        self.rowContent = rowContent
    }

    public var body: some View {
        let filteredData = data.filter {
            isIncluded($0[keyPath: filterKey])
        }
        
        return List(filteredData, rowContent: rowContent)
    }
}
```

- 제네릭을 사용하는 <Element, FilterKey, RowContent> 부분의 실제 타입은 호출 시 지정되거나 컴파일러를 통해 유추된다.
- 이니셜라이저가 호출되면 타입 매개변수가 실제 유형으로 대체된다.
- 이니셜라이저를 실제 호출하는 `SmoothieList`에서 작성된 타입 주석은 없지만, 구체적인 타입을 추론하는데 필요한 모든 정보를 제공하고 있다.

```swift
FilteredList(
            smoothies,
            filterBy: \.title,
            isIncluded: { title in title.hasSubstring(searchPhrase) }
        ) { smoothie in
            SmoothieRowView(smoothie: smoothie)
        }
```

- 만약 여기서 모든 타입의 유형을 명시적으로 작성한다면 어떨까

![캡처1](https://github.com/Groot-94/WWDC_Study/assets/96932116/a7c85c42-182a-4e69-b53c-b56908434492)

- 원래 타입추론으로 채워야 하는 형식에 대한 많은 자리 표시자를 포함하여 장황한 타입 주석으로 가득 차게 된다.
- 타입 추론은 코드에서 이러한 모든 유형의 철자를 정확하게 알 필요가 없기 때문에 소스 코드를 더 빠르게 작성하는 데 도움이 된다.

### 컴파일러에서 타입 추론이 작동하는 방식
- 퍼즐과 같이 한 조각을 채우면 나머지 조각에 대한 단서를 발견하여 문제를 푸는 방식과 비슷하다.
1. "smoothies" 인수는 Element에 대해 무엇을 채울지 알려줄 수 있으며 "smoothies"는 이미 유형이 있는 속성임을 알고있다. 
    - "Smoothie" 요소의 배열임을 알 수 있으므로 요소를 "Smoothie"로 채울 수 있음. 
    - 모든 Element에 대한 표시를 Smoothie 유형으로 바꿀 수 있다.
     ![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/b163cea1-f105-4e72-9735-7f1d472d11b2)
2. Smoothie.title이 문자열임을 알 수 있으므로 FilterKey를 "String"으로 채울 수 있다. 
    - 이제 FilterKey가 무엇인지 알았으므로 다른 FilterKey 자리 표시자도 "String"으로 바꿀 수 있다
     ![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/2d7e3d49-977f-48d9-b544-624d62f248cc) 
3. 이 클로저는 본문에 하나의 뷰만 있기 때문에 ViewBuilder는 SmoothieRowView 유형을 가진 단일 자식 뷰를 반환\
   - RowContent가 무엇인지 알았으므로 마지막 자리 표시자도 SmoothieRowView로 바꿀 수 있다.
     ![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/9f7d83e1-355b-4c6a-bb40-bc3838d55a9a)

- 이것이 컴파일러가 코드 전체에서 유형을 유추하는 데 사용하는 전략
- 작성하는 코드는 컴파일러가 사용할 단서를 제공한다.

### 컴파일러가 소스 코드 오류가 있는 경우 타입 추론 전략을 수정하는 방식 & 도구를 활용하여 이러한 오류를 이해하고 수정할 수 있는 방법
- 컴파일러가 FilterKey에 대한 구체적인 유형을 유추한 위치로 되돌아 가보자.
- 만약 FilterKey의 타입에 Bool 타입을 작성했다면??
   - 키 경로 리터럴에서 잘못된 속성을 사용하는 실수를 저질렀다면 컴파일러는 FilterKey의 유형을 잘못된 속성의 유형으로 유추하려고 시도했을 것
      ![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/8b439639-2fe1-45ad-8ea0-a1eab26291c0)
- 하지만, Bool에 hasSubstring이라는 메서드가 없기 때문에 이 부분이 적합하지 않기 때문에 컴파일러는 문제를 알려주게 된다.
- Swift 컴파일러는 나중에 오류 메시지에서 사용할 유형 추론 알고리즘에 오류 추적을 통합하여 이러한 실수를 포착하도록 설계되었다.

1. 컴파일러는 발생하는 오류를 모두 기록한다.
2. 타입 추론을 계속하기 위해 휴리스틱? 을 사용하여 오류를 수정함.
3. 타입 추론이 완료되면 수집한 모든 오류를 보고한다.

>**Xcode 11.4의 Swift 5.2, Swift 5.3 및 Xcode 12의 많은 오류 메시지에 대해 통합 오류 추적이 도입되었으며, 컴파일러는 식의 모든 오류 메시지에 대해 이 새로운 전략을 사용**

### Swift 코드를 작성하는 동안 이러한 도구를 사용하여 오류를 수정하는 방법
- Xcode 메뉴를 열고 Behaviors 편집을 클릭
![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/882342a3-f640-42f1-9cab-1c99179ba201)

- 빌드가 문제 탐색기를 자동으로 표시하지 못하는 경우를 위한 동작을 추가한다.
![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/040c2248-bc30-4dc0-9151-33c9a723c4fb)

- 프로젝트 빌드에 실패할 때마다 프로젝트 전체의 모든 오류를 볼 수 있다.

- 에러가 발생한 모습
- 코드의 이 부분 어디에도 "identifiable"이 작성되어 있지 않기 때문에 약간 혼란스러울 수 있다.
![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/dc42314a-c1ac-440a-883a-bc4b0ecbaecb)

- 새로운 통합 오류 추적 기능을 통해 컴파일러는 이 오류가 발생했을 때 타입 추론 중에 발생한 상황에 대한 정보를 기록하므로 컴파일러는 컴파일러 메모를 통해 코드의 다른 부분을 보도록 안내하는 이동 경로를 남길 수 있다.
  1. Option 키와 Shift 키를 누른 상태에서 노트를 클릭하여 대상 선택기를 표시.
     - ![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/894b55f0-f5ea-450e-acfd-0967c2eef3fe)

  2. 오른쪽으로 화살표를 이동하고 Enter 키를 눌러 새 편집기에서 파일을 열 수 있다.

- 화면에서 Element 또는 Smoothie가 "identifiable"을 준수해야 함을 알 수 있다.
- Smoothie에 identifiable을 준수하면 오류가 사라짐.
![image](https://github.com/Groot-94/WWDC_Study/assets/96932116/ab9d6a6a-b52b-4b7b-a3f8-f222fe5993ca)

### 요약
- 컴파일러의 새로운 통합 오류 추적 기능을 통해 컴파일러는 실패에 대한 더 많은 정보를 수집할 수 있으며, 컴파일러는 이를 메모를 통해 표시한다.
- 소스 코드의 단서를 사용하여 이러한 세부 정보를 파악하여 유형 추론이 생략된  부수적인 세부 정보를 채우는 방법
- 컴파일러가 오류 추적을 유형 추론 알고리즘에 통합하여 더 많은 정보를 기록하고 실수를 이해하고 수정하는 데 도움이 되는 오류 메시지에 대한 이동 경로를 남기는 방법
> 자세한 내용은 swift.org/blog/new-diagnostic-arch-overview/ 를 살펴봐라


