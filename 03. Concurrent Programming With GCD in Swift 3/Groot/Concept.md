## Concurrency

- 메인스레드는 사용자 인터페이스의 코드 실행을 담당한다
- 이런 인터페이스는 비용이 많이 들기 때문에 메인스레드에서 데이터 변환이나 이미지 처리를 도입하면 사용자는 버벅거리는 경험을 할 수 있다.
- 이 문제를 동시성으로 해결하는 방법을 이야기 한다.

### 동시성

- 스레드를 생성해서 앱의 여러 코드를 동시에 실행할 수 있다.
- CPU 코어는 주어진 시간동안 각각 단일 스레드를  실행할 수 있다.
- 코드 불변성을 유지하기 위해 Thread Safe 를 유지하기가 훨씬 더 어렵다.

## GCD

- 이런 동시성을 지원하기 위해 스레드 자체에 한 단계 더 추상화를 도입했다.

### Dispach Queues and Run Loops

- 디스패치 큐는 큐에 작업 항목을 제출할 수 있다. 이걸 클로저로 구현한다.
- 디스패치는 작업을 처리하기 위해 스레드를 생성하고, 해당 작업이 끝날 때 해당 스레드를 종료한다.
- 자체적으로 스레드를 만들 수 있고 런 루프를 사용할 수 있다.
- 메인 스레드는 메인 큐와 메인 런 루프 모두를 얻는다.
- 디스패치 큐에 작접을 제출하는 두 가지 주요 방법
    1. 비동기 실행
        - 여러 개의 작업 항목을 큐에 등록한 후 디스패치를 사용하여 스레드를 생성하여 해당 작업을 실행
        - 디스패치는 큐에서 작업 항목을 하나씩 가져와서 실행
        - 모든 항목을 실행한 후 시스템은 해당 스레드를 회수한다.
    2. 동기 실행
        - 순서대로 빼는 것은 동일하나, sync일 경우는 queue의 컨트롤을 작업을 넣은 스레드로 넘기고, 그 작업이 끝나는 대로 다시 돌려 받는다.(즉 current Thread에서 실행됨). queue에 작업을 넣었던 스레드는 블록됨
    
    ### GCD를 사용해 앞에서 말했던 인터페이스의 문제를 해결할 수 있다.
    
    - 다른 대기열에서 수행한 데이터 변환 결과를 메인 스레드에서 실행하는 방법을 사용하자
        1. 디스패치 큐 객채를 생성하고 제출한다.
        2. 큐의 작업을 다른 스레드에서 실행하자
        3. 결과를 메인스레드에서 사용하여 UI를 변경하자.
    
    ```swift
    let queue = DispatchQueue(label: "com.example.imagetransform")
    queue.async {
    	let smallImage = image.resize(to: rect)
    	DispatchQueue.main.async {
    		imageView.image = smallImage
    	 }
    }
    ```
    
    - 이런 방법은 비용이 든다
    - 동시성을 제어해야 한다.
    
    ### 동시성 제어
    
    - 스레드 풀은 동시성을 제한한다.
    - 하지만, 이렇게 스레드를 차단할 때 블락된 스레드가 많으면 더 많은 스레드가 생성될 수 있다.
    - 그렇기 때문에 적절한 디스패치 대기열의 수를 정하는게 중요하다.
        - 하나의 스레드가 막히면 다른 스레드가 나타나고 다른 스레드를 차단하는데 이 패턴을 스레드 폭발이라고 부른다.
    
    ### 앱 구조와 디스패치큐
    
    - 애플리케이션에서 데이터 흐름이 발생하는 지점을 파악하고, 각 서브시스템으로 분리합니다. 이후, 각 서브시스템에서 큐를 구현하여 작업해라
    

    
    ### Chaining vs Grouping
    
    - Chaining: 한 큐에서 작업을 끝내면 다른 큐로 넘기는 것
    - Grouping: 여러 큐에서 작업을 이어 받는 것. 기다리는 작업을 그룹지어서 모든 작업이 끝나는 것은 노티받을 수 있다.
    
  
    
    ### 동기와 서브시스템
    
    - 직렬 큐는 순서대로 실행되기 때문에 상호배제로 사용 가능
    - 동기를 사용하면 서브 시스템의 스레드 세이프를 구현할 수 있다.
    - 하지만, 데드락을 조심해야 한다.
    
    ### QOS
    
    - 업무에 대한 명시적인 분류
    - 개발자가 의도적으로 실행 우선 순위를 지정하는 것
    - async로 작업을 넣을 때 작업별로 지정할 수도 있고, 큐 자체에 미리 지정해 놓을 수 도 있다.
        
      
        
    
    ### DispatchWorkItem
    
    - 기본적으로 .async는 제출 시점에서 실행 컨텍스트를 캡처한다.
    - 실행 속성을 제어하기 위해 클로저에서 DispatchWorkItem을 생성합니다.
    - 생성 시점에서 현재 QoS를 캡처하기 위해 .assignCurrentContext를 사용해라.
    - .wait 메서드를 사용하여 진행하기 전에 해당 작업 항목이 완료되어야 함을 알려줄 수 있다.
    - Dispatch는 대기 중인 작업을 우선적으로 처리
    - DispatchWorkItem으로 대기하면 소유권 정보를 얻을 수 있다.
    - 세마포어와 그룹은 소유권 개념을 받아들이지 않기 때문에 세마포어를 기다리는 경우 세마포어 신호 앞에 있는 항목이 더 빨리 실행되지 않는다.
    

