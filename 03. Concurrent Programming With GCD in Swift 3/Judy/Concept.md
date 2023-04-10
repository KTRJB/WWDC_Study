> 동시 프로그래밍으로 프로그램을 구성하는 방법

---

> #### Main Thread 
> : 사용자 인터페이스를 강화하는 모든 코드 실행을 담당
> - 메인 스레드에서 데이터 변환이나 이미지 처리와 같은 큰 항목을 도입하면 사용자 인터페이스 성능이 떨어짐

이러한 문제를 피하는 방법
How? 애플리케이션에 동시성 개념을 도입

- GCD = 동시성 라이브러리
- 동시성을 지원하기 위해 스레드 위에 추상화를 도입 => Dispatch Queue와 Run loop
<br>

## Dispatch Queue & Run loop
1. Worker 
- Dispatch Queue: 해당 큐에 work item을 넣을 수 있는 구조 
- dispatch는 알맞는 스레드와 서비스를 가져옴
- dispatch가 모든 작업의 실행을 완료하면 해당 작업 스레드를 자체적으로 해제

2. Own Thread
- 스레드를 생성할 수 있고, 해당 스레드에서 run loop 실행 가능

3. Main Thread
- main run loop와 main queue 모두 가능

> #### Dispatch Queue에 작업을 넣는 방법<br>
> 1. asynchronous execution<br>
> - 작업을 디스패치 대기열에 넣은 다음 해당 작업을 실행할 스레드를 불러옴<br>
> - 대기열에서 하나씩 제거하고 실행<br>
> - 모든 작업을 수행하면 스레드를 회수<br>
> <br>
> 2. synchronous execution<br>
> - 일부 동기 작업이 포함된 디스패치 큐에서 스레드를 가지고 있고, 해당 스레드는 큐에서 코드를 실행하고 기다림<br>
> - 디스패치 대기열에 제출하면 block됨<br>
> - 요청한 실행이 끝날 때까지 기다림<br>

<br>

## 메인 스레드에서 사용자 인터페이스 작업
메인 스레드에서 수행한 변환을 가져와서 다른 대기열에서 수행

```swift
let queue = DispatchQueue(label: "com.example.imagetransform")
// 작업을 제출한 DispatchQueue 생성

queue.async { // async메서드로 해당 대기열에 작업을 추가
	let smallImage = image.resize(to: rect)
	
    DispatchQueue.main.async { // 메인 스레드로 가져오기
    	imageView.image = smallImage
    }
}
```
❕디스패치 큐는 선입선출
<br>

### Controlling Concurrency
디스패치가 사용하는 스레드 풀은 동시성을 제한
스레드를 차단할 때 애플리케이션의 다른 부분을 기다리는 경우 차단된 스레드로 인해 더 많은 작업자 스레드가 생성될 수 있음 (코드를 실행할 수 있는 새 스레드를 제공하여 동시성을 제공)
따라서 코드를 실행할 올바른 디스패치 큐를 선택하는 것은 매우 중요
<br>

## 애플리케이션 구성하기
별도의 하위 시스템으로 분할 후 각각 디스패치 큐로 지원하기
-> 너무 많은 대기열과 스레드 문제를 겪지 않고 독립적으로 작업을 실행할 수 있는 대기열이 하위 시스템에 제공
<br>

### Grouping Work
작업을 **그룹화**하고 작업이 완료되기 기다리기 

```swift
queue.async(group: group) { ... }
```
- 디스패치 그룹은 작업을 추적하는데 도움이 됨
- **DispatchGroup** 객체를 생성하기만 하면 됨
- 작업을 제출할 때 비동기 호출에 매개변수로 추가 

```swift
group.notify(queue: DispatchQueue.main) { ... } 
```
- 해당 그룹의 작업이 모두 완료되면 noti를 받을 수 있음 
<br>

### Synchronizing Between Subsystems
동기 실행
- 하위 시스템 간에 상태를 **직렬화**할 수 있음
- 상호 배제 속성에 사용할 수 있음 (mutual exclusion)
	= 작업이 동시에 실행되지 않음을 보장
