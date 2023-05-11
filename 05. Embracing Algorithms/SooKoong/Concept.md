# [WWDC18] Embracing Algorithms

## 💎 배경

> **모델, 뷰, 컨트롤러가 디자인 프로세스에서 중요한 역할을 하지만, 앱이 수행해야 할 밑바탕 작업에는 그만큼의 관심을 기울이지 않는 경우가 많다. 코드 영역에서 loop문(반복문)을 사용하는 것은 과연 좋은 방법인가를 고민해보자.**
> 

## 💎 해결방안

> **앱 내 알고리즘을 식별하고 최적화하는 방법을 이해하며, 일반 프로토콜 확장으로 알고리즘을 구현하여 효율적이고 효과적이며 유지 보수가 용이한 코드를 생성하자!**
> 

> **구체적으로는 Swift Standard Library를 이해하여 Raw Loop를 기피하자. Swift Standard Library에 존재하지 않는다면, 직접 알고리즘을 생성하여 implementation에 loop를 이동시키자.**
> 

- **문제상황: Loop로 인한 코드 성능 고민**
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/64da090e-f670-452c-9d7b-e2b04f244f33" width="50%" height="50%">
    
    - Array 내에서 isSelected가 True인 도형을 제거하는 작업
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/8d556790-93fa-4d42-a771-b7f8ec1409dd" width="50%" height="50%">
    
    - remove(at:) 메서드를 통해 Array 길이의 변화로 Error 발생
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/05056186-824f-4e21-b7e0-0d53ec42c3e5" width="50%" height="50%">
    
    - while문으로 변경 및 인덱스 카운팅 방법에 대한 개선
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/6e8572f6-6168-4acd-95d6-f9877ca20bf1" width="50%" height="50%">
    
    - 그러나, grouping된 요소에 대해서 건너뛰는 Error 발생
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/a7b804be-13d8-4124-9764-c034a3ac3f84" width="50%" height="50%">
    
    - else문을 통한 개선
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/260e822f-2486-40a2-a429-903cc9722ef2" width="50%" height="50%">
    
    - 추가적으로, reversed()를 통해 remove(at:)을 통해 재정립되는 인덱스에 대한 문제를 해결
    - 즉, 앞에서부터 해당 요소를 제거하면 인덱스 재정립이 필요했으나, 뒤에서부터 삭제한다면 인덱스 재정립이 필요하지 않고 해당 인덱스의 요소를 삭제만 하면 됨!
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/d0eb0e58-185f-49cc-b818-480ead3e2d78" width="50%" height="50%">
    
    - 그런데 remove(at:) 메서드는 시간복잡도가 O(N)의 작업이므로, loop와 합쳐져 O(N^2)의 시간복잡도를 가짐
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/ef58ac4d-819e-42f8-8ca7-90403994f7f3" width="50%" height="50%">
    
    - 이는 N의 크기가 커질수록 기하급수적으로 처리해야할 요소가 많아지기에 효율적이라 보기에는 어려움
- **해결방안: Swift Standard Library를 통한 Algorithm 적용**
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/19d1cac3-0555-4e77-a340-48f94f944215" width="50%" height="50%">
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/9ce20fd1-6650-4d63-a072-d10d3511e8d9" width="50%" height="50%">
    
    - Swift Standard Libray에 정의된 removeAll(where:) 메서드를 활용하여 시간복잡도를 O(N)으로 개선
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/be9c88e6-ea33-4f7e-b863-971ce9081988" width="50%" height="50%">
    
    - removeAll(where:) 메서드의 구현부를 직접 보면, 우선 generic algorithm임을 확인 가능
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/0af9bac3-a8a1-4eb0-a1e8-5118372d2b29" width="50%" height="50%">
    
    - 다음으로, halfStablePartition(isSuffixElement)이란 알고리즘 메서드를 통해 해당 predicate를 통해 움직이지 않아도 될 요소는 유지시키고, 움직여야할 요소는 scramble함
    - 이는 위의 그림을 통해 알 수 있음
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/eb2eb59e-4583-4fc2-b7e3-4a82f4a264ff" width="50%" height="50%">
    
    - 마지막으로, removeSubrange()를 통해 불필요한 요소 제거
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/4d06c200-876f-4944-8ec3-5f432ae9f72f" width="50%" height="50%">
    
    - 추가적으로, halfStablePartition(isSuffixElement:)는 위와 같이 구현되어있음
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/1ecfd6a7-431f-4479-8103-29b4310c138a" width="50%" height="50%">
    
    - 이를 통해 알 수 있는 건 이 알고리즘 메서드 또한 firstIndex(where:)라는 또 다른 알고리즘 메서드를 사용하고 있다는 것임
    - 그리고 메서드 요소를 재정렬해야 하지만 컬렉션의 길이나 구조를 변경하지 않기 때문에 위와 달리, MutableCollection만을 준수한다는 점
    - 어쨌든 중요한건, **[Swift Standard Library](https://developer.apple.com/documentation/swift/swift-standard-library)에 친숙해져, 각각의 알고리즘의 의미와 성능을 파악하여 사용해보자**
    
    <img src = "https://github.com/Groot-94/WWDC_Study/assets/99063327/746f8d30-48e8-4f62-8077-989d22e4c6d7" width="50%" height="50%">
    
    - 이는 직접 Loop문을 작성하는 것보다 알고리즘 호출로 대체하는 것이 성능면에서나 가독성 및 유지보수 면에서나 이점이 있을 것임을 의미
    - 만약 필요한 알고리즘을 찾을 수 없다면, 해당 알고리즘을 직접 만들고 루프를 구현부로 이동시키자(**No Raw Loops**)

## 💎 요약

> **Discover Generic Algorithms! No Raw Loops**
> 

## 💎 참고 자료

- **Embracing Algorithms - Apple Developer**

[Embracing Algorithms - WWDC18 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2018/223/)

- ****WWDC 2018 — Embracing Algorithms — 223 - Ankit Kumar Gupta Medium****

[WWDC 2018 — Embracing Algorithms — 223](https://medium.com/@ankitkumargupta/wwdc-2018-embracing-algorithms-223-8b4fb11966d5)
