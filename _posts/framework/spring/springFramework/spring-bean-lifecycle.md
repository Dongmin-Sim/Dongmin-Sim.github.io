---
title: Bean의 생성 과정
author: codongmin
date: 
categories: 
tags: 
image:
  path: /assets/img/thumbnail/.png
  lqip: 
  alt: 이미지 설명
---

## 들어가며

## Header

스프링이 빈을 생성하는 과정을 단계별로 설명하겠습니다. 이 과정에서 final 필드에 값을 주입할 수 없는 이유를 생성 과정 중에 설명하겠습니다.

1. **빈의 정의 찾기:** 스프링은 빈을 생성하기 위해 빈 정의를 찾습니다. 빈 정의는 XML 파일, 자바 설정 클래스, 어노테이션 등을 통해 설정될 수 있습니다.
    
2. **빈의 생성:** 스프링은 빈의 클래스를 로드하고, 빈의 인스턴스를 생성합니다. 이 과정에서는 빈의 클래스를 JVM의 메모리에 로드하고, 해당 클래스의 객체를 생성합니다.
    
3. **의존성 주입:** 빈의 생성 후에는 의존성 주입이 이루어집니다. 이 과정에서 스프링은 빈의 의존성을 주입하기 위해 필드 주입(Field Injection), 생성자 주입(Constructor Injection), 세터 주입(Setter Injection) 등의 방법을 사용합니다.
    
4. **빈 초기화:** 의존성 주입이 완료되면 빈의 초기화 메서드가 호출됩니다. 초기화 메서드는 `@PostConstruct` 어노테이션이나 `init-method` 속성을 통해 지정할 수 있습니다. 이 단계에서는 빈이 필요한 초기화 작업을 수행합니다.
    
5. **빈의 등록:** 모든 초기화 작업이 완료된 후에는 스프링 컨테이너에 빈이 등록됩니다. 이제 빈은 스프링 애플리케이션 내에서 사용될 수 있습니다.
    

스프링이 빈을 생성하는 과정 중에 final 필드에 값을 주입할 수 없는 이유는 주로 빈의 생성과 의존성 주입 단계에서 발생합니다. final 필드는 한 번 초기화되면 그 이후에는 값을 변경할 수 없기 때문에, 스프링이 빈을 생성하는 동안에는 final 필드에 값을 주입할 수 없습니다. 스프링은 객체를 생성하고 의존성을 주입하는 과정에서 객체의 상태를 변경할 수 있어야 하기 때문에 final 필드에 값을 주입하는 것이 불가능합니다. 따라서 스프링에서는 주로 생성자 주입(Constructor Injection)이나 세터 주입(Setter Injection)을 사용하여 의존성을 주입합니다.

## 마무리
