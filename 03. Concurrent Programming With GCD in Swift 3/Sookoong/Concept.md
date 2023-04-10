# [WWDC16] Concurrent Programming With GCD in Swift 3

## 💎 배경

> **Main Thread에서 모든 작업을 처리시, I/O 작업과 같은 비용이 큰 작업에 직면할 때 성능상으로나 UX 측면으로나 비효율적**
> 

## 💎 해결방안

> **GCD를 활용한 Concurrency Programming 구현 → 동시에 여러개의 명령을 처리하자!**
> 

- **Grand Central Dispatch(GCD)**
    - 정의
        - 비동기 및 동시성 작업을 처리하는 기술
    - 작동방식
        - 큐(queue)와 작업(item)을 기반으로 동작
            - 큐는 작업을 순서대로 처리하는 역할
            - 작업은 실행할 코드와 함께 큐에 추가되어 비동기적으로 실행
    - 장점
        - 애플의 멀티코어 CPU와 GPU를 최대한 활용하여 성능 향상
        - 코드 단순화
        - 가독성 향상

- **Concurrency**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230806069-71d093d9-7df3-4498-9780-4c2c2d538242.png" width="50%" height="50%">
    
    - 특징
        - Thread 동시에 코드 실행을 가능케함
        - CPU Core는 각각 하나의 Thread만을 실행
        - Concurrency 하에 코드 불변성 유지는 어려움
            - 새롭게 만들어진 Thread에서의 작업이 다른 Thread 작업에 영향 가능

- **GCD 내 Concurrency 처리 - DispatchQueue**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230806189-4c323089-7384-444b-89de-550faf81f270.png" width="50%" height="50%">
    
    - 특징
        - Dispatch는 자신의 스레드 생성 가능
        - 해당 스레드 내에서 Run Loop 실행 가능
        - Main Thread는 유일하게 Main Run Loop와 Main Queue를 가짐
    - 구성
        - Worker
            - Dispatch는 Queue에 수행 작업을 closure 형태로 올림
            - Dispatch Queue 작업을 수행하기위하여 Thread를 생성 혹은 가져옴
            - 작업 완료시 Thread 해제
        - Thread
            - 본인의 Thread 생성
            - Thread 내 Run Loop 작동
    - 작업 제출 방법
        - 비동기(Asynchronous)
            - 작동방식
                
                <img src = "https://user-images.githubusercontent.com/99063327/230806475-003d6303-a4ad-4a89-a90c-5c9af8e45068.png" width="50%" height="50%">
                
                - DispatchQueue 생성
                
                <img src = "https://user-images.githubusercontent.com/99063327/230806507-76d3033d-fd34-49bf-8102-814c0a058691.png" width="50%" height="50%">
                
                - DispatchQueue 내 작업 등록
                
                <img src = "https://user-images.githubusercontent.com/99063327/230806604-9977adc5-9e43-4d53-8941-a46c5fc08875.png" width="50%" height="50%">
                
                - 해당 작업을 처리할 Thread 생성 혹은 불러오기
                
                <img src = "https://user-images.githubusercontent.com/99063327/230806636-6b4d6c3f-d70b-47db-9399-22d16b4f2618.png" width="50%" height="50%">
                
                - 순서에 따른 작업 수행
                
                <img src = "https://user-images.githubusercontent.com/99063327/230806887-f84c4061-331b-4e40-893d-1591d0a55bef.png" width="50%" height="50%">
                
                - 작업 완료 시 Thread 회수
                
        - 동기(Synchronous)
            - 작동방식
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807046-077015ec-f7a0-4223-b30e-99b52e024f1f.png" width="50%" height="50%">
                
                - 일부 비동기 작업이 포함된 DispatchQueue
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807045-38b01460-b857-4c28-8364-a241d5469338.png" width="50%" height="50%">
                
                - 그런데, 자신의 Thread를 가지고 있고, 해당 Queue에서 코드를 실행하고 작업이 완료될때까지 기다리기를 원함
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807044-5e819c20-c847-468d-939c-98cffeed2f93.png" width="50%" height="50%">
                
                - 해당 작업을 DispatchQueue에 제출하여 Block 발생
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807041-ea2a28d4-a3d8-414b-ab1a-b4195fbd61e6.png" width="50%" height="50%">
                
                - 또다른 비동기 작업의 추가
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807040-101b9020-67cf-4399-a009-4e5a4ad556ae.png" width="50%" height="50%">
                
                - 작업 수행을 위한 쓰레드 생성 혹은 불러오기
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807038-f8a2572c-e9b7-4397-9013-8d3cd2a4a243.png" width="50%" height="50%">
                
                - 먼저 있던 비동기 작업 처리 후, 동기 작업 처리 순서 직면
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807033-0ca340c2-9a43-482b-aafa-2c6b42c8186a.png" width="50%" height="50%">
                
                - DispatchQueue는 대기 중인 Thread로 제어권 넘김
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807052-9580eb97-b59d-4b04-aaec-9226e96491b1.png" width="50%" height="50%">
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807050-cede364d-36ef-4ecb-8258-3143cc919d8f.png" width="50%" height="50%">
                
                - 해당 작업 실행 후 DispatchQueue 제어권을 다시 Worker Thread로 반환
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807048-2cb865f8-2147-4f45-9091-f87ef965c23e.png" width="50%" height="50%">
                
                <img src = "https://user-images.githubusercontent.com/99063327/230807053-64b75cc6-39c1-4603-a172-32715f7d9bd9.png" width="50%" height="50%">
                
                - 나머지 비동기 작업 처리후 Thread 회수

