---
layout: post
title: SQL의 조건 분기에 대해
date: 2025-03-29
series: sql-optimization
series_order: 1
tags: []
---
## 들어가며


SQL은 조건 분기를 할때 `CASE` 식을 주로 사용함. `CASE` 식은 프로그래밍 언어에서  `IF-THEN-ELSE` 구문 혹은 `SWITCH` 에 대응되는 SQL 조건 분기 식에 해당됨. 

SQL을 작성할때 효율적으로 조건분기할 수 있는 포인트들을 확인해본다.

## UNION을 조건 분기에 사용하지 않기 

보통 UNION을 사용하여 조건분기를 하는 경우가 있는데, 이는 그리 권장되는 방법이 아니다. 왜냐하면 성능적인 측면에서 단점이 존재하기 때문이다.  마치 하나의 SQL 구문을 실행하는 것처럼 보이지만, 내부적으로는 여러개의 SELECT 구문을 실행하도록 실행계획이 만들어지기 때문이다. 이는 테이블에 접근하는 횟수가 증가해 I/O 비용을 크게 늘릴 수 있기 때문이다. 


예를 들어 배타적인 조건의 결과가 필요한 경우 종종 UNION을 사용하여 쿼리를 작성할 수 있다. 만일 2024년 전의 데이터와 2024년 이후의 데이터가 각각 필요한 경우, 각각에 조건에 해당되는 쿼리를 실행 후 UNION으로 결과를 합치는 쿼리를 작성할 수 있다. 

```sql
select Items.item_name, Items.year, price_tax_ex as price  
from Items  
where year <= 2001  
union all  
select item_name, year, price_tax_in as price  
from Items  
where year >= 2002;
```

이 쿼리는 어떻게 동작할까?  예상대로 사실상 같은 테이블에 동일한 쿼리를 두 번 실행하는 것과 같다. 


다음은 해당 쿼리에 대한 실행 계획이다. `type` 은 쿼리 실행시 테이블에 접근하는 방식을 나타내는 지표이다. 이는 쿼리의 성능을 파악하는데 아주 중요한 지표다. 그 중에 `ALL`은 테이블을 풀 스캔한다는 의미이다. 조건을 비교하기 위해 레코드 하나하나를 모두 살피는 방식으로 가장 느린 접근 방법이다.

| id  | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | extra       |
| --- | ----------- | ----- | ---------- | ---- | ------------- | --- | ------- | --- | ---- | -------- | ----------- |
| 1   | PRIMARY     | Items |            | ALL  |               |     |         |     | 12   | 33.33    | Using where |
| 2   | UNION       | Items |            | ALL  |               |     |         |     | 12   | 33.33    | Using where |

그 외에도 다음과 같은 값들이 존재한다.
- `index`: 인덱스 전체 스캔 (전체 인덱스 검색)
- `range`: 인덱스 범위 스캔 (조건 범위에 맞는 인덱스 사용)
- `ref`: 인덱스 조회, 동등 비교 (비유니크 인덱스나 복합 인덱스 일부 사용)
- `eq_ref`: 유니크 인덱스 사용, 1:1 매칭 (조인 시 가장 효율적)
- `const` / `system`: 상수 테이블, 매우 빠름 (하나의 행만 참조)
- `NULL`: 테이블 접근하지 않음

아래는 실행계획 분석. `Table scan on Items` 을 2번 실행해서 결과를 합치는 것을 볼 수 있다. 
```sh
-> Append  (cost=2.9 rows=8) (actual time=0.0637..0.114 rows=12 loops=1)  
    -> Stream results  (cost=1.45 rows=4) (actual time=0.0568..0.0676 rows=6 loops=1)  
        -> Filter: (Items.`year` <= 2001)  (cost=1.45 rows=4) (actual time=0.0328..0.0416 rows=6 loops=1)  
            -> Table scan on Items  (cost=1.45 rows=12) (actual time=0.0311..0.0381 rows=12 loops=1)  
    -> Stream results  (cost=1.45 rows=4) (actual time=0.027..0.035 rows=6 loops=1)  
        -> Filter: (Items.`year` >= 2002)  (cost=1.45 rows=4) (actual time=0.0226..0.0284 rows=6 loops=1)  
            -> Table scan on Items  (cost=1.45 rows=12) (actual time=0.0206..0.0254 rows=12 loops=1)
```

결국 테이블 풀 스캔을 유발하는 쿼리가 2번 나가게되는 것이다. 테이블의 레코드를 하나씩 비교하니 당연히 테이블의 레코드 수에 따라 쿼리를 실행하는 비용도 선형적으로 증가하게 될 것이다. 

