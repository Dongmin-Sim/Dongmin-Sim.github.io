---
layout: post
title: 성능 테스트 초기 단계
date: 2025-03-29
tags: []
---
## 들어가며


> 초기 단계 성능테스트 수행. 
> 결과 및 원인 분석.
> 개선 사항.


조회 API 성능 테스트. 



조회 API 개선 포인트. 

날짜 필터의 경우 단위별로 끊을 수 있도록. 


|조건|개선 포인트|
|---|---|
|날짜 필터|`created_at` 단일 인덱스 → 효율적 `range scan`|
|작성자 ID 필터|`author_id` 인덱스 → 단일 조회는 빠름|
|최신순/오래된순|`created_at DESC/ASC` 인덱스 필요|
|추천/비추천순|`upvote/downvote DESC` → **별도 정렬 인덱스** 필요|
|날짜+작성자 복합|`(author_id, created_at)` 복합 인덱스 필요|
|page=90000|`OFFSET N` 방식은 비효율 → **keyset pagination** (`WHERE created_at < ?`) 으로 전환 권장|
