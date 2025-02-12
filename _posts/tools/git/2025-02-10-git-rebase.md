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

### 3-way 머지와 다른점은?

Rebase를 하든지, Merge를 하든지 최종 결과물은 같고 커밋 히스토리만 다르다는 것이 중요하다. Rebase 의 경우는 브랜치의 변경사항을 순서대로 다른 브랜치에 적용하면서 합치고 Merge 의 경우는 두 브랜치의 최종결과만을 가지고 합친다.


![Desktop View](/assets/posts/tools/git/git-rebase/3-way-merge.png){: width="972" height="589"}_테스트 코드_


그림으로 보면 3-way-merge의 경우 두 브랜치를 합치면서 새로운 merge commit을 남긴다. 

![Desktop View](/assets/posts/tools/git/git-rebase/rebase.png){: width="972" height="589"}_테스트 코드_

Rebase는 3-way-merge와는 다르게 별도의 Merge Commit을 남기지 않는다. 브랜치의 기반이 되는 커밋을 재구성하기 때문에 마치 `main` 브랜치에서 이어서 작업한 것처럼 보인다. 별도의 Merge commit이 남지 않는 이유는 rebase 이후, main에 합치는 과정이 fast-forward로 진행되기 때문이다. 여기서 한 가지 유심히 확인해야하는 것은 rebase이 이후 변경되는 커밋의 해시값이다. 

이는 rebase 이후 가리키고 있는 **부모 커밋이 변경**되었기 때문이다. 커밋은 고유한 해시값을 가지고 있다. 이 해시값은 각각의 커밋들을 식별하기 위해 사용된다. 커밋의 해시값은 커밋을 이루는 여러 요소들을 조합하여 해시 알고리즘으로 생성한다. 커밋을 이루는 여러 요소들 중에 부모 커밋에 대한 값이 rebase 이후에 다른 부모 커밋으로 변경되기 때문이다. 이 내용이 중요한 이유는 이후 주의사항에서 다시 언급하겠다.

## 왜 사용하는지?

Rebase 다음과 같은 이유로 사용할 수 있다.

브랜치를 보다 깔끔하게 관리하고 싶을때, 브랜치가 한 두개로 적을때는 괜찮은데 브랜치가 너무 많아져서 브랜치 트리의 뎁스가 너무 깊어져 보기 힘들때는 Rebase를 통한 브랜치를 머지하는 경우 깔끔한 히스토리가 관리방법이 될 수 있다.


rebase기능은 `-i` 옵션을 활용한 인터렉티브 rebase로 기존에 작성했던 커밋들을 다듬을 때도 사용한다.
이와 관련된 내용은 별도의 포스팅으로 작성할 예정이다.


## Git Rebase 사용 방법 

Git rebase를 사용하는 방법은 다음과 같다. 

옮길 브랜치로 이동 후 이동할 브랜치로 rebase 해주면 된다.
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


## rebase 동작원리

`main` 브랜치와 `main` 브랜치에서 파생된 `feature/a` 브랜치가 존재하는 상황을 가정해봤다. `feature/a` 브랜치를 `main` 브랜치로 rebase 하는 과정을 통해 rebase의 동작원리를 설명한다.

### 1. 공통 조상 커밋 찾기 

![Desktop View](/assets/posts/tools/git/git-rebase/find.png){: width="972" height="589"}_두 브랜치의 공통 조상 찾기_


먼저 공통 조상 커밋을 찾는다. 공통 조상 커밋이란, 두 브랜치가 처음 분기된 최초의 상태를 가지는 커밋을 의미한다. 이후에 현재 브랜치에서 공통 조상 이후의 모든 커밋을 선택한다. 위 이미지에서는 `main` 브랜치와 `feature/a` 브랜치의 공통 조상인 `c1` 커밋을 찾고 이후 rebase할 브랜치의 커밋들을 선택한다.


### 커밋들 간 Diff 계산
![Desktop View](/assets/posts/tools/git/git-rebase/diff.png){: width="972" height="589"}_테스트 코드_

	
이후 선택된 커밋들을 하나씩 확인하면서 부모 커밋과의 비교를 통해 패치 파일을 만든다. 위 이미지에서는 `C3` 커밋의 부모 커밋인 `C1` 커밋과의 차이점을 계산한 `p1` 패치가 생성되고, 같은 방식으로 `C4` 커밋에 대한 패치도 저장이 완료된 상태이다. 

> 패치란? 
> 패치는 두 커밋간 변경사항을 나타내는 정보를 의미한다. Git에서는 특정 커밋과 그 부모 커밋과의 diff를 계산해서 "패치"(Patch) 라는 형태로 저장함.
> -  수정된 파일 경로
> - 추가/삭제된 코드 내용
> - 변경된 메타데이터(예: 파일 권한 등)


### 3. target 브랜치로 패치 적용 
![Desktop View](/assets/posts/tools/git/git-rebase/apply-diff.png){: width="972" height="589"}_테스트 코드_

1. **새로운 기준(base) 위로 재적용**:
    - 지정된 브랜치(예: `main`)의 최신 상태를 기준으로 패치를 하나씩 재적용합니다.
    - 이 과정에서 새로운 부모 커밋을 참조하며, 새로운 커밋이 생성됩니다.
    - Rebase 과정에서는 git이 브랜치의 각 커밋들을 기반으로 패치를 생성하고 이를 새로운 기반 브랜치 위에 순차적으로 적용함.

### 4. Fast-forward 머지

![Desktop View](/assets/posts/tools/git/git-rebase/ff-merge.png){: width="972" height="589"}_테스트 코드_


Rebase 이후에는 `feature/a`브랜치가  `main` 브랜치의 최신 커밋을 부모로 하고 있으므로 fast-forward 머지를 통해 rebase 과정을 마무리할 수 있다.



## Rebase 시 충돌 발생의 경우


만일 conflict 난다면? 언제나는가?
해결해가면 됨. 


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

앞서 주의깊게 살펴봤던 Rebase 이후에 커밋의 해시가 달라져버리는 


## 마무리하며