- **DispatchQueue 사용방법**
    - Main Thread 밖에서 작업 처리
        - 방법
            
            <img src = "https://user-images.githubusercontent.com/99063327/230808082-fe795617-7179-4f12-8020-ef64ff6979f6.png" width="50%" height="50%">
            
            - 작업을 제출할 Dispatch Queue 생성
                - label → 디버깅 용도
            - 작업 항목을 FIFO 방식으로 실행
            - `.async` 메서드를 사용하여 수행해야할 작업 제출
    - 처리된 작업을 Main Thread로 가져오기
        - 방법
            
            <img src = "https://user-images.githubusercontent.com/99063327/230808139-6eeb877a-883d-4938-9446-f97e0c6d242e.png" width="50%" height="50%">
            
            - Dispatch main Queue는 Main Thread에서 작업을 수행하므로 이를 사용
            - Queue 간 작업 연동 간단

- **Concurrency 주의사항**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808194-08a20648-5e4b-4af1-a349-2d2bbbd62a28.png" width="50%" height="50%">
    
    - Dispatch가 사용하는 Thread pool은 모든 호출을 제어하기 위하여 Concurrency를 제한
    - Thread Block 으로 인해 더 많은 Worker Thread 생성 우려 → Thread Explosion
        - 저렴한 context switching을 위해 Thread를 생성했는데, Thread의 갯수가 기하급수적으로 많아져 오히려 비효율로 달리는 현상
    - 따라서, 적절한 수의 Queue(Thread)를 사용하는 것이 중요

- **Application 구조화**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808244-0e5e2f51-522c-4cce-b413-e84051552e38.png" width="50%" height="50%">
    
    - Application 내 Data Flow 영역 식별
    - 개별 하위 시스템으로 분할
    - 하위 시스템 각각 독립적으로 실행 가능한 DispatchQueue 할당
    - 패턴 1: Chaining
        
        <img src = "https://user-images.githubusercontent.com/99063327/230808287-17044f94-6971-4a15-8f23-ed7475612419.png" width="50%" height="50%">
        
        - 위의 방식과 동일
        - 작업 수행 → 다른 쓰레드 다른 작업 수행 → 또 다른 쓰레드에서 또 다른 작업 수행
    - 패턴 2: Grouping
        
        <img src = "https://user-images.githubusercontent.com/99063327/230808316-08e2d2dc-3696-44fb-bf55-0eba180e2271.png" width="50%" height="50%">
        
        <img src = "https://user-images.githubusercontent.com/99063327/230808359-bde58498-9282-4898-ae7b-ad9742746815.png" width="50%" height="50%">
        
        - 작업을 Grouping 한 후, 작업이 완료되기를 대기(wait)
        - 여러 개의 서로 다른 작업을 단일 작업화
        - DispatchGroup
            - 그룹 내 작업 추가
            - 서로 다른 큐에서 작업 수행과 동시에 동일 그룹으로 연관
            - Group 내 작업 항목의 수만큼 카운트 증가
            - 작업 처리 시 카운트 감소

