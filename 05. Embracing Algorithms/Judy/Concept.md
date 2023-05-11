## 상황 1
### 선택 항목 삭제
배열에서 특정 항목을 선택해 삭제하고자 할 때

#### 방법 1) for
```swift
extension Canvas {
	mutating func deleteSelection() {
		for i in 0..<shapes.count {	
        	if shapes[i].isSelected {
            	shapes.remove(at: i)
            }
		}
	}
}
```
- 0에서부터 삭제할 항목을 반복으로 찾은 후 제거
문제) 이미 삭제를 해도 끝까지 반복하여 빈 요소(존재하지 않는 끝 요소)를 가리키게 됨
<br>

#### 방법 2) while
```swift
extension Canvas {
	mutating func deleteSelection() {
    	var i = 0
		while i < shapes.count {	
        	if shapes[i].isSelected {
            	shapes.remove(at: i)
            }
            i += 1
		}
	}
}
```
- while을 사용하면 count를 셀 수 있음 
문제) 연속되어 선택된 경우 첫 요소를 제거 후 바로 다음 요소로 건너뜀
- 테스트로 실행되지 않는 이상 버그를 찾아내기 어려움
<br>

#### 방법 3) else
```swift
extension Canvas {
	mutating func deleteSelection() {
    	var i = 0
		while i < shapes.count {	
        	if shapes[i].isSelected {
            	shapes.remove(at: i)
            }
            else {
         	   i += 1
            }
		}
	}
}
```

- 왜 이렇게 어렵게 해? 🤷🏻‍♀️ 뒤에서부터 반복하면 되는데
<br>

#### 방법 4) 뒤에서 반복
```swift
extension Canvas {
	mutating func deleteSelection() {
		for i in (0..<shapes.count).reversed() {
			if shapes[i].isSelected {
				shapes.remove(at: i)
			}
		}
	} 
}
```
- 아직 변경하지 않은 배열 부분만 반복
<br>

#### 💡 문제
요소를 제거하려면 배열 길이에 비례하는 단계가 필요 => O(n)
> - 각 요소에 대해 한 번씩 n단계를 수행
> - n 개의 요소를 선택할 수 있음
> => 총 단계 수는 n 제곱의 비례

<br>

### 알고리즘으로 해결
어떻게 해결할까? -> 알고리즘을 사용하자

#### 방법 5) removeAll(where:) 적용
```swift
extension Canvas {
	mutating func deleteSelection() {
		shapes.removeAll(where: { $0.isSelected })
	}
}
```
- 성능 문제 해결
- `removeAll()` - O(n)
- 루프에 넣을 필요가 없어 전제 작업 반복하지 않아도 됨
<br>

### 성능
- 선형 알고리즘은 작은 문제에서는 나쁠 수 있지만 결국에는 2차 알고리즘보다 빠름
- 결국 언제가는 선형 알고리즘이 좋은 성능인 지점이 존재
- 우리가 중요시하는 것은 절대적인 성능이 아니라 확장성!
<br>

> 교훈 = **Swift 표준 라이브러리 내용에 익숙해지자**
> - 문서화된 내용과 의미있는 알고리즘 모음이 포함됨
> - 공식 문서는 라이브러리를 효과적으로 사용하기 위해 알아야 할 것들을 알려줌

<br>

