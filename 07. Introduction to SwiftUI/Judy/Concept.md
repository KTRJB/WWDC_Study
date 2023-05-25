## SwiftUI 시작하기
### Canvas
editor 오른쪽에 canvas가 표시됨

> #### Canvas
> - View 코드를 미리 보여줌
> - 캔버스에서 선택이 코드에도 반영됨 = 반대도 동일
> - 코드 편집과 학습에 도움

<br>

### Cell List 만들기
#### 1. 텍스트 추가하기
- 라이브러리에서 캔버스에 끌어다 놓으면 자동으로 코드 생성 및 추가
- 텍스트 - `Text("표시할 내용")`
-> VStack에 넣어 아래(위)에 추가할 수 있음

> #### SwiftUI의 일반적인 Layout Cotainer 
> Stack = 원하는 View를 배치할 수 있는 Container
> - **VStack** : View를 세로로 쌓을 수 있음
> - **HStack** : View를 가로로 쌓을 수 있음

<br>

#### 2. 텍스트 옆에 이미지 추가하기
- 추가하고 싶은 뷰 코드에 `command + 클릭 + Embed in 컨테이너`로 간단하게 컨테이너를 추가할 수 있음
![](https://velog.velcdn.com/images/juyoung999/post/660744e6-a0a7-427e-91be-cac44c56b147/image.png)

- 이미지 - `Image(systemName: "photo")`
<br>

#### 3. 컨테이너의 정렬 변경하기
- View 코드에 `command + 클릭 + show SwiftUI Inspector...`으로 속성 지정 가능
(`control + option + 클릭`하면 바로 나옴)

```swift
VStack(alignment: .leading) {
```
<br>

#### 4. 텍스트 변경하기
- 캔버스에서도 `command + 클릭 + show SwiftUI Inspector...`으로 속성 지정 가능
```swift
Text("3 ingredients")
	.font(.subheadline)
```

- `.font(.subheadline)`와 같은 메서드를 **modifire**라고 하며 뷰 또는 동작 방식을 지정할 때 사용
- font 색상 변경 - `.foregroundColor(.secondary)`
<br>

#### 5. Cell을 리스트에 넣기
- 뷰에 `command + 클릭 + Embed in List` 하여 List Container에 넣으면 테이블 형식으로 만들어짐
```swift
 List(0 ..< 5){ item in
 	//..
 }
```
- Cell을 0부터 5 미만으로 반복
- List를 만들기 위한 delegate, data sources 없음
<br>

#### 6. 데이터와 연결하기
- List에서 사용하려면 타입이 식별 가능해야 함
- 기본으로는 Cell 높이가 44 포인트였지만 더 큰 이미지를 할당하면 셀이 자동으로 확장됨

>❕뷰에 큰 변화가 있을 때 캔버스는 일시정지 함 
-> 재개 버튼 또는 `command + option + P`로 다시 활성화할 수 있음

<br>

#### 7. 이미지 모서리 반경 변경
![](https://velog.velcdn.com/images/juyoung999/post/b1c8d654-d9e2-4f14-8578-dff840080d0d/image.png)

- 어떤 modifire를 사용할지 모르겠다면 라이브러리에서 목록에서 검색하여 찾을 수 있음
- 라이브러리에서 찾은 modifire를 캔버스(또는 코드)에 드래그로 적용 가능
<br>

#### 8. Cell 클릭하여 이동하기
- List를 **NavigationView**로 래핑

> **NavigationView**
> - 앱의 다른 부분으로 navigating할 수 있음
> - Navigation Bar를 표시하고 Navigation 스택으로 push

- Cell을 Stack에 push하기 위해 Cell의 content를 **NavigationLink**로 래핑
- NavigationLink - destination으로 표시하려는 content (또는 뷰)를 지정
-> Cell에 indicator `>`가 표시됨
- 스와이프로 뒤로가기 동작 시 자동으로 Cell의 Highlight가 조정됨
<br>

#### 9. Preview Live 보기
- Preview에서 Live 버튼을 선택하면 실제 실행처럼 볼 수 있음
<br>

#### 10. row에 샌드위치 수를 표시하기
- Cell에 해당하는 뷰 코드가 크니까 다른 뷰로 분리
- 뷰를 `command + 클릭 + Extract SubView` 하면 분리해줌
- SwiftUI를 사용하면 뷰가 매우 가벼워짐 -> 캡슐화나 분리를 위해 뷰를 생성하는 것에 대한 걱정 🙅🏻‍♀️
- List로 단일 컬렉션을 사용할 때는 괜찮지만 더 필요한 경우에는 혼동될 수 있으니 `ForEach`로 분리해서 데이터 전달
```swift
 List(sandwiches) { sandwich in
 ⬇️ 
 List() {
	ForEach(sandwiches) { sandwich in
 ```
- List content에 Text를 추가해서 row 개수를 표시
- HStack과 Spacer를 사용해 Text가 가운데로 위치하도록 지정

> **Spacer**
> - SwiftUI의 Layout 요소
> - toolbar의 flexible space 처럼 공간을 채우도록 확장

<br>

### 상세 뷰 만들기
- SwiftUI 템플릿을 이용하면 `View`와 `PreviewProvoder`가 제공된 파일을 만들어줌
<br>

#### 1. 이미지 크기 조정하기
- 이미지를 넣었더니 너무 큼 -> `resizable` 수정자로 변경
- 이미지 비율을 변경하려면 `aspectRatio` 수정자를 이용
<br>

#### 2. Cell을 탭할 때 DetailView를 push하도록 변경
- Cell의 NavigationLink의 destination을 생성한 **DetailView**로 설정
- navigationTitle을 설정해도 네비게이션으로 push 됐을 때만 navigationTitle이 보임 
-> PreviewProvider에 NavigationView를 설정하면 Preview로 바로 볼 수 있음
<br>

#### 3. 이미지의 aspectRatio를 왔다 갔다 할 수 있도록 하기
이미지를 확대해서 볼 수 있도록 `fill` <-> `fit`을 왔다 갔다 하고 싶음 🤔
<br>

## SwfitUI에서 View가 동작하는 방식

SwiftUI에서 뷰는 UIView와 같은 클래스를 상속하는 클래스가 아닌 `View` **프로토콜을 준수하는 구조체**
-> 상속받지 않고 스택에 쌓이고 값으로 전달됨
-> 참조 카운팅 없음

> => 뷰 계층 구조를 렌더링하기 위한 효율적인 데이터 구조로 축소

- SwiftUI에선 뷰가 엄청 가벼움
- `View` 프로토콜은 `body` 프로퍼티만 required
- body 자체가 뷰

프레임워크는 UI를 정의하는 것 외에도 뷰의 종속성을 정의하기 때문에 렌더링할 시기를 알고 있음

### 이미지 탭해서 확장하기
- 이미지 확대 여부를 판단할 Bool 변수 추가 `zoomed` - 프레임워크에 의해 유지
- 확대 상태를 전환할 탭 제스처 추가 -> tap 제스처 시 변수가 toggle 되도록 지정
```swift
  @State private var zoomed = false
  
  Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }                
```

<br>

### 뷰의 렌더링 과정
`State 프로퍼티`는 SwiftUI가 읽고 쓸 때 관찰할 수 있음
-> 뷰의 렌더링이 확대 변수(= zoomed = State 프로퍼티)에 의존함을 알고 있음
-> 확대 변수가 변경되면 프레임워크는 렌더링을 변경하기 위해 body를 다시 요청

- `aspectRatio` 호출이 뷰를 만든다 -> contentMode 속성은 zoomed 변수에서 파생
<br>

### Source of Truth
> 상태 변수 = **Source of Truth**
> 오래된 속성 = **Derived Value**

![](https://velog.velcdn.com/images/juyoung999/post/79cea846-c690-4221-89e9-420f3aac0398/image.png)

- 읽기-쓰기 파생 값을 전달하기 위해 `Binding`도 발명
- 상수(Constant)는 좋은 Source of Truth 역할을 할 수 있음
- 모델도 Source of Truth
<br>

### 종속성
- 기존 UI 프레임워크 사용 시 뷰가 데이터를 읽을 때마다 암시적 종속성이 생성됨
- 해당 데이터가 변경되면 뷰가 업데이트해야 한다 = "종속성" -> 업데이트를 실패하면 버그
- SwiftUI는 자동으로 종속성을 관리해 적절한 파생값을 다시 계산하여 버그를 방지
- 일반적인 앱의 UI는 크고 복잡하기에 하나가 아닌 여러 종속성을 관리 (이전에 수동으로 관리할 때는 UI 버그가 발생하기 쉬웠음)
<br>

### 이벤트 핸들러
이벤트 핸들러 콜백의 어떤 순서에서도 UI가 일관된 상태인지 확인해야 함

#### UIKit Sandwich에서의 버그
> 이미지를 확대 및 향상하는 이벤트 순서
> 1) zoom -> enhance -> zommout -> completion
> 2) zoom -> enhance -> completion -> zoomout
> 3) ...