## Shared State Synchronization

- 전역 변수는 원자적으로 초기화
- 클래스 프로퍼티는 원자적이지 않다.
- 지연 프로퍼티는 원자적으로 초기화되지 않다.
    - 프로퍼티를 호출하는 경우 지연 초기화가 실제로 두 번 실행될 수 있다는 것
- 동기화를 제대로 하지 않으면 충돌이 발생하거나 데이터가 손상된다.
    - Thread Sanitizer and Static. Analysis 도구를 사용해서 동기화가 적절하게 되어있는지 알 수 있다.
    

### Traditional C Locks in Swift

- 스위프트에선 전통적으로 Lock을 사용해서 동기화를 구현했다
- Darwin에서 제공하는 C스타일의 Lock은 제대로 쓰기가 굉장히 어렵다.
- Foundation의 Lock: Objective-C 객체로 C스타일 구조체를 감싼 것
- 권장하는 것은 DispatchQueue.sync

### **Use GCD for Synchronization**

- DispatchQueue.sync(execute:)를 사용해라
    - 전통적인 Lock 오용되기 어렵고 더 견고(코드는 범위가 지정되는 방식으로 실행하기 때문에 잠금 해제를 잊을 수 없다.)
    - Xcode, Assertions 등에서 더 좋은 기능 제공한다.
    
    ```swift
    // Use Explicit Synchronization
    class MyObject {
    	private let internalState: Int
    	private let internalQueue: DispatchQueue
    	var state: Int {
    		get {
    			return internalQueue.sync { internalState }
    		}
    		set (newState) {
    			internalQueue.sync { internalState = newState } }
    		 }
    }
    ```
    

### Object Lifecycle in a Concurrent World

- 동시성에서 사용되는 객체의 안전할 수 있도록 하는 4단계
1. Setup
2. Activatied
3. Invaildated
4. Deallocation

## GCD Object Lifecycle

### Setup

- 빌드할 때 수행할 수 있는 모든 작업과 전달할 수 있는 모든 특성
    - Attributes and target queue
    - Source handlers

### Activation

- activate이후에는 프로퍼티 변경 금지
- Queue도 처음에는 액티브되지 않은 상태로 만들어질 수 있다.
- Cancellation
    - Source는 명시적으로 취소되어야 한다.
        - 캔슬 핸들러가 돌아간다.
        - 이벤트 모니터링이 중단된다.
        - 모든 등록되었던 핸들러가 해제된다.

### Deallocation Hygiene

- active, not suspended인 상태여야 한다.
