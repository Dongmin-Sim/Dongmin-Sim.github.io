---
title: JVM 구성과 동작 원리
author: codongmin
date: 2025-01-23T21:14:00
categories:
  - Java
  - JVM
tags:
  - JVM
description: JVM이 무엇인지, 구성요소와 동작원리를 설명합니다.
---

## 들어가며

WORA! Write Once, Run Anywhere. 1995년 썬 마이크로시스템즈에서 개발된 자바를 대표하는 슬로건이었다. "한번의 작성으로 어디서나 실행 가능"이라는 슬로건은 개발언어의 플랫폼 독립성을 확보했다는 의미에서 혁신으로 다가왔지 않을까 짐작해본다. 어떤 점이 그러했을까?

일반적으로 자바 이전의 언어들은 플랫폼에 종속적인 형태로만 개발이 가능했다. 여기서 말하는 **플랫폼 종속적**이라는 것은 특정 운영체제와 하드웨어의 아키텍쳐에 맞는 형태의 머신 코드로 변환되어야 함을 의미했다. 예를 들어 A라는 프로그램을 Window에서 컴파일 후 변환된 실행파일을 Linux에서 실행할 수 없었고, 반대로 Linux에서 개발하고 변환한 실행파일을 window에서 바로 실행하는 것은 불가능했다. 

설사 같은 OS라 하더라도 프로세서의 명령어 셋에 따라서도 각자 고유한 명령어 셋을 가지고 있었으므로, 컴파일러가 소스코드를 각각 칩 제소사의 명령어 셋에 맞게 변경해주지 않으면 같은 소스코드라해도 동작하지 않았다. 이처럼 동일한 소스코드를 각 OS와 하드웨어에 맞게 컴파일을 해주어야만 했기 때문에, 컴파일된 바이너리 파일들은 플랫폼에 종속적이게 될 수 밖에 없었다.


![Desktop View](/assets/posts/language/java/what-is-jvm/platform-dependency.png){: width="972" height="589"}_플랫폼 종속적 구조_

Java는 이러한 플랫폼 종속성을 JVM이라는 중간 매개체를 통해서 한번의 컴파일로 컴파일된 코드가 서로 다른 OS와 하드웨어에서도 실행될 수 있는 환경을 누릴 수 있게 되었다. 이러한 특성 덕분에 Java 뿐 아니라 JVM에서 이해할 수 있는 코드로 변환될 수만 있다면 어떤 언어라도 JVM을 활용하여 플랫폼 독립성이라는 장점을 얻어갈 수 있게 되었다. 덕분에 특정 플랫폼에 따라 코드를 수정하거나 여러번 컴파일일 할 필요가 사라졌고, 다양한 환경에 쉽게 배포할 수 있게 되었다. 

이 글에서는 이러한 특성을 활용할 수 있게 도와주는 JVM에 대해서 알아보려한다. 글에 대상 독자는 다음과 같다. 
- JVM의 기본 개념에 대해 알고 싶은 독자 
- JVM 구조와 주요 구성요소에 대해 이해하고 싶은 독자
- JVM 내의 주요 구성요소들의 동작 방식들에 대한 전반적인 이해를 높이고 싶은 독자.


## JVM 이란?

JVM이란 Java Virtual Machine의 앞글자를 딴 약자이다. 

기존 방식과의 차이 


## JVM의 구조와 구성요소 


전체 구조도를 가져오는 것이 이해가 쉬울 것 같아서 그려봤다. 이 그림을 목차 삼아 JVM의 구조와 구성요소들에 대해서 설명하고자 한다.

크게 3파트로 나누어볼 수 있다. 

JVM 구성요소 이해

###  JVM 메모리 구조 **runtime data area (위의 구성 요소들과 상호작용)**

- 스레드 공유 (모든 스레드에 공유되어 어느 곳에서나 접근 가능)
    - method area
	    - 처음 메모리 공간을 올릴때 초기화되는 대상들을 저장하기 위한 메모리 공간
        - **클래스의 메타 데이터**를 가지고 있는 영역, **상수 const** 변수들, **static**, 생성자, 메서드(바이트 코드) 등을 기본적으로 메모리에 로드되어있는 친구들 위치
        - 프로그램이 종료될때까지 메모리에 남아있음. 
	- Runtime Constant Pool(method area)
		- Method Area 영역에 포함되지만 독자적 중요성을 띔 
		- 클래스 파일 constant pool 테이블에 해당되는 영역
    - heap
        - 참조 값들,