따라서 SELECT 구문 전체를 여러번 사용하는 방식은 지양해야한다. UNION을 사용하게된다면 이런 구조의 쿼리를 작성할 확률이 높아진다.

## SELECT 절에서 조건 분기를 하자.

위의 쿼리와 동일한 결과를 출력하지만 조건 분기를 where절에서 하지 않는 쿼리를 작성할 수 있다. 바로 `CASE` 식을 사용해서 가능하다. 

```sql
select item_name,  
   year,  
   case  
	   when year <= 2001 then price_tax_ex  
	   when year >= 2002 then price_tax_in  
	   end as price  
from Items;
```

위 쿼리의 실행계획도 다음과 같다. 

| id  | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | extra |
| --- | ----------- | ----- | ---------- | ---- | ------------- | --- | ------- | --- | ---- | -------- | ----- |
| 1   | SIMPLE      | Items |            | ALL  |               |     |         |     | 12   | 100      |       |

```sh
-> Table scan on Items  (cost=1.45 rows=12) (actual time=0.0213..0.0256 rows=12 loops=1)
```

테이블의 접근 한번에 동일한 결과를 얻었으니, 앞선 두 번의 쿼리를 UNION 하는 방식보다는 2배 성능이 좋아졌다. 

SQL 구문의 성능이 좋은지, 나쁜지는 반드시 실행 계획을 통해서 판단을 해야만 한다. 안타깝게도 SQL은 실제 어떻게 실행되는지 사용자가 신경쓰지 않도록 선언적으로 설계되었지만, DBMS와 여러 설정 상황들로 인한 성능차이가 나는 한계점 때문에 이러한 실행계획을 확인해야만 한다.

SQL을 작성하여 조건 분기를 할때 주의해야할 것은 '구문'이 아닌 '식'을 위주로 생각하면 성능 측면에서 이득을 볼 수 있는 부분들이 존재한다. SQL은 선언적으로 작성하도록 설계가 되었다. 따라서 각 구문의 절(WHERE, FROM, etc)에서는 식을 작성하는 것을 염두해두면 좋다.


## 집계에서도 UNION을 사용하지 말자.

행/열을 변환해서 PIVOT하여 집계를 내야하는 경우에서도 UNION을 사용하면 쿼리도 복잡해지고 성능도 그리 좋지 않다. 예를 들면 다음과 같은 경우이다. 

```sql
select tmp.prefecture, sum(pop_men), sum(pop_won)  
from (select prefecture, pop as pop_men, null as pop_won  
      from Population  
      where sex = 1  
      union  
      select prefecture, null, pop as pop_won  
      from Population  
      where sex = 2) tmp  
group by prefecture
```

이 역시 실행계획을 분석했을때, 마찬가지로 2번의 테이블 스캔이 일어나는 것을 확인할 수 있다.

```sh
-> Table scan on <temporary>  (actual time=0.0827..0.0835 rows=5 loops=1)  
    -> Aggregate using temporary table  (actual time=0.082..0.082 rows=5 loops=1)  
        -> Table scan on tmp  (cost=3.96..5.23 rows=2) (actual time=0.0636..0.0656 rows=10 loops=1)  
            -> Union materialize with deduplication  (cost=2.7..2.7 rows=2) (actual time=0.0623..0.0623 rows=10 loops=1)  
                -> Filter: (Population.sex = 1)  (cost=1.25 rows=1) (actual time=0.0285..0.0342 rows=5 loops=1)  
                    -> Table scan on Population  (cost=1.25 rows=10) (actual time=0.0268..0.0312 rows=10 loops=1)  
                -> Filter: (Population.sex = 2)  (cost=1.25 rows=1) (actual time=0.00507..0.00772 rows=5 loops=1)  
                    -> Table scan on Population  (cost=1.25 rows=10) (actual time=0.00451..0.00656 rows=10 loops=1)
```


이 역시도 CASE 식으로 변환이 가능하다. 집계함수 내부에서 `CASE` 식을 사용해서, 조건을 줄 수 있다.

```sql
select prefecture,  
       SUM(CASE WHEN sex = 1 THEN pop ELSE 0 END ) as pop_men,  
       SUM(CASE WHEN sex = 2 THEN pop ELSE 0 END ) as pop_won  
from Population  
group by prefecture;
```


## UNION을 사용해야하는 예시들 

서로 다른 테이블에서 데이터가 필요한 경우에는 UNION의 설계의도와 부합한다.
인덱스와 관련된 경우 UNION