- **하위 시스템 간 Synchronizing 가능**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808488-b3c94910-78df-454e-a910-36a725a1903d.png" width="50%" height="50%">
    
    - 상호 배타적으로 하위 시스템 serial queue 사용 가능
    - `.sync` 메서드를 통해 직렬화가 이루어져 하위 시스템의 프로퍼티에 안전하게 접근 가능
        - Race Condition 방지
    - DeadLock 문제 발생할 수 있으므로, 하위 시스템 간 lock ordering에 주의

- **QoS를 통한 작업순서 지정**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808620-be04ff70-88f8-40b1-9fe3-59d1e46151f5.png" width="50%" height="50%">
    
    - QoS를 통한 작업 암시적 분류 가능
    - 개발자 의도 반영 가능
    - 작업 실행 프로퍼티에 영향
    - 작업 순서가 아닌 자원 할당량에 대한 우선순위 부여 작업
    - 사용방법
        
        <img src = "https://user-images.githubusercontent.com/99063327/230808688-f8e1c01c-055a-4540-afa5-62bf478203e5.png" width="50%" height="50%">
        
- **DispatchWorkItem**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808781-36a9fbe2-ad16-431b-8d45-a6af89b91f3e.png" width="50%" height="50%">
    
    - 기본적으로 `.async` 메서드는 제출 시점의 실행 컨텍스트를 캡쳐
    - DispatchWorkItem을 사용하여 실행 방법을 더 많이 제어 가능
        - `.assignCurrentContext`를 통해 Work Item을 DispatchQueue 제출 시기가 아닌 Work Item을 만드는 시기에 실행 컨텍스트의 QoS 사용
        - 즉, 해당 작업을 생성하고 나중을 위해 저장도 가능하며, 최종적으로 실행시 생성 당시의 프로퍼티와 함께 Dispatch에 제출
    - `.wait` 메서드를 사용하여 Dispatch에 해당 작업 수행 완료 보장 가능
        
        <img src = "https://user-images.githubusercontent.com/99063327/230808842-76e60759-7fa3-404c-b207-fb1af18b0e9e.png" width="50%" height="50%">
        
        - Dispatch는 대기 중인 작업의 우선순위를 해당 QoS까지 높여 대응
            - DispatchWorkItem은 제출된 위치와 실행하려는 대기열을 알고 있기 때문에 가능
        - 세마포어 및 그룹은 소유권 개념을 인정 X
            - 즉, 세마포어 이전 작업들이 더 빠르게 실행되지 않음

- **Swift 3 내 동기화**
    - 전역 변수는 Atomic(Thread-Safe)하게 초기화
    - 클래스와 Lazy 프로퍼티는 그렇지 않음
    - 따라서, 동기화를 통해 Thread-Safe 확보 필요

