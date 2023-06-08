## 배경
표준 라이브러리는 타입, 프로토콜, 함수, 프로퍼티 등 다양한 구조를 제공
➡️ 이 중 몇몇은 `Unsafe`로 표시됨
<br>

## Unsafe API
대부분 작업은 실행 전 입력을 검증하기 때문에 심각한 코딩 오류를 안정적으로 포착함
ex) Optional 강제 언래핑 - nil 값이면 런타임 오류가 발생하고 실행을 중지

 
> - **Safe** = 가능한 모든 입력(요구 사항을 충족하지 않는 입력을 포함)에 대한 동작을 설명할 수 있다
> - **Unsafe** = 일부 입력에서 정의되지 않는 동작을 보인다

<br>

### unsafelyUnwrapped
```swift
let value: String? = nli
print(value.unsafelyUnwrapped)	// ?!
```

- 강제 언래핑처럼 기본 값이 nil이 아니어야 함
- 하지만 최적화가 활성화된 상태로 컴파일 시 nil이 아닌 값으로만 호출하는 것을 신뢰
- nil을 호출하게 되면 존재하지 않는 값을 읽으며 무엇을 의미하는지 알 수 없음
- crash를 발생하거나 쓰레기 값을 반환함 => 의도하지 않은 동작
<br>

### Unsafe의 의미
- unsafe 표시는 코드를 읽는 사람에게 사용에 내재된 위험을 경고
- 사용에 각별한 주의가 필요하며 사용 조건을 완전히 이해해야 함
<br>

## Unsafe 인터페이스 사용의 장점
> #### Unsafe 인터페이스 사용을 통해 성취할 수 있는 것
> - C 또는 Objective-C와의 상호 운용성 제공
> - 런타임 성능 또는 프로그램 실행에 대한 세밀한 제어를 제공

<br>

### unsafelyUnwrapped 
unsafelyUnwrapped 경우 두 번째에 속함
- nil 값에 대한 불필요한 검사를 제거할 수 있음
- 최적화된 빌드에서 nil 검사만 생략
- 최적화되지 않는 디버그 실행에서는 여전히 검사
<br>

### Crash
> **safe code** != **no crashes**

안전한 코드의 목표가 크래시를 없애는 것이 아님
실제로는 반대로 제약 조건이 벗어난 입력 시 안전한 API는 런타임 오류를 발생시켜 실행을 중지
-> 오류로 인해 생성된 crash report로 문제가 발생한 상황을 보고 디버깅하고 수정할 수 있음
<br>

## Unsafe Pointers
Swift는 
C 프로그래밍의 포인터와 거의 동일한 추상화인 강력한 unsafe 포인터 타입을 제공

### 포인터의 동작 방법
Swift는 플랫 메모리 모델을 사용
메모리를 개별적으로 주소 지정 가능한 8비트 바이트의 선형 주소 공간으로 취급
- 각 바이트에는 16진수 정수 값으로 표시되는 고유한 주소를 가짐

![](https://velog.velcdn.com/images/juyoung999/post/6394b776-f3d2-4f25-bd62-b8f38d7e97a4/image.png)

런타임 시 주소 공간은 앱의 실행 상태를 반영하는 데이터로 드물게 채워짐
ex) 앱의 바이너리, 라이브러리와 프레임워크, 스택, 일부 함수의 매개변수 또는 로컬 및 임시 변수 등

실행이 계속되며 새 개체가 할당되고 스택이 변경되며 이전 항목이 파괴됨
Swift와 런타임은 이를 계속 추적하기 때문에 수동으로 메모리를 관리할 필요 없음

unsafe 포인터는 메모리를 효과적으로 관리하는 모든 하위 수준 작업을 제공하는 대신 위험을 감수
- 포인터는 단순히 메모리 어딘가의 주소를 나타냄
- 주의하지 않으면 포인터 작업이 조심스럽게 유지되는 응용 프로그램의 상태를 망칠 수 있음


