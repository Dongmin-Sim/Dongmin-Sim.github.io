---
title: 해시 자료구조와 HashMap이 해시 충돌을 해결하는 방법
author: codongmin
date: 2024-11-18T21:08:00
categories:
  - Data-Structure
  - Hash
tags: 
preview: 해시 자료구조와 HashMap에서 해시 충돌을 해결하는 방법을 자세히 알아봅니다.
image:
  path: /assets/img/thumbnail/hash-data-structure.png
  lqip: 
  alt: 해시 자료구조와 HashMap이 해시 충돌을 해결하는 방법
---

## 🙋 **들어가며**

이 글에서는 **해시 자료구조에 대한 전반적인 내용**을 다룬다. 해시 자료구조에 대한 이해를 돕기 위해 일상적인 예시를 기반으로 글을 전개해나간다. 해시 자료구조의 핵심 개념인 **해싱에 대한 이해**로 시작해서 해싱을 위한 **해시 함수**에 대해 알아보고, 해시 자료구조에서 필연적으로 만나게 되는 **해시 충돌**에 대해서 다룬다. 그리고 해시 충돌을 **해결하는 여러 방법들**을 설명한다.

더 나아가 자바의 대표적 해시 자료구조인 **`HashMap`** 에서는 어떤 해시 충돌 해결 방식을 사용하는지 다룬다. 자바 버전에 따라 해시 충돌 해결 방식이 달라졌으며, 특히 자바 8버전 이후 **최적화된 충돌 해결 방식**에 대해 설명한다. 마지막으로 `HashMap`의 **내부 동작 원리**를 통해 해시기반 자료구조를 사용할때 어떻게 활용할 수 있을지 살펴보려 한다.

해시 자료구조에 대해서 **처음 들어봤거나**, 단순히 해시 자료구조를 기반으로 하는 구현체들을 많이 사용해봤지만 해시 자료구조가 **어떤 원리로 동작하는지 모르는 경우**에 이 글이 도움이 될 수 있다.

<br>

반면에 대상이 아닌 독자는 다음과 같다.
> - 해시 테이블의 구조와 해시 함수가 어떻게 동작하는지 명확하게 이해하고 있는 사람.
- 해시 충돌에 대한 개념을 이해하고 있는 사람.
- 해시 충돌이 발생했을 때 자바에서 어떤 방식으로 문제를 해결하는지 이해하고 있는 사람.
- 자바 8 버전 이전과 이후 `HashMap`의 최적화된 충돌 해결 방식의 차이에 대해서 이해하고 있는 사람.
- `hashcode()`와 메서드의 관계와 해시자료 구조와의 연관성을 이해하고 있는 사람. 


그럼 지금부터 해시 자료구조에 대해서 차근차근 알아가보자.

<br>
---

## 🛄 **물품 보관소**


![Desktop View](/assets/posts/datastructure/hash/hash-example.png){: width="972" height="589" .w-80}_물품보관소_

물품을 대신 보관해주는 물폼보관소를 통해 해시 자료구조의 전체적인 구성을 이해해보자.    
이 물품보관소는 다음과 같은 단계로 물품을 보관하고, 다시 돌려준다. 
#### 🧳 보관 시
1. 손님이 "물품의 이름"과 "물품"을 직원에게 전달한다.
2. 직원은 "위치분배기"에 "물품의 이름"을 입력하고, 물품을 보관할 "창고 위치"를 반환받는다. 
	- "**위치분배기**"는 맡기는 "**물품의 이름**"을 넣어주기만 하면 보관해야할 "**창고 위치**"를 알려준다.
3. 직원은 반환받은 "창고 위치"에 "물품"을 보관한다.

#### 🔍 찾을 시
1. 손님이 찾을 "물품의 이름" 을 직원에게 전달한다.
2. 직원은 "위치분배기"에 "물품의 이름"을 입력하고, 물품이 보관된 "창고 위치"를 반환받는다. 
3. 직원은 반환받은 "창고 위치"에서 "물품"을 꺼내 손님에게 전달한다.

