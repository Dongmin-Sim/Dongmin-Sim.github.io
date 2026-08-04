# 북마크

글 쓸 때 근거로 대거나 참고할 만한 글을 모아두는 곳. 사이트에 발행되지 않는다
(`_config.yml`의 `exclude`에 들어 있음).

한 줄 규칙 — **링크 + 왜 담아뒀는지 한 줄.** 그 이상은 필요해질 때 늘린다.

> ⚠️ 아래 대부분은 **검색 결과만 보고 담은 것이고 본문을 읽지 않았다.**
> 읽고 나면 메모를 실제 내용으로 바꿀 것.

---

## 증분 처리 · CDC · 데이터 수집

### 표준·벤더 문서 (정의 층 — 근거로 댈 수 있는 급)

- [Oracle Database 19c Data Warehousing Guide — Extraction in Data Warehouses](https://docs.oracle.com/en/database/oracle/oracle-database/19/dwhsg/extraction-data-warehouses.html)
  — 추출 방법을 Logical(Full / Incremental) · Physical(Online / Offline) · Change Tracking으로 나눈 원전.
  "증분 추출"이 공식 용어로 박혀 있는 거의 유일한 자리. **읽음(2026-08-04)**
- [Microsoft Learn 한국어 — 변경 데이터 캡처(CDC)란 (SQL Server)](https://learn.microsoft.com/ko-kr/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver17)
  — CDC의 한국어 정의. 영어 원문의 번역이라 새 정의는 아님
- [Databricks 한국어 — 데이터 인제스천(Data Ingestion)이란 무엇인가요?](https://www.databricks.com/kr/blog/what-is-data-ingestion)
  — 데이터 수집과 ETL의 차이를 한국어로 정리. 역시 번역 층

### 한국 기업 기술블로그 (사례기 — 정의 대신 "이렇게 만들었다")

- [당근 — 매번 다 퍼올 필요 없잖아? 당근의 MongoDB CDC 구축기](https://medium.com/daangn/%EB%A7%A4%EB%B2%88-%EB%8B%A4-%ED%8D%BC%EC%98%AC-%ED%95%84%EC%9A%94-%EC%97%86%EC%9E%96%EC%95%84-%EB%8B%B9%EA%B7%BC%EC%9D%98-mongodb-cdc-%EA%B5%AC%EC%B6%95%EA%B8%B0-302ae8a0dc23)
  — 제목이 곧 증분 처리의 동기. 전체 추출을 왜 버리는지가 그대로 들어 있음
- [카카오페이 — Oracle에서 MongoDB로의 CDC Pipeline 구축](https://tech.kakaopay.com/post/kakaopaysec-mongodb-cdc/)
  — 원천이 오라클인 사례
- [토스 — 대규모 CDC Pipeline 운영을 위한 Debezium 개선 여정](https://toss.tech/article/cdc_pipeline)
  — 만든 뒤 운영하면서 겪은 문제 쪽
- [토스증권 — Iceberg 적용기 #1: CDC 환경은 왜 제대로 동작하지 않을까?](https://toss.tech/article/iceberg-cdc-1)
  — CDC가 깨지는 지점
- [토스 — 입수는 Datalake로! (feat. Iceberg)](https://toss.tech/article/datalake-iceberg)
- [뱅크샐러드 — 데이터 분석가가 직접 정의·배포·관리하는 데이터 파이프라인](https://blog.banksalad.com/tech/datapipe/)
  — Airflow로 굴리는 파이프라인 운영 구조
- [크몽 — 데이터 레이크 구축 방법](https://medium.com/@dahuin000/%E1%84%8F%E1%85%B3%E1%84%86%E1%85%A9%E1%86%BC-%EB%8D%B0%EC%9D%B4%ED%84%B0-%E1%84%85%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%8F%E1%85%B3-%EA%B5%AC%EC%B6%95-%EB%B0%A9%EB%B2%95-dd6b39bea392)
- [IOTRUST — dbt를 통한 데이터 웨어하우스 개발 후기](https://medium.com/iotrustlab/data-warehouse-with-dbt-b65be67750e9)
  — dbt 실사용 후기 (증분 모델 얘기가 있을 가능성)
- [IOTRUST — GA4 기반 데이터 웨어하우스 구축 후기](https://medium.com/iotrustlab/ga4-%EA%B8%B0%EB%B0%98-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EC%9B%A8%EC%96%B4%ED%95%98%EC%9A%B0%EC%8A%A4-%EA%B5%AC%EC%B6%95-%ED%9B%84%EA%B8%B0-f900bc06c078)

### 한국어 개념 정리 (기업 블로그 아닌 쪽)

- [엔씨소프트 단비 — ETL 개념과 ETL 개발 시 고려해야 하는 원칙들](https://danbi-ncsoft.github.io/works/2021/07/23/etl_principles.html)
  — 한국 기업 쪽에서 정의와 원칙을 다룬 드문 글. 점진적 적재를 원칙 중 하나로 다룸
- [위키백과 — 추출, 변환, 적재](https://ko.wikipedia.org/wiki/%EC%B6%94%EC%B6%9C,_%EB%B3%80%ED%99%98,_%EC%A0%81%EC%9E%AC)
  — 한국어 표제어 확인용. "로드"가 아니라 "적재"
- [wikidocs — 데이터간 처리 (데이터 분석론)](https://wikidocs.net/103398)
- [ETL 설계 (개인 블로그, Kim Yeonjun)](https://zcqggntwsd.medium.com/%EB%8D%B0%EC%9D%B4%ED%84%B0-%EC%9B%A8%EC%96%B4%ED%95%98%EC%9A%B0%EC%8A%A4%EB%A5%BC-%EC%9C%84%ED%95%9C-etl-%EC%84%A4%EA%B3%84-fe4adb901c95)
- [Product Analytics Playground — 데이터 파이프라인 개념 정리](https://playinpap.github.io/data-pipeline/)

### 영어 실무 문서 (공급업체 블로그 — 근거 급 낮음, 상호 인용이 많음)

- [Hevo — Incremental Data Load vs Full Load ETL](https://hevodata.com/learn/incremental-data-load-vs-full-load/)
- [Airbyte — Incremental Load in ETL](https://airbyte.com/data-engineering-resources/etl-incremental-loading)
- [Estuary — Incremental Load vs Full Load ETL](https://estuary.dev/blog/incremental-data-load-vs-full-load-etl/)
- [Panoply — Full vs Incremental Loading in ETL](https://panoply.io/data-warehouse-guide/data-warehouse-etl/)