-> 하위 시스템의 프로퍼티에 thread safe한 접근을 구축할 수 있음
```swift 
var count: Int {
	queue.sync { self.connections.count }
}
```
❕ 교착 상태에 빠지지 않도록 유의
<br>

### QoS 
```swift
queue.async(qos: .background) {
	print("Maintenance work")
}

queue.async(qos: .userInitiate) {
	print("Button Tapped")
}
```
- 특정 QoS 클래스를 가진 디스패치 큐를 만들 수도 있음
ex) 백그라운드에서 실행하는 큐 생성

<br>

### DispatchWorkItem
DispatchWorkItem을 사용하면 실행 방법을 제어할 수 있음
```swift
let item = DispatchWorkItem(flags: .assignCurrentContext) {
	print("Hello WWDC 2016")
}

queue.async(execyte: item)
```
예를 들어`assignCurrentContext`를 사용하면 디스패치 큐에 제출할 때가 아닌 작업 항목을 만들 때 컨텍스트의 QoS를 사용

#### wait
- 작업을 진행하기 전에 완료해야 할 작업을 나타낼 수 있음
- **DispatchWorkItem**은 제출된 곳과 실행할 대기열을 알고 있기에 가능 

---

## Shared State Synchronization
클래스는 원자적이지 않음 = lazy initializer가 두 번 실행될 수도 있다.
-> 그래서 동기화(Synchronize)를 해줘야 함

동기화 지점을 잊어버리면 충돌이 발생하거나 사용자 데이터가 손상될 수도 있다.

1. 동기화에는 전통적으로 lock을 사용 (C 기반의 lock)
하지만 Swift는 뮤텍스 또는 잠금과 함께 작동하지 않는다고 가정하므로 이러한 종류의 lock을 사용하지 않는 것이 좋음

2. 전통적인 lock을 원할 경우 클래스인 `Foundation.lock` 사용 가능
더 작고 C와 비슷한 lock을 원한다면 Objective-C를 호출하고 lock이 있는 기본 클래스를 도입해야 함
그리고 하위 클래스로 만들 때 lock, unlock 메서드와 try lock을 노출

3. 동기화 목적으로 디스패치 큐를 사용하는 것이 좋다
1) 기존 lock 보다 오용하기 쉽다
-> 코드 범위가 지정된 방식으로 실행되어 잠금 해제를 잊을 수 없음
2) 디스패치 큐는 Xcode에서 런타임과 잘 통합됨
<br>

### 디스패치 큐를 사용하여 동기화하는 방법
atomic property 구현하기
```swift
class MyObject {
	private let internalState: Int
    private let internalQueue: DispatchQueue
    var state: Int {
    	get {
        	return internalQueue.sync { internalState }
        }
        set(newState) {
        	internalQueue.sync { internalState = newState }
        }
    }
}
```
<br>

### 4단계의 상태
#### 1. SetUP
- Object를 만들고 필요한 프로퍼티를 개체에 부여
#### 2. Activated
- 활성화 = 이 Object를 다른 하위 시스템에게 알리기
#### 3. Invalidated
- 무효화 = 하위 시스템이 Object가 사라지고 있음을 확인
#### 4. Deallocation:
- 할당 해제
<br>

#### 예시
Observer Pattern
> 데이터 변환 작업 시(DataTransForm) 유저 인터페이스에 시각적 표시가 나타나고 사라지는 동작


```swift 
// 1. 설정
class BusyController: SubsystemObserving {
	init(...) { ... }
    
    // 2. 활성화 - 상태 변경 알림 수신을 시작하고자 하위 시스템에 등록하고 main 큐에서 수신되도록 요청
    func activate() {
    	DataTransForm.sharedInstance.register(observer: self, queue: DispatchQueue.main)
    }
    
    func systemStarted(...) { ... }
    func systemDone(...) { ... }
    
//    BusyController는 main 큐 및 사용자 인터페이스의 참조
//	  데이터 변환 하위 시스템에 등록했을 때 이 개체에 대한 참조를 가져왔을 가능성은 적음
//	  = deinit은 실행되지 않음
// 	  등록이 취소되고 버려진 메모리가 됨
//    deinit {
//    	DataTransForm.sharedInstance.unregister(observer: self)
//    }
}
```




