# WWDC Unsafe Swift
- 표준 라이브러리에서 Unsafe로 표시되는 API가 소량 있다.
- 이런 작업중 한 가지 예는 옵셔는 강제 언래핑이다.
```swift
let value: Int? = nil

print(value!) // Fatal error: Unexpectedly found nil while unwrapping an Optional value
```
- 값이 nil이 아니여야 하지만, 이 값이 잘못되면 런타임 오류가 발생한다.

- 여기서 unsafelyUnwrapped 속성을 통해 안전하지 않은 강제 언래핑 작업을 제공한다.
```swift
let value: String? = "Hello"

print(value.unsafelyUnwrapped) // Hello
```
- 일반적인 force-unwrap 연산자와 마찬가지로 기본 값이 nil이 아니어야 함.
- 하지만, 최적화가 활성화된 상태로 컴파일되면 이 속성은 이 요구 사항을 확인하지 않는다. nil이 아닌 값으로만 호출하고 직접 읽어낸다는 것을 신뢰하게 된다.
- 실수로 nil을 호출하게 되면 존재하지 않는 값을 읽게되고 결과를 예측할 수 없으며 문제를 디버깅하는 것이 매우 어려울 수 있다.

### Unsafe 키워드
- "Unsafe" 속성을 사용하면 해당 요구 사항을 컴파일 단계에서 확인하지 않기 때문에 충족할 전적인 책임을 진다는 것이다.
- "Unsafe" 접두사는 **위험** 기호처럼 작동하는 네이밍 규칙이다.
- 성능 지향적인 안전하지 않은 인터페이스를 구현한 적이 있다면 이 동작을 복제하는 것이 개발 중에 문제를 훨씬 쉽게 감지할 수 있기 때문에 좋다. 
### Safe code != no crashes
- 안전한 API의 목표는 충돌을 방지하는 것이 아니라는 점에 유의하라.
- 문서화된 제약 조건을 벗어난 입력이 제공되면 안전한 API는 치명적인 런타임 오류를 발생시켜 실행을 중지한다. 
- 그리고 오류로 인해 생성된 충돌 보고서를 통해 문제가 발생한 상황을 알려주므로 문제를 디버깅하고 수정할 수 있다.
- Swift가 안전한 프로그래밍 언어라고 말하는 것은 기본적으로 언어 및 라이브러리 수준 기능이 입력을 완전히 검증한다는 의미이다.
### UnsafeMutablePointer 
- 포인터는 단순히 메모리 어딘가에 있는 위치의 주소를 나타낸다.
- 강력한 작업을 제공하지만 사용자가 올바르게 사용할 것이라고 믿어야 하므로 근본적으로 안전하지 않는다.
- 포인터는 기본 메모리에 대한 완전한 제어를 제공하지만 대신 관리하지는 않는다.
- 나중에 해당 메모리 위치에 어떤 일이 발생하는지 추적할 수도 없다.
- 기본 메모리가 초기화 해제되고 할당 해제됨에 따라 포인터가 무효화된다.
- 그러나 유효하지 않은 포인터는 일반적인 유효한 포인터처럼 보이고, 포인터 자체는 자신이 무효화되었음을 알지 못함.
```swift
let ptr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
ptr.initialize(to: 42)
print(ptr.pointee) // 42
ptr.deallocate()
ptr.pointee = 23 // UNDEFINED BEHAVIOR
```
- 이 코드에서 `ptr.deallocate()`를 통해 포인터를 해제했지만, `ptr.pointee = 23`를 통해 다시 접근하게 되면 훨씬 더 심각한 문제가 발생한다.
>Xcode는 이러한 메모리 문제를 파악하는 데 도움이 되는 Address Sanitizer라는 런타임 디버깅 도구를 제공한다.
>"Finding Bugs Using Xcode Runtime Tools" 세션참조

### 그러면 왜 이런 포인터를 사용해야 할까?
- 가장 큰 이유는 C나 Objective-C와 같은 안전하지 않은 언어와의 상호 운용성이다.
- 이러한 언어에서 함수는 종종 포인터 인수를 사용하므로 Swift에서 호출할 수 있으려면 Swift 값에 대한 포인터를 생성하는 방법을 알아야 함.

