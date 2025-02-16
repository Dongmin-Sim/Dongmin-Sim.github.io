---
title: 깔끔한 커밋 관리, Git Rebase
author: codongmin
date: 2025-02-01T21:34:00
categories:
  - tools
  - git
tags:
  - git
  - rebase
description: git rebase에 대한 개념과 활용예시에 대해서 다룹니다.
image:
  path: /assets/img/thumbnail/git-rebase.png
  lqip:
  alt: git rebase
---

## 들어가며

Git을 사용한다면 브랜치를 분기하고 기능을 개발하고 다시 메인 브랜치에 Merge하는 일련의 과정들은 개발과 형상관리를 함에 있어서 거의 필수적으로 사용되는 기능들이다. 하지만 Git에는 서로 다른 브랜치를 합치는 방식으로 rebase라는 기능도 존재한다.

이 글에서는 git rebase에 대한 개념과 동작원리를 가볍게 다룬다.

## Git Rebase란?

Rebase는 말 그대로 **커밋의 베이스를 재배치**하는 git 명령어이다.

Rebase는 특정 커밋을 기반으로 커밋을 재생성할 수 있다. Rebase를 수행하면 내부적으로 패치를 생성해 커밋을 재생성한다. 동작원리에 대해서는 뒤에서 더 자세히 설명한다.

### 3-way-merge 와 다른점은?

Rebase를 하든지, Merge를 하든지 최종 결과물은 같고 커밋 히스토리만 다르다는 것이 중요하다. Rebase 의 경우는 브랜치의 변경사항을 순서대로 다른 브랜치에 적용하면서 합치고 Merge 의 경우는 두 브랜치의 최종결과만을 가지고 합친다.

![Desktop View](/assets/posts/tools/git/git-rebase/3-way-merge.png){: width="972" height="589"}_3-way-merge_

그림으로 보면 3-way-merge의 경우 두 브랜치를 합치면서 새로운 merge commit을 남긴다.

![Desktop View](/assets/posts/tools/git/git-rebase/rebase.png){: width="972" height="589"}_rebase를 통한 머지_

Rebase는 3-way-merge와는 다르게 별도의 Merge Commit을 남기지 않는다. 브랜치의 기반이 되는 커밋을 재구성하기 때문에 마치 `main` 브랜치에서 이어서 작업한 것처럼 보인다. 별도의 Merge commit이 남지 않는 이유는 rebase 이후, main에 합치는 과정이 fast-forward로 진행되기 때문이다. 여기서 한 가지 유심히 확인해야하는 것은 Rebase 이후 **변경되는 커밋의 해시값**이다.

이는 rebase 이후 가리키고 있는 **부모 커밋이 변경**되었기 때문이다. 커밋은 고유한 해시값을 가지고 있다. 이 해시값은 각각의 커밋들을 식별하기 위해 사용된다. 커밋의 해시값은 커밋을 이루는 여러 요소들을 조합하여 해시 알고리즘으로 생성한다. 커밋을 이루는 여러 요소들 중에 부모 커밋에 대한 값이 rebase 이후에 다른 부모 커밋으로 변경되기 때문이다. 이 내용이 중요한 이유는 이후 주의사항에서 다시 언급하겠다.

## 왜 사용하는지?

Rebase 다음과 같은 이유로 사용할 수 있다.

![Desktop View](/assets/posts/tools/git/git-rebase/dirty-branch.png){: width="972" height="589"}_지저분한 브랜치_

브랜치를 보다 깔끔하게 관리하고 싶을때, 브랜치가 한 두개로 적을때는 괜찮은데 브랜치가 너무 많아져서 브랜치 트리의 뎁스가 너무 깊어져 보기 힘들때는 Rebase를 통한 브랜치를 머지하는 경우 깔끔한 히스토리가 관리방법이 될 수 있다.

![Desktop View](/assets/posts/tools/git/git-rebase/apply-recent-commit.png){: width="972" height="589"}_최신 커밋 반영_

또는 최신 변경사항을 반영할 때도 Rebase를 사용할 수도 있다.

rebase기능은 `-i` 옵션을 활용한 인터렉티브 rebase로 기존에 작성했던 커밋들을 다듬을 때도 사용한다.
이와 관련된 내용은 별도의 포스팅으로 작성할 예정이다.

