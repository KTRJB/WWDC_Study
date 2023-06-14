# [WWDC20] Unsafe Swift

## 💎 배경

![스크린샷 2023-06-08 오후 12 51 01](https://github.com/Groot-94/WWDC_Study/assets/99063327/70e8ba6f-89f8-4cf2-a02a-de75bb134136)

> Swift Standard Library에서는 다양한 타입, 프로토콜, 함수, 프로퍼티 등을 제공하는 가운데 일부 `Unsafe`라고 적혀있는 것들이 존재한다. Unsafe가 적혀있는 기능들은 어떠한 특징을 보이고, 나아가 어느 상황에서 사용하는 것이 적절하고, 무엇을 주의해야할 지를 알아보자.
> 

## 💎 해결방안

- **Unsafe**
    - **의미**
        - 보통 표준 라이브러리에 있는 대부분의 작업은 어떠한 입력이라도 예상 가능한 범주 내에서 처리할 수 있음을 가정
        
        ![스크린샷 2023-06-08 오후 12 53 52](https://github.com/Groot-94/WWDC_Study/assets/99063327/ab2f5402-a34a-47eb-9675-9146d4470604)
        
        - 예시로, 강제 옵셔널 추출의 경우에서도 값이 nil이 아니어야 하지만, nil이더라도 fatal runtime error라는 예상 가능한 결과값을 기대할 수 있음
        
        ![스크린샷 2023-06-08 오후 12 55 02](https://github.com/Groot-94/WWDC_Study/assets/99063327/79f68c54-539f-469b-98bc-d71db8d0ee85)
        
        - 즉, `Safe` 라고 하는건 요구 사항을 충족하지 않는 입력을 포함하여 가능한 모든 입력에 대한 동작들을 완전히 설명할 수 있기에 안전하다고 말하는 것
        
        ![스크린샷 2023-06-08 오후 12 56 08](https://github.com/Groot-94/WWDC_Study/assets/99063327/afdc194b-76e5-4e98-8005-38e992944412)
        
        - 이와 반대로, `Unsafe` 라 함은 적어도 일부 입력에서는 기대에 벗어난 정의되지 않은 동작을 보여주는 것임
        
        ![스크린샷 2023-06-08 오후 12 57 09](https://github.com/Groot-94/WWDC_Study/assets/99063327/fc51916a-2054-46de-ab43-4cc5177e2d97)
        
        - 예시로, `unsafelyUnwrapped` 는 unsafe한 강제 unwrap 작업임
        - 기본값이 nil이 아니어야 하는데, 최적화가 활성화된 상태로 컴파일되면 이 프로퍼티는 요구사항을 확인하지 않음
        - nil값이 아닌 값으로만 호출하고 직접 읽어낸다고 신뢰
        
        ![스크린샷 2023-06-08 오후 12 59 01](https://github.com/Groot-94/WWDC_Study/assets/99063327/c15d7c65-282f-44a9-a53b-d63fdd7932be)
        
        - 만약 nil값을 호출한다면, 존재하지 않는 값을 읽어내며 정확히 무엇을 의미하는지 알기 어려움
        - 충돌을 일으킬수도, 일부 의미없는 값을 반환할 수도 있음
        - 실행때마다 같은 결과값을 낼수도, 또 아닐수도 있음
        
        <img width="804" alt="스크린샷 2023-06-08 오후 1 02 02" src="https://github.com/Groot-94/WWDC_Study/assets/99063327/d69e61bf-5f91-4852-81d5-f5337a355231">
        
        - 본인의 경우에는 Xcode 자체에서 fatal runtime error가 발생했음
        - 중요한 점은 해당 프로퍼티를 사용한다면 해당 요구사항을 전적으로 충족하는 책임을 짐을 의미
        - 요구사항을 위반하면 그 결과는 예측불가능하고 디버깅도 어려움
        - 이것이 표준 라이브러리에 있는 모든 `unsafe` 타입들의 전형적인 특징
        - 따라서, 이를 사용하는 것에 각별한 주의가 필요
    - **장점**
        - C 혹은 Objective-C와의 상호 운용성 제공
        - 런타임 성능 혹은 프로그램 실행의 다른 측면에서 세밀한 제어 제공
    - **주의할점**
        
        ![스크린샷 2023-06-08 오후 1 10 28](https://github.com/Groot-94/WWDC_Study/assets/99063327/35221624-e267-4e51-a3d8-f148e27ab5d0)
        
        - Safe API의 목표는 no crash가 목적이 아님
        - 오히려 그 반대
        - 문서화된 제약 조건을 벗어난 입력이 제공되면 Safe API는 fatal runtime error 발생시켜 실행 중지
        - 이러한 상황은 심각한 프로그래밍 오류를 나타냄
        - 코드가 중요한 계약을 위반했으니 수정해야함
        - 오류로 인해 생성된 crash report는 문제가 발생한 상황을 아려주므로 문제를 디버깅하고 수정 가능

- **Unsafe Pointers**
    - **의미**
        - Swift Standard Library에서 C 언어의 pointer와 거의 동일한 수준의 powerful한 Unsafe Pointer 타입 제공
        - 포인터 동작 방식을 알기 위해서는 메모리에 대해서 알아야함
        
        ![스크린샷 2023-06-08 오후 1 16 16](https://github.com/Groot-94/WWDC_Study/assets/99063327/ca422c26-09ef-4b46-beaf-11489a664b4e)
        
        - Swift는 Flat Memory Model 사용
        - 메모리를 개별적으로 주소 지정이 가능한 8-bit 바이트의 선형 주소 공간(linear address space)로 취급
        - 각 바이트에는 일반적으로 16진수 정수 값으로 표현되는 고유한 주소가 있음
        
        ![스크린샷 2023-06-08 오후 1 23 28](https://github.com/Groot-94/WWDC_Study/assets/99063327/b652816f-393c-4a10-ba57-13c027af1c0a)
        
        - 런타임 시 주소 공간은 앱의 실행 상태를 반영하는 데이터로 드물게 채워짐
            - 앱의 실행 가능 바이너리
            - 모든 라이브러리와 프레임 워크
            - stack
                - 함수 인자(argument)뿐만 아니라 로컬 및 임시 변수를 위한 스토리지 제공
            - dynamic memory region
                - 수동으로 할당한 class instance storage 및 메모리 포함
            - 그 외
                - 읽기 전용 리소스에 mapping
                    - 예시) 이미지 파일
        - 각 item들은 동일한 공유 선형 주소 공간에 일종의 데이터를 저장하는 연속 메모리 영역(contiguous memory region)이 할당됨
        - 앱이 실행됨에 따라 메모리 상태는 계속 진화함
            - 새 개체가 할당
            - 스택 변경
            - 이전 아이템 파괴
            - …
        - Swift Language와 런타임은 우리가 어디에 있는지 추적 가능
        - 일반적으로 Swift에서 수동으로 메모리 관리할 필요 X
        - 수동으로 메모리 관리가 필요할 때는 unsafe pointer가 효과적인 관리를 위해 필요한 모든 하위 수준의 작업(low-level operation)을 제공
        - 물론, 이러한 모든 제어의 이면에는 그에 따른 책임이 따름
        - 포인터는 단순히 메모리 어딘가에 있는 위치의 주소를 나타냄
        - **강력한 작업을 제공하지만 올바르게 사용할 것이라고 믿어야 하므로 근본적으로 unsafe함**
        - **주의하여 사용하지 않으면, 포인터 작업이 주소 공간 전체에 휘갈겨져 앱을 망칠 수 있음**
    - **예시**
        
        ![스크린샷 2023-06-08 오후 1 30 59](https://github.com/Groot-94/WWDC_Study/assets/99063327/03e5df75-69a9-489d-b97c-0a88903cb889)
        
        - 예시로, integer value에 대한 스토리지를 동적으로 할당하면 스토리지 위치가 생성되고 이에 대한 직접적인 포인터가 제공됨
        - 포인터는 기본 메모리에 대한 full control을 제공하지만 대신 관리하지는 않음
        - 추후에 해당 메모리 위치에서 어떤 일이 발생하는지 추적 불가능
        
        ![스크린샷 2023-06-08 오후 1 35 59](https://github.com/Groot-94/WWDC_Study/assets/99063327/d0a976b6-1dae-4283-ae76-b10b66ceab5b)
        
        - underlying memory가  deinitialize & deallocate됨에 따라 포인터가 무효화됨
        - 그런데, 유효하지 않은 이 포인터는 마치 유효한 포인터처럼 보임
        - 포인터 자체는 자신이 무효화되었음을 알지 못함
        
        ![스크린샷 2023-06-08 오후 1 36 42](https://github.com/Groot-94/WWDC_Study/assets/99063327/c0451c5d-deb5-47f7-a223-cd4691ac90d8)
        
        - 이러한 dangling pointer를 역참조하려는(dereference) 시도는 심각한 프로그래밍 오류임
            - dangling pointer(허상 포인터)란 포인터가 여전히 해제된 메모리 영역을 가리킴을 의미
            - wild pointer 혹은 permature free(너무 급한 해제)라고 부르기도 함
            - 다음의 문제 야기
                - 메모리 접근시 예측 불가능한 동작
                - 메모리 접근 불가시 Segmentation fault
                - 잠재적인 보안 위험
            - 다음의 동작 발생
                - 메모리 해제 후, 해제된 메모리에 접근
                - 함수 호출에서 자동 변수를 가리키는 포인터 반환
        - 운좋으면 메모리 위치는 deallocate되어 완전히 액세스 할 수 없게 렌더링되어 액세스 시도시 즉시 crash 발생
        - 근데 꼭 이러한 동작을 하리라 보장 X
        
        ![스크린샷 2023-06-08 오후 1 43 30](https://github.com/Groot-94/WWDC_Study/assets/99063327/e2cfc261-f204-4d42-8871-688ddd3ee5a1)
        
        - Subsequent allocation(후속 할당)으로 동일한 주소를 재사용해 다른 값을 저장했을 수도 있음
        - 이 경우, dangling pointer를 역참조하면 훨씬 더 심각한 문제 발생
        - 이를 통해 쓰려고 한다면 앱의 관련 없는 부분의 상태가 자동으로 손상될 수 있음
        - 이는 arbitrary effect를 미칠 수 있으므로 좋지 않음
            - 예시로, 자동으로 손상되거나 유저 데이터가 손실될 수 있음
            - 이러한 버그는 우리가 액세스하는 값에 참조가 포함되어 있거나 메모리에 호환되지 않는 유형의 Swift 값이 포함되어 있을 때 특히 문제
    - **Address Sanitizer**
        
        ![스크린샷 2023-06-08 오후 1 58 35](https://github.com/Groot-94/WWDC_Study/assets/99063327/dd06530a-5c5e-422a-acc2-58079aff3758)
        
        - Xcode는 이러한 메모리 문제를 파악하는데 도움이 되는 Address Sanitizer라는 런타임 디버깅 툴 제공
        - Pointer 타입을 위험하면서도 사용하는 이유는 C나 Objective-C와 같은 unsafe language와의 상호 운용성(interoperability) 때문
    - **Swift Unsafe Pointers**
        
        ![스크린샷 2023-06-08 오후 2 01 30](https://github.com/Groot-94/WWDC_Study/assets/99063327/5564d81d-3e29-405a-bf3e-20e7a7434f8c)

        
        - 위의 언어에서 함수는 종종 포인터 인수(argument)를 사용하므로 호출할 수 있으려면, Swift 값에 대한 포인터를 생성하는 방법을 알아야 함
        - 사실은 C 포인터 타입과 그에 상응하는 Swift unsafe Pointer 사이에는 direct mapping이 있음
        - Swift로 가져오는 C API는 이 mapping을 사용하여 번역됨
        - 이에 대한 예시는 Unsafe Buffer와 연계하여 알아보고자 함

- **Unsafe Buffers**
    - **의미(feat. Pointer)**
        
        ![스크린샷 2023-06-08 오후 2 03 05](https://github.com/Groot-94/WWDC_Study/assets/99063327/eff7111a-16e3-42eb-a66a-e14c66ece554)
        
        - 어떤 방식으로든 정수 값의 버퍼를 처리하려는 간단한 C 함수의 경우
        - Swift로 가져올 때, const int라는 pointer argument는 implicitly-unwrapped Optional unsafe pointer 타입(`UnsafePointer<CInt>!`)으로 변환됨
        
        ![스크린샷 2023-06-08 오후 2 12 21](https://github.com/Groot-94/WWDC_Study/assets/99063327/f054a6c5-c1c0-47cf-82ac-96b2d9819a3a)
        
        - 과정
            - 이러한 포인터를 얻는 한 가지 방법은 UnsafeMutablePointer에서 static allocate method(정적 할당 메서드)를 사용하여 정수 값을 유지하는데 적합한 dynamic buffer를 만드는 것
            - 그런 다음 pointer arithmetic과 전용 초기화 방법을 사용하여 버퍼의 요소를 특정 값으로 설정
            - 모든 것이 정리되면 마지막으로 C 함수를 호출하여 최기화된 버퍼에 대한 포인터를 전달
            - 함수가 반환되면 버퍼 deinit 및 deallocate하여 Swift가 나중에 다른 작업을 위해 메모리 위치를 재사용할 수 있도록 해주기
    - **문제점 간단정리: 모든 과정을 완전히 제어할 수 있으나 근본적으로 unsafe**
        
        ```swift
        let start = UnsafeMutablePointer<CInt>.allocate(capacity: 4)
        ```
        
        - 할당된 버퍼의 수명은 return pointer에 의해 관리되지 않음
        - 적절한 시점에 수동으로 deallocate해야함
        - 그렇지 않으면 memory leak 발생
        
        ```swift
        start.initialize(to: 0)
        (start + 1).initalizae(to: 2)
        (start + 2).initalizae(to: 4)
        (start + 3).initalizae(to: 6)
        ```
        
        - Initialization은 주소 지정된 위치가 할당한 버퍼 내에 있는지 자동으로 확인 불가
        - 잘못하면 정의되지 않은 동작 발생 가능
        
        ```swift
        process_integers(start, 4)
        ```
        
        - 함수를 올바르게 호출하려면 기본 버퍼의 소유권을 가져갈지 여부를 알아야 함
        - 이 경우 함수 호출 기간 동아만 액세스하고 포인터를 유지하거나 할당 해제를 시도하지 않는다고 가정
        - 이것은 Language에 의해 시행되지 않음
        - 함수의 documentation에서 찾아봐야함
        
        ```swift
        start.deinitialize(count: 4)
        ```
        
        - Deinitialization은 기본 메모리가 이전에 올바른 타입의 값으로 초기화된 경우에만 의미가 있음
        
        ```swift
        start.deallocate()
        ```
        
        - 이전에 할당되었고 deinit되지 않은 상태에 있는 메모리만 deallocate해야 함
    - **문제점 상세정리**
        - 모든 단계에서 확인되지 않은 가정이 존재하고, 그 중 하나라도 잘못되면 undefined behavior 발생
        - 또한 위의 의문점 중 하나로 버퍼가 시작 주소로만 표시됨
            - 버퍼의 길이는 중복되는 별도의 값임
            - 버퍼를 (시작 주소, 길이) 값의 쌍으로 모델링하여 코드의 명확성 향상 가능
            - 이렇게 하면 버퍼의 경계를 항상 쉽게 사용할 수 있으므로, 어떤 지점에서 범위를 벗어난 액세를 하는지 쉽게 확인 가능
            - 이것이 swift standard library가 `UnsafeBufferPointer<Element>`, `UnsafeMutableBufferPointer<Element>`, `UnsafeRawBufferPointer<Element>`, `UnsafeMutableRawBufferPointer<Element>`라는 4가지 unsafe buffer pointer 타입을 제공하는 이유
            - 이는 개별 값에 대한 포인터가 아니라 메모리 영역으로 작업해야 할 때마다 유용
            - package에 여역의 크기와 위치를 포함함으로써 best practice를 권장하고 메모리를 보다 신중하게 관리 가능
            - 최적화되지 않은 디버그 빌드(unoptimized debug build)에서 버퍼 포인터는 subscript 작업을 통해 범위를 벗어난 액세스를 확인하여 약간의 안정성을 제공
            - 그러나 이 유효성 검사는 필요에 따라 분완전하여 bound checking으로 제한됨
                - **경계 검사**(bounds checking)는 변수가 사용되기 전에 어떤 경계 내에 위치하는지를 검사하는 기법
                - 주로 숫자 데이터가 특정 범위 내에 존재하는지 여부나 (범위 검사), 배열 인덱스가 배열의 경계 안에 있는지 여부를 검사하는데 사용 (인덱스 검사)
                - 경계 검사에서 실패한 경우 (가령, 접근할 배열 인덱스가 배열 경계 바깥에 있는 경우)는 보통 프로그램 예외로 처리
                - 경계 검사는 주로 컴퓨터 보안과 관련하여 메모리 취약점 발생을 근본적으로 방지하는 목적으로 사용되지만, 성능 측면에서 상당한 오버헤드를 발생시켜 통상 모든 경우에 항상 수행되지는 않음
                - 이와 관련한 컴파일러 최적화 기법 가운데 하나는 불필요한 경계 검사 코드를 제거하는 것을 목표로 하기도 함 (Bound-checking elimination)
            - 포인터와 마찬가지로 underlying memory는 예상된 상태인지 확인할 수 X
            - 그래도 부분적으로 확인하는 것이 전혀 확인하지 않는 것보다는 훨씬 더 유용하고 길이와 주소를 단일 단위로 함께 고려하는 단순한 행위만으로도 이미 몇 가지 간단한 실수를 방지하는데 도움이 됨
    - **활용**
        - Accessing Contiguous Collection Storage
            
            ![스크린샷 2023-06-08 오후 3 53 10](https://github.com/Groot-94/WWDC_Study/assets/99063327/12ef74bf-889b-44c9-8946-b16d7e7b4d84)
            
            - Swift Standard Contiguous Collection은 편리한 unsafe 메서드를 통해 기본 스토리지 버퍼에 대한 임시 direct access를 제공하기 위해 위의 버퍼 포인터 사용
        - Temporary Pointers to Swift Values
            
            ![스크린샷 2023-06-08 오후 3 53 27](https://github.com/Groot-94/WWDC_Study/assets/99063327/bea9eb35-73d7-4299-995f-f48abbb2416a)
            
            - 또한 개별 Swift 값에 대한 임시 포인터를 얻을 수 있으며, 이를 기대하는  C 함수에 전달 가능
            
            ![스크린샷 2023-06-08 오후 3 54 02](https://github.com/Groot-94/WWDC_Study/assets/99063327/b20a53ab-10cd-479c-a6cd-12bd3daa3a86)
            
            - 이러한 방법을 사용하여 코드를 단순화하고 unsafe 작업을 가능한 가장 작은 코드 섹션으로 격리 가능
            - `let values: [CInt] = [0, 2, 4, 6]` 과 같이 수동 메모리 관리의 필요성을 없애기 위해 입력 데이터를 배열 값에 저장 가능
            - 그런 다음 `withUnsafeBufferPointer` 메서드를 사용하여 일시적으로 배열의 기본 스토리지에 직접 접근 가능
            - 해당 함수에 전달하는 클로저 내에서 시작 주소와 카운트 값을 추출하고 호출하려는 C 함수에 직접 전달 가능
            - C 함수에 대한 포인터 전달 필요 작업은 빈번히 발생하여 Swift에서는 special syntax 제공
            
            ![스크린샷 2023-06-08 오후 3 57 22](https://github.com/Groot-94/WWDC_Study/assets/99063327/2d5e3964-436b-4e3c-ac53-3258e5cea0f9)
            
            - unsafe pointer를 예상하는 함수에 배열 값을 전달하기만 하면 컴파일러가 자동으로 동등한 withUnsafeBufferPointer 생성
            - 주의할 점은 포인터가 함수 호출 기간 동안만 유효하다는 점임
            - 함수가 포인터를 탈출하고 나중에 기본 메모리에 액세스하려고 시도하면 포인터를 얻기 위해 어떤 syntax를 사용했는지에 관계없이 undefined 동작 발생
    
- **Interoperability with C**
    - **변환 목록**
        
        ![스크린샷 2023-06-08 오후 3 59 37](https://github.com/Groot-94/WWDC_Study/assets/99063327/c7d6a201-99e9-4468-828e-6bcc7e3446ff)

        
        - 다음은 Swift에서 지원하는 implicit value-to-pointer 변환 목록임
        - `const T *` → `[T]`
            - 위의 예시에서 본 바와 같이, Swift Array를 C 함수에 전달하려면 배열 값 자체를 전달하기만 하면 됨
        - `T *` → `inout [T]`
            - 함수가 요소를 변경하려는 경우 배열에 대한 inout 참조를 전달하여 mutable pointer 얻을 수 있음
        - `const char *` → `String`
            - C String을 사용하는 함수는 Swift String 값을 직접 전달하여 호출 가능
            - String은 가장 중요한 Null char을 포함하여 임시 C String 생성
        - `T *` → `inout T`
            - C 함수가 단순히 개별 값에 대한 포인터를 기대하는 경우, 적절한 임시 포인터를 얻기 위해 해당 Swift 값에 대한 inout 참조 사용 가능
    - **예시 1: cacheLineSize**
        
        ![스크린샷 2023-06-08 오후 4 05 05](https://github.com/Groot-94/WWDC_Study/assets/99063327/cd1f6288-2542-47fe-84ac-da2cc8857132)
        
        - 위의 기능들을 주의깊게 사용하면 가장 복잡한 C 인터페이스도 호출 가능
        - `sysctl` 은 Darwin 모듈에서 제공하는 C 함수로  실행 중인 시스템에 대한 low-level 정보를 쿼리하거나 업데이트하는데 사용
            - 6개의 매개변수
                - `name`, `namelen`: 액세스하려는 값의 식별자 역할을 integer buffer의 위치와 크기
                - `oldp`, `oldlenp`: 함수가 현재 값을 저장하기를 원하는 다른 버퍼의 위치와 크기
                - `newp`, `newlen`: 지정된 entry에 대해 설정할 수 있는 새 값을 포함하는 optional read-only 세번째 버퍼
        - Swift에서 해당 함수를 호출하는 것이 C에서처럼 반드시 더 복잡하지는 X
        - implicit pointer conversion을 사용하여 큰 효과를 얻을 수 있고, C 언어와 외관상 비슷한 코드 생성
        
        ![스크린샷 2023-06-08 오후 4 12 52](https://github.com/Groot-94/WWDC_Study/assets/99063327/edfc6fd8-0000-4a8e-834a-cec25dc4c771)
        
        - 예시로 실행 중인 프로세스 아키텍처의 캐시 라인 크기를 검색하는 함수를 만들 때
        - sysctl의 문서는 하드웨어 섹션의 CACHELINE 식별자 아래에서 이 정보를 사용할 수 있다고 알려줌
        - 이 ID를 sysctl에 전달하기 위해 implicit array-to-pointer conversion 및 해당 count에 대한 explicit integer conversion 사용 가능
        
        ![스크린샷 2023-06-08 오후 4 14 56](https://github.com/Groot-94/WWDC_Study/assets/99063327/00b995ab-a8bf-44e2-b819-2db591912d15)
        
        - 검색하려는 정보는 C integer 값이므로, local integer 변수를 생성하고, 또 다른 inout-to-pointer conversion과 함께 세 번째 argument에 대한 임시 포인터 생성
        - 이 함수는 캐시 라인의 크기를 이 포인터에서 시작하여 버퍼에 복사해 원래의 0 값을 다른 정수로 덮어씀
        
        ![스크린샷 2023-06-08 오후 4 15 42](https://github.com/Groot-94/WWDC_Study/assets/99063327/66a7780d-bba7-48e5-ad35-869e4f704260)
        
        - 네 번째 argument는 해당 정수 유형의 MemoryLaout에서 가져올 수 있는 이 버퍼의 크기에 대한 포인터
        - 돌아오면, 함수는 이 값을 result에 복사한 바이트 수로 설정
        
        ![스크린샷 2023-06-08 오후 4 17 27](https://github.com/Groot-94/WWDC_Study/assets/99063327/b28f9363-eedf-4617-9206-e45e3d95180d)
        
        - 현재 값을 검색하기만 하고 설정하지는 않기 때문에, new value 버퍼에 nil 값을 제공하고, 크기를 0으로 설정
        
        ![스크린샷 2023-06-08 오후 4 18 21](https://github.com/Groot-94/WWDC_Study/assets/99063327/324c32f5-7617-4dc9-a4ed-6a756f698663)
        
        - sysctl은 성공 시, 0 값을 반환하도록 문서화
        - 이 코드가 실패할 수 없다고 가정하지만 우리가 제공한 argument에서 실수를 한 경우 이 가정을 확인
        
        ![스크린샷 2023-06-08 오후 4 19 33](https://github.com/Groot-94/WWDC_Study/assets/99063327/43c1e760-f65a-4eb1-9246-ed8ec81308b5)
        
        - 비슷한 맥락으로 해당 호출이 C integer 값과 동일한 크기의 바이트를 설정하기를 기대
        
        ![스크린샷 2023-06-08 오후 4 19 52](https://github.com/Groot-94/WWDC_Study/assets/99063327/52c8af53-3769-4e9d-b3d2-cfd9437abc1f)
        
        - 마지막으로 C integer를 Swift Int로 변환하고 결과 반환
        - 확인 결과도 그렇고 대부분 플랫폼에서 캐시 라인은 64바이트
        
        ![스크린샷 2023-06-08 오후 4 20 50](https://github.com/Groot-94/WWDC_Study/assets/99063327/63447a3f-a2ad-406f-92e6-5968d34141bc)
        
        - unsafe한 부분들을 단일 함수 호출로 깔끔하게 분리 성공
        - 이를 아래와 같이 explicit closure 기반 호출로 확장하도록 선택 가능
        
        ![스크린샷 2023-06-08 오후 4 21 58](https://github.com/Groot-94/WWDC_Study/assets/99063327/5e7f8459-4b9e-4f93-8e5e-daec30e5c761)
        
        - 코드 기능은 위와 동일
        - 스타일에 따라 선택하면 됨
        - 중요한 점은 **생성된 포인터 값은 일시적이며 함수가 반환될 때 무효화된다는 점을 항상 인식**
        - inout-to-pointer 변환은 편리할 수 있지만 실제로는 C 함수 호출을 돕기 위한 것일 뿐
        
        ![스크린샷 2023-06-08 오후 4 23 44](https://github.com/Groot-94/WWDC_Study/assets/99063327/98ca328b-6237-4bad-86cc-59b1b9130e4e)
        
        - 순수 Swift 코드에서는 포인터를 훨씬 덜 자주 전달해야 하므로 closure 기반 API 사용 선호
        - 좀 더 장황할 수 있으나 명확하기 때문에 무슨 일이 일어나는지 더 쉽게 이해 가능
        
        ![스크린샷 2023-06-08 오후 4 27 22](https://github.com/Groot-94/WWDC_Study/assets/99063327/7154c706-4c92-4b71-9637-37bfbbc72ead)
        
        - 특히, closure 기반 디자인은 결과 포인터의 실제 수명을 훨씬 더 명확하게 만들어 잘못된 포인터 변환과 같은 수명 문제 방지에 도움
        - 여기서 mutable pointer initializer에 임시 포인터를 전달하면 초기화 호출에서 해당 값을 escape
        - 그 결과, dangling pointer 값에 접근하는 undefined behavior로 전락
        - 기본 메모리 위치가 더 이상 존재하지 않거나 다른 값에 재사용되었을 수 있음
        - Swift 5.3 컴파일러는 이러한 경우 감지하여 경고 생성
    - **예시 2: kernelVersion**
        
        ![스크린샷 2023-06-08 오후 4 28 01](https://github.com/Groot-94/WWDC_Study/assets/99063327/85c33ad2-b4df-4770-b13b-06e242f15edf)
        
        - 또 다른 개선 사항으로 Swift Standard Library는 이제 기본 초기화되지 않은 스토리지에 데이터를 직접 복사하여 Array 또는 String 값을 생성할 수 있는 새로운 초기화 프로그램 제공
        - 이를 통해 그러한 데이터를 준비하기 위해서만 임시 버퍼를 할당할 필요가 없어짐
        
        ![스크린샷 2023-06-08 오후 4 30 15](https://github.com/Groot-94/WWDC_Study/assets/99063327/2a445578-bb55-41df-b48c-cb830b965387)
        
        - 예를 들어, String의 새로운 초기화 프로그램을 사용하여 동일 sysctl 함수를 호출해 String 값 검색 가능
        - 커널 섹션의 VERSION 항목으로 식별되는 운영 체제의 커널 버전을 찾고자 함
        - cacheline 예제와 달리 VERSION String의 크기를 미리 알 수 없음
        - 이를 파악하려면 sysctl을 두 번 호출해야 함
        
        ![스크린샷 2023-06-08 오후 4 31 00](https://github.com/Groot-94/WWDC_Study/assets/99063327/65752d22-10fc-4c25-a566-57f64eb83b8c)
        
        - 먼저 nil 출력 버퍼로 함수를 호출
        - 반환되면, length 변수는 문자열을 저장하는데 필요한 바이트 수로 설정됨
        
        ![스크린샷 2023-06-08 오후 4 32 22](https://github.com/Groot-94/WWDC_Study/assets/99063327/066d4db1-78ab-4e04-a02b-499d002122a6)
        
        - 마찬가지로 오류가 있는지 확인 필요
        - result의 size가 있으므로 실제 데이터를 얻을 수 있또록 초기화되지 않은 저장소를 준비하도록 String에 요청 가능
        
        ![스크린샷 2023-06-08 오후 4 33 42](https://github.com/Groot-94/WWDC_Study/assets/99063327/7b5e11f4-96cb-416b-9dbc-57003c1f6a5c)
        
        - 이니셜라이저는 sysctl 함수에 전달할 수 있는 버퍼 포인터 제공
        - 해당 함수는 version string을 이 버퍼에 직접 복사
        
        ![스크린샷 2023-06-08 오후 4 35 24](https://github.com/Groot-94/WWDC_Study/assets/99063327/9f2fa619-2e62-4552-a63c-fcd53808fed6)
        
        - return시 함수 호출 성공했는지 확인
        - 함수가 실제로 일부 바이트를 버퍼에 복사했는지, 마지막 바이트가 C String을 종료하는 NULL Char에 해당하는 0인지 double check
        - Null Char은 Version String의 일부가 아니므로 복사한 바이트 수보다 1 적은 값을 반환하여 버림
        - 이는 스토리지에 복사한 UTF-8 데이터가 정확히 몇 바이트인지 String에 알림
        - 이 새로운 string initializer를 사용하면 여기에서 수동 메모리 관리 필요 X
        - 결국 일반 Swift String 인스턴스의 저장소가 될 버퍼에 직접 액세스 가능
        - 수동으로 메모리 할당, 할당 해제 필요 X
        
        ![스크린샷 2023-06-08 오후 4 37 23](https://github.com/Groot-94/WWDC_Study/assets/99063327/7d390766-460f-4fca-b1d4-a95169368f74)
        
        - 함수 호출시 예상 버전 string을 얻음

## 💎 요약

![스크린샷 2023-06-08 오후 4 42 09](https://github.com/Groot-94/WWDC_Study/assets/99063327/c4592837-04c3-4fb7-93c8-8e2408e751bc)

> Unsafe API를 사용하여 가장 까다로운 상호 운용성 문제를 해결할 수 있다는 점을 인지해야 합니다. 그러나 Unsafe API를 효과적으로 사용하기 위해서는 항상 기대치를 인식하고 이를 충족시키는 데 주의해야 합니다. 그렇지 않으면 코드는 정의되지 않은 동작을 수행할 수 있습니다. 따라서 가능한한 Unsafe API 사용을 최소화하고, Safe한 대안을 선택하는 것이 좋습니다.
> 
> 
>   또한, 메모리 영역에 여러 요소가 포함되어 있는 경우에는 단순 포인터 값 대신 unsafe buffer pointer를 사용하여 경계를 추적하는 것이 가장 좋습니다. 이를 통해 코드를 더 안전하게 작성할 수 있습니다.
> 
>   Xcode는 안전하지 않은 API를 사용할 때 발생할 수 있는 문제를 디버깅하는 데 도움이 되는 도구인 Address Sanitizer를 제공합니다. 따라서 코드를 실제 생산에 적용하기 전에 Xcode의 도구를 활용하여 버그를 식별하고 발견되지 않은 문제를 디버깅할 수 있습니다. 이러한 조치를 취함으로써 Unsafe API 사용과 관련된 문제를 미리 예방하고 안전성을 높일 수 있습니다.
> 

## 💎 참고 자료

- **Unsafe Swift - Apple Developer**

[Unsafe Swift - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10648/)

- **Dangling Pointer - Wikipedia**

[허상 포인터](https://ko.wikipedia.org/wiki/허상_포인터)

- **Dangling Pointer - Thinkpro Tistory**

[댕글링 포인터(Dangling Pointer)](https://thinkpro.tistory.com/67)

- **Bound Checking - Wikipedia**

[경계 검사](https://ko.wikipedia.org/wiki/경계_검사)
