---
layout: post
# published: false = 미발행 / true = 발행
published: false
title: MySQL 전문검색, FullText 인덱스.
date: 2025-03-29
series: sql-optimization
series_order: 4
tags: []
---
## 들어가며




현재 실행계획에서 알 수 있는 것은 FullText 인덱스를 사용하고 있습니다. FullText 인덱스는 자체 랭킹(score) 정렬만 수행합니다. 그렇기 때문에, `ORDER BY id DESC`에 필요한 id 인덱스를 사용하지 않게 됩니다. 즉 pk 인덱스가 존재하더라도, 해당 인덱스를 타지 않습니다.

그렇다면 FullText 인덱스에 필요한 컬럼을 같이 추가해서 복합인덱스로 구성하면 되지 않을까?
결론부터 말하자면 불가능합니다. FullText 인덱스의 경우 복합인덱스 구성을 지원하지 않습니다. 


## 동작 방식.


### 1. FULLTEXT 인덱스 구조: 역색인(Inverted Index)

- FULLTEXT 인덱스는 **역색인** 구조를 갖습니다.    
- 역색인은 각 단어(word)마다, 해당 단어가 포함된 **문서(레코드 ID) 목록을 빠르게 조회할 수 있도록 만든 자료구조**입니다.

예를 들어, 단어 "메시지"가 포함된 문서 ID가 `[1, 10, 234, 1234, ...]` 이런 식으로 저장됨.

### 2. 검색어 파싱 및 토큰화

- `AGAINST('메시지 큐 활용')` 입력 시, 검색어는 **공백 등으로 토큰화**되어 단어 단위로 분해됩니다: `"메시지"`, `"큐"`, `"활용"`
- 각 단어가 FULLTEXT 역색인에서 찾아집니다.


### 3. 각 단어별 문서 리스트 조회 및 합산

- 역색인에서 각 단어가 포함된 문서 리스트를 가져옵니다.
- 예)
    - "메시지" 포함 문서: [1, 10, 20, 100]  
    - "큐" 포함 문서: [10, 30, 100, 200]
    - "활용" 포함 문서: [20, 100, 300]
- 이 리스트들을 **합치고 교집합하여 매칭되는 문서 후보를 선정**합니다.
    
### 4. Relevance(가중치) 계산

- MySQL은 각 문서별로 **TF-IDF 기반** 또는 MySQL 버전에 따른 가중치 알고리즘으로 점수를 계산합니다    
- 점수는 각 단어 빈도, 문서 빈도, 문서 길이 등 다양한 요소를 반영합니다.
- 결과적으로 각 문서에 대해 `relevance_score`가 할당됩니다.

### 5. 내부 정렬: relevance score 기준 정렬

- 계산된 relevance 점수를 기준으로 **내부적으로 정렬**합니다.    
- 이 정렬 결과에서 상위 N개를 반환하거나, LIMIT, OFFSET에 따라 페이징 처리합니다.

### 6. 결과 반환 및 테이블 액세스

- 내부 정렬 후, 결과 문서 ID를 기반으로 실제 테이블의 각 행 데이터를 디스크에서 읽어 옵니다.    
- (인덱스 스캔 → 테이블 로우 읽기)




본문을 일정길이의 토큰으로 쪼개서 사용하는 n-Gram 방식으로 정확성을 올릴 수 있음.




## 모드.


### NATURAL LANGUAGE MODE
MySQL의 **NATURAL LANGUAGE MODE**에서는:
- 검색어의 등장 빈도 (TF)
- 전체 문서에서의 희귀성 (IDF)
- 정규화(문서 길이, 단어수) 등을 기준으로 계산

결과는 소수점 점수로 나옵니다 (ex: 2.145, 0.98 등)


### BOOLEAN MODE


## 주의사항.

### OrderBy와 함께 쓰이면 안된다.

FullText 인덱스는 내부적으로 유사도를 계산한 score 기준으로 자동 정렬해서 결과를 반환합니다. 
다음 쿼리를 통해, 유사도 score를 뽑아볼 수 있습니다.

MySQL은 `ORDER BY`가 명시되어 있지 않은 경우에도 **`MATCH ... AGAINST`의 relevance score로 내부 정렬**을 합니다.

```sql
select p1_0.title, MATCH(title, content) AGAINST('스프링 활용') AS score  
from post p1_0  
where MATCH(p1_0.title, p1_0.content)  
            AGAINST('스프링 활용' IN NATURAL LANGUAGE MODE) > 0  
limit 0,10;
```


![Desktop View](/assets/images/full-text-index/full-text-index-no-order-by.png){: width="1072" height="589" }

그런데 만약, 이렇게 조회된 결과를 `id` 순으로 정렬해야해서 다음과 같이 `order by` 절을 명시적으로 사용하게 되면, 유사도를 기준으로 정렬된 관련도 정렬은 무시되고, `id` 순으로 정렬되게 됩니다.

```sql
select p1_0.title, p1_0.content, MATCH(title, content) AGAINST('스프링 활용') AS score  
from post p1_0  
where MATCH(p1_0.title, p1_0.content)  
            AGAINST('스프링 활용' IN NATURAL LANGUAGE MODE) > 0  
order by id desc  
limit 0,10;
```

![Desktop View](/assets/images/full-text-index/full-text-index-order-by.png){: width="1072" height="589" }

조회 결과로 나온 행들은 기존에 의도하던 전문검색의 결과와는 많이 관련성이 낮은 건들이 조회될 가능성이 매우 높습니다. 때문에 FullText index를 사용하고자 할때는 `order by` 절의 유무에 따라 조회 결과가 달라질 수 있음을 유념해야합니다.


## 다른 전문 검색 


DB 