---
layout: post
# published: false = 미발행 / true = 발행
published: true
title: 글쓰기와 코드, 그 사이 어딘가
date: 2026-03-15
tags:
  - 에세이
  - 개발
---
좋은 글과 좋은 코드는 닮은 점이 많다. 둘 다 명확함을 추구하고, 불필요한 것을 덜어내는 과정을 거친다. 군더더기 없는 문장이 읽는 이에게 편안함을 주듯, 잘 정리된 코드는 읽는 개발자에게 같은 종류의 안도감을 준다.

## 문장을 다듬듯 코드를 다듬는다

When I write prose, I revise obsessively. A sentence that felt right at midnight looks bloated by morning. The same instinct applies to code — that clever one-liner often deserves to be three clear lines instead.

글을 쓸 때 가장 어려운 부분은 처음 시작하는 것이 아니라, 이미 쓴 것을 지우는 일이다. 코드도 마찬가지다. 동작하는 코드를 지우는 것은 용기가 필요하다. 하지만 그 용기가 결국 더 나은 결과를 만든다.

> 완벽함이란 더 이상 더할 것이 없을 때가 아니라, 더 이상 뺄 것이 없을 때 달성된다.
> — 앙투안 드 생텍쥐페리

## 도구에 대하여

The tools we choose shape the way we think. A monospaced font in a terminal feels different from a proportional font in a word processor. Each environment nudges us toward a different kind of clarity.

요즘 나의 작업 환경은 단순하다. 터미널 하나, 에디터 하나, 그리고 메모장 하나. 복잡한 도구는 오히려 생각의 흐름을 끊는다.

```ruby
def simplify(text)
  text
    .strip
    .gsub(/\s+/, ' ')
    .downcase
end
```

이 함수는 별것 아닌 것처럼 보이지만, 내가 글을 다듬는 과정과 정확히 같다. 공백을 정리하고, 하나로 통일하고, 낮추는 것. Stripping away the unnecessary until only the essential remains.

## 글쓰기와 코딩, 어디가 닮았나

| 관점 | 글쓰기 | 코딩 | 공통 원칙 |
|------|--------|------|-----------|
| 초안 | 일단 거칠게 써본다 | 일단 동작하게 만든다 | 완벽보다 시작이 먼저 |
| 퇴고 | 불필요한 문장을 지운다 | 불필요한 코드를 지운다 | 덜어내는 용기 |
| 독자 | 읽는 사람을 의식한다 | 읽을 개발자를 의식한다 | 명확함이 최우선 |
| 구조 | 단락과 흐름으로 정리 | 함수와 모듈로 정리 | 논리적 단위로 분리 |
| 도구 | 메모장, 워드프로세서 | 에디터, 터미널 | 단순한 도구가 낫다 |

*글쓰기와 코딩의 유사점 비교*

## 결국 같은 이야기

Writing and programming are both acts of translation — taking the messy, tangled thoughts in your head and rendering them into a form that others can follow. The medium differs, but the discipline is the same.

좋은 코드를 작성하고 싶다면 글쓰기를 연습하라. 좋은 글을 쓰고 싶다면 코드를 읽어보라. 둘 사이의 거리는 생각보다 가깝다.