```swift
void process_integers(const int *start, size_t count);

func process_integers(_ start: UnsafePointer<CInt>!, _ count: Int)

let start = UnsafeMutablePointer<CInt>.allocate(capacity: 4)

start.initialize(to: 0)
(start + 1).initialize(to: 2)
(start + 2).initialize(to: 4)
(start + 3).initialize(to: 6)

process_integers(start, 4)

start.deinitialize(count: 4)
start.deallocate()
```
- C 함수에 정수 배열을 전달하는 예시이다.
- 할당된 버퍼의 수명은 반환 포인터에 의해 관리되지 않기 때문에, 적절한 시간에 수동으로 할당을 해제해야 한다는 것을 기억해야 함. 그렇지 않으면 메모리 누수가 발생하여 영원히 남아 있게 된다.
- 버퍼를 (시작 주소, 길이) 값의 쌍으로 모델링하여 이 코드의 명확성을 향상시킬 수 있다.
- 이렇게 하면 버퍼의 경계를 항상 쉽게 사용할 수 있으므로 예를 들어 어떤 지점에서든 범위를 벗어난 액세스를 쉽게 확인할 수 있다
- 이런 이유로 위의 기능을 제공하는 네 가지 Unsafe 버퍼 포인터 유형을 제공하고 있다.
```swift
UnsafeBufferPointer<Element>
UnsafeMutableBufferPointer<Element>

UnsafeRawBufferPointer
UnsafeMutableRawBufferPointer
```
- 이는 개별 값에 대한 포인터가 아니라 메모리 영역으로 작업해야 할 때마다 유용하다.
- 멋진 패키지에 영역의 크기와 위치를 포함함으로써 모범 사례를 권장하고 메모리를 보다 신중하게 관리할 수 있다.
- 최적화되지 않은 디버그 빌드에서 이러한 버퍼 포인터는 첨자 작업을 통해 범위를 벗어난 액세스를 확인하여 약간의 안전성을 제공
- 이 유효성 검사는 필요에 따라 불완전하다. 경계 검사로 제한되기 때문에
- 부분적으로라도 검사하는게 실수 방지에 좋다.

### Swift의 표준 연속 컬렉션
- Swift의 표준 연속 컬렉션은 이러한 Unsafe 메서드를 통해 기본 스토리지 버퍼에 대한 임시의 직접 접근을 제공하기 위해 이러한 버퍼 포인터를 사용한다.
- 코드를 단순화하고 안전하지 않은 작업을 가능한 가장 작은 코드 섹션으로 격리할 수 있다.
```swift
Sequence.withContiguousStorageIfAvailable(_:)
MutableCollection.withContiguousMutableStorageIfAvailable(_:)

String.withCString(_:)
String.withUTF8(_:)

Array.withUnsafeBytes(_:)
Array.withUnsafeBufferPointer(_:)
Array.withUnsafeMutableBytes(_:)
Array.withUnsafeMutableBufferPointer(_:)
```
- 수동 메모리 관리의 필요성을 없애기 위해 입력 데이터를 배열 값에 저장할 수 있다.
- 그런 다음 `withUnsafeBufferPointer` 메서드를 사용하여 일시적으로 어레이의 기본 저장소에 직접 액세스할 수 있습니다.
- 이 함수에 전달하는 클로저 내에서 `시작 주소와 카운트 값을 추출`하고 호출하려는 C 함수에 직접 전달할 수 있다
```swift
void process_integers(const int *start, size_t count);

let values: [CInt] = [0, 2, 4, 6]

values.withUnsafeBufferPointer { buffer in
  print_integers(buffer.baseAddress!, buffer.count)
}
```
- 안전하지 않은 포인터를 예상하는 함수에 배열 값을 전달하기만 하면 컴파일러가 자동으로 동등한 withUnsafeBufferPointer를 생성
```swift
void process_integers(const int *start, size_t count);

let values: [CInt] = [0, 2, 4, 6]

print_integers(values, values.count)
```
- 함수가 포인터를 탈출하고 나중에 기본 메모리에 액세스하려고 시도하면 포인터를 얻기 위해 어떤 구문을 사용했는지에 관계없이 정의되지 않은 동작이 발생

