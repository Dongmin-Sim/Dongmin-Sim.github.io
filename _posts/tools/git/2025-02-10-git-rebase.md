---
title: 24년을 돌아보며
author: codongmin
date: 2025-02-01T21:34:00
categories:
  - 회고
  - 연말
tags:
description: git rebase에 대한 개념과 활용예시에 대해서 다룹니다.
image:
path: /assets/img/thumbnail/lookback2024.png
lqip:
alt: git rebase
---

## 들어가며

git을 사용한다면 브랜치를 분기하고 기능을 개발하고 다시 메인 브랜치에 머지하는 일련의 과정들은 개발과 형상관리를 함에 있어서 거의 필수적으로 사용되는 기능들이다. 하지만 git에는 서로 다른 브랜치를 합치는 방식이 merge만 존재하지 않는다. 

예상 독자 , 커밋 머지에 대해 이해가 있는 사람.
브랜치를 리베이스를 통해 관리하고 싶은 사람. 

## Git Rebase란?

리베이스는 말 그대로 커밋의 베이스를 재배치하는 git 명령어이다.

리베이스는 특정 커밋을 기반으로 커밋을 재생성할 수 있다 .
리베이스를 수행하면 내부적으로 패치를 생성해 커밋을 재생성한다. 동작원리에 대해서는 뒤에서 더 자세히 설명한다.



3-way 머지와 다른점은?
Rebase를 하든지, Merge를 하든지 최종 결과물은 같고 커밋 히스토리만 다르다는 것이 중요하다. Rebase 의 경우는 브랜치의 변경사항을 순서대로 다른 브랜치에 적용하면서 합치고 Merge 의 경우는 두 브랜치의 최종결과만을 가지고 합친

그림으로 보면 3-way-merge와 머지 히스토리를 남기는지 안남기는지의 차이이다. 


## 왜 사용하는지?


3-way-merge 대신 이용할 수 있는 방법 
- 브랜치를 보다 깔끔하게 관리할 수 있다. 
- 적을때는 괜찮은데 브랜치가 너무 많아져서 브랜치 트리의 뎁스가 너무 깊어져 보기 힘들때 사용


커밋들을 다듬을 때도 사용한다.

## rebase 동작원리

`git rebase`는 현재 브랜치의 커밋들을 다른 브랜치(예: `main`)의 최신 상태 위로 재배치합니다. 이 과정에서 다음 작업이 수행됨.

먼저 공통 조상을 찾는다.

1. **기존 커밋 "분리"**:
    - 현재 브랜치에서 공통 조상 이후의 모든 커밋을 선택합니다.
    - 선택된 각 커밋은 "패치(patch)" 형태로 임시 저장됩니다[5](https://wonyong-jang.github.io/git/2021/02/05/Github-Rebase.html).
    
2. **새로운 기준(base) 위로 재적용**:
    - 지정된 브랜치(예: `main`)의 최신 상태를 기준으로 패치를 하나씩 재적용합니다.
    - 이 과정에서 새로운 부모 커밋을 참조하며, 새로운 커밋이 생성됩니다.
    
3. **결과**:
    
    - 기존 커밋과 동일한 내용이라도 부모 커밋이 변경되었기 때문에 새로운 해시값을 가진 커밋들이 생성됩니다[2](https://ho8487.tistory.com/90)[6](https://louis-devlog.tistory.com/6).

패치란? 



## Git Rebase 사용 방법 

Git rebase를 사용하는 방법은 다음과 같다. 

옮길 브랜치로 이동 후 이동할 브랜치로 rebase해주면 된다.
```git 
git checkout [rebase-branch]
git rebase [target-branch]
```

예를 들어 `feature/user` 브랜치를 `main`의 최신 커밋 뒤로 배치하고 싶다면 다음과 같이 수행하면 된다.
```git
git checkout feature/user
git rebase main
```

그림으로 보면 다음과 같다. 현재 위치는 HEAD로 표시한다.


## 기본 rebase 활용 

최신 브랜치로 정리할 때 


## Rebase를 이용한 브랜치 관리 전략

Rebase로 여러 브랜치를 관리할 수 있다.

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
pr에서 rebase엔 머지하면 어떤지


## 주의사항 

rebase에서 주의해야할 사항은 public repository에 푸시한 커밋을 rebase 하지 않는 것.
-> 왜? 커밋의 해시값이 달라지기 때문임. 왜냐하면 커밋의 해시를 이루는 것에는 부모 커밋도 존재하기 때문. 
해시함수의 특성상 하나의 값이라도 변경되면 완전 다른 값으로 변경되기 때문에, 이를 이미 공개된 커밋을 rebase할 경우  수행이 되지 않음. 


## 마무리하며