## Git Rebase 사용 방법

Git rebase를 사용하는 방법은 다음과 같다.

![Desktop View](/assets/posts/tools/git/git-rebase/init-status.png){: width="972" height="589"}_초기상태_

옮길 브랜치로 이동 후 이동할 브랜치로 rebase 해주면 된다.

```
git checkout [rebase-branch]
git rebase [target-branch]
```

예를 들어 `feature/user` 브랜치를 `main`의 최신 커밋 뒤로 배치하고 싶다면 다음과 같이 수행하면 된다.

```
git checkout feature/user
git rebase main
```

그림으로 보면 다음과 같다. 현재 위치는 HEAD로 표시한다.

![Desktop View](/assets/posts/tools/git/git-rebase/after-checkout.png){: width="972" height="589"}_rebase 대상 브랜치로 checkout_

![Desktop View](/assets/posts/tools/git/git-rebase/after-rebase.png){: width="972" height="589"}_main으로 rebase_

## Rebase 동작원리

`main` 브랜치와 `main` 브랜치에서 파생된 `feature/a` 브랜치가 존재하는 상황을 가정해봤다. `feature/a` 브랜치를 `main` 브랜치로 rebase 하는 과정을 통해 rebase의 동작원리를 설명한다.

### 1. 공통 조상 커밋 찾기

![Desktop View](/assets/posts/tools/git/git-rebase/find.png){: width="972" height="589"}_두 브랜치의 공통 조상 찾기_

먼저 공통 조상 커밋을 찾는다. 공통 조상 커밋이란, 두 브랜치가 처음 분기된 최초의 상태를 가지는 커밋을 의미한다. 이후에 현재 브랜치에서 공통 조상 이후의 모든 커밋을 선택한다. 위 이미지에서는 `main` 브랜치와 `feature/a` 브랜치의 공통 조상인 `c1` 커밋을 찾고 이후 rebase할 브랜치의 커밋들을 선택한다.

### 2. 커밋들 간 Diff 계산

![Desktop View](/assets/posts/tools/git/git-rebase/diff.png){: width="972" height="589"}_패치 생성_

이후 선택된 커밋들을 하나씩 확인하면서 부모 커밋과의 비교를 통해 패치 파일을 만든다. 위 이미지에서는 `C3` 커밋의 부모 커밋인 `C1` 커밋과의 차이점을 계산한 `p1` 패치가 생성되고, 같은 방식으로 `C4` 커밋에 대한 패치도 저장이 완료된 상태이다.

> 패치란?
> 패치는 두 커밋간 변경사항을 나타내는 정보를 의미한다. Git에서는 특정 커밋과 그 부모 커밋과의 diff를 계산해서 "패치"(Patch) 라는 형태로 저장함.
>
> - 수정된 파일 경로
> - 추가/삭제된 코드 내용
> - 변경된 메타데이터(예: 파일 권한 등)

### 3. target 브랜치로 패치 적용

![Desktop View](/assets/posts/tools/git/git-rebase/apply-diff.png){: width="972" height="589"}_패치 적용_

앞서 저장해 두었던 패치를 하나찍 꺼내면서 `main` 브랜치의 최신 상태를 기준으로 패치를 하나씩 재적용하게 된다. 이 과정에서 새로운 부모 커밋을 참조하는 방식으로, 새로운 커밋이 생성된다.

### 4. Fast-forward 머지

![Desktop View](/assets/posts/tools/git/git-rebase/ff-merge.png){: width="972" height="589"}_ff merge_

Rebase 이후에는 `feature/a`브랜치가 `main` 브랜치의 최신 커밋을 부모로 하고 있으므로 fast-forward 머지를 통해 rebase 과정을 마무리할 수 있다.

## Rebase 시 충돌 발생의 경우

![Desktop View](/assets/posts/tools/git/git-rebase/conflict.png){: width="972" height="589"}_충돌발생_

Rebase를 할때도 충돌이 발생하는 경우가 존재한다. 공통 조상으로부터 분기된 두 브랜치가 동일한 위치를 서로 각각 수정했을 경우 Rebase 시 Diff를 적용하면서 충돌이 발생되게 된다. 이때는 차분하게 충돌을 하나씩 처리해나가면 된다.

