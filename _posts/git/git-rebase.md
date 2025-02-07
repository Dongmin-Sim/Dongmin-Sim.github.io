---
title: git rebase
author: codongmin
date: 2025-02-01T21:34:00
categories:
  - 회고
  - 연말
tags:
description: git rebase 기능과 예시에 대해서 알아봅니다.
image:
  path: /assets/img/thumbnail/lookback2024.png
  lqip:
  alt: git rebase
---

## 들어가며


예상 독자 , 커밋 머지에 대해 이해가 있는 사람.
브랜치를 리베이스를 통해 관리하고 싶은 사람. 



## 리베이스란?

리베이스는 말 그대로 베이스를 재배치하는 git 명령이다.

리베이스는 특정 커밋을 기반으로 커밋을 재생성할 수 있다 .
리베이스를 수행하면 내부적으로 패치를 생성해 커밋을 재생성한다. 

3-way-merge 대신 이용할 수 있는 방법 
- 브랜치를 보다 깔끔하게 관리할 수 있다. 
- 적을때는 괜찮은데 브랜치가 너무 많아져서 브랜치 트리의 뎁스가 너무 깊어져 보기 힘들때 사용

머지와 다른점은?
Rebase를 하든지, Merge를 하든지 최종 결과물은 같고 커밋 히스토리만 다르다는 것이 중요하다. Rebase 의 경우는 브랜치의 변경사항을 순서대로 다른 브랜치에 적용하면서 합치고 Merge 의 경우는 두 브랜치의 최종결과만을 가지고 합친

### 일반적인 ff 머지 방법 

main 브랜치만 남기는 깔끔한 방법



main에서 분기된 브랜치 feature/a, 
feature/a에서 분기된 브랜치 feature/b

feature/a가 Main에 머지되고, 
feature/b를 main에 rebase 이후에 

### no-ff 머지 방법 

브랜치의 시작과 끝을 명확히 표시할 수 있음. 


main에서 분기된 브랜치 feature/a, 
feature/a에서 분기된 브랜치 feature/b

feature/a가 Main에 머지되고, 
feature/b를 main에 rebase 이후에 
feature/b를 -> main에 three-way merge할 경우  다음과 같은 그래프로 관리 가능 
![[Pasted image 20250207171110.png]]

pr에서 일반 머지 

pr 에서 rebase엔 머지하면 어떤지


## 주의사항 

rebase에서 주의해야할 사항은 public repository에 푸시한 커밋을 rebase 하지 않는 것.


## 마무리하며
