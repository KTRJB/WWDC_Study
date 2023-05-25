# Introduction to SwiftUI (wwdc)

- VStack
    - 세로로 쌓을 수 있음
- HStack
    - 가로로 쌓을 수 있음
- 뷰에 마우스를 대고 cmd+클릭 => Embed in HStack 하면 HStack으로 감싸짐
- 뷰에 있는 요소에 대고 cmd+클릭 => inspector로 이동 
- wwdc에서는 스와이프가 된다고 하는데 나는 오ㅐ안됨..10:50
- 뷰에 cmd+클릭하고 Extract View 클릭하면 바로 뷰를 추출할 수 있음

![](https://hackmd.io/_uploads/Hky519hSh.png)

- 지금까지 우리는 single collection을 사용하여 목록을 만들었고, 이는 데이터에서 기반한 list였다.
- 하지만 SwiftUI를 사용하면 list에서 정적 content와 동적 content를 혼합하여 사용할 수도 있다.
=> 바로 ForEach를 사용하면 된다.

1. 처음
![](https://hackmd.io/_uploads/H1bNgcnS2.png)

2. ForEach 사용시

![](https://hackmd.io/_uploads/r1rPg93Sn.png)

이제 아래와 같이 목록 바깥에다가 정적 요소를 추가할 수 있게 됐다.

![](https://hackmd.io/_uploads/SJ0--92Hh.png)

![](https://hackmd.io/_uploads/Bkdzb9hBn.png)

- Spacer()은 SwiftUI의 일반적인 layout 요소이다. toolbar에서 유연하게 공간을 이동하며 사용 가능한 공간을 채우는 역할을 한다. 


#### SandwichDetail (이미지)

- resizable
    - SwiftUI가 공간에 맞게 이미지 크기를 조정하는 모드

- aspectRatio
    - 가로 세로 비율을 유지하며 화면에 맞도록 하는 모드
    - fill
        - 이미지 잘리기도 함 + 화면에 아예 꽉차게
        - ![](https://hackmd.io/_uploads/rk46V52rh.png)

    - fit
        - 이미지 전체를 보여줌 + 비율 맞춤 (화면에 꽉차지 않음)
        - ![](https://hackmd.io/_uploads/r11C452B3.png)


차례대로
![](https://hackmd.io/_uploads/SJQDa52Hn.png)
![](https://hackmd.io/_uploads/Hyrvp9nH3.png)
![](https://hackmd.io/_uploads/S1_vachr3.png)


#### 프리뷰에서 네비게이션뷰 적용하기


![](https://hackmd.io/_uploads/ByjqH92Bn.png)

원래 이랬는데 프리뷰에 NavigationView만 넣어주면 아래와 같이 제대로 나옴

![](https://hackmd.io/_uploads/HksjHc2B2.png)


#### 발표자의 질문 
> 샌드위치 안의 소스의 양을 확인하기 위해 이미지를 확대했다 작게했다 하면서 동적으로 컨텐츠를 변경하고싶은데 어떻게 할 수 있을까?
>  => 알려면 SwiftUI에서 뷰가 작동하는 방식과 이유에 대해 알아야한다.

- 스유에서 View는 UIView와 같은 기본 클래스에서 상속되는 클래스가 아니라 View 프로토콜을 준수하는 구조체이다. 
- 따라서 이는 뷰가 저장 프로퍼티를 상속하지 않음을 의미하고, 이는 스택에 할당되고 값으로 전달된다. (pass by value)
- 스유에서는 뷰가 엄청나게 light하다. => SwiftUI에서는 리팩토링을 망설일필요가 없다. subview를 추출하는 것은 런타임 오버헤드가 없기 때문이다.
- 프레임워크는 언제 다시 렌더링을 할지 알고있다. 그 이유는 view가 dependencies를 가졌기 때문이다. ‼️
- 사용자가 zoom하면 이미지를 fill로, 아니면 이미지를 fit으로 바꾸는 예시

![](https://hackmd.io/_uploads/B1nAGshS3.png)


- SwiftUI는 해당변수가 read, written 될 때를 observe할 수 있다.
- SwiftUI는 body내에서 zoomed가 read 되어지는것을 알고, 그것에 따라 렌더링하도록 할 수 있다.
- 즉, 해당 프로펕티가 변할떄, framework는 body가 다시 렌더링하도록 한다.


다시 돌아와서  아래 모서리부분에 빈 공간이 생기는 문제점이 발생했다. 

![](https://hackmd.io/_uploads/SkJrminBh.png)

- 이를 해결하기 위해서는 `edgesIgnoringSafeArea(.bottom)` 을 사용해주면 된다. 그럼 아래쪽 가장자리가 사라진다.

- Spacer()는 자동으로 요소 사이의 일부 padding을 유지하기 위한 최소한의 크기를 갖는다.
    - Spacer(minLength:)를 통해 설정할 수 있다.


- ![](https://hackmd.io/_uploads/rygOLinH3.gif)

이런 애니메이션이 자연스럽게 나오도록 WithAnimation과 transition을 사용해줌

![](https://hackmd.io/_uploads/r1eFUjhHh.png)
![](https://hackmd.io/_uploads/BJYFLinHh.png)



그럼 지금까지 아이폰에서 봤고, 아이패드에서는 어떻게 보일까?

아래와 같이 보인다.
![](https://hackmd.io/_uploads/S17CDi3Bn.png)
![](https://hackmd.io/_uploads/SJ4nvs2r3.png)


![](https://hackmd.io/_uploads/rye-OihH2.png)


그래서 빈 화면에 샌드위치를 선택하라는 글을 써주려면 이렇게 네비게이션뷰 안에 Text만 추가해주면 된다. 

![](https://hackmd.io/_uploads/BkMVOj3Sn.png)


### SandwichStore로 리팩토링🔩


1. 최상단 

![](https://hackmd.io/_uploads/rkIZKT3H3.png)

앱의 시작점은 @main을 통해 이루어지고, 그 객체는 App 프로토콜을 채택하며  WindowGroup에서 시작화면을 정의한다.

2. ContentView

![](https://hackmd.io/_uploads/BkzztTnr3.png)

3. SandwichStore

![](https://hackmd.io/_uploads/BkfXYT3H3.png)



### 📚 스유 프로퍼티 래퍼 정리 

> @ObservedObject / @Published 

@State는 `특정 view에서만 사용하는 프로퍼티` 였다면,
@ObservedObject는` 여러 view에서 공유할 수 있는 커스텀 타입이 있는 경우나 여러 프로퍼티나 메서드가 있는 경우`, 즉 **복잡한 프로퍼티**에 사용된다.

<br>

특징
> ❗️ 1. String이나 integer 같은 간단한 로컬 프로퍼티 대신 외부 참조 타입을 사용한다는 점을 제외하면 @State와 매우 유사.
> ❗️ 2. @ObservedObject와 함께 사용하는 타입은 ObservableObject 프로토콜을 따라야 함.
> ❗️ 3. @Observed object가 데이터가 변경되었음을 view에 알리는 방법은 여러 가지가 있지만 가장 쉬운 방법은 @Published 프로퍼티 래퍼를 사용하는 것. = SwiftUI에 view reload를 트리거.

예시
```swift
class UserSettings: ObservableObject {
   // @ObservedObject를 사용하기위해 @Published를 할당
   @Published var score = 0
}
 
struct ContentView: View {
    // @state를 지우고 @ObervedObject로 바꿔줌
    // view가 외부 객체를 감지하게 해주는 역할
    @ObservedObject var settings = UserSettings()
 
    var body: some View {
        VStack {
            Text("나의 점수는 \(settings.score)점 입니다.")
            Button(action: {
                self.settings.score += 1
            }) {
                Text("Increase Score")
            }
        }
    }
}
```
score에 @Published가 붙었기 때문에 이 score가 변경되면 view를 reload하게 된다.
 
 
> 참조타입이 아닌 struct로 해주고 싶을 때 
```swift
struct UserSettings {
    var score = 0
}
 
struct ContentView: View {
 
    @State var settings = UserSettings()
 
    var body: some View {
        VStack {
            Text("나의 점수는 \(settings.score)점 입니다.")
            Button(action: {
                self.settings.score += 1
            }) {
                Text("Increase Score")
            }
        }
    }
}
```

> @StateObject

WWDC 2020에서 애플은 @StateObject를 추가로 공개했다.
@ObservedObject와 거의 같은 방식으로 작동한다.
SwiftUI가 View를 다시 랜더링 할 때, 실수록 취소되는 것을 방지해준다고 한다.