- 스레드 각자
    - stack
    - pc
    - native method area?

Hotspot JVM
- Longview Technologies LLC라는 회사에서 1999년에 처음 발표한 JVM → SUN → Oracle
- 중요 기능으로 최신 버전의 JVM 들에 포함됨

https://deveric.tistory.com/123
https://inpa.tistory.com/entry/JAVA-%E2%98%95-JVM-%EB%82%B4%EB%B6%80-%EA%B5%AC%EC%A1%B0-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%98%81%EC%97%AD-%EC%8B%AC%ED%99%94%ED%8E%B8#%EB%9F%B0%ED%83%80%EC%9E%84_%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%98%81%EC%97%AD_runtime_data_area

### Java compiler
    
### gc
- heap 영역과 관련 

gc와 애플리케이션 응답 속도와 관련이 높음


### execute engine

- Runtime DA 에 배치된 바이트 코드를 실행하는 역할
- 바이트 코드를 machine language로 바꾸는 역할, 여기서 방식이 2가지로 나뉨
    - **Interpreter 방식**
    - **JIT 방식** : 인터프리터처럼 실행되지만, 자주 실행되는 섹션(바이트 코드)를 → 네이티브 코드(머신코드) 로 변환, 이를 캐시에 저장해 두고 사용.
        - 자주 실행되는 부분을 ‘hotspot’이라고 부름
        - 이 JIT 컴파일러 덕분에 full-compile과 비슷한 성능을 낼 수 있게 도와줌.
            - Tiered Compilation
                - C1 - Client Compiler
                    - JIT 컴파일러를 빠른 최초 시작을 위해 최적화하는 방법
                    - 주로 Start-Up Time(앱 초기 실행시간)이 중요한 애플리케이션에서 사용되어 왔음.ㄴ
                    - Java 8 이전에는 C1 Compiler를 사용하기 위해 `-client` 옵션을 사용했어야만 했음. (이후 버전부터 X)
                - C2 - Server Compiler
                    - 전반적인 성능 향상이 있는 JIT 컴파일러 최적화 방법
                    - C1 보다 코드를 분석하는데 더 많은 시간을 소요, 대신 컴파일 코드 최적화가 더 잘된다.
                    - Java 8 이전에는 C2 Compiler를 사용하기 위해 `-server` 옵션을 사용했어야만 했음. (이후 버전부터 X)
                    - Graal 컴파일러로 C2 대체 가능 (Java10부터 )
                        - Graal can run in both just-in-time and [ahead-of-time](https://www.baeldung.com/ahead-of-time-compilation) compilation modes to produce native code.
                        - AoT 방식 JIT 방식?
        - AOT , JIT
            - 실행 전에 미리컴파일 해둘거냐, 런타임에 실시간으로 할거냐의 차이
            - 둘 다 장단점이 존재

인터프리터 방식으로 실행되다가 메서드에 카운터가 존재.(카운터 2가지 존재) 이 카운더를 기준으로 많이 쓰이는 것을 컴파일 대상으로 지정, 컴파일 대상 큐에 넣고 , 컴파일 관련 스레드가 이를 모니터링하고 있다가 컴파일을 시작, 컴파일이 완료된 메서드는 불릴때마다 컴파일된 코드로 실행이되어서 빨라짐.

### class loader

- 자바 클래스들을 메모리로 로드하는 역할,
- Loading, Linking, initialization 기능을 담당한다.





## JVM 동작과정 

hello world 쳤을때ㅡ 

.java -> .class -> 클래스 로더가 로드, 링킹 -> 실행 
되는 과정일 듯



## 메모리 관리

GC 어떤전략 가지고 실행되는지 

엔진 어떤식으루

JIT(Just-In-Time) 컴파일러 설명

### Header3

## 마무리