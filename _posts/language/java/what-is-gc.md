---
title: 
author: codongmin
date: 
categories: 
tags: 
preview:
---

## 들어가며

gc란 무엇인지? 

대상 독자 설정

## 배경 설명 - 오징어 게임에 비유



## GC란? 

### 개념과 역할
gc의 개념, 역할, 

### 메모리 관리 - 기본 개념
- 메모리 관리의 개념
    - 힙 메모리와 스택 메모리
    - 객체의 생명주기와 메모리 할당

### GC 등장 배경 

메모리 관리의 자동화 기존에는 하나씩 설정해주어야 했음. 

핵심 가설 
. Generational GC는 객체의 생존 기간에 따라 힙 메모리를 **Young Generation**과 **Old Generation**으로 나누고, 각각의 특성에 맞는 방식으로 가비지를 수집합니다. Serial GC도 이러한 세대 개념을 따르며, Young Generation과 Old Generation을 별도로 관리합니다.

## GC 기본 원리 

### GC의 종류
**1. Minor GC (Young Generation에서 발생)**
- Minor GC는 **Young Generation**에서 발생하며, 짧은 생명주기를 가진 객체를 정리하는 데 초점을 둡니다.
- Young Generation은 **Eden 영역**과 두 개의 **Survivor 영역(S0, S1)**으로 구성됩니다.
- 대부분의 객체는 Young Generation에서 생성되며, 금방 소멸합니다(Weak Generational Hypothesis).

1. **객체 생성**:
    - 새롭게 생성된 객체는 Eden 영역에 저장됩니다.
2. **Eden 영역 가득 참**:
    - Eden 영역이 가득 차면 Minor GC가 발생합니다.
3. **Mark 단계**:
    - Eden 영역의 객체 중 참조 가능한 객체를 식별(Mark)합니다.
4. **Sweep 단계**:
    - 참조되지 않는(Unreachable) 객체를 제거(Sweep)하여 메모리를 회수합니다.
5. **Survivor 영역으로 이동**:
    - 살아남은 객체는 Survivor 영역(S0 또는 S1)으로 이동합니다.
6. **Survivor 영역 간 이동**:
    - 여러 번의 Minor GC를 거쳐 Survivor 영역에 남아있는 객체는 Old Generation으로 승격(Promotion)됩니다.
    - 승격 기준은 객체의 생존 횟수(Age)가 특정 임계값(Tenuring Threshold)에 도달했을 때입니다.

 **Major GC (Old Generation에서 발생)**
- Major GC는 Old Generation에서 발생하며, 장기적으로 살아남은 객체를 정리합니다.
- Old Generation은 Young Generation보다 크고, 긴 생명주기를 가진 객체가 저장됩니다.

1. **Old Generation 가득 참**:
    - Old Generation이 가득 차면 Major GC가 발생합니다.
2. **Mark 단계**:
    - Old Generation 전체를 검사하여 참조 가능한 객체를 식별(Mark)합니다.
3. **Sweep 단계**:
    - 참조되지 않는(Unreachable) 객체를 제거(Sweep)하여 메모리를 회수합니다.
4. **Compact 단계 (선택적)**:
    - 메모리 단편화를 방지하기 위해 살아남은 객체를 한쪽으로 이동시켜 연속된 공간을 확보합니다.


### GC 핵심 단계 

Mark 
회수 대상 판단 -> 표시
- 모든 GC는 "객체가 참조 가능한지 여부"를 기준으로 가비지를 판단.
- 참조 카운팅 
- 그래프 탐색방식으로 도달 가능성 평가


Sweep

Compact





## GC 알고리즘.

주요 알고리즘 

|                                 |                              |                                                                                                                                                                                                                |
| ------------------------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Serial GC**                   | Mark-Sweep-Compact           | 단일 스레드 기반, 간단한 구조로 소규모 애플리케이션에 적합[<br><br>1<br><br>](https://sihyung92.oopy.io/java/garbage-collect/1).                                                                                                        |
| **Parallel GC**                 | Mark-Sweep-Compact           | 멀티스레드를 활용하여 처리량(Throughput)을 높임[<br><br>1<br><br>](https://sihyung92.oopy.io/java/garbage-collect/1).                                                                                                          |
| **CMS (Concurrent Mark-Sweep)** | Mark-Sweep                   | STW 시간을 줄이기 위해 일부 작업을 병행 수행, 단편화 문제 발생 가능[<br><br>1<br><br>](https://sihyung92.oopy.io/java/garbage-collect/1)[<br><br>4<br><br>](https://f-lab.kr/insight/understanding-java-gc-and-optimization-strategies). |
| **G1 GC**                       | Region 기반 Mark-Sweep-Compact | Region 단위로 힙을 관리하며, 짧은 STW 시간과 예측 가능한 지연 시간 제공[<br><br>2<br><br>](https://blog.metafor.kr/163)[<br><br>4<br><br>](https://f-lab.kr/insight/understanding-java-gc-and-optimization-strategies).                 |
| **ZGC**                         | Concurrent Mark-Sweep        | 대부분의 작업을 병행 수행하며 STW 시간을 10ms 이하로 유지, 대규모 힙에 적합[<br><br>4<br><br>](https://f-lab.kr/insight/understanding-java-gc-and-optimization-strategies).                                                                |
| **Shenandoah GC**               | Concurrent Compact           | G1과 유사하지만 더 짧은 지연 시간 제공, Compact 단계도 병행 수행[<br><br>4<br><br>](https://f-lab.kr/insight/understanding-java-gc-and-optimization-strategies).                                                                     |


## 마무리