![Desktop View](/assets/posts/tools/git/git-rebase/conflict-resolve.png){: width="972" height="589"}_충돌해결_

일단 충돌난 부분을 확인하고, 충돌 부분을 해결한 후

```
git add [file]
```

충돌을 해결했다면 다음 명령어를 통해 Rebase를 계속 진행할 수 있다.

```
git rebase --continue
```

앞의 동작원리에서 설명했듯이 각 커밋들을 기반으로 만들어진 패치를 통해 새 커밋들을 생성하므로 이 과정은 충돌이 발생할때 마다 반복될 수 있다.

![Desktop View](/assets/posts/tools/git/git-rebase/conflict-again.png){: width="972" height="589"}_충돌 재발생_

## Rebase를 이용한 브랜치 관리 전략

![Desktop View](/assets/posts/tools/git/git-rebase/branch-init.png){: width="972" height="589"}_초기 상태_

Rebase로 브랜치를 깔끔하게 관리할 수 있다고 했는데, 이에 세부적인 2가지 방법이 존재한다. 다음 기본 브랜치 상태를 가정하고 진행해본다.

### 일반적인 Rebase + ff 머지 방법

이 방법은 앞에서 설명했던 내용의 Rebase 방법이다. 결과적으로 하나의 main 브랜치만 남기는 방법으로 가장 깔끔한 방법에 속한다.

![Desktop View](/assets/posts/tools/git/git-rebase/rebase-with-ff.png){: width="972" height="589"}_rebase + ff_

하지만 이런 경우에는 브랜치 히스토리가 남지 않기 때문에 작업이력을 파악하는데는 적합하지 않을 수 있다. 직관적으로 작업 커밋을 남기고 싶다면 다음과 같은 브랜치 관리 전략을 사용해볼 수 있다.

### Rebase + no-ff 머지 방법

이 방법은 브랜치의 시작과 끝을 명확히 표시할 수 있음.

![Desktop View](/assets/posts/tools/git/git-rebase/rebase-no-ff.png){: width="972" height="589"}_rebase + no-ff_

그림처럼 main에서 분기된 브랜치 feature/a, feature/b 가 있다고 했을때, 다음과 같은 방식으로 수행될 수 있다.

- `feature/a`가 `main`에 머지되고,
- `feature/b`를 `main`에 rebase 한다.
- `feature/b`를 `main`에 3-way-merge할 경우 위와 같은 그래프로 관리 가능

Rebase를 한 이후에는 `main` 브랜치 이후에 Rebase한 최신 커밋들이 존재하기 때문에 `main` 브랜치에서 Fast forward 하여 머지할 수 있지만, 일부러 커밋 메시지를 남김으로써 작업이력을 명확하게 표시하는 방법이다.

결과적으론 다음과 같은 모습으로 브랜치를 관리할 수 있다.

![Desktop View](/assets/posts/tools/git/git-rebase/rebase-with-no-ff-result.png){: width="972" height="589" .h-75}_rebase + no-ff 최종 모습_

## 주의사항

rebase에서 주의해야할 사항은 **public repository에 푸시한 커밋을 강제로 Rebase 하지 않는 것**이다.

왜냐하면 앞서 살펴본 Rebase 이후의 커밋 해시값이 달라지기 때문이다. 해시함수의 특성상 하나의 값이라도 변경되면 완전 다른 값으로 변경되기 때문에, 이를 이미 공개된 커밋을 Rebase하여 강제 푸시할 경우 커밋히스토리가 꼬여버릴 수 있다. 더군다나 원격 리포지토리는 혼자 작업하는 환경이 아니기 때문에 반드시 서로 상호간의 이야기가 된 후에 작업해야한다.

가능하면 원격으로 푸시하기 전에 다른 커밋에 영향을 미치지 않는 선에서 작업하는 것이 안전하다.

## 마무리하며

Git rebase를 잘 사용하면 복잡한 브랜치를 보다 깔끔하게 다룰 수 있다. 본 글에서는 가볍게 Git rebase에 대한 개념과 각 단계별 제시된 그림을 통해 동작되는 원리를 살펴보고, Rebase를 다루는 명령어에 대해서 소개했다. 이후에는 Rebase 시에 충돌 발생시 대처 방법과 Rebase를 활용한 브랜치 관리 전략을 간단하게 살펴보면서 글을 마무리했다.
