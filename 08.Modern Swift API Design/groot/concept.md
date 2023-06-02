# WWDC Modern Swift API Design
### API 가이드 문서에서 말하고 싶은 것
#### Clarity at the point of use
- 사용시점이 명확해야 한다. 
- 올바르게 사용하기 위해 쉽게 만들어야 한다.
  - 가독성  
  - 앞으로 Swift 전용 API의 Swift 유형에 접두사를 사용하지 않을 것 
- 주의점: 매우 일반적인 이름은 충돌 발생 시 사용자가 수동으로 명확하게 구분해야 한다.

### Values and references
- 클래스는 참조 타입으로 복사 시 동일 객체를 참조한다.
  - 복사해서 사용하면 공유된 변경을 야기함
    - 복사 시 참조되는 클래스   

    ![스크린샷 2023-05-31 오후 11 16 40](https://github.com/Groot-94/WWDC_Study/assets/96932116/d0168e72-ccbc-461c-b977-b2e3fdbd801e)

- 구조체와 열거형은 값 타입으로 복사 시 또 하나의 객체를 만든다.
  - 복사되기 때문에 공유되지 않는다. 
  ![스크린샷 2023-05-31 오후 11 17 30](https://github.com/Groot-94/WWDC_Study/assets/96932116/07a0d56c-7ff9-4e82-a6a7-ed837b3a5159)

- **클래스를 사용할 타당한 이유가 없는 한 구조체를 사용해라**
  - 참조 타입이 중요할 때만 사용하자.
  - 참조 카운팅과 메모리 해제가 필요할 때 필수적이다.
  - 값의 변경을 공유할 수 있을 때 좋다.
  - 객체가 정체성을 가져야 할 때? 좋다(Where there is a separate notion of “identity” from “equality)

- 예시
 ![스크린샷 2023-05-31 오후 11 18 37](https://github.com/Groot-94/WWDC_Study/assets/96932116/7ffc0758-9849-4c83-b1f0-1d4573591ddb)

- Material 라는 구조체 안에 클래스가 존재하면 복사 시 texture는 참조타입이 되기 때문에 데이터를 공유하게 된다.

   ![스크린샷 2023-05-31 오후 11 18 48](https://github.com/Groot-94/WWDC_Study/assets/96932116/c7801c18-62c6-417e-9157-d55a1c6cc005)

- 만약 texture가 불변한다면 문제가 없지만, 변경되는 값이 존재하면 그 값은 공유되기 때문에 사용자에게 혼란을 주게된다.
  ![스크린샷 2023-05-31 오후 11 19 08](https://github.com/Groot-94/WWDC_Study/assets/96932116/afe84f66-50a2-4013-a0f1-d73b8f7aca13)
  ![스크린샷 2023-05-31 오후 11 19 21](https://github.com/Groot-94/WWDC_Study/assets/96932116/3602ce02-2cf3-4c32-b414-b822b3072891)

- 위와같이 항상 구조체가 복사본을 만드는게 아니다 하위에 클래스가 존재하면 하위의 데이터는 참조의 특성을 가질 수 있다.
- 이와 같은 문제를 피하기 위해 필요한 기술이 많이 있지만, 여기선 방어적인 복사본을 만드는 방법을 소개함.
   - 참조 타입을 노출하는 방법
   ![스크린샷 2023-05-31 오후 11 26 33](https://github.com/Groot-94/WWDC_Study/assets/96932116/78f10849-5b10-4782-9d89-f9d9409518ee)
   - 참조 타입을 노출하지 않고 변경되는 프로퍼티를 연산프로퍼티로 정의하는 방법
   ![스크린샷 2023-05-31 오후 11 27 01](https://github.com/Groot-94/WWDC_Study/assets/96932116/57de0977-c504-424f-a778-efdf92be093f)
> isKnownUniquelyReferenced : Returns a Boolean value indicating whether the given object is known to have a single strong reference.
https://developer.apple.com/documentation/swift/isknownuniquelyreferenced(_:)-98zpp

### Protocols and Generics
- 프로토콜은 값 타입에 적용할 수 있다.
- 제네릭을 사용해서 서로 다른 값 타입 간에 코드를 공유할 수 있다
#### 프로토콜을 시작하기
- 구체적인 use case를 정하고 구현하고
- generic 코드의 필요성 발견하자
- 하지만, 먼저 기존 프로토콜에서 솔루션 구성 시도해보고
- 그 뒤에 프로토콜 대신 generic 유형을 고려하라.
- 예시
  - 프로토콜을 구성
   ![스크린샷 2023-05-31 오후 11 56 53](https://github.com/Groot-94/WWDC_Study/assets/96932116/f6c7b449-ed2a-4400-b0ee-016aa44c0c2b)
   - 기본구현
   ![스크린샷 2023-05-31 오후 11 57 11](https://github.com/Groot-94/WWDC_Study/assets/96932116/0c454156-635c-4ecb-8b73-16033bc51034)
   - 실제 사용
   - ![스크린샷 2023-05-31 오후 11 57 11](https://github.com/Groot-94/WWDC_Study/assets/96932116/0c454156-635c-4ecb-8b73-16033bc51034)
   - 이 예시에서 사용자 정의구현을 가지지 않고 그냥 기본 구현만 사용하는데 왜 굳이 프로토콜을 써야했을까? 이렇게 쓰면 유용하지 않다.
   - 우리가 원하는 기능을 SIMD 프로토콜의 익스텐션으로 그냥 구현해서 쓰는게 더 좋아보임.
   ![스크린샷 2023-05-31 오후 11 59 47](https://github.com/Groot-94/WWDC_Study/assets/96932116/b3430f0a-f0d8-4cc0-8813-3839c8e838a2)
   - 프로토콜 없이 간단하게 확장함으로 컴파일러는 더 쉽게 처리한다.
   - 복잡한 프로토콜 유형이 많은 프로젝트에서 단순화 접근 방식을 통해 컴파일 시간을 줄이는데 도움을 줄 수 있다.
   - 하지만, 완전한 API를 설계할 때 확장성 문제가 생김
   - 사용하기 쉬운 API를 설계할 때 Is-a 관계 대신 has-a 관계로 구현하는 옵션을 고려해라.
   - 구조체로 감싸고 제네릭을 사용하는 방법
   - 새로운 타입에 노출되는 API를 정확히 훨씬 더 세밀하게 제어할 수 있다.
   ![스크린샷 2023-06-01 오전 12 04 42](https://github.com/Groot-94/WWDC_Study/assets/96932116/8ae9946b-b1c8-4b2f-862f-b4d90fac0495)
   ![스크린샷 2023-06-01 오전 12 06 39](https://github.com/Groot-94/WWDC_Study/assets/96932116/3683f0c2-7374-4a4b-b6b2-a7c1215d092b)
   ![스크린샷 2023-06-01 오전 12 08 33](https://github.com/Groot-94/WWDC_Study/assets/96932116/0bff3be8-728f-49da-91df-303cfe279bac)

### Key path member lookup
- Swift 5.1에는 Key Path Member Lookup이라는 새로운 기능이 있다.
- 하나의 타입에서 여러 가지 계산된 속성을 모두 한 번에 노출하는 단일 스크립트 작업을 작성할 수 있다.
   - 예시
   ![스크린샷 2023-06-01 오전 12 10 34](https://github.com/Groot-94/WWDC_Study/assets/96932116/abe8b62a-d68d-48a0-bede-ac023e2b07d2)
   ![스크린샷 2023-06-01 오전 12 11 59](https://github.com/Groot-94/WWDC_Study/assets/96932116/cf4b0c3b-bdfd-4890-87b5-a88a41db7022)
![스크린샷 2023-06-01 오전 1 18 30](https://github.com/Groot-94/WWDC_Study/assets/96932116/c1a21d35-f03d-40a7-9dc7-4c9e65299076)

- 또한, 복잡한 논리들을 서브스크립트에 넣을 수 있다.
- 아래와 같이 copy on write를 isSparkly에만 제한하지 않고, 제네릭을 사용해서 다양한 내부 속성에 논리를 줄 수 있다.  
   ![스크린샷 2023-06-02 오후 12 23 05](https://github.com/Groot-94/WWDC_Study/assets/96932116/dabc2968-0515-4738-a6c7-656babee1a3c)

   ![스크린샷 2023-06-02 오후 12 25 16](https://github.com/Groot-94/WWDC_Study/assets/96932116/c0ef5a30-379b-4732-8778-d83f6f86c9ec)

### Property wrappers
- Property wrappers의 기본 아이디어는 작성하는 계산된 속성에서 코드를 효과적으로 재사용하는 것
- 아래의 코드는 실제 사용하는 시점에 init을 하는 lazy한 프로퍼티를 만드는 방법이다.
   ![스크린샷 2023-06-02 오후 12 30 02](https://github.com/Groot-94/WWDC_Study/assets/96932116/566aa978-0a56-42ac-8854-57e8dd8256da)
- 우리는 이것을 lazy 라는 이름으로 사용하고 있다.
- 이렇게 사용하면 문서화에 좋고 가독성이 좋아진다.
   ![스크린샷 2023-06-02 오후 12 31 07](https://github.com/Groot-94/WWDC_Study/assets/96932116/26bfbdd3-af4f-4a07-8401-4ae81024b4af)
- 이와같이 Property wrappers을 통해서 우리는 상용구를 제거하고 더 표현력이 풍부한 API를 얻으려는 것
   ![스크린샷 2023-06-02 오후 12 36 03](https://github.com/Groot-94/WWDC_Study/assets/96932116/53766d2c-b88a-4a64-b17b-e5f495203a3b)
- 재사용을 위한 지원 스토리지 속성 및 액세스 정책 캡처
- lazy와 유사한 장점을 제공한다.
   - 상용구 제거
   - 정의 지점에서 의미 체계를 문서화한다.
   ![스크린샷 2023-06-02 오후 12 36 11](https://github.com/Groot-94/WWDC_Study/assets/96932116/07d2246b-5f56-426a-96eb-ea976a79ea6d)
- 구현 방법
   ![스크린샷 2023-06-02 오후 12 43 42](https://github.com/Groot-94/WWDC_Study/assets/96932116/c1865f43-4b97-4ab6-8318-a705845080cf)
- 실제 사용
- $접두사는 실제 저장소이다.
   ![스크린샷 2023-06-02 오후 12 44 45](https://github.com/Groot-94/WWDC_Study/assets/96932116/dba7ff9d-2789-40a8-9e20-1e22d7a4b2c0)
- 원하는 유형의 다양한 속성에 대해 수행할 수 있으므로 훨씬 간단하고 상용구가 적다(사용구??)
- 이번엔 Defensive Copying을 Property wrappers로 구현한다.
   ![스크린샷 2023-06-02 오후 12 53 33](https://github.com/Groot-94/WWDC_Study/assets/96932116/1dd37905-b8e1-4b7c-8b16-6fd9e84112b9)
   
   ![스크린샷 2023-06-02 오후 12 54 21](https://github.com/Groot-94/WWDC_Study/assets/96932116/1b341d00-274f-4839-a21c-f6e5e43c49dc)
- 확장도 가능 
   ![스크린샷 2023-06-02 오후 12 56 47](https://github.com/Groot-94/WWDC_Study/assets/96932116/e94510b5-3f3d-4fe5-918d-87f018b5fd90)
- Property wrappers의 장점과 다양한 쓰임새
   - 데이터에 액세스하기 위해 이러한 정책 개념을 추상화한다. 데이터 저장 방법을 결정할 수 있습있다.
   - 데이터에 액세스하는 방법을 결정할 수 있다.
   ![스크린샷 2023-06-02 오후 12 58 34](https://github.com/Groot-94/WWDC_Study/assets/96932116/240ef1b5-af5a-4814-8958-0216c89d3694)
- Property wrappers는 SwiftUI에서도 많이쓰임
   ![스크린샷 2023-06-02 오후 1 00 27](https://github.com/Groot-94/WWDC_Study/assets/96932116/ae0d719c-7fb7-45da-b5eb-bee9680bab4d)
- Property Wrappers & Key Path Member Lookup 예시
   ![스크린샷 2023-06-02 오후 1 03 46](https://github.com/Groot-94/WWDC_Study/assets/96932116/bcc6c6f3-064a-431c-809c-2d9e208d062c)
- 요약
   ![스크린샷 2023-06-02 오후 1 04 08](https://github.com/Groot-94/WWDC_Study/assets/96932116/8977a158-657a-4d4c-b0f1-e199ec585074)

- 값 의미론과 참조 의미론, 각각을 사용하는 시기 및 함께 작동하게 만드는 방법
- 제네릭과 프로토콜의 사용
   - 프로토콜은 매우 강력하다는 것
   - 코드 재사용을 위해 사용.
   - 분류 및 큰 계층 구조 구축을 위한 것이 아님.
- Property wrappers 기능과 이를 사용하여 데이터에 대한 액세스를 추상화하는 방법
