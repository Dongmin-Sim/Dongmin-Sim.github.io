---
title: TDD에 대하여
author: codongmin
date: 2024-06-01T13:49:00
categories: 
tags: 
image:
  path: /assets/img/thumbnail/.png
  lqip: 
  alt: 이미지 설명
---

## 들어가며

오늘은 개발 방법론 중 하나인 TDD에 대한 개념을 알아보려고 한다. 처음 이 개념을 접했을때는 사실 아리송했다. 테스트가 주도하는 개발..? 보통은 기능 구현과 그 다음에 따라오는 부가적인 요소인 테스트의 순서가 자연스럽지 않나? 라고 생각했었다. 

하지만 TDD에서는 테스트가 기능의 구현보다 테스트가 중심이 되는데, 알고있던 개념에서 역전된 새로운 방식이 만들어내는 가치를 접하고 점점 매료되고 있는 것 같다. 무엇보다 내 성격이랑 조금 맞는 부분이 있다고 생각됐다. 나는 주로 어떠한 의사결정을 내리는데 있어 가능한 모든 위험성을 명확하게 하려고 하는 성격이 있는데, 이런 성향이 TDD 방법론과 약간 비슷한 성향? 이 있는 것 같다. 무언가 결정을 내릴때, 최대한 작게 쪼개고, 하나씩 하나씩 해결해나가는 방법이 얼추 비슷하다고 느꼈다. 기준점이 되어주는 무언가가 있다는 것이 나를 안심시킨다. 때문에 TDD에 대해서 깊이 이해해보고 싶다고 느꼈다. 하지만 아직도 사실 명확하게 체득하지는 못했다. 

그래서 본 글에서는 TDD에 대해서 간략하게 알아보려고 한다. 
글은 TDD에 대해서 처음 접해보았거나, 관심이 있는 사람을 대상으로 작성하였다. 


## TDD (Test-Driven-Development)

전통적인 개발은 다음과 같이 이루어졌다. 

1. 설계하고
2. 구현하고
3. 테스트하고

테스트는 TDD 이전에도 존재했지만, 주로 설계와 구현쪽에 더 관심도가 높았다. 왜냐하면 테스트를 한다는 것은 말그래도 무언가 "테스트할 것"이 있어야 테스트를 할 수 있다는 굉장히 당연하고 자연스러운 생각 때문이지 않았을까 싶다. 

사실 실체가 없는 무언가를 테스트 한다는 것은 본능적으로 반감이 드는 행동같기도 하다. 그런데 TDD는 테스트할 무언가의 구현보다 테스트부터 시작한다.

## TDD 흐름 


[iteration]
Test - Implement - Refactor - Test  - Implement - Refactor ...

Tdd는 구현하고자 하는 기능을 검증하는 테스트를 먼저 작성한다. 
그리고 해당 테스트를 통과할정도로만 기능을 구현시킨다. 더도 말고 딱 테스트를 통과할 정도면 된다. 
테스트를 통과했다면, 구현 코드를 정리한다. 

레드(Red) - 그린(Green) - 리팩터(Refactor)

### 특징

#### 테스트 주도



#### 지속적인 유지보수 가능

리팩토링 단계에서의 테스트 코드는 일종의 Save 기능역할
맘에 들지 않는다면 테스트 코드를 통해 언제든지 기능이 동작하던 때로 돌아가는 것을 보장해줄 수 다.

#### 빠른 피드백

구현 코드 & 리팩토링 코드에 피드백이 빠르다. 이미 작성된 테스트를 돌리기만하면 되기 때문에 구현 코드 & 리팩토링 코드가 안정적으로 검증되었음을 빠르게 확인할 수 있다.

https://okky.kr/articles/476113

## 마무리

개인적으로는 TDD를 알아봤지만, 이에 연관된 궁금증들이 다발로 생긴 기분이었다. 테스트하기 좋은 코드란 무엇이지? 어떤 코드가 테스트하기 어려운 코드지 ? 단순히 테스트 도구들을 사용해서 테스팅을 하는 것만이 TDD라기보다, 전반적인 설계, 코