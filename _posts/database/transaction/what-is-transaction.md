---
title: 트랜잭션이란?
author: codongmin
date: 2024-04-01T16:53:00
categories:
  - database
  - transaction
tags:
  - 데이터베이스
  - 트랜잭션
image:
  path: /assets/img/thumbnail/.png
  lqip: 
  alt: 이미지 설명
---

## 들어가며

데이터베이스나, 기타 애플리케이션을 개발할때 데이터의 영속성에 대한 행위(저장, 수정)에 대해 말할때 빠지지 않는 개념이 있다. 바로 트랜잭션(Transaction)이다. 매우 중요한 개념인 이 트랜잭션이란 대체 무엇일까? 문자그대로 번역하면 "거래"라는 뜻이지만 잘 와닿지는 않는다. 

데이터에서 사용되는 트랜잭션은 대체 어떤 맥락에서 사용되는 말일까? 그리고 이것이 왜 그렇게 중요한 것일까?

## 맥락
먼저 트랜잭션을 정의하는 것에서 시작하지 말고 트랜잭션이 요구되는 상황과 맥락에 대해서 이해를 하고 넘어가려고 한다. 

(계좌이체 상황 추가)

이 상황을 가만히 분석해보자.

이 작업들은 왜 동시에 수행되어야 할까? 그렇게 약속했기 때문이다. 이 약속이 보장되지 않는다면, 의미가 없어진다. 

이 작업들은 개념적으로 **특정 목적을 달성해야하기 위해** 동시에 수행해야 되어야한다.
하지만 실제로는(물리적으로) 그럴 수 없는 작업들이 (가) 대상이며,

여러 작업을 하나의 작업(원자성을 띄는)으로 만드는데(묶는데) 그 목적이 있다. 

묶는 기준은 행동이 위치한 상황 맥락에 따라 달라진다. 

그리고 이렇게 **"동일한 목적성을 위한 여러 작업들의 논리적인 묶음."** 을 **트랜잭션**이라고 지칭한다. 

## 트랜잭션이란

> 트랜잭션은 **"동일한 목적성을 가지는 여러 작업들의 논리적인 묶음."** 

이 묶음안에 있는 작업들을 1가지 동일한 목적성을 같기 때문에 이 목적을 달성하기 위한 하나의 단위라고 볼 수 있다.

그리고 이 묶음 단위라는 개념이 데이터의 영속성 관점으로 넘어오게 되면 데이터의 안정성을 보장하는 하나의 수단으로 유용하게 사용될 수 있다.

그리고 데이터의 안정성을 보장하기 위해 다음과 같은 특성을 보유해야만 비로소 데이터베이스에서의 트랜잭션의 의미가 생긴다. 

### 원자성
트랜잭션은 **"동일한 목적성을 가지는 여러 작업들의 논리적인 하나의 묶음"** 라고 했다. 때문에 트랜잭션 범위에 있는 작업들은 하나의 목적을 수행하기 위해 묶인 작업들이기 때문에, 이 작업들 중 일부만 작업을 완료했거나, 하나의 작업도 완료하지 못한 경우는 그 목적을 달성했다고 보기 어렵다. 

따라서 트랜잭션이 동일한 목적을 달성하기 위해서는 *묶인 모든 작업이 완료가 되어야한다.*  
일부만 완료한 경우도 전체 묶음 단위로 보았을때는 동일한 목적 달성하지 못했기 때문에 모두 실패한 것으로 간주해야한다. 

**"(동일한 목적성)을 위한 여러 작업들의 논리적인 묶음"** 이 모두 성공하거나, 모두 실패해야하는 2가지 상태만을 가져야한다. 


비지니스 관점에서의 트랜잭션의 정의는 **(비지니스 로직)을 보장하기 위한 여러 작업의 논리적인 묶음 단위**로 정의할 수 있을 것 같다. 

데이터의 안정성 관점에서의 트랜잭션의 정의는 **(데이터의 안정성)을 보장하기 위한 여러 작업의 논리적인 묶음 단위**로 정의할 수 있을 것 같다. 



## 이유


데이터의 영속성을 보장하는 방법은 여러가지다, 파일시스템에 파일로서 저장을 해도 된다. 그런데 보통 비지니스 애플리케이션을 개발하면 항상 같이 등장하는 시스템은 데이터베이스이다. DBMS를 사용하는 데는 많은 이유가 있지만, 

데이터의 안정성 관점에서 바라보자면 DBMS가 트랜잭션을 보장해주는 기능을 제공하기 때문이다. 
트랜잭션은 "데이터의 안정성을 보장하기 위한 여러 작업의 논리적 묶음 단위"이다. DBMS는 이 묶음 단위의 안정성을 보장하기 위해 어떤 기능들을 지원할까?

격리성이 가장 어렵다. 
순차대로 수행하면 되지만, 성능 상의 한계가 발생한다. 
이를 지키면서 성능까지 얻을 수 잇는 방법으로 고안된 것이. 동시성 + 격리 수준이다.


ANSI 표준은 다음과 같이 격리 수준을 나누어 정의했다. 

트랜잭션 격리 수준 isolation level
1. READ UNCOMMITED
2. READ COMMITED
3. REPEATABLE READ
4. SERIALIZABLE




## 마무리

트랜잭션은 "데이터의 안정성을 보장하기 위한 여러 작업의 논리적 묶음 단위"이다. 