현실 세계에서의 물품보관소와 비슷한 원리로 운영되는 것 같지만, 하나 눈에 거슬리는 존재가 있다. 만일 "**위치분배기**"가 눈에 거슬렸다면, 여러분은 핵심을 잘 파악하는 센스가 좋은 편이다. 이 친구를 잘 기억해두자. 

## **해싱과 용어**

해싱(Hashing)이란 **임의의 크기**를 가진 데이터를 **고정된 크기의 데이터로 변환**하는 과정을 말한다.  

해시 자료구조에서는 **해싱 과정**을 통해서 값을 **저장**하고, **조회**한다.  
이때, **저장하고자 하는 값**을 `value`라 부르고, `value`를 **구분**할 수 있는 **고유한 값**을 `key`라고 정의한다.
- 앞의 예시에서 "물품의 이름"은 `key`에 해당되고,  "물품" 은 `value`에 대응된다.


이때 입력받은 `key`를 고정길이의 "**해시값**"으로 **변환**해주는 함수(알고리즘)을 **해시 함수**라고 부른다.  
"해시값"이란, 해시 함수의 출력값으로 **원본 데이터를 대표하는 고정길이의 값**을 의미한다.

이 **해시값을 인덱스 값**으로 이용해서 데이터를 저장하는 구조를 **해시 테이블**이라고 한다.
`key`를 해싱하여 나온 고정된 크기의 해시값을 인덱스로 `value`의 저장위치를 결정한다.

그리고 실제 `value`가 저장되는 공간을 **버킷(Bucket)** 이라고 부른다.

## **해시 함수**

해시함수는 **키**를 입력으로 받아 **고정 크기의 해시값**으로 **변환**해주는 알고리즘을 말한다.

해시함수는 단순히 변환하는 역할을 하는 함수지만 구현 정도에 따라 함수의 좋고 나쁨이 결정된다. 이는 해시 자료구조의 성능을 결정한다.

좋은 해시 함수의 조건은 다음과 같다.

1. 키 값을 고르게 분포시켜야 하고,
2. 해시값 변환 계산이 빨라야 한다.
3. 그리고 해시 충돌 가능성을 최소화 해야한다.

### 1. 고르지 않은 키 값 분포

공간이 효율적으로 사용되지 못해 최악의 경우 해시 자료구조의 이점을 제대로 누릴 수 없다.
이는 해시 충돌문제로 이어지는데 이는 뒤에서 추가로 다룬다.

### 2. 느린 해시값 변환 계산

해시 자료구조의 가장 큰 장점은 `key`를 알고 있을 경우, O(1)의 시간복잡도로 원하는 데이터를 조회할 수 있다는 것이다. 

너무 당연하겠지만, 만약 해시값으로 변환하는 계산 자체가 느리다면 해시자료구조의 빠른 조회성능의 이점을 누릴 수 없다.

### 3. 높은 해시 충돌 가능성

이 조건을 이해하기 위해서는 "해시 충돌"이라는 개념에 대해서 이해가 필요하다. 때문에 해시 충돌에 대한 개념과 이를 해결하는 방법들을 먼저 살펴본 뒤 다시 언급하려한다. 

짧게 결론부터 말하자면 해시 충돌 가능성이 높아질수록 해시 테이블의 성능이 저하될 수 밖에 없기 때문이다.

## **해시 충돌**

해시충돌이란 서로 다른 입력값에 대해서 동일한 해시값이 출력되는 상황이다.
즉, 해시 테이블에서 서로 다른 데이터가 같은 버킷에 할당하게 되는 경우를 말한다.

왜 이런일이 발생할까? 해시함수가 고장나거나 잘못된 것이 아닐까?


![Desktop View](/assets/posts/datastructure/hash/collision.png){: width="972" height="589"}_해시 충돌_