이런 에러는 Source of Truth를 변경하고 이벤트 핸들러 콜백에서 직접 뷰를 변경하는 경우 쉽게 발생

4개의 이벤트 핸들러가 호출되는 순서의 경우는 24가지 (실제로는 두 번 이상 발생할 수 있으니 더 많음)
=> UI 프로그래밍.. 어렵다... 😟

뷰는 대부분 4개 이상의 이벤트를 처리해야 함
>- Model Notification
- Target Action
- Delegate Methods
- Lifecyle Checkpoints
- Completion Handlers...

우리는 Human이라 너무 복잡한 걸 할 수가 없다!
기능이 추가 -> 요청이 폭발적으로 증가 -> 버그 증가

대부분 하나의 메서드에서 뷰의 업데이트를 수행하도록 작성
-> 순서가 고정되어 복잡성이 줄음
-> 이것에서 SwiftUI가 영감을 받음
<br>

## SandwichDetail
#### 1. 이미지를 전체 화면으로 보기
- 이미지를 확대해도 아래에 공간이 있음
- SwiftUI는 safeArea에 뷰를 배치 -> UI 요소가 corner radius 같은 항목에 잘리지 않음
- `edgesIgnoringSafeArea` 수정자로 가장자리에서 safeArea를 무시하도록 변경
<br>

