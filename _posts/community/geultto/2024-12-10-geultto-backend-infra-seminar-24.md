---
title: 하루하루 써내려가는 일기 (백엔드-인프라 반상회 with 글또 10기)
author: codongmin
date: 2024-12-10T21:14:00
categories:
  - 커뮤니티
  - 글또
tags: 
preview: 글또 커뮤니티의 백엔드-인프라 반상회를 다녀오며 느낀점을 작성한 회고입니다.
image:
  path: /assets/img/thumbnail/geultto-backend-infra-seminar-24.jpg
  lqip: 
  alt: 글또 마지막 백엔드 인프라 반상회
---

## 들어가며

다가오는 연말.. 글또에서 백엔드-인프라 반상회를 열렸다. 어쩌면,, 글또의 마지막 반상회가 될지도 몰라 신청했다.
백엔드-인프라 반상회는 12월 5일 목요일 우아한 형제들, 우테코 교육장에서 진행됐다. 지난 9기때 반상회 준비위하면서 처음 만났던 장소였어서 반가웠다.

![Desktop View](/assets/posts/review/geultto/geultto-backend-infra-seminar-24/seminar-entrance.jpeg){: width="972" height="589" .w-50}_우테코 교육장_

지난 9기에는 운영진 분들을 도와 반상회 준비위원회로 참여했었었는데 10기에서는 온전히 참여자로 글또를 즐기고 싶었다. 참여자로 반상회를 들어가니 또 다른 시선이어서 재밌었다. 마치 걸어왔던 길을 거꾸로도 가보는 것 같은 기분이랄까. 하나하나 준비해주시느라 고생많으셨을 거라 생각되어서 시간내주셔서 준비해주셨음에 감사했다.

## 🎤 발표세션

![Desktop View](/assets/posts/review/geultto/geultto-backend-infra-seminar-24/seminar-start.jpeg){: width="972" height="589" .w-75}_글또 대장 성윤님👍_

글또 10기 백엔드-인프라 반상회의 발표세션은 성윤님의 인사말을 시작으로 총 세 분의 연사분들의 발표로 진행되었다.

- 주니어의 고민들을 담은 권시연님의 발표
- 아무도 건들이지 않느 레거시를 파내며 진행한 리팩토링 경험을 이야기해주신 서민재님의 발표
- 늘 하루하루 나아갈 뿐인 이 길에 대해 고민을 담은 손영인님의 발표

세 발표 세션 모두 기대가 되어서 반상회를 신청했었다.

### 주니어는 오늘도 고민한다.

첫번째 발표는 현재 우아한형제들에서 재직중인 권시연님의 발표였다. 개발자가 된 순간부터 현재 서버 개발팀에서 일하게되면서 겪었던 잦은 팀 이동과 같은 순간 순간의 고민들과 고민의 기로에서 해결하기 위해 수행했던 액션아이템들을 이야기해주셨다.

#### ⭐️ 인상깊었던 포인트

시연님의 발표에서 가장 인상 깊었던 점은, 취준생 시절 최선을 다했던 경험과, 같은 문제를 다르게 바라보는 관점의 전환을 했던 부분이 가장 인상 깊게 남았다. 우아한테크코스를 수료하면서 정말 후회없는 노력을 했다는 경험. 수많은 스터디와 코드들을 작성하셨다는 경험. 과연 나는 정말 후회없이 하고 있는가? 를 되묻게 하는 대목이었었다.

또 시기마다 들었던 고민을 기점으로 회고를 진행하신것 같아서 이 부분도 인상깊게 봤던 것 같다. 인생의 순간 순간 나에게 중요하게 다가왔던 고민들은 무엇이었을까? 그리고 난 그 고민속에서 어떤 결정을 내렸었던가 나를 다시 회고하게 만들었던 발표였다.

나는 별로 좋지 않은 상황이라고 내 주변을 판단하곤하는데, 시연님도 비슷한 상황에서 주변 동료분께 전혀 다른 관점의 의견을 듣고, 자신의 상황을 다시 바라볼 수 있다고 했었다. 어쩌면 지금 나에게도 "오히려 좋아"라는 관점이 필요할 때지 않을까 싶었다.

