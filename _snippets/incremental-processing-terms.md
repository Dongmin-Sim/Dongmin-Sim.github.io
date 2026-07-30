---
layout: post
# published: false = 미발행 / true = 발행
published: false
title: 증분 처리란
description:
tags: [etl, incremental]
stage: seed
---

<!-- 첫 정의: 소스→타깃 동기화 관점에서 증분 처리(incremental processing) 한 문장 정의 -->

데이터를 활용하기 위해서는 원천 시스템에서 데이터를 가져와서 분석할 수 있는 곳에 적재를 해야한다.
그리고 원천 시스템의 데이터를 가져와 타겟에 옮기는 행위를 '데이터 수집(data ingestion)'라고 부른다.

'데이터 수집' 방법에는 크게 2가지 방식이 존재하는데, 데이터의 신선도 요구사항/에 따라 배치와 스트리밍으로 분류된다. 
보통 이렇게 구분되는 이유는, 비즈니스적으로 데이터를 실시간/준실시간으로 빠르게 확인이 필요한 경우에 따라서 데이터 수집 방식이 결정된다. 

배치는 특정 구간을 나눠 데이터을 일괄적으로 모았다 한꺼번에 일괄처리 하는 방식을 의미한다.
스트리밍 수집 방식은 특정한 구간이 없이 연속적으로 데이터를 원천시스템으로부터 타겟 시스템으로 올기는 방법을 의미한다.

이 두 수집 방법 중 배치 방식





<!-- 축 1: 단계별 구분 — 증분 추출(incremental extraction) / 증분 적재(incremental load) -->

<!-- 축 2: 반영 방식 — append / upsert·merge / delete+insert -->

<!-- 열린 질문 -->