![](https://velog.velcdn.com/images/juyoung999/post/2f818737-7770-4eab-9f96-56ba4b6586cd/image.png)

예를 들어 정수 값에 대한 스토리지를 동적으로 할당하면 스토리지 위치가 생성되고 이에 대한 직접적인 포인터가 제공됨
- 포인터는 기본 메모리에 대한 제어를 제공하지만 대신 관리하지는 않음
- 해당 메모리 위치에 어떤 일이 발생하는지 추적할 수도 없음

![](https://velog.velcdn.com/images/juyoung999/post/87a270f4-3881-443a-b95f-70207457fbd0/image.png)

- 포인터가 무효화된 이후에도 자신이 무효화된 것을 알지 못해 포인터를 역참조하려는 오류를 범할 수 있음
- 운이 좋으면 할당 해제에 의해 접근할 수 없게 렌더링된 경우 접근 시도 시 충돌이 발생하지만 이를 보장할 수 없음
- 이미 해당 주소를 재사용한 경우 역참조 시 심각한 문제가 발생할 수 있음

➡️ Xcode는 이러한 메모리 문제 파악을 위해 런타임 디버깅 도구인 **Address Sanitizer**를 제공
<br>

### 포인터 안전성 문제를 피하는 방법
포인터가 그렇게 위험한데 왜 사용해?
=> C나 Objective-C와 같은 안전하지 않은 언어와의 상호 운용성 때문

C의 포인터들은 Swift의 unsafe pointer로 매핑됨

![](https://velog.velcdn.com/images/juyoung999/post/fc4806ed-c07c-43f1-a77e-9dbe4e7f4365/image.png)

### <br>정수 값의 버퍼를 처리하는 예시

![](https://velog.velcdn.com/images/juyoung999/post/9ad517d9-4e3f-4d92-8192-54492a069a1f/image.png)

1. **UnsafeMutablePointer**에서 `allocate` 메서드를 통해 정수 값을 유지할 동적 버퍼를 만들기
2. 포인터 산술과 초기화 방법을 통해 버퍼의 요소를 특정 값으로 설정
3. C 함수를 호출해 초기화된 버퍼에 대한 포인터를 전달
4. 함수가 반환되면 버퍼 초기화 및 할당 해제로 메모리 위치를 재사용할 수 있도록 함

작업을 제어할 수는 있지만 모든 단계는 근본적으로 안전하지 않음 
-> 적절한 시간에 수동으로 할당 해제하지 않으면 메모리 누수가 발생

#### 단계 별 문제
1. 할당된 버퍼의 수명은 반환 포인터에 의해 관리되지 않음
2. 초기화 시 주소 지정된 위치가 할당한 버퍼 내에 있는지 확인할 수 없음 
-> 정의되지 않은 동작이 발생할 수 있음
3. 함수를 호출하려면 기본 버퍼의 소유권을 가져갈지 여부를 알아야 함 
-> 함수 호출 동안만 접근하고 포인터를 유지하거나 할당 해제를 시도하지 않는다고 가정
4. 초기화 해제는 기본 메모리가 올바른 타입의 값으로 초기화된 경우에만 의미가 있음, 또한 이전에 할당되었고 초기화되지 않은 상태인 메모리만 할당 해제해야 함

이 중 하나라도 잘못되면 정의되지 않은 동작이 발생
<br>

#### 추가적인 문제
잘 동작하지만 버퍼가 시작 주소로만 표시된다는 문제가 있음

버퍼를 (시작 주소, 길이) 쌍으로 모델링하여 코드의 명확성을 향상시키 수 있다
=> 버퍼의 경계를 쉽게 사용할 수 있으므로 범위를 벗어난 액세스를 쉽게 확인할 수 있음
⬆️ 이것이 표준 라이브러리가 네 가지 안전하지 않은 버퍼 포인터 타입을 제공하는 이유

> - UnsafeBufferPointer<Element\>
> - UnsafeMutableBufferPointer<Element\>  
> - UnsafeRawBufferPointer
> - UnsafeMutableRawBufferPointer
  
개별 값에 대한 포인터가 아니라 메모리 영역으로 작업해야 할 때 유용

최적화되지 않은 디버그 빌드에서 이러한 버퍼 포인터는 첨자 작업을 통해 범위를 벗어난 액세스를 확인하여 안전성을 제공
<br>

### 주소-길이 모델링

![](https://velog.velcdn.com/images/juyoung999/post/771badeb-4989-4dd6-9c69-b08b2d10a9e3/image.png)

Swift의 표준 연속 컬렉션은 편리한 unsafe 메서드를 통해 기본 스토리지 버퍼에 대한 임시 직접 접근을 제공하기 위해 버퍼 포인터를 사용

![](https://velog.velcdn.com/images/juyoung999/post/ca183db2-3d1d-4e96-901e-78131e0d2347/image.png)

또한 개별 Swift 값에 대한 임시 포인터를 얻을 수 있으며, C 함수에 전달할 수 있음

![](https://velog.velcdn.com/images/juyoung999/post/14032944-9bdc-4e4c-85d9-cb1d5422fa47/image.png)

이러한 방법으로 코드를 단순하고 unsafe한 작업을 작은 코드 섹션으로 격리할 수 있다
- 수동 메모리 관리의 필요성을 없애기 위해 데이터를 배열에 저장할 수도 있음
- withUnsafeBufferPointer 메서드를 사용해 일시적으로 배열의 기본 저장소에 직접 접근 가능
- 해당 함수의 클로저 내에서 baseAdress와 count 값을 추출하고 호출하려는 C 함수에 직접 전달 가능


![](https://velog.velcdn.com/images/juyoung999/post/aa21a25f-a25f-4b11-9668-eb8a20625922/image.png)

C 함수에 대한 포인터를 전달하는 필요성이 자주 발생해 Swift는 이에 대한 특수 구문을 제공
- 안전하지 않은 포인터를 예상하는 함수에 배열 값을 전달하기만 하면 컴파일러가 자동으로 동등한 `withUnsafeBufferPointer`를 생성함
- 포인터가 함수 호출 동안만 유효함
- 함수가 포인터를 탈출한 후 기본 메모리에 접근을 시도하면 포인터를 얻기 위해 사용한 구문에 관계없이 정의되지 않은 동작이 발생
<br>

## 암시적 값-포인터 변환
Swift에서 지원하는 변환 목록

![](https://velog.velcdn.com/images/juyoung999/post/2a31fea9-9a86-485d-bbb4-c3e6d1953720/image.png)

- Swift 배열 내용을 C 함수에 전달하려면 배열 값 전체를 전달하기만 하면 됨
- 함수가 요소를 변경하는 경우 배열에 대한 `inout` 참조를 전달하여 변경 가능한 포인터를 얻을 수 있음
- C 문자열을 사용하는 함수는 Swift 문자열 값을 직접 전달하여 호출할 수 있음
	- 문자열은 종료 NUL 문자를 포함해 임시 C 문자열을 생성
- C 함수가 단순히 개별 값에 대한 포인터를 기대하는 경우 해당 Swift 값에 대한 `inout` 참조를 사용할 수 있음

이 기능을 사용하면 복잡한 C 인터페이스도 호출 가능

예시 - 실행 중인 시스템에 대한 하위 수준 정보를 쿼리 또는 업데이트하는 Darwin 모듈에서 제공하는 C 함수

![](https://velog.velcdn.com/images/juyoung999/post/2ef07bfa-aea8-462c-9f7c-ee409eb7c77a/image.png)

다음 6개의 매개변수가 제공
- 엑세스 하려는 값의 식별자 역할을 하는 정수 버퍼의 위치와 크기
- 함수가 현재 값을 저장하기를 원하는 다른 버퍼의 위치와 크기
- 지정된 항목에 대해 설정할 수 있는 새 값을 포함하는 선택적인 읽기 전용 버퍼의 위치와 크기

암시적 포인터 변환을 사용하면 모국어와 복잡성이 거의 비슷한 코드가 생성됨
<br>

### 예시 
실행 중인 프로세서 아키텍처의 캐시 라인 크기를 검색하는 함수를 만드는 예시
![](https://velog.velcdn.com/images/juyoung999/post/86f99b8b-aff7-43f9-910f-5ceddf00fa39/image.png)

=> sysctl 문서는 하드위어 섹션의 `CACHELINE` 식별자에서 이 정보를 사용할 수 있음을 알려줌
```swift
var query = [CTL_HW, HW_CACHELINE]
```

=> 이 ID를 sysctl에 전달하기 위해 암시적 배열-포인터 변환 및 해당 개수에 대한 명시적 정수 변환을 사용
```swift
let r = sysctl(&query, CUnsignedInt(query.count), ...)
```

=> 검색하려는 정보가 C 정수 값이므로 로컬 정수 변수를 생성하고 `inout-to-pointer` 변환과 함께 세 번째 인수에 대한 임시 포인터를 생성
=> 이 함수는 캐시 라인의 크기를 이 포인터에서 시작하여 버퍼에 복사하고 원래의 0 값을 다른 정수로 덮어씀
```swift
var result: CInt = 0

let r = sysctl(&query, CUnsignedInt(query.count), &result...)
```

=> `&resultSize` - 해당 정수 유형의 MemoryLayout에서 가져올 수 있는 버퍼의 크기에 대한 포인터
```swift
var resultSize = MemoryLayout<CInt>.size

let r = sysctl(&query, CUnsignedInt(query.count), &result, &resultSize..)
```

=> 현재 값을 검색하기만 하고 설정하지 않기 때문에 버퍼에 nil을 제공하고, 크기를 0으로 설정
```swift
let r = sysctl(&query, CUnsignedInt(query.count), &result, &resultSize, nil, 0)
```

=> 해당 코드가 실패하지 않음을 가정하지만 제공한 인수 중 실수한 경우 이 가정을 확인
```swift
precondition(r == 0, "Cannot query cache line size")
```

=> 호출이 C 정수 값에 있는 만큼의 바이트를 설정하기를 기대
```swift
precondition(query.count == MemoryLayout<CInt>.size)
```

=> 마지막으로 C 정수를 Swift Int로 변환하고 결과를 반환
```swift
return Int(result)
```

#### 클로저 기반 호출 방식
![](https://velog.velcdn.com/images/juyoung999/post/23944b76-4c6e-4878-b7e1-1a340b22704f/image.png)

이렇게 명시적 클로저 기반 호출로 확장할 수도 있음 (취향차이)

어떻게 표현하든 생성된 포인터 값은 일시적이며 함수가 반환될 때 무효화된다는 것을 인식!

![](https://velog.velcdn.com/images/juyoung999/post/5499cf65-b4ea-481a-a5bf-bf718fd9355e/image.png)


#### 클로저 기반 API
Swift 코드에서는 포인터를 덜 전달하는게 좋으므로 클로저 기반 API 사용을 선호
- 더 장황하더라도 명확해서 무슨 일이 일어나는이 쉽게 이해 가능
- 클로저 기반 디자인이 결과 포인터의 실제 수명을 명확하게 만들어 잘못된 포인터 변환을 비롯한 수명 문제를 방지

![](https://velog.velcdn.com/images/juyoung999/post/cfee3e5f-4f13-479c-a207-6b05f6ba2c37/image.png)

-> MutablePointer에 임시 포인터를 전달하면 초기화 호출에서 해당 값을 이스케이프 
-> 결과 포인터 값에 접근은 의도되지 않은 동작
-> 기본 메모리 위치가 더 이상 존재하지 않거나 재사용되었을 수 있음
-> Swift 5.3 컴파일러는 이러한 경우를 감지해 경고를 생성 
<br>

## Unsafe 초기화
(또 다른 개선 사항)
![](https://velog.velcdn.com/images/juyoung999/post/487dbda1-69f8-45c3-8201-d3b6f86a2509/image.png)

Swift 표준 라이브러리가 기본 초기화되지 않은 저장소에 데이터를 직접 복사하여 Array 또는 String 값을 생성할 수 있는 새로운 초기화 제공
데이터를 준비하기 위해서만 임시 버퍼를 할당할 필요가 없음
<br>

### 사용 예시 
- String 초기화를 통해 동일한 sysctl 함수를 호출하여 문자열 값을 검색 가능
커널 섹션의 VERSION 항목으로 식별되는 운영 체제의 커널 버전 찾기
![](https://velog.velcdn.com/images/juyoung999/post/3c7a1468-fda3-47aa-a59f-0c9f69668b95/image.png)
- 캐시 라인 예제와 달리 버전 문자열의 크기를 미리 알 수 없어 sysctl을 두 번 호출해야 함
1) nil 출력 버퍼로 함수를 호출 
2) 돌아오면 length 변수는 문자열을 저장하는 데 필요한 바이트로 수정됨
- `"Error retrieving kern.version"` - 보고된 오류가 있는지 확인
- 결과의 크기가 있으므로 실제 데이터를 얻도록 초기화되지 않은 저장소를 String에 요청
- 이니셜라이저는 sysctl 함수에 전달할 수 있는 버퍼 포인터를 제공
- 이 함수는 버전 문자열을 이 버퍼에 직접 복사
- 돌아오면 `precondition`으로 호출 성공했는지 확인
- 함수가 실제로 바이트를 버퍼에 복사했는지 확인
- NUL에 해당하는 0인지 다시 확인
- NUL 문자는 버전 문자열의 일부가 아니므로 복사한 바이트보다 1 적은 값을 반환

이 새로운 String 이니셜라이저를 사용하면 여기서 수동 메모리 관리가 필요하지 않음 👍
-> Swift String 인스턴스의 저장소가 될 버퍼에 직접 접근 가능
-> 수동으로 메모리 할당/해제 필요 없음
<br>

## 요약
- 표준 라이브러리의 Unsafe API를 사용하여 까다로운 상호 운용성도 해결할 수 있다

- Unsafe API를 효과적으로 사용하려면 기대치를 인식하고 항상 이를 충족하도록 주의해야 함
그렇지 않으면 정의되지 않은 동작을 얻게 될 것 (최소화해서 사용하면 이를 수행하기 쉽다)
- 가능할 때마다 더 안전한 대안 선택하기

- 둘 이상의 요소를 포함하는 메모리 영역 작업 시 포인터 보다는 **UnsafeBufferPointer**를 사용해 경례를 추적하는 것이 좋다

- Xcode는 `Address Sanitizer`를 포함하여 Unsafe API를 사용과 관련된 문제를 디버깅하는 데 도움을 주는 도구를 제공
<br><br>

---

[WWDC - Unsafe Swift](https://developer.apple.com/videos/play/wwdc2020/10648/)
