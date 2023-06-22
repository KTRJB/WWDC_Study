# Embrace Swift type inference

스위프트는 코드의 안정성을 훼손하지 않고 간결한 코드를 작성하기 위해 타입 추론을 자주 사용합니다.

이 영상을 통해 다음의 것을 살펴볼 것 입니다.

1. 타입 추론을 활용하는 법
2. 컴파일러에서 타입 추론이 어떻게 동작하고 컴파일 하는지
3. 타입 추론에 의해 발생할 수 있는 에러의 원인과 이를 해결하는 방법

## 인터페이스란?

먼저 타입 추론이 무엇일까요??

타입 추론은 프로퍼티에 타입을 명시적으로 선언하지 않아도 컴파일러가 문맥에 따라 타입을 추론하는 것을 말합니다.

![](https://hackmd.io/_uploads/BkOYRibdh.png)

위의 코드를 보면 String을 명시적으로 선언하지 않아도 컴파일러 자체에서 이것을 String으로 추론 합니다.

자 좀더 복잡한 코드를 봅시다.

![](https://hackmd.io/_uploads/ryD3RjW_3.png)

위의 코드에서는 FilteredList가 주어진 데이터를 리스트 형태로 보여주고 필터링 하는 기능을 제공하는 재사용 뷰 입니다. 이 FilteredList는 재사용이 가능해야 하므로 기본적으로 생성자들에 대해서 제네릭 해야 합니다.

위의 코드에서 FilteredList를 사용하면서 따로 타입을 명시해주지 않고 있는데, 이는 컴파일러가 타입 추론을 하기 떄문에 가능한 일입니다.

좀 더 자세하게 FilteredList가 어떻게 정의되어 있는지 코드를 살펴봅시다.

![](https://hackmd.io/_uploads/BkeEy3W_n.png)

Elment, FilterKey 그리고 RowContent는 FilteredList가 생성될 떄 실제 타입, 즉 Concrete 타입으로 대체됩니다.
선언부와 호출부를 나란히 두고 비교해 봅시다.

![](https://hackmd.io/_uploads/Hkkdy2ZO3.png)

제네릭 타입으로 인해 복잡한 선언부와 비교했을 떄 호출부는 훨씬 깔끔한 코드임을 확인할 수 있습니다. 이는 컴파일러가 주어진 값들로 타입 추론을 하기 떄문에 가능한 일입니다.
만약 타입 추론이 아닌 선언해주어야만 타입을 선언한다면 아래 처럼 복잡한 코드를 작성해야 합니다.

![](https://hackmd.io/_uploads/SJyaJ3WOh.png)

자 그러면 이제 타입 추론에 대해 얘기를 나누었고, 그럼 컴파일러는 어떻게 타입 추론을 하는 것에 대해서 얘기해봅시다.

타입 추론은 퍼즐이라고 할 수 있습니다. 우리는 퍼즐을 하면서 하나의 조각이 맞춰질떄마다 다음 조각이 어떤 것인지 자연스럽게 유추할 수 있습니다. 마치 단서를 얻는 것처럼 말이죠.
컴파일러는 이렇게 퍼즐을 풀 듯이 코드에서 단서를 찾아 하나씩 맞춰가면서 타입을 추론합니다.

위의 코드를 사용하여 컴파일러가 어떻게 퍼즐을 맞춰가는지 살펴봅시다.

![](https://hackmd.io/_uploads/rJiXe3WO3.png)

첫번쨰로 인자를 넘기는 smoothies라는 단서를 통해 Element의 타입을 추론할 수 있습니다. smoothies는 [Smoothie] 타입으로 Elment는 Smoothie타입으로 대체됩니다.

![](https://hackmd.io/_uploads/SJTIg3Zdh.png)

이제 Elment는 추론할 수 있어 다음 단서를 얻을 수 있습니다. 그 다음은 FilterKey입니다. \.title은 \Smoothe.title로 대체되고, Smoothie의 title프로퍼티는 String이란 것을 알 수 있기 떄문에 FilterKey는 String으로 대체됩니다.

![](https://hackmd.io/_uploads/S1ciehZd3.png)

![](https://hackmd.io/_uploads/rk12x3-_n.png)

RowContent 역시 ViewBuilder 클로저 안에서 SmoothieRowView가 반환되기 떄문에SmoothieRowView로 대체될 수 있습니다.

![](https://hackmd.io/_uploads/ryeCae2b_h.png)

![](https://hackmd.io/_uploads/SyMAe3ZOh.png)

이런 식으로 컴파일러는 이전 단계의 단서를 통해 하나씩 타입을 추론해 갑니다. 하지만 이렇게 얻은 이전 단계의 퍼즐 단서가 맞지 않는다면 소스 코드에 에러가 발생한 것을 알 수 있습니다. 즉 타입이 맞지 않아 컴파일러는 타입 추론을 할 수 없습니다.

Smoothie.title이 아닌 Bool타입의 Smoothie.isPopular로 바꿔봅시다.

![](https://hackmd.io/_uploads/r1OmW2Z_n.png)

이렇게 된다면 컴파일러는 Bool타입을 FilterKey의 조각으로 사용할 것이지만 Bool타입은 hasSubString(_:) 메서드가 없기에 이후 타입을 추론할 수 없고 에러가 발생됩니다.

![](https://hackmd.io/_uploads/SyAIbnZdh.png)

이렇게 스위프트 컴파일러는 에러 메세지 출력할 떄 사용하기 위해 에러 추적 기능을 타입 추론과 통합시켰습니다. 컴파일러는 타입 추론을 진행하면서 직면한 에러를 기록하게 됩니다. 그리고 컴파일러는 에러를 고치고 타입 추론을 계속 진행하기 위해 휴리스틱? 이란것을 사용합니다.

그리고 타입 추론이 끝나게 되면 컴파일러는 타입 추론을 진행하면서 수집한 에러를 actionable한 에러 메세지(자동 수정)이나 에러를 발생시킨 실제 타입에 대한 메시지와 함께 개발자에게 알립니다.

휴리스틱?? - 발견법?? 간편추론??? 
발견법은 인간과 기계에서 어떤 문제를 해결하거나 제어하기 위해 필요한 정보를 느슨하게 적용시키는 접근을 시도하는 전략을 말한다.[6] 가능한 가장 좋은 해답 혹은 최적의 해결법에 접근하기 위한 빠른 방법을 얻기 위해 특히 쓰인다. 이는 어림짐작이며 교육된 추정이고 직감에 의한 직관적인 판단 또는 간단히 상식을 이용한다. 발견법은 문제를 해결하기 위해 가장 보편적으로 쓰는 방법 중 하나이다.

- 위키\