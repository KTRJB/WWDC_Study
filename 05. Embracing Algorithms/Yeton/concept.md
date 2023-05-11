# 📚 embraces Algorithm WWDC 

#### ✅ 한 줄 요약:  알고리즘이 애플리케이션을 구축하고 효율적인 코드 및 사용자 경험을 개선하는 데 어떻게 사용될 수 있는지 설명

<br>

아래는 배열을 돌면서 특정 원소를 찾아지우는 연산이다.

![](https://hackmd.io/_uploads/Bkh-GvcVh.png)

![](https://hackmd.io/_uploads/By0ZX7qV2.png)

- 앞에서부터 for문을 돌면서 지우면 문제가 발생함.
    - 지울때 마다 원소의 개수가 바뀌면서 out-of-index 문제가 생긴다. 

![](https://hackmd.io/_uploads/S1IfYX9Nn.png)

- while문으로 변경하면 버그를 알아차리기 힘들고, 인덱스를 잘못 스킵하는 문제가 생길 수 있다. 예를 들어 두 개의 요소를 연속적으로 선택하면 첫 번째 요소가 제거되고 다음 요소로 바로 이동하기 때문에 문제가 발생한다. 
- 해결하더라도 else구문을 추가해야 해서 코드가 길어진다. 


![](https://hackmd.io/_uploads/ByAgKQc4h.png)

- 그래서 발표자가 알아낸 방법은 위와 같이 뒤에서부터 탐색하는 방법이다. 
- 거꾸로 가면 배열의 일부를 아직 변경하지 않은 부분만 반복하며 삭제할 수 있게 된다.
- 하지만 위의 코드는 원소가 많아지면 느려지는 상황이 생긴다. 

이를 크러스트가 해결해줌.

위의 코드가 느린 이유는, 이는 배열의 삭제 연산이 O(n)이기 때문이다. 실제로는 **O(n^2)** 이라고 한다.

위의 방법을 해결할 수 있는데, 바로 **O(n)** 인` removeAll(where:)`을 쓰는 것이다.


![](https://hackmd.io/_uploads/rkrRqQcNn.png)


![](https://hackmd.io/_uploads/SkD4iXq4n.png)

### Linear vs Quadratic

![](https://hackmd.io/_uploads/r1UJ2m942.png)

Linear 알고리즘은 작은 문제에서는 더 좋지 않을 수 있지만, 결국에는 Quadratic 알고리즘보다 더 빠르다.
만약 우리가 계속해서 더 큰 문제를 본다면, 항상 선형 알고리즘이 승리하는 것을 발견할 수 있다.

따라서 우리는 절대적인 성능이 아니라 확장성에 대해 이야기해야한다.


확장성 문제는 해결되었지만, 이전에 발표자가 썼던 스위프트 표준 라이브러리는 어떻게 개선되었는지 확인하고 싶었다. 
=> removeAll의 내부 구조를 살펴보자!

1. halfStablePartition을 한다.
2. 나머지 뒷부분을 모두 삭제한다.

![](https://hackmd.io/_uploads/SykdwNcN3.png)

![](https://hackmd.io/_uploads/SyZRRXqV2.png)

결과: 사용하는 모든 면에서 좋아졌음. 
주석을 이해해야하는 번거로움 & 성능까찌 모두!

이와 같이 swift standard Libray를 알면, 이러한 최적화된 코드를 쉽게 짤 수 있으며, 코드의 의미도 쉽게 알 수 있다.
모든 것을 기억할 필요는 없다. 거기에 무엇이 있고 어떻게 그것을 찾을 수 있는지에 대한 아이디어를 갖는 것이 우리에게 많은 도우밍 될 것이다.

<br>

또, 도형의 순서를 자유자재로 바꾸는 코드가 필요하다고 해보자.

![](https://hackmd.io/_uploads/Hy_geN9En.png)

![](https://hackmd.io/_uploads/SJ7T5VqVh.png)

삭제 후 다시 삽입하기 때문에 결국 또 O(n^2)의 시간복잡도가 발생한다.
이를 어떻게 해결할까?

코드가 아닌 말로 이 상황을 설명하면,
"선택한 도형을 앞으로 이동하여 상대적 순서를 유지합니다." 가 된다. 

=> Stable Partition이라는 게 있구나! 깨달음


- swift 오픈 소스 프로젝트의 이 파일에서 구현부를 찾을 수 있었음 [링크]( https://github.com/apple/swift/blob/master/test/Prototypes/Algorithms.swift)
<br>

변경 전 
![](https://hackmd.io/_uploads/SJUBsS54h.png)

변경 후 
![](https://hackmd.io/_uploads/ByhjiS943.png)


![](https://hackmd.io/_uploads/ryln3B943.png)


![](https://hackmd.io/_uploads/Sy68ar9N3.png)
nlogn은 n^2만큼은 아니지만 거의 비슷하게 취급돼서 굿. (실제로 nlogn이 성능이 훨씬 조음)

<br>

도형 예시 
![](https://hackmd.io/_uploads/HkAkbLcNh.png)
![](https://hackmd.io/_uploads/r1ycgUqNn.png)


원래 이랬는데
![](https://hackmd.io/_uploads/HJ-WJUqE3.png)

이렇게 바꿀 수 있게 됨
![](https://hackmd.io/_uploads/B1jmeI5N2.png)




즉, 앞에 날리고 뒤에 stablePartition 하면 된다.

근데 일반화하려면, 위 아이콘의 모양이나 배열의 특성에 구애받지 않도록 만들어야 하겠지?
그럼 어떻게 해야할까

1. shape를 어떤 모양이든 가능하도록 해보자
![](https://hackmd.io/_uploads/SJRNmLcE2.png)
2. 근데 where절을 없애고 싶은데...?
![](https://hackmd.io/_uploads/H1zS785Nn.png)
3. 그럼 이렇게 바꾸면 됨! 근데 array에도 구애받고 싶지 않은데?
![](https://hackmd.io/_uploads/HkVH7UcEn.png)
4. 그럼 mutableCollection으로 바꿔주자! 근데 오류가뜬다... array는 다른걸로 바꿔놓고 또 Int를 쓴단말야..?
![](https://hackmd.io/_uploads/Syq44L94h.png)
5. 완성~
![](https://hackmd.io/_uploads/rk0Am85Nh.png)

<br>

> 결론

- 모양, selections, 배열, int에 대한 모든 세부사항을 제거하면 "핵심"만 전달되기 때문에 코드가 명확해진다.
- 즉, 필요한 알고리즘을 최대한 일반적으로 짜도록 하자.
- 테스트와 문서화를 잊으면 안된다. 
- 우리는 추상화의 탑들을 만들고 있다. 우리 아래의 층들을 지속적으로 조사하지 않고 만들 수 있는 이유는 우리가 만드는 부분들이 문서화되어 있기 때문이다.
    - 앱 개발자로서, 우리는 시스템 프레임워크, DOS, 그리고 물리 법칙에 기초한 하드웨어에 걸쳐 있는 타워의 맨 꼭대기에서 일하고 있다.
- `generic algorithms`이 non-generic algorithms보다 더 재사용 가능하고, 테스트 가능하며, 훨씬 더 명확하다.
- 그러므로 우리들의 코드를 문서화하자.
- 조직에서 코드 품질을 개선하려면 모든 코딩 표준을 원시 루프 없음이라는 하나의 목표로 교체하자.
