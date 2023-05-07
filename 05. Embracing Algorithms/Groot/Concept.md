## Embracing Algorithms - 2018

- WWDC 목적 : 앱에서 알고리즘을 식별하고 최적화하는 방법을 이해하고 알고리즘을 일반 프로토콜 확장으로 구현하여 효율적이고 효과적이며 유지 관리 가능한 코드를 생성하는 방법을 알아봐라~
- 배열에서 선택한 요소를 제거하는 함수를 만드는 예제를 만들어서 사용했는데 굉장히 느려지는 문제가 생겼다.
![](https://hackmd.io/_uploads/HyFX_VSEh.png)
![](https://hackmd.io/_uploads/H1FmOEBEn.png)
- 문제가 생긴 부분은 아래와 같다.
- 배열의 요소를 제거하면 다음 요소를 모두 새 위치로 밀어 넣어야한다.
- 그래서 결국 제곱의 시간이 들어서 오래걸렸다.
- 0~20개의 요소로 구성된 작은 테스트 케이스의 경우 빠르다고 느꼈지만
- 사람들이 점점 더 많은 데이터를 관리하기 위해 휴대폰과 iPad를 사용하고 있기 때문에 확장성이 중요

![](https://hackmd.io/_uploads/SJDdd4rN2.png)

- 확장성을 고려해서 removeAll을 사용하자

![](https://hackmd.io/_uploads/HJJKOEHVn.png)

![](https://hackmd.io/_uploads/S1cY_VHE3.png)

- removeAll을 사용하면 데이터 양이 적을 땐 기존 알고리즘(n제곱)보다 느릴 수 있다.
- 하지만, 선형 알고리즘이 결국에는 더 빠르다.

![](https://hackmd.io/_uploads/BJ2qdVHV2.png)

![](https://hackmd.io/_uploads/SySj_NS42.png)


- RemoveAll은 구현내부를 볼 수 있다. 하지만, halfStablePartition은 세부 사항이라서 볼 수 없다.

### halfStablePartition 설명부분

![](https://hackmd.io/_uploads/rJIT_NrE2.png)

### 스위프트 표준 라이브러리에 익숙해져라

- [https://developer.apple.com/documentation/swift/swift-standard-library](https://developer.apple.com/documentation/swift/swift-standard-library)
- 모든 것을 기억하지 않고, 거기에 무엇이 있고 그것을 찾는 방법에 대한 아이디어가 있으면 좋다.
- 후행클로저를 통해 주석이 없어도 간결하게 표현되는 코드를 만듬.

![](https://hackmd.io/_uploads/Hk20dNH43.png)

- 도형의 순서를 바꾸기 위한 함수를 만들어보자.

![](https://hackmd.io/_uploads/ry_yYNrVh.png)

![](https://hackmd.io/_uploads/HyFxFErEn.png)

![](https://hackmd.io/_uploads/BJ0gtNSE3.png)

- 선택 된 도형을 삭제하고 특정 위치에 다시 삽입하는 방법으로 구현이 가능
- 하지만, 탐색(n) * 삽입(n)을 하기 때문에 n제곱의 시간복잡도를 가지게 된다.

![](https://hackmd.io/_uploads/ByZztNB4n.png)


- 크러스티 아저씨가 이 동작을 말로 설명하라고 했다. “선택한 도형을 앞으로 이동시켜 상대적인 순서를 유지한다 라고” 설명해보니 이 동작을 구현할 수 있는 무언가가 있다고 깨달았다고 함.

- 그게 바로 Stable partition 임
- [https://github.com/apple/swift/blob/main/test/Prototypes/Algorithms.swift](https://github.com/apple/swift/blob/main/test/Prototypes/Algorithms.swift)

![](https://hackmd.io/_uploads/SysGtVrN3.png)

![](https://hackmd.io/_uploads/HyvmtVB4h.png)

- 하지만, 우리가 원하는 동작은 특정 위치로 옮기는 것이지 맨 앞이나 맨 뒤가 아님.

![](https://hackmd.io/_uploads/BkuEY4BVn.png)

![](https://hackmd.io/_uploads/BywStVSE3.png)

- 우리가 원하는 동작

![](https://hackmd.io/_uploads/rkXUFEHEn.png)

![](https://hackmd.io/_uploads/By2UF4rEn.png)


- 우리가 원하는 함수에서 앞의 4개 원소를 제외하고 실행한다면 `stablePartition` 함수를 사용하는 방법과 다를게 없다.

![](https://hackmd.io/_uploads/HkQvY4HVh.png)

## Discover Algorithms

- 예전부터 효율적인 계산에 관련된 문제들을 해결하기 위해서 엄청 많은 자료들이 쌓여있을 것이다.
- 표준 라이브러리에 필요한 것이 없다면, 필요한 것은 아마도 테스트, 문서, 종종 정확성에 대한 증거와 함께 있을 것
- 문제 영역에 적용되는 연구를 웹에서 검색하는 방법을 공부해라.
- 이번엔 만든 bringForward 함수를 일반화 해보자. 지금까지 만든 건 canvas를 위한거임.
- 기존 코드를 일반화 했지만, index에 접근할 때 Int를 사용하는게 문제가 됨.

![](https://hackmd.io/_uploads/rJP_tVB43.png)

![](https://hackmd.io/_uploads/rykFK4HE2.png)

- 루키는 이런식으로 수정하지만, 이러면 안된다.
- 먼저 0번째 인덱스가 아닌 startIndex를 활용해라.
    
![](https://hackmd.io/_uploads/B1qKtES43.png)

    
- `indexBeforeFirst` 알고리즘을 사용해라
- Predecessor는 조건이 만족되는 첫 번째 인덱스 이전의 인덱스이다.

![](https://hackmd.io/_uploads/S1PqF4SEn.png)
 
- 알고리즘을 사용할 때마다 우리가 우리 코드의 의미와 효율성에 대한 결론을 도출하기 위해 크러스티의 문서에 의존했다.
- 앱 개발자로서 시스템 프레임워크, DOS 및 물리 법칙에 따라 하드웨어로 확장되는 계층의 가장 상위에서 일하지만, 자신의 메서드 중 하나를 호출하는 즉시 해당 메서드는 기반의 일부가 되니까 코드를 문서화하자.
- 이미 만들어진 알고리즘 함수들을 통해 또다른 알고리즘이 만들어질 수 있으니 우리가 만든 코드들도 알고리즘의 하나로 문서화를 해놓자는 이야기

![](https://hackmd.io/_uploads/r1roKVBEh.png)

![](https://hackmd.io/_uploads/rJpiYVH4h.png)

- 이런 느낌으로 문서화를 하자.

![](https://hackmd.io/_uploads/S1-2Y4HE3.png)

### stablePartition을 알아보자
![](https://hackmd.io/_uploads/SJFmiVSN3.png)

- 반복해서 분할하고 회전한다는거 같음.
- 자세한 건 실제구현에서 찾아보라함.
### 실제 적용하기
- 기존 코드 설명

![](https://hackmd.io/_uploads/H1lKq3VBVn.png)


1. 임시 버퍼를 할당한다.
2. 선택한 도형만 반복적으로 추출한다.
3. 마지막으로 삽입한다.

- 새로운 방법으로 적용하기

![](https://hackmd.io/_uploads/ryP3TVBNn.png)

- 훨씬 간결해졌다.

### Discover Generic Algorithms
- 이렇게 하는 이유?

- 제네릭 알고리즘은 관련 없는 세부 정보와 분리되어 있기 때문에, 제네릭이 아닌 알고리즘보다 더 재사용 가능하고 테스트 가능하며 훨씬 더 명확하다.
- 이건 프로그래밍을 진정으로 사랑하는 사람에게는 매우 보람 있는 일이라고 생각한다.
- 크러스티 아저씨가 말하길 "프로그래밍은 진짜를 드러낸다." 라고함
- 그러니까 유형 및 응용 프로그램 아키텍처에 대해 진지하게 생각하는 모든 권리와 의무를 가진 일급 시민으로 계산을 처리하자

- 마지막 한마디 
>“If you want to improve the code quality in
your organization, replace all of your coding
guidelines with one goal:
No Raw Loops"
>"조직의 코드 품질을 개선하려면 모든 코딩 표준을 하나의 목표인 No Raw Loops로 바꾸십시오"