- **Obejct Lifecycle In Concurrent World**
    
    <img src = "https://user-images.githubusercontent.com/99063327/230808984-f0302c36-0bb7-48ab-a36d-6b36f91a4a2c.png" width="50%" height="50%">
    
    - 4 Step State Mission
        - Thread 간 충돌 방지 목적
        - 구성
            - Setup(설정)
                
                <img src = "https://user-images.githubusercontent.com/99063327/230809021-054d40c2-1e5f-4e89-ba2f-b5c604d52ebb.png" width="50%" height="50%">
                
                - 객체 생성
                - 목적에 필요한 프로퍼티를 객체에 부여
            - Activate(활성화)
                
                <img src = "https://user-images.githubusercontent.com/99063327/230809078-23b5e382-2fe2-42a7-a752-2f03a2308321.png" width="50%" height="50%">
                
                - 해당 객체를 다른 하위 시스템에 알림
                - 작업 수행시 보다 동시적인 상황에서 사용하기 위함
            - Invalidate(무효화)
                - 모든 하위 시스템에서 해당 객체가 deallocated 되고 있음을 인지하는지 확인
            - Deallocate(할당 해제)
                - 할당 해제
        - 주의사항
            - deinit을 통한 할당 해제
                - `deinit`을 통한 할당 해제 시 하위 시스템에서는 아직도 참조되고 있는 상태
                    
                    <img src = "https://user-images.githubusercontent.com/99063327/230809114-ac98a742-f352-41da-a4d3-e4bcb762638b.png" width="50%" height="50%">
                    
                    <img src = "https://user-images.githubusercontent.com/99063327/230809196-e2a41e39-a391-44da-a701-4ead89434c31.png" width="50%" height="50%">
                    
                    - BusyController는 UI에 대한 참조
                    - Data Transform 하위 시스템에 등록시 해당 객체에서 참조를 가져왔을 가능성 농후
                    - 이로 인하여, deinit 미실행
                    - 등록 취소 및 수집 불가 → Abandoned Memory
                
            - Weak Reference를 통한 할당 해제
                
                <img src = "https://user-images.githubusercontent.com/99063327/230809261-2e28e8a8-611b-48bd-942d-a2e33fb1bd4f.png" width="50%" height="50%">
                
                - Weak Reference(약한 참조) 시에도 다른 객체가 참조하고 있을 가능성 존재
                    - 계속해서 Main Thread에서 해당 참조 제거
                    - Abandoned Memory는 아님
                        - 다른 객체(예) Octopus)는 본인이 이 참조를 가지고 있다는 것을 앎
                    - 하지만, Data Transform 하위시스템의 컨텍스트에서 다른 객체(예) Octopus) 제거 시, deinit이 하 일이기 때문에 BusyController에 있는 참조를 제거
                    - 이를 위해 해당 데이터 구조를 소유하는 Dispatch Queue와 동기화해야할 가능성 매우 높음 → DeadLock 발생
        - 해결 방안
            
            <img src = "https://user-images.githubusercontent.com/99063327/230809322-565a7ff4-0cba-4b1e-a2a3-ed4dff254d71.png" width="50%" height="50%">
            
            - Invalidation을 명시적 함수 호출로 변경
            - 전제 조건
                - 해당 VC가 Main Thread에서 관리되어야 함
                - API 사용자가 제대로 수행하는지 확인을 원함
            - 파생되는 문제
                - 모든 것은 메인 스레드에서 발생하고, 여전히 상태 전환을 보내는 하위 시스템이 존재
                - 즉, 무효화하는 시점에 여전히 작업 중인 하위 시스템 존재 가능
                - 해결방안
                    
                    <img src = "https://user-images.githubusercontent.com/99063327/230809321-5c669cd9-1a8f-4fb8-838f-640233bcff4b.png" width="50%" height="50%">
                    
                    - 무효화를 실제 상태로 추적하려고 함
                    
                    <img src = "https://user-images.githubusercontent.com/99063327/230809319-9ec0aee4-da05-400d-b8f8-1a9a40b8a7de.png" width="50%" height="50%">
                    
                    <img src = "https://user-images.githubusercontent.com/99063327/230809318-928b8d84-ab3d-40c0-80bf-6fef00834871.png" width="50%" height="50%">
                    
                    - 동시에 더 많은 전제 조건을 추가하여 할당 해제 되기 전에 적절하게 무효화 되었는지 확인하고 시행
                    - 상태 전환에 대한 알림을 처리하는 코드에서 객체가 무효화되었음 관찰 가능
        

## 💎 요약

> Data Flow의 관점에서 앱에 대하여 어떻게 생각을 하고, 독립적인 하위 시스템으로 앱을 나누는 방법을 살펴봄
> 

> 상태를 동기화해야 하는 경우 DispatchQueue를 통해 동기화하는 방법 소개
> 

> 동시성이 매우 높은 환경에서 사용되는 객체의 경우 Activation과 Invalidation Pattern을 사용하여 올바른 구조를 짜는 법을 배움
> 

## 💎 참고 자료

- Concurrent Programming With GCD in Swift 3 - Apple Developer

[Concurrent Programming With GCD in Swift 3 - WWDC16 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2016/720/)

- Concurrent Programming With GCD in Swift 3 - grumpy-sw velog

[[WWDC16] - Concurrent Programming With GCD in Swift 3](https://velog.io/@grumpy-sw/WWDC16-Concurrent-Programming-With-GCD-in-Swift-3)

- Concurrent Programming With GCD in Swift 3 - okstring velog

[번역 - Concurrent Programming With GCD in Swift 3(1/2)](https://velog.io/@okstring/번역-Concurrent-Programming-With-GCD-in-Swift-3)

- 스레드 프로그래밍 이해하기(동시성 프로그래밍, thread, GCD, Swift Concurrency) - 김종권 tistory

[[iOS - swift] 1. 스레드 프로그래밍 이해하기 - 동시성 프로그래밍, thread, GCD, Swift Concurrency](https://ios-development.tistory.com/1287)