#### 2. 확대-축소 시 애니메이션 넣기
- `onTapGesture`에서 zoomed를 토글하는 코드를 `withAnimation`으로 래핑
- 애니메이션 중에도 상호작용할 수 있어 확대되는 중에 다시 축소도 가능
<br>

#### 3. Spicy 정보 표시하기
- VStack으로 래핑 후 VStack과 관련된 수정자 이동
- 정보를 표시하기 위해 `Label` 사용
- `Label("Spicy", systemImage: "flame.fill")` - 텍스트와 이미지를 함께 표시
- 정보를 하단에 표시하기 위해 Spacer 추가
- Spacer는 요소 사이의 패딩을 유지하기 위한 최소 크기를 가짐 - minLength로 지정할 수 있음
- 화면 가장자리에 닿지 않도록 -> padding을 조정
- SwiftUI에서 뷰는 content에 맞게 크기가 조정됨 => Stack에 넣고 Spacer로 해결
<br>

#### 4. 매울 때만 세부정보 표시하기
- `if`로 매운지 확인하고 배너 표시
- PreVeiw로 매울 때/안 매울 때 버전 추가 가능
<br>

#### 5. 이미지를 확대/축소할 때는 정보 숨기기
- zoomed 변수가 false일 때만 보이도록 설정
- fade in/out으로 애니메이션으로 사라졌다 나타남
- 애니메이션도 지정해줄 수 있음 - `transition`
<br>