### 리팩토링 - 저주받은 프로젝트를 살리는 마지막 힘

두번째 발표는 실시간 협업 툴을 개발하는 잔디에 재직중이신 서민재님의 발표였다. 수습기간이 종료된 후 팀 내에서 저주받았다고 불리는 프로젝트를 맡게되는데,,, 라는 인트로를 듣자마자 기대감이 솓구쳤다. 발표하시는 말솜씨도 좋으시고 중간중간 집중이 느슨해질 타이밍에 적절하게 유머도 섞으셔서 너무 재밌게 들었던 발표로 기억에 많이 남는다. 만약 나도 발표를 한다면 민재님과 같은 호흡으로 가져가면 좋을 것 같다는 생각을 발표들으면서 했던 것 같다.

#### ⭐️ 인상깊었던 포인트

민재님의 발표 세션에서 가장 인상깊었던 점은, 리팩토링을 해나가는 과정에 있었다. 먼저 느낌으로 '막막하다'라는 것을 자연어로 풀어서 어떤 점이 어려운지 정의하고, 어려운 포인트를 하나하나 분석해나가면서 리팩토링 범위를 지정하는 모습이 가장 인상깊었다. 모든 문제는 정의하는 것이 가장 어렵다고 생각한다. 정의가 명확하지 않으면 뒤따라오는 풀이도 흐려지기 마련이다. 민재님의 경험담에서는 그것이 정말로 옳은지, 아닌지는 몰라도 정의가 확실하다는 점이 가장 인상 깊었다. 단계적으로 해결해야할 문제들을 직접 정의해나가는 것과 행위에 대한 성과를 글로 표현하려는 점이 인상 깊었다.

### 마라톤도 스프린트도 아닌, 일기

마지막 발표는 9시 백엔드-인프라 반상회에서도 발표를 해주신, 손영인님의 발표였다. 영인님 발표는 지난 9기 반상회에서도 너무 재밌게 들었어서 기억에 남아있었다. "모든 것은 트레이드 오프"라는 주제로 발표해주셨었는데, 10기의 발표에서는 어떤 내용들이 나올까 궁금해하면서 발표를 듣기 시작했었다. "마라톤도 스프린트도 아닌, 일기"라니,,

총 2가지의 주제와 4가지의 액션아이템을 소개해주셨다. 그 중 첫번째 주제는 '업무의 끝'이었다. 보통 업무의 시작에 많은 힘을 주지만, 업무의 끝에는 잘 신경쓰지 않게 된다. 업무의 끝을 어떻게 대할 수 있는지, 구체적으로 어떤 것들을 할 수 있는지 고민했던 포인트들을 액션아이템으로 제시해주셨다. 첫번째는 프로젝트를 다시 되돌아볼 수 있는 '칭찬스티커'와 삽질했던 기록들을 정리하는 '삽질로그'를 작성하는 것들이었다.

두번째 주제는 무언가를 알아가야하는, 학습과 관련된 주제였다. 이 주제와 관련해서는 '모두가 발표하는 스터디'와 '일기'라는 액션 아이템을 제시해주셨다. 그 중 '일기'에서는 40년차 프로그래머라는 블로거가 바라보는 프로그래밍과 관련된 지식을 배울때 가져볼만한 태도들을 설명해주셨다. 그 중 하나가 발표 제목인 '마라톤도 스프린트도 아닌, 일기'였다. 종종 개발 공부를 하다보면 끝도 없이 깊고 넓은 지식들로 인해 압도되는 경험을 몇번 한적이 있다. 아니 사실 거의 맨날하는 것 같다. 영인님은 블로거의 말에서 "결국에는 할 수 있음"을 느끼셨고 선택과 집중을 통해서 이러한 불안감을 다스릴 수 있었다고 하셨다.

#### ⭐️ 인상깊었던 포인트

영인님의 발표에서 인상 깊었던 것은 (+지난기수를 포함하여,,) 겪으셨던 경험을 메타인지적으로 잘 파악하고 계시는 것 같다는 느낌을 받았다. 그리고 발표를 듣고나서 생각해볼만한 거리들을 던져주신다는 것. 어떤 발표는 그냥 흘러가는 발표도 있는 반면에 영인님의 발표는 같은 주제에 대해서 생각해볼 수 있다는 점이 장점인 것 같다.