```swift 
class BusyController: SubsystemObserving {
    deinit {
    	DataTransForm.sharedInstance.unregister(observer: self)
    }
}
```
➡️ 동작하지 않음 why?
- BusyController는 main 큐 및 사용자 인터페이스의 참조
- 데이터 변환 하위 시스템에 등록했을 때 이 개체에 대한 참조를 가져왔을 가능성은 적음
	= deinit은 실행되지 않음
- 등록이 취소되고 버려진 메모리가 됨

> 약한 참조로 해결 가능 but 데드락의 위험성

![](https://velog.velcdn.com/images/juyoung999/post/e268c3f6-bdfa-4f84-af49-e2dbd0286729/image.png)
<br>

deinit에서 등록 취소는 안됨 그럼? 무효화를 명시적 함수 호출로 변경

```swift 
class BusyController: SubsystemObserving {
	// 무효화를 Bool 값으로 추적
    private var invalidated: Bool = false
 	func invalidate() {
     	dispatchPrecondition(.onQueue(DispatchQueue.main))
        invalidated = true
  		DataTransform.sharedInstance.unregister(observer: self)
	}
    
	deinit { // 개체가 할당 해제되기 전에 무효화 여부 확인하고 시행
    	precondition(invalidated)
    }
}
```

---

## GCD Object Lifecycle
### SetUp
디스패치 개체에 대한 설정은 빌드할 때 수행할 수 있는 모든 작업과 전달할 수 있는 특성 
ex) label, queue attributes

```swift 
let q = DispatchQueue(label: "com.example.queue", attributes: [.autoreleaseWorkItem])
let source = DispatchSource.read(fileDescriptor: fd, queue: q)

source.setEventHandler { /* handle your event here */ }
source.setCancelHandler { close(fd) }
```
모니터링하는 리소스도 있음
핸들러도 있어 이벤트 핸들러는 모니터링이 실행되고 대기 중인 이벤트 리소스가 실행될 코드

### Activate
개체를 설정하고 사용할 준비가 되면 활성화할 수 있습니다.
`resume`에서 `activate`는 여러 번 호출될 수 있으며 한 번만 작동
`activate`를 호출하면 개체의 속성을 더 이상 변경하지 않음


그룹이나 대기열 같이 많은 디스패치 큐는 사용을 중단하면 비활성화되기 때문에 실제로는 명시적인 무효화가 필요하지 않음

소스에서 cancel하면 모니터링 중인 항목에 대한 이벤트 수신이 중지됨
취소 핸들러를 설정하면 취소 시점에 큐에서 실행됨
핸들러는 클로저로 캡쳐할 수 있음

개체가 할당 해제될 때 Dispatch는 두 가지를 기대
1) 개체가 활성 상태
2) 일시정지(suspended)되지 않음
=> 일시정지 또는 비활성 상태인 경우 관련 코드를 실행하지 않는 것이 안전하다고 개발자로서 생각하지만 객체를 제거하려면 실행해야 한다는 의미

---

## 결론
> #### 오늘의 이야기<br>
- 데이터 흐름의 관점에서 앱을 어떻게 생각할 수 있는지,
이를 사용하여 통신 목적으로 값 타입을 사용하는 독립적인 하위 시스템으로 앱을 나누는 방법을 살펴보았다.<br>
- 상태를 동기화해야 하는 경우 **Dispatch Queue**를 사용하는 방법<br>
- 동시성이 매우 높은 환경에서 사용되는 개체가 있는 경우 활성화 및 무효화를 사용하여 패턴을 만드는 방법<br>