발생원인은 "고정 크기의 출력값"에 있다.
해시 충돌은 해시 테이블의 크기가 유한하기 때문에 발생하는 문제이다.

입력 값의 범위 자체가 해시 테이블의 크기보다 항상 크기 때문에 **필연적**으로 발생할 수 밖에 없다.
100개의 공을 10개의 서로 다른 공간에 겹치지 않게 넣을 수 있다면(?) 해시충돌을 피할 수 있지만 현실적으로 불가능하다.

이러한 확률이나 충돌 현상을 이해하는데 도움을 주는 원리나 증명들로 설명되는 편이니 가볍게 읽어보는 것도 좋을 것 같아 대표적인 내용들을 가져왔다.
- [비둘기 집 원리](https://namu.wiki/w/%EB%B9%84%EB%91%98%EA%B8%B0%20%EC%A7%91%EC%9D%98%20%EC%9B%90%EB%A6%AC)
- [생일 문제](https://namu.wiki/w/%EC%83%9D%EC%9D%BC%20%EB%AC%B8%EC%A0%9C)


## **해시 충돌 해결**

해시 충돌이 발생한 경우 동일한 해시 값을 갖는 데이터를 저장하기 위한 방법을 해시 충돌 해결방법이라 한다.
해시 충돌을 해결할 수 있는 방법은 크게 2가지가 존재한다.

### 1. 체이닝

해시 충돌이 발생한 버킷에 충돌난 데이터들을 서로 연결하는 방식으로 데이터를 저장하는 방법이다.
충돌이 발생한 데이터를 같은 버킷안에 연결 리스트 형태로 구현되어 데이터를 저장한다.
실제 Java의 HashMap에서는 이 방식을 통해서 해시 충돌을 해결한다.

![Desktop View](/assets/posts/datastructure/hash/chaining.png){: width="972" height="589"}_체이닝 예시_

이렇게 되면, 해시 충돌이 발생하더라도, 동일 버킷에 데이터를 연결시켜 저장할 수 있다.

하지만 이런 체이닝 방식도 해시 충돌이 많이 일어날 경우 완벽한 해답이 될수 없다. 그 이유는 다른 충돌해결방식인 "개방주소법"을 다룬 뒤에 다루겠다.

### 2. 개방 주소법

해시 충돌이 발생한 버킷이 아닌 다른 빈 버킷을 탐색해 충돌난 데이터를 저장하는 방법이다. 
이 방법은 동일한 해시 테이블 내에서 데이터를 저장하기 때문에 체이닝 방식처럼 추가적인 데이터 구조가 필요하지는 않음. 

개방 주소법은 어떻게 빈 버킷을 탐색할지 결정하는 탐색 기법에 따라 나뉜다. 

#### 2.1 선형 탐사

충돌이 발생하면, 충돌이 발생한 버킷의 인덱스로부터, 고정된 간격 `n` 만큼 다음 버킷을 순차적으로 확인하면서 빈 버킷을 찾는 방식이다. 

#### 2.1 제곱 탐사

이름에서도 알 수 있듯이 충돌 발생 시, 충돌이 발생한 버킷의 인덱스로부터 제곱된 간격으로 빈 버킷을 찾는 방식이다. 

제곱된 간격으로 빈 버킷을 탐색하기 때문에, 최초 충돌 이후 선형 탐사법에 비해서는 더 넓게 분산되는 특징을 가지고 있다. 때문에 제곱 탐사는 앞서 선형 탐사에서 발생한 클러스터링 문제를 어느정도 완화시켜줄 수 있는 방법이다.

하지만 제곱 탐사 역시, 충돌 시 빈 버킷을 탐색하는 패턴은 동일하므로, 여전히 클러스터링 문제가 발생한다.

#### 2.1 이중 해싱 탐사

이 클러스터링 문제를 보다 완화하기 위해 충돌 발생 시 새로운 위치를 구하는 해시 함수를 하나 더 사용하는 방식이 이중 해싱 탐사 방법이다. 

첫번째 해시함수로는 초기 위치를 구하고, 두번째 해시함수는 충돌 발생 시 이동 간격을 결정해주는 방식으로 고르게 분포시키도록 설계되었다. 

다만 두개의 해시 함수를 사용하기 때문에, 계산 비용이 앞선 탐사 방법들보다는 높을 수 밖에 없다. 


앞서 설명한 개방 주소법 방법은 빈 버킷을 찾기 위해서 탐색을 하는 동작원리로 해시 테이블에 데이터가 저장된 적재율이 높아질수록 빈 버킷을 찾기 위해 더 많은 탐색이 필요해져 성능이 저하되는 특성이 있다. 

때문에 적절한 적재율을 유지하면서, 테이블의 크기를 조절해야 하는 관리가 추가로 필요할 수 있다.

### 좋은 해시 함수의 조건: 많은 해시 충돌 발생 시

이제 앞에서 이야기 했었던 좋은 해시함수의 조건 중 "해시 충돌을 최소화해야 한다"에 대해서 다시 이야기를 해보려고 한다. 

이제 해시 충돌이 무엇인지, 충돌을 해결하기 위한 방법들에는 어떤 방법들이 존재하는지 알아보았다.  

> 해시 충돌을 왜 최소화해야만 하나요?   
> 해시 충돌이 발생하면, 앞선 방법들로 해결되는 것 아닌가요?

결론적으로 **해시테이블의 성능이 저하**되기 때문에 **최소화**를 해야만 한다.   
왜냐하면 충돌 해결방법을 사용한다고 해서, **근본적인 문제**가 사라지는 것이 아니기 때문이다.   

이는 앞서 살펴본 두 해시 충돌 방식 모두에게 해당되는 내용이다. 

앞서 "체이닝 방식"과 "개방 주소법"에서 해시 충돌이 많이 발생하는 경우를 시뮬레이션하면서 왜 그런지 살펴보자. 

#### 체이닝 방식 
해시 함수를 통해서 O(1)의 시간복잡도로 원하는 데이터를 조회할 수 있더라도, 동일한 해시 인덱스 주소에 여러 버킷이 연결된 상태로 있다면, 버킷들을 **순차적으로 탐색하면서 검색**해야하므로 연결 버킷이 길어질수록 성능도 좋지 않음. 

결국 충돌이 발생하게 될 경우 동일한 버킷의 데이터를 처리하고자 추가 처리를 해주어야함.
때문에 삽입과, 조회 시 모두 **성능 하락이 발생**하게 된다.

#### 개방 주소법 (선형 탐사)
이는 굉장히 간단한 방식의 탐사방법이지만, 버킷이 연속적으로 차있는 경우에는 다음 빈 버킷을 찾기까지 오랜 시간이 소요될 수 있다. 

또한 데이터들이 **특정 위치에 몰리게 되는 현상**을 클러스터링(clustering)이라 하는데 선형 탐사 방식의 경우 고정된 간격만큼 이동하며 다음 빈 버킷을 찾는 방식이기 때문에, 동일한 해시값을 가지는 데이터들이 근방에 몰려 클러스터링이 발생하기 쉽다.

클러스터링이 발생할 경우, 이후 삽입되는 값들 중 클러스터링 범위 안에 있는 해시값을 갖는 값들은 이 클러스터링 영역 끝부분에 추가되는 꼴이 된다. 
- 클러스터링이 커질수록, 삽입, 조회 성능 모두 저하된다. 
- 새로운 충돌이 발생할 가능성이 높아짐.

#### 결론 

앞선 방식들로 인해 
때문에 근본적으로는 해시함수 자체에서 충돌을 발생하지 않도록하고,  
발생하더라도 최소화하는 하는것이 중요하다. 

## **Java, HashMap의 해시 충돌 해결**

Java의 Map 자료구조의 구현체인 `HashMap` 은 해시 충돌을 해결하기 위한 기본 전략으로 **체이닝 방식**을 사용한다. 

Java 8 버전부터는 `HashMap`은 **해시 충돌이 많이 발생할 경우** 성능 개선을 위해, **체이닝 방식의 링크드 리스트**구조에서 **레드-블랙 트리**로 **변환**한다.

`HashMap`이 어떻게 해시 충돌을 해결하는지 보기 위해 데이터의 삽입과정과 해시 충돌 발생 시 충돌 해결 과정을 살펴본다.

### 동작 원리

다음과 같은 시나리오로 `HashMap`의 동작 순서를 따라가보자.

1. 첫 번째 데이터 삽입 
2. 두 번째 데이터 삽입 & 해시 충돌 발생 


> ⚠️ 물론 2번의 데이터를 삽입한다고 해서 바로 해시충돌이 발생하지는 않는다.   
> 다만, 동작원리의 설명을 위해 두번째 데이터 삽입시 해시 충돌이 발생한다고 가정한다.



**1. 첫 번째 데이터 삽입**

![Desktop View](/assets/posts/datastructure/hash/put-first-data.png){: width="972" height="589" .w-75}_데이터 삽입 시 메서드 호출과정_

`HashMap` 에 `put()` 을 통해 데이터를 삽입하면 내부적으로 `putVal()` 메서드를 호출하는 데 이때 외부에서 받은 `key` 값을 내부 `hash()` 함수를 통해 해시 값으로 변환해서 `putVal()` 의 인자로 넘겨주도록 설계되어 있다.

위 문장에서 무엇인가 익숙한 느낌이 들었다면 해시 자료구조의 핵심에 대한 이해에 한걸음 더 가까워졌다는 의미다. 앞서 우리는 "키를 입력으로 받아 **고정 크기의 해시값**으로 **반환해주는 알고리즘**"에 대해서 접했다.

바로 `hash()`함수가 `HashMap`의 **해시함수**이다. 

`HashMap` 내부의 `hash()` 함수는 다음과 같이 구현되어 있다. 
```java
static final int hash(Object key) { 
    int h; 
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16); 
}
```

입력으로 주어진 `key` 가 `null`이 아닌 경우에는 `key.hashCode()`를 호출해서 키 객체의 해시 값을 계산한다. 그리고 이 값을 [논리적 우측 시프트](https://ko.wikipedia.org/wiki/%EB%85%BC%EB%A6%AC_%EC%8B%9C%ED%94%84%ED%8A%B8) 를 통해 이동시킨 값과 XOR(`^`) 연산한 값을 반환한다. 

기본적으로 객체의 `hashCode()`를 통해 특정 규칙에 따라 값을 반환받는다. 하지만 이 값이 단순히 배열 인덱스에 매핑되면 충돌이 발생할 가능성이 높기 때문에 상위 비트와 하위 비트를 섞어 더 고르게 분산된 해시값을 반환하도록 설계되어 있는 것을 확인할 수 있다. 

**2. 두 번째 데이터 삽입 & 해시 충돌 발생!**

`HashMap`은 해시 충돌 해결방법 중 **체이닝 방식**을 기본으로 사용한다. 
해시 충돌이 발생했을 경우 동일한 해시 값의 주소의 버킷에 연결 리스트 형태의 자료구조로 저장이 된다.

그림으로 보자면 다음과 같은 구조로 표현해볼 수 있다. 

![Desktop View](/assets/posts/datastructure/hash/collision-resolution.png){: width="972" height="589"}_충돌 해결 과정: 체이닝 방식_

위 그림에서 표현한 실제 데이터의 삽입과정을 `putVal()` 메서드에서 담당한다.   
`putVal()` 메서드의 흐름을 요약해보면 다음과 같다. 

1. 테이블 초기화: `table`이 초기화되지 않은 경우 `resize()`를 호출하여 테이블을 초기화.
2. 버킷 확인: 계산된 인덱스(i)의 버킷이 비어 있으면 새 노드를 생성하여 저장.
3. **충돌 처리**:
    - **동일한 해시 값**과 **키**를 가진 노드가 이미 존재하면 해당 노드를 참조.
    - TreeNode인 경우 트리 구조에 삽입 또는 업데이트.
    - **연결 리스트**인 경우 끝까지 순회하며 새 노드를 추가하거나 기존 노드를 참조.
    
4. 트리화 조건: 연결 리스트의 길이가 `TREEIFY_THRESHOLD` 이상이면 레드-블랙 트리로 변환.
5. 값 업데이트: 기존 매핑이 있으면 조건에 따라 값을 업데이트하고 이전 값을 반환.

<br>

다음은 `putVal()`메서드의 소스코드를 동작 부분에 따라 요약 재구성한 코드이다. 이해를 돕기 위해 실제 소스코드의 일부분을 생략하거나, 변환했다. 

```java
final V putVal(int hash, K key, V value, boolean onlyIfAbsent,  
               boolean evict) {  
    Node<K,V>[] tab; Node<K,V> p; int n, i;  
    
    if (테이블이 초기화되지 않았거나, 크기가 0일 경우)  
        // 1. 테이블 초기화 & 크기 설정 로직
    if (해시 테이블 인덱스에 해당하는 버킷이 비어있다면)  
	    // 2. 노드 생성 후 해당 버킷에 저장
        tab[i] = newNode(hash, key, value, null);  
    else {
        // 3. 충돌 처리
        if (만일 첫번째 노드가 key와 동일할 경우)  
            // 업데이트 준비
            e = p;  
        else if (p instanceof TreeNode)  
	        // 레드-블랙 트리의 노드인 경우, 삽입 & 업데이트 처리
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);  
        else {  
	        // 연결 리스트인 경우 순회하면서 끝으로 도달.
            for (int binCount = 0; ; ++binCount) {  
	            // 연결 리스트의 끝에 도달한 경우 새 노드를 생성하여 연결 리스트의 마지막에 추가
                if ((e = p.next) == null) {  
                    p.next = newNode(hash, key, value, null);  

                    // 4. 연결 리스트의 노드 수가 TREEIFY_THRESHOLD(기본값: 8)에 도달하면, 
                    // 연결 리스트를 레드-블랙 트리로 변환
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st  
                        treeifyBin(tab, hash);  
                    break;  
                }  
                if (e.hash == hash &&  
                    ((k = e.key) == key || (key != null && key.equals(k))))  
                    break;  
                p = e;  
            }  
        }  
        // 5. 동일한 key에 대해 value 업데이트 작업 
	    ...
        }  
    }  
    ...
}
```

HashMap에서 각 노드는 아래와 같은 구조를 가짐.  
충돌이 발생하면 새 데이터는 기존 노드의 `next` 포인터를 통해 연결되는 방식으로 구현되어 있는 것을 확인할 수 있다. 

```java
static class Node<K,V> implements Map.Entry<K,V> {  
    final int hash;  
    final K key;  
    V value;  
    Node<K,V> next;  
  
    Node(int hash, K key, V value, Node<K,V> next) {  
        this.hash = hash;  
        this.key = key;  
        this.value = value;  
        this.next = next;  
    }
    ...
}
```




### 변환 조건
`HashMap` 은 다음과 같은 조건들을 만족해야 Red-Black Tree로 변환한다.

레드-블랙 트리(Red-Black Tree)는 **자가 균형 이진 탐색 트리**의 한 종류로, 삽입, 삭제, 검색 연산에서 최악의 경우에도 O(log⁡n)의 시간 복잡도를 보장하는 효율적인 자료구조를 말한다.   

> 레드-블랙 트리(Red-Black Tree)에 대한 내용은 본 글의 범위를 벗어나므로 추후 별도의 설명 글로 링크를 달아두려 한다. 지금은 연결리스트보다는 효율이 좋은 자료구조로 이해해도 괜찮다.

- 한 버킷의 노드 수가 `TREEIFY_THRESHOLD` (8)를 초과할 때 발생한다.
- 단, 전체 버킷 수가 `MIN_TREEIFY_CAPACITY` (64) 이상이어야 한다. 
  그렇지 않으면 대신 배열 크기를 늘리는 리사이즈 작업이 수행된다.

위 조건들은 다음 `putVal()`, `treeifyBin()` 메서드에서 확인해볼 수 있다.

`putVal()` 메소드에 첫번째 변환 조건이 기술되어 있다.
```java
// 연결 리스트의 노드 수가 TREEIFY_THRESHOLD(기본값: 8)에 도달하면, 
// 연결 리스트를 레드-블랙 트리로 변환
if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st  
	treeifyBin(tab, hash);  
break;  
```

변환을 위한 핵심 내용은 `treeifyBin`에서 담당한다. 

> "주어진 해시에 해당하는 인덱스(bin)에서 연결된 모든 노드를 교체합니다. 단, 테이블 크기가 너무 작을 경우에는 이 작업 대신 테이블 크기를 확장(resize)합니다."

```java
final void treeifyBin(Node<K,V>[] tab, int hash) {  
    int n, index; Node<K,V> e;  

    // 전체 버킷 수가 `MIN_TREEIFY_CAPACITY` (64) 이하면 resize()
    if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY)  
        resize();
    else if () {
    // 변환 로직
    }
    ...
}
```

레드-블랙 트리로 변환하여 최악의 경우 시간 복잡도를 O(n)에서 O(log⁡n)으로 줄일 수 있다. 이는 많은 데이터가 동일한 버킷에 저장되는 경우에도 높은 성능을 유지할 수 있도록 보장한다.

따라서 Java 8 이후 HashMap은 일반적인 경우 평균 시간 복잡도가 O(1)인 빠른 데이터 접근을 제공하며, 충돌 상황에서도 효율적인 성능을 유지할 수 있다. 

## 마무리

지금까지 해시 자료구조에 대해서 알아보았다. 다루었던 내용들을 복기하면서 정리해보자.

글을 시작하며 해시 자료구조를 간단한 물품보관소에 비유하여, 해시 자료구조의 전체적인 구조에 대해서 알아보았다. 해시 자료구조에서 사용하는 용어들에 대해서도 알아보았다. 
- `key`와 `value`
- 해시값으로 변환해주는 해시함수 
- 해시값을 인덱스로 하는 해시 테이블 
- 실제 값이 저장되는 버킷

해시 자료구조의 핵심인 해싱과 고정길이의 "해시값"으로 변환해주는 함수인 해시 함수에 대해서도 알아보았다. 그리고 좋은 해시함수의 조건은 무엇인지에 대해서도 간략하게 다루었다. 

해시 자료구조에서 필연적으로 발생할 수 밖에 없는 **해시 충돌**의 개념과, 이를 해결하는 큰 두가지 방식, **체이닝 방법**과 **개방주소법 방법**에 대해서도 알아보았다. 추가로 개방주소법에서 발생할 수 있는 클러스터링의 개념과 이를 완화하기 위한 추가적인 탐색방법들에 대해서도 알아보았다.

뿐만 아니라 많은 해시 충돌이 발생했을 시 나타나는 문제점들을 통해 해시함수의 중요성을 다시 한번 확인했다.

추가로 Java의 해시자료구조인 HashMap이 어떻게 해시 충돌을 해결하는지 그 방법과 동작원리를 코드를 통해 알아보았다. Java 8 버전 이후 연결리스트에서 레드블랙트리로 변환되는 내용을 통해 어떻게 충돌 상황에서도 효율적인 성능을 유지할 수 있는지 정리해보았다. 

이러한 내용들을 바탕으로, HashMap을 보다 효율적으로 활용하고, 나아가 해시 기반 자료구조를 사용할 때 발생할 수 있는 문제를 예측하고 적절히 대처할 수 있기를 바란다.