그리고 10기 발표에서는 나도 했던 고민들에 대해서 한번 적용해보고 싶은 액션아이템들도 있어서 기억에 남았었다.

## 네트워크 세션

발표가 마무리 된 이후에는 반상회 참여인원들과 각자 조를 이뤄 네트워크를 가졌다. 글또에서 슬랙으로 자주 뵙던 분들도 계셔서 속으로 반가웠었다. 운영진 분들께서 비슷한 도메인과 관심있는 주제로 여러 글또 분들을 묶어주신 것 같았다. 간단한 자기소개와 함께 현재 관심있는 분야와 글또이야기를 나눴다. 언제나 네트워크에서 아쉬운 것은 서로 이야기할 수 있는 시간이 많이 적었다는 것,, 다음 만남을 약속하면서 글또의 마지막 백엔드-인프라 반상회를 마무리했다.

![Desktop View](/assets/posts/review/geultto/geultto-backend-infra-seminar-24/seminar-gift.jpeg){: width="972" height="589" .w-50}_연말 꽃단장한 글또와 훈훈한 사은품까지_

## 반상회를 참여하고 나서

세 발표를 모두 듣고나서 다음과 같은 부분에서 나에게 질문들로 의미있게 다가왔었다.

- 나에게 후회없도록 살고 있는가?
- 나는 코드를 어떻게 바라보는가?
- 나는 어떻게 마무리를 짓고, 성장을 위해 어떤 고민들을 했나?

솔직하게 매 순간순간 후회없이 살았다고 자신있게 말은 못할 것 같았다. 하지만 나의 후회는 대부분 해보지 못한 것에 대한 후회가 많았던 것 같다. 내 단점이자 최고의 강점은 심사숙고하는 타입이다. 최대한 많은 부분들을 검증하려하고, 확인해보려 하다보니(대체로는 좋은 결과들이었지만, 이게 항상 좋은 결과를 가져다주진 않았음) 빠르게 실행을 해보지 못해서 오는 아쉬움들이었다. 올 한해는 최대한 실행력 있게 살아보기로 도전을 많이 했던 해인 것 같다. 커뮤니티에서 소모임을 운영해보기도 하고, 많이 모자라지만, 첫 앱도 스토어에 올려봤다. 내 성격을 잘 알게 된 것도 올 한해 가장 큰 수확이었던 것 같다. 나를 잘 이용해보다보면 점점 더 후회없는 하루를 살아가는 날들이 많아지지 않을까?

반상회 발표 덕분에 마무리와 끝을 대하는 법에 대해서 생각해보게 되었다. 하루의 끝, 한 주의 끝, 한 달의 끝, 프로젝트의 끝들을 나는 생각하거나 회고해봤던 경험이 그리 많지 않았던 것 같다. 구체적인 액션아이템까지 있어 시도해볼만한 것들을 적용해보고 내 방식에 맞추어서 적용해보려고 한다. 마침 연말이기도 하고 일단락된 프로젝트가 있어 적용해보려 한다.

- 만약 똑같은 프로젝트를 다시 처음부터 한다면?
- 다른 방법을 사용해 볼 수 있진 않았을까?


## 마무리!

현재 공식적인 글또 활동은 10기가 마지막이다. 따라서 이러한 반상회도 공식적으로는(?) 이제 마지막이다.
글또가 기수를 거듭하면서 시스템도 조금씩 새로 생기고 인원들도 많아지면서 분위기가 많이 바뀌었다곤 하지만, "조금 더 일찍 글또를 알았더라면"이라는 아쉬움과 "금번 기수가 마지막이 아니었더라면"이라는 두 가지 아쉬움이 남는 것 같았다.

그래도 끝을 잘 맺음해봐야 다음을 준비할 수 있다는 점을 반상회 발표를 통해서 깨달을 수 있었다.
아직 글또 활동이 마무리된 것은 아니지만, 다시 만날 글또를 기다리면서 현재 참여하고 있는 기수에 집중해야겠다.