### 예시
- sysctl을 사용한 Darwin의 함수 예시
```swift
func sysctl(
  _ name: UnsafeMutablePointer<CInt>!,
  _ namelen: CUnsignedInt,
  _ oldp: UnsafeMutableRawPointer!,
  _ oldlenp: UnsafeMutablePointer<Int>!,
  _ newp: UnsafeMutableRawPointer!,
  _ newlen: Int
) -> CInt

import Darwin

func cachelineSize() -> Int {
    var query = [CTL_HW, HW_CACHELINE]
    var result: CInt = 0
    var resultSize = MemoryLayout<CInt>.size
    let r = sysctl(&query, CUnsignedInt(query.count), &result, &resultSize, nil, 0)
    precondition(r == 0, "Cannot query cache line size")
    precondition(resultSize == MemoryLayout<CInt>.size)
    return Int(result)
}

print(cachelineSize()) // 64
```
- 동일한 다른 방법의 구현예시
```swift
import Darwin

func cachelineSize() -> Int {
    var query = [CTL_HW, HW_CACHELINE]
    return query.withUnsafeMutableBufferPointer { buffer in
        var result: CInt = 0
        withUnsafeMutablePointer(to: &result) { resultptr in
            var resultSize = MemoryLayout<CInt>.size
            let r = withUnsafeMutablePointer(to: &resultSize) { sizeptr in
                sysctl(buffer.baseAddress, CUnsignedInt(buffer.count),
                       resultptr, sizeptr,
                       nil, 0)
            }
            precondition(r == 0, "Cannot query cache line size")
            precondition(resultSize == MemoryLayout<CInt>.size)
        }
        return Int(result)
    }
}

print(cachelineSize()) // 64
```
- 어떤 버전을 선택하든 생성된 포인터 값은 일시적이며 함수가 반환될 때 무효화된다는 점을 항상 인식하자

### 클로저 기반 대 암시적 포인터
- 순수한 Swift 코드에서는 포인터를 훨씬 덜 자주 전달해야 하므로 클로저 기반 API 사용을 선호하여 이러한 작업을 수행하는 경우를 강조하는 것이 좋다.
- 클로저 기반 디자인은 결과 포인터의 실제 수명을 훨씬 더 명확하게 만들어 잘못된 포인터 변환과 같은 수명 문제를 방지하는 데 도움이 된다.
```swift
// 올바른 예시
var value = 42
withUnsafeMutablePointer(to: &value) { p in
  p.pointee += 1
}
print(value)  // 43

// 문제 예시
var value2 = 42
let p = UnsafeMutablePointer(&value2) // BROKEN -- dangling pointer!
p.pointee += 1
print(value2)
// 기본 메모리 위치가 더 이상 존재하지 않거나 다른 값에 재사용되었을 수 있다.
```

### 새로운 개선 사항
- Swift 표준 라이브러리가 이제 기본 초기화되지 않은 저장소에 데이터를 직접 복사하여 Array 또는 String 값을 생성할 수 있는 새로운 초기화 프로그램을 제공한다
- 이 방법을 사용하면 데이터를 준비하기 위해서만 임시 버퍼를 할당할 필요가 없다.
```swift
Array.init(unsafeUninitializedCapacity:initializingWith:)
String.init(unsafeUninitializedCapacity:initializingUTF8With:)
```
- 사용 예시
```swift
import Darwin

func kernelVersion() -> String {
    var query = [CTL_KERN, KERN_VERSION]
    var length = 0
    let r = sysctl(&query, 2, nil, &length, nil, 0)
    precondition(r == 0, "Error retrieving kern.version")
    return String(unsafeUninitializedCapacity: length) { buffer in
        var length = buffer.count
        let r = sysctl(&query, 2, buffer.baseAddress, &length, nil, 0)
        precondition(r == 0, "Error retrieving kern.version")
        precondition(length > 0 && length <= buffer.count)
        precondition(buffer[length - 1] == 0)
        return length - 1
    }
}

print(kernelVersion())
// Darwin Kernel Version 19.5.0: Thu Apr 30 18:25:59 PDT 2020; root:xnu-6153.121.1~7/RELEASE_X86_64
```

### 요약
- Unsafe API를 효과적으로 사용하려면 기대치를 인식하고 항상 이를 충족하도록 주의해야함.
    - 그렇지 않으면 코드가 정의되지 않은 동작을 갖게 된다.
- Unsafe API 사용을 최소로 유지
    - 가능할 때마다 더 안전한 대안을 선택
- 둘 이상의 요소를 포함하는 메모리 영역으로 작업할 때 포인터 값보다는 Unsafe Buffer Pointer를 사용하여 경계를 추적
- Xcode는 Address Sanitizer를 포함하여 안전하지 않은 API를 사용하는 방법과 관련된 문제를 디버깅하는 데 도움이 되는 일련의 훌륭한 도구를 제공
    - 코드를 생산에 적용하기 전에 코드의 버그를 식별하고 발견되지 않은 문제를 디버깅