### 결과
![](https://velog.velcdn.com/images/juyoung999/post/921b9d3c-8c69-48f0-ac73-e3d9f28ce56a/image.png)

=> 알고리즘을 적용한 쪽이 훨씬 명백함을 알 수 있음

> Shawn Perin이 제한한 코드의 지침<br>
> - Loop를 작성할 때마다 알고리즘 호출로 대체해라<br>
> - 알고리즘을 찾을 수 없다면 직접 만들어 대체해라

<br>

## 상황 2
### bringToFront()
- 도형들을 그룹화하고 앞으로 가져오는 메서드
![](https://velog.velcdn.com/images/juyoung999/post/2af411f8-6fed-4ab3-a40f-4383b049fe0c/image.png)

- 이외에도 배열을 반복하면서 삽입 및 삭제 동작을 하기 때문에 이와 비슷한 역할의 메서드 모두 O(n^2)을 가짐
<br>

### 생각해보기
> 무슨 동작을 하나? **"선택한 도형을 상대적 순서를 유지하면서 앞으로 이동하기"**<br>
=> `stablePartition(isSuffixElement: (Shape) -> Bool)`<br>
=> nlogn

<br>

### nlogn
![](https://velog.velcdn.com/images/juyoung999/post/68799489-97e8-4e31-a55c-4d6164357bcc/image.png)
- logn : 빠르게 평준화되고 더 커질수록 느리게 성장하고, 일정해질수록 더 가까워짐

O(nlogn)
- 커짐에 따라 선형에 가까워짐
- 동일하게 취급하기도 함
<br>

### bringToForward
선택한 도형 중 가장 앞쪽에서 하나 앞으로 이동한 후 모두 가져오기

![](https://velog.velcdn.com/images/juyoung999/post/c2d2a666-2d2c-4355-be9c-966d6418ff3e/image.png)

- 맨 앞 도형 하나 이동 + 뒤에 선택된 도형 가져오기 => ❌
-> 부분적으로 `stablePartition`을 적용하면 동일한 작업을 할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/bf9b1b55-1c32-4fdc-8221-8eede66bdb0d/image.png)

- 일부만 어떻게 수정하나? -> **Slice**를 이용
- 배열에서 일정 범위만 사용할 수 있음
<br>

### 일반화
하지만 Slice는 배열 타입이 아님

어떻게 테스트할건데? 일반적으로 만들어라!

#### 1. 캔버스에서 분리하고 모양 배열로 이동

```swift
extension Canvas
-->
extension Array where Element == Shape
```
Shape를 가지는 모든 배열(Array)에서 가능하도록 변경

```swift
extension Array where Element == Shape {
	mutating func bringForward() {
		if let i = firstIndex(where: { $0.isSelected }) {
			if i == 0 { return }
			let predecessor = i - 1
			self[predecessor...].stablePartition(isSuffixElement: { !$0.isSelected })
		}
	} 
}

--> where 절 제거

extension Array {
mutating func bringForward(elementsSatisfying predicate: (Element) -> Bool) {
	if let i = firstIndex(where: predicate) {
		if i == 0 { return }
		let predecessor = i - 1
			self[predecessor...].stablePartition(isSuffixElement: { !predicate($0) })
		}
    }
}
```

`$0.isSelected`에 해당하는 조건을 매개변수로 받아 Shape와 종속성을 떼어낼 수 잇음 -> 모든 Array에서 가능!
<br>

#### 2. Array에서 벗어나기
Array이여만 해? `아.. 그것도 아님`

![](https://velog.velcdn.com/images/juyoung999/post/63cd4045-c7aa-4108-aa93-2549603d75b4/image.png)

가변 컬렉션으로 변경 -> 하지만 Index가 Int가 아니라서 문제
-> `where Index == Int`? 🚫

- 애초에 0과 비교하는 것은 문제
- ArraySlice는 0부터 시작하지 않을 수 있음 -> `startIndex`로 변경
- 앞에 있는 위치를 찾기 위해 정수를 빼는 것은 정수에 국한되게 함
-> 이미 존재하는 이전 인덱스를 찾도록 비교하여 위치를 구할 수 있음
<br>

### 결과
- `indexBeforeFirst` 알고리즘 적용
```swift
extension MutableCollection {
	mutating func bringForward(elementsSatisfying predicate: (Element) -> Bool) {
		if let predecessor = indexBeforeFirst(where: predicate) { 		
      	  self[predecessor...].stablePartition(isSuffixElement: { !predicate($0) })
		}
    }
}


extension Collection {
	func indexBeforeFirst(where predicate: (Element) -> Bool) -> Index? {
		return indices.first {
			let successor = index(after: $0)
			return successor != endIndex && predicate(self[successor])
		} 
    }
}
```
➡️ Shape, Selections, Array, Int와 관련 없는 디테일을 제거하면 문제의 핵심만 전달되어 코드가 명확해짐
<br>

## 문제
- 새 알고리즘을 사용할 때마다 의미와 효율성을 도출하기 위해 문서에 의존했다
- 대부분의 알고리즘은 다른 알고리즘을 기반으로 구축되기 때문에 기반이 같음

> 문서화의 역할<br>
> - 우리는 추상화의 탑을 짓고 있다<br>
> - 우리가 아래 레이어를 지속적으로 검사하지 않고 만들 수 있는 이유는 우리가 만드는 부분이 문서화되어 있기 때문이다<br>
> - 우리는 개발자로서 하드웨어까지 뻗어있는 탑 꼭대기에서 일하고 있다<br>
<br>

## 문서화
### bringForward 문서화하기
![](https://velog.velcdn.com/images/juyoung999/post/a4f94f7a-d666-4f7e-8141-f8db0d55f184/image.png)

### stablePartition의 내부
컬렉션 수를 가져오고 분할 정복 전략을 사용하는 메서드로 전달

#### 1. 컬렉션 수가 2 미만일 때 처리
파티션 지점이 컬렉션 시작인지 끝인지만 파악하면 됨

#### 2. 컬렉션을 둘로 나눔
왼쪽과 오른쪽으로 분할 후 작업
중앙 섹션은 교환해야 함 -> ratate 알고리즘
<br>

## 결론
Shape은 도형 목록에서 드래그를 구현하며 복잡하고 버그가 많은 작업이었음

### 해결한 전략 
#### 초기
> 1. 임시 버퍼를 할당<br>
> 2. 삽입점 앞의 도형을 반복하여 선택한 도형을 추출하고 삽입점 조정<br>
> 3. 않고 나머지 도형을 반복하여 선택한 도형을 추출<br>
> 4. 삽입점으로 선택한 도형을 다시 삽입<br>

#### 알고리즘 적용
- 두 파티션으로 나누기 
- 선택한 도형을 가장 뒤로 + 선택한 도형들을 가장 앞으로

![](https://velog.velcdn.com/images/juyoung999/post/990fe84a-e0d5-4236-802c-51b2ff18f238/image.png)

코드를 두 줄만에 끝내게 해줌 = 재사용 가능하고 효율적인 문서화 범용 알고리즘을 얻음
<br>

## 정리
> 애플리케이션 도메인에 세부 정보를 파악하고 기반적으로 수행하는 작업을 확인하고 재사용 가능한 일반 코드를 추출하는 기술

- 세부 정보와 분리되어 재사용 가능 + 테스트 가능 + 명확

=> 타입 및 응용 프로그램 아키텍처의 권리와 의미를 가진 일급 시민으로 계산을 처리해라
식별하고, 이름을 지정하고, 단위 테스트하고, 의미 체계와 성능을 문서화

> “If you want to improve the code quality in   your organization, replace all of your coding guidelines with one goal:
No Raw Loops” <br>
> <br>
> Sean Parent, C++ Seasoning

<br><br>

---

[Embracing Algorithms](https://developer.apple.com/videos/play/wwdc2018/223/)