## iPad에 적용하기
#### 1. 미리보기 표시
- 아이패드에서는 왼쪽 네비게이션바로 List가 표시되어 셀을 선택하지 않았을 때는 아무런 표시가 없음
- NavigationView에 새로운 뷰 추가

![](https://velog.velcdn.com/images/juyoung999/post/a3a82680-3758-4baa-b80d-5786c37179c6/image.png)

- 단순히 뷰가 쌓이는 것이 아닌 적절한 위치로 표시됨
- iPhone에서 처럼 필요하지 않으면 표시되지 않음

## Mac에 적용하기
![](https://velog.velcdn.com/images/juyoung999/post/2ea8c506-868b-4288-9d7c-d89e2d47e045/image.png)
- iPad와 마찬가지로 placeholer 뷰가 표시됨

> 모든 플랫폼에서 동일한 코드를 사용할 수 있음

<br>

## List 편집 지원하기
#### 1. 변경 가능한 모델 만들기
```swift
class SandwichStore: ObservableObject {
    @Published var sandwiches: [Sandwich]
    
    init(sandwiches: [Sandwich] = []) {
        self.sandwiches = sandwiches
    }
}
```
- Sandwich를 포함하는 가변 객체
- 객체가 변경될 때 SwiftUI에 알려야 함 -> `ObservableObject` 준수
- `@Published`로 관찰하려는 속성을 표시
- `@State`로 값에 대한 truth of value를 만든 것처럼 `@StateObject`를 사용해 truth of mutable object를 만들 수 있음
-> `@StateObject` 객체를 관찰하여 변경될 때 자동으로 뷰를 업데이트
<br>

#### 2. 모델과 연결
- **SandwichApp** - App 프로토콜을 준수하는 구조체
- `@main` 표시가 있음 -> 앱의 시작점이다
- 뷰와 마찬가지로 body를 가짐
- `WindowGroup` - 앱의 모든 window에 뷰를 지정할 수 있음
- 이곳에 `@StateObject` 객체 선언
<br>

#### 3. 뷰 코드에 전달
- ContentView의 이니셜라이저에 전달
- ContentView에도 객체를 선언하고 `@ObservedObject`로 만들어 이 객체의 변화를 관찰하고 싶다고 SwiftUI에 알림
<br>

#### 4. 편집 및 삭제 기능 추가
- Cell 이동 - `OnMove(perform:)`
- Cell 삭제 - `OnDlete(perform:)` -> 이미 Swipe로 삭제 가능
- iOS에서는 명시적으로 편집 모드로 들어가는 방법을 추가해야 함 -> `toolbar`, `EditButton`
- 편집 모드 시 필요한 행에만 편집 컨트롤 표시
<br>

#### 5. 추가 기능
- Cell 추가 - `OnMove(perform:)`
- Add 버튼 추가 - `Button`
- Sandwich는 식별가능하기 때문에 `ForEach`는 컬렉션의 변경 사항을 감시하여 데이터 소스 불일치 예외에 대해 걱정할 필요 없음
<br>

#### 6. 다양한 지원
- 요즘에는 Dynamic Type, Dark mode, Localization 에 대한 지원을 기대
- wiftUI는 이러한 동작에 대해 자동으로 더 많은 지원하고 Preview로 빠르게 테스트 가능
- 특별한 작업을 하지 않아도 자동으로 추론됨
<br>

## Preview
앱 구축하고 한 번도 실행하지 않고 풍부한 동작을 모두 테스트했다 👍


<br><br>

---

[WWDC - Introduction to SwiftUI](https://developer.apple.com/videos/play/wwdc2020/10119/)
