---
title: Dive INTO 가상화 그리고 컨테이너 기술부터 도커까지
author: codongmin
date: 2023-12-20 12:10:00 +0800
categories: [DevOps, 도커]
tags: [도커, 가상화, 하이퍼바이저, 컨테이너, diveinto]
---

## 들어가며

 도커는 DevOps함께 거의 대부분 IT 회사에서 필수적으로 사용하는 "컨테이너 기술"이 되었습니다. 뿐만 아니라 컨테이너 관리(Orchestration)하는 기술인 쿠버네티스도 컨테이너 기술과 함께 서비스를 배포, 운영하는데 있어 필수 기술로 자리잡으며 사실상 표준이 되었습니다. 때문에 DevOps 직무 뿐만 아니라 백엔드 개발 직군에서도 이에 대한 필요 기술로 요구하는 경우도 심심치 않게 보입니다. 

![Desktop View](/assets/posts/stackOverFlowServey.png){: width="972" height="589" .w-75}
_이미지 출처 : [StackOverFlow](https://survey.stackoverflow.co/2023/#most-popular-technologies-tools-tech)_

스택오버플로우의 2023 Developer Servey 중 기타 툴에 대한 서베이 항목입니다. 작년에 비해 한단계 올라서면서 가장 많은 사용자가 사용하는 툴로 자리 잡았습니다.

 최근 도커를 다시 공부해보고 있습니다. 이전 회사에서는 주로 VMware 가상머신을 주로 사용하고 간혹 테스트 환경을 구성할 때 도커를 띄워서 사용하곤 했었습니다. 처음 도커를 접했을때는 일단 쓰긴쓰는데 어떤 이유에서 쓰는 거야? 뭐가 좋은 거야? 에 대한 답변을 바로 내리기는 어려웠습니다. 이후에 VMware 를 같이 쓰면서 도커의 편리함에 감탄을 했었던 기억이 납니다. 이러한 경험을 떠올리며 도커를 공부해보기 위해 역사를 거슬러 올라가서 "가상화"에 대한 내용부터 차례대로 내려오며 도커 기술에 대한 이해를 높여봤습니다.

 도커 파일을 만들고 동작시키는 api와 사용 방법들은 도커에서 제공하는 docs가 훨씬 정확하기 때문에 여기서는 이에 대한 내용은 다루지 않습니다. 도커를 공부하며 도커가 탄생하게 된 배경과 역사, 왜 도커를 사용하는지, 도커가 왜 이렇게 인기 있는 기술이 되었는지 그 흐름과 배경을 정리하여 한번 설명해보고자 합니다. 


## Problem. 어떤 문제(배경)가 있었나 ? 

여기서는 도커에 대해 살펴보기전에 도커가 탄생하기까지의 여러 가상화 기술과 컨테이너 기술들이 탄생하게 된 배경에는 어떤 것이 있었는지 크게 2가지의 관점으로 나누어 살펴보고자 합니다. 이후에 이런 문제들을 어떻게 해결했는지, 그리고 그 기술들은 어떤 것인지 하나씩 짚어나가는 방식으로 서술하였습니다.

- 한정된 컴퓨팅 리소스로 인한 비효율성
- 유연하지 않은 소프트웨어 개발(배포) 프로세스

### <u>한정된 컴퓨팅 리소스(=리소스의 효율적 사용 욕구)</u>

**1. 하이퍼바이저 기반의 가상머신 기술의 발전**

 초기에는 한정된 컴퓨팅 리소스를 한계를 극복하는 것에 초점이 맞추어 기술이 발달하기 시작했습니다. 1960년대의 컴퓨팅 리소스는 현재에 비교하면 절망적일 정도로 열악했습니다. 컴퓨터의 물리적 크기도 집채만할뿐 아니라 지원할 수 있는 컴퓨팅의 성능도 매우 한정되어 있어, 주어진 제약조건 속에서 작업을 하기 위해서는 최대한 효율적으로 자원을 사용해야만 했습니다. 

![Desktop View](/assets/posts/whatIsVirtualization1.png){: width="972" height="589" .w-75}_이미지 출처 : [Redhat 가상화의 이해](https://www.redhat.com/ko/topics/virtualization/what-is-virtualization)_

 가상화 기술이 보편화되기 전에는 엔지니어가 하나의 OS에 의존하는 애플리케이션을 개발하여야 했습니다. 이런 개발 프로세스는 시간과 비용이 많이 소요되는 단점이 존재 했었습니다. 1964년 IBM에서 시분할 기술을 사용하는 메인프레임 시스템인 CP-40을 출시했습니다. 이를 통해 동시에 두 명 이상의 사람이 컴퓨터 리소스를 공유하여 사용할 수 있는 환경이 마련되었습니다. 그리고 이를 기반으로 얼마지나지 않아 최초의 하이퍼바이저가 탄생하여 하드웨어의 가상화를 제공하게 됩니다.

 1972년에 IBM은 System/370을 출시했습니다. 가상 메모리 지원 기능이 있는 시스템이었습니다. 이를 통해 가상화 기술은 상용화 단계로 나아가기 시작했습니다. 이 시기에는 하이퍼바이저가 포함된 가상 시스템들이 오픈소스 프로젝트와 되어 활발하게 개발되기 시작한 무렵이었습니다.

![Desktop View](/assets/posts/whatIsVirtualization2.png){: width="972" height="589" .w-75}
_이미지 출처 : [Redhat 가상화의 이해](https://www.redhat.com/ko/topics/virtualization/what-is-virtualization)_

 1990~2000년대 들어서는 가상화 기술을 활용한 서버의 컴퓨팅 리소스를 효율적으로 사용할 수 있는 다양한 솔루션들이 탄생하기 시작했습니다. 인지도 높은 VMware의 워크스테이션 솔루션이 출시되었으며, 현 AWS EC2의 기반기술이 된 Xen 오픈 소스 솔루션이 2003년에 출시되었습니다. 이후엔 VM의 관리(오케스트레이션)와 자동화 배포를 도와주는 툴들의 개발과 함께 풍성한 생태계가 구성되기 시작했습니다.

>  이후 개발된 다양한 가상화 기술들을 통해 기업들은 서버를 더 효율적으로 사용하여 서버 구매 비용을 줄이거나 유지관리 비용을 줄일 수 있었습니다.

**2. 컨테이너 기술**

컨테이너의 기술의 핵심 기술이라고 여겨지는 chroot 기능이 1979년 Unix V7 개발과 함께 탄생했습니다. 이는 프로세스의 루트 디렉토리를 재설정 함으로써 다른 프로세스의 엑세스 범위를 구분지을 수 있었습니다. 이러한 격리(Isolation)기술은 컨테이너 기술의 발전의 초석이 되었습니다.

> 이는 서로 다른 프로세스 간에 간섭이나 충돌을 최소화하면서, 한정된 리소스를 효율적으로 활용할 수 있도록 돕고, 이러한 아이디어는 현대의 컨테이너 기술과 같은 형태로 이어지, 더욱 효율적이고 격리된 환경에서의 리소스 관리를 가능케 하는 발판이 되었습니다.

### <u>유연하지 않은 소프트웨어 개발(배포) 프로세스</u>
**1. 하이퍼바이저 기반의 가상머신 기술의 발전**

1990년대에 들어서 회로칩의 발전과 컴퓨팅 리소스의 상승으로 높아졌지만, 대부분의 서비스 회사들은 하드웨어 서버와 하나의 IT 스택을 같이 사용하고 있었기 때문에 타 업체의 하드웨어 서버에서 레거시 프로젝트를 실행하기 어려웠습니다. 다양한 벤더가 제공하는 저렴한 상용 서버, 운영 체제, 애플리케이션으로 IT 환경을 업데이트하면서 기업은 사용률이 낮은 <u>물리 하드웨어에 종속</u>되었으며 각 서버에서 벤더별 태스크를 1개만 실행할 수 있었습니다.

> 가상화는 이러한 문제를 해결할 수 있었습니다. 가상화를 통해 기업은 서버를 파티셔닝하고 여러 유형 및 버전의 운영 체제에서 레거시 애플리케이션을 실행할 수 있게 되었습니다. 

이러한 장점 때문에 1990년대 초반에 몇몇 가상화 회사에서는 관리자를 더욱 효율적으로 가상화하기 위한 서비스와 소프트웨어를 출시했습니다. 1995년 Red Hat Software Inc.는 Linux 커널 기반 OS를 제공하는 Red Hat Commercial Linux의 첫 번째 일반 버전을 출시했습니다.

여담이지만 1991~6년 비슷한 시기 자바가 탄생 했습니다. 자바 역시 JVM이라는 가상머신위에서 동작함으로 OS에 구속받지 않는 환경을 장점으로 내세운 언어로 많은 사랑을 받았으며, 지금까지 많은 사람들이 사용하고 사랑하는 언어로 자리잡고 있습니다. 이런 특성을 미루어보았을때 가상화에 대한 시대적 요구가 컸음을 한번 짐작해봅니다.

1998년에는 VMware가 설립되었으며, 이듬해 회사는 첫 번째 제품인 VMware Workstation을 출시했습니다. Workstation은 x86 버전의 Windows 및 Linux OS에서 실행되는 유형 2 하이퍼바이저를 제공하여 관리자가 설정할 수 있도록 했습니다.각 VM은 자체 OS를 동시에 복제하고 실행할 수 있습니다. 나중에 VMware는 x64 버전에 대한 지원도 제공했습니다.

**2. 컨테이너 기술의 발전**

2000~2010년대에 들어 컨테이너 기술도 본격적으로 발전했습니다. 이러한 컨테이너 기술의 발전은 가상머신 기술보다 훨씬 적은 오버헤드로 애플리케이션 개발 및 배포 프로세스를 획기적으로 개선하고자 하는 필요성과 욕구와 함께 성장했습니다. 

![Desktop View](/assets/posts/containerHistory.png){: width="972" height="589" .w-75}_컨테이너 기술의 흐름_

- **FreeBSD Jails** 
  - 2000년 소규모 호스팅 업테에서 자사/고객 서비스를 분리하고 보안과 관리 용이성을 위해 FreeBSD Jail이 개발되었습니다. <u>FreeBSD Jails</u>  소위 "감옥"이라고 하는 여러 개의 독립적이고 작은 시스템으로 분할하고 각 시스템에 IP 주소를 할당할 수 있는 특징이 있었습니다.

- **Solaris Continers**
  - 이 기술에 "컨테이너"라는 명명이 사용되기 시작한 것은 2004년에 ZFS의 스냅샷 및 복제와 같은 기능을 활용할 수 있는 영역별 경계 분리와 시스템 리소스 제어를 결합한 <u>Solaris Containers</u>의 첫 번째 공개 베타가 출시였습니다.

- **Process Containers(cgroup)**
  - Process Containers (2006년 Google에서 출시)는 프로세스 모음의 리소스 사용량(CPU, 메모리, 디스크 I/O, 네트워크)을 제한 및 격리하기 위해 설계되었습니다. 1년 후 "<u>Control Groups(cgroups)</u>"로 이름이 바뀌었고 Linux 커널 2.6.24에 합쳐졌습니다.

- **LXC(LinuX Containers)**
  - 현재 컨테이너 기술의 시초라고 할 수 있는 <u>LXC(LinuX Containers)</u>는 Linux 컨테이너 관리자의 최초의 구현이었습니다. 2008년에 cgroups 및 Linux namespace를 사용하여 구현되었습니다.

- **Docker**
  - 2013년 <u>Docker</u>가 등장하면서 컨테이너의 인기가 폭발적으로 높아졌습니다. Docker는 컨테이너 기술의 성장과 사용을 견인하는 역할에 높은 기여를 하였습니다. Docker도 초기 단계에서 LXC를 사용했고 나중에 해당 컨테이너 관리자를 자체 라이브러리인 libcontainer로 교체했습니다. 이후에는 이러한 컨테이너들을 대규모 환경에서 오케스르레이션 할 수 있는 도구들이 탄생하게 되었습니다.

>가상머신보다 가볍고 빠른 특성을 가진 컨테이너 기술로 개발자들은 애플리케이션을 더욱 빠르게 배포하고 대규모 환경에서 컨테이너를 확장하고 관리함으로써 기존 대비 비약적으로 서비스의 개발 및 배포 프로세스에 대한 유연성을 확보할 수 있었습니다.



---

## Solution. 무엇을 해결해 주었는가? 

앞서 가상화 기술의 발전배경과 역사를 1.컴퓨팅 리소스와 2. 개발 프로세스 관점으로 살펴보았습니다. 초기에는 주로 컴퓨팅 자원의 효율적 사용과 따라 서버 관리에 대한 니즈에 맞물려 가상화 기술이 주를 이루며 발전을 했지만 2000년대에 들어서는 소프트웨어 개발과 배포 관점에서의 편의성과 운영 관리 관점에의 프로세스에 대한 관심과 필요성으로 인해 컨테이너 기반의 기술들이 주를 이루며 표준이 되어가고 있을만큼 그 인기가 날로 높아졌습니다.

다음과 같이 정리해볼 수 있을 것 같습니다.

1. **컴퓨팅 리소스의 효율적 사용:**
   - **하이퍼바이저 기반의 가상머신:**  <u>하나의 물리적 서버에서 여러 개의 가상머신</u>을 운영할 수 있도록 해줍니다. 이는 서버의 물리적 자원을 효율적으로 활용할 수 있게 하여, 여러 애플리케이션을 하나의 서버에서 실행하더라도 격리되어 작동할 수 있습니다. 이로써 서버 자원의 낭비를 최소화하고, <u>물리적 서버의 가용성</u>을 높일 수 있습니다.
   - **컨테이너 기술:** 컨테이너는 경량화되고 빠르게 실행되는 가상화 기술을 제공합니다. 가상머신과는 달리 컨테이너는 호스트 운영체제의 커널을 공유하므로 <u>시작 시간이나 자원 소비 등에서 더 경제적</u>입니다. 또한, 여러 개의 컨테이너가 하나의 운영체제를 공유하면서 실행되므로 가상머신에 비해 <u>더 적은 오버헤드</u>를 가지게 됩니다. 이는 빠른 배포와 확장이 가능하며, 자원의 효율적인 활용을 지원합니다.
2. **소프트웨어 개발(배포) 프로세스의 유연성 확보**
   - **하이퍼바이저 기반의 가상머신:** 가상머신은 애플리케이션을 가상 환경에서 실행하므로, 확장성이 용이합니다. 필요에 따라 가상머신을 늘리거나 축소하여 <u>리소스를 효과적으로 조절</u>할 수 있습니다. 또한, <u>가상머신 스냅샷</u>과 같은 기능을 통해 특정 상태를 저장하고 복원함으로써 시스템 복구 및 테스트에 유용하게 활용될 수 있습니다.
   - **컨테이너 기술:** 컨테이너는 애플리케이션과 모든 종속성을 포함하고 있어 이식성이 뛰어나며, 어디서든 <u>동일한 환경에서 실행</u>될 수 있습니다. 이는 <u>개발과 운영 간의 일관성</u>을 유지하고, 여러 환경에서 애플리케이션을 유연하게 이동시킬 수 있게 해줍니다. 또한, 컨테이너 오케스트레이션 도구를 활용하여 애플리케이션을 <u>자동으로 배포하고 관리</u>함으로써 비지니스 탄력성을 향상시킵니다.



---
## 하이퍼바이저 기반의 가상 머신이란?
### 가상화란

> 가상화란 **물리적** 개념을 **논리적** 개념으로 변환하여 구현하는 것

서버 뿐아니라 네트워크, 운영체제 등 모든 물리적인 개념을 논리적 개념으로 구현할 수 있다면, 그 이외의 것들도 가상화하는 것이 가능합니다. 

하드웨어 리소스를 가상화하면 관리자가 물리 리소스를 풀링할 수 있으므로 하드웨어의 범용성을 높일 수 있습니다. 유지관리 비용이 많이 들지만 중요한 애플레이션을 지원하는 레거시 인프라는 가상화를 통해 사용을 최적화할 수 있다는 장점이 있습니다.

![Desktop View](/assets/posts/virtualization.png){: width="972" height="589" }
_이미지 출처 : [VMware 'Virtualization Overview'](chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://www.vmware.com/pdf/virtualization.pdf)_

- 하나의 물리머신에서 복수의 시스템을 동시 운영할 수 있음
- 또 다른 cpu, 메모리, 하드디스크, NIC 등을 논리적으로 생성할 수 있음.
- 물리서버 단위가 아닌 애플리케이션 단위로 전환할 수 있음.




### 하이퍼바이저와 역할, 종류

하이퍼바이저(가상 머신 모니터)는 컴퓨터 하드웨어에서 **<u>다수의 운영체제와 애플리케이션을 실행</u>**하기 위해 추상화하여 격리하는 **<u>논리적 플랫폼</u>**을 의미한다. 물리적인 호스트 시스템 위에 설치되어 일종의 가상화를 위한 운영체제처럼 작동되며, 가상머신들이 하드웨어 리소스를 공유하여 사용할 수 있게끔 스케줄링하는 책임을 맡는 역할을 합니다.

 하이퍼바이저는 가상화 방법에 따라 분류됩니다. 

![Desktop View](/assets/posts/hypervisor.png){: width="972" height="589" }
_이미지 출처 : [[가상화] 하이퍼바이저와 가상화](https://suyeon96.tistory.com/52)_

||Type 1(Native/Bare Metal)|Type 2(Hosted)|
| :--: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| 내용 |  하이퍼바이저가 하드웨어 바로 위의 <br />레이어에서 작동하는 방식  | 하드웨어의 Host OS가 존재하고, <br />Host OS 위의 레이어에서 실행하는 방식 |
| 장점 | 별도의 OS가 없이 하드웨어에<br /> 바로 접근하므로, Type 2보다 오버헤드가 적음. |              가상의 하드웨어를 실행하므로, Host              |
| 단점 |        하드웨어를 제어/관리할 컴퓨터나 콘솔이 필요함.        | 하드웨어와 하이퍼바이저 중간에 Host OS가 존재하기 <br /> 때문에 Type1에 비해 오버헤드가 큼. |

![Desktop View](/assets/posts/HyperviseurType.svg.png){: width="972" height="589" .w-50}
_이미지 출처 : [위키피디아 하이퍼바이저](https://commons.wikimedia.org/wiki/File:Hyperviseur.svg)_

### 가상머신

 하이퍼바이저에 의해 생성되고 관리되는 **<u>논리적인 하드웨어 집합체</u>**입니다. BIOS와 CPU, 메모리, HDD, 네트워크 인터페이스 카드 등을 가지고 있습니다. 가상 머신 위에 설치되는 운영체제 입장에서는 실제의 물리적인 일반 시스템과 전혀 다를 바가 없으나, 실제로 이러한 가상 하드웨어들은 전부 일종의 파일 형태로 존재합니다.

![](https://t1.daumcdn.net/cfile/tistory/2751E74358D22F2F28)

보통 CPU, RAM, NIC 등 물리적인 리소스를 가지는 하드웨어 머신을 **<u>호스트 시스템</u>**(Host System, Physical Server 등)이라고 부릅니다. 그리고 하이퍼바이저에 종류에 따라 호스트 시스템위에서 작동하는 OS를 **<u>호스트 운영체제</u>**(Host Operating System 또는 줄여서 Host OS)로 부르며 가상머신 위에서 설치되어 운영되는 OS들을 **<u>게스트 운영체제</u>**(Guest Operating System 또는 줄여서 Guest OS)라고 부릅니다. 


**가상화 이전**에는 서비스를 운영하기 위한 Application들이 OS 단위에 올라가 있고, OS들은 CPU, memory, 디스크 같은 하드웨어 위에 있는 환경으로 구성되어 있습니다. 따라서 하나의 서버 - 하나의 Application(1:1) 형태로만 운영이 가능했었습니다.
- 개별 머신들이 보다 안정적인 환경에서 동작한다.
- 리소스 사용에 있어 비효율적이다.

**가상화 이후**에는 서비스를 운영하기 위한 Application들이 가상 머신위에 올라가게 되고(1:N) 각각의 가상 머신들에는 서로다른 OS를 운영할 수 있었습니다. 따라서 단일 서버에서 서로 다른 Application을 운영할 수 있는 환경이 만들어졌습니다.

- 효율적인 리소스 사용이 가능하다.
- 다양한 비지니스 목적을 충족시킬 수 있다.



---



## 컨테이너 기술이란?

컨테이너 기술은 전통적인 하이퍼바이저 기반의 가상머신 방식과는 느낌이 다릅니다. 컨테이너 기술은 기존의 가상 머신상의 게스트 OS에서 동작하는 프로세스 같아 보이지만, 실제로는 하이퍼바이저와 Guest OS에서 오는 **<u>오버헤드를 줄이기</u>** 위해 이 중간 단계를 없애고 **<u>격리된 환경</u>**처럼 실행되는 격리된 프로세스로 동작시키는 기술입니다. Host OS에서 동작하는 크롬이나, 타 프로세스들과 같은 레벨에서 동작하는 것과 같습니다.

 격리된 환경처럼 프로세스로 동작시키기 위해 개발된 다양한 코어 기술들이 컨테이너 기술을 발전시켰습니다.

그 처음은 **chroot**라고 해서 **사용자 격리**를 시작으로 **파일이나 네트워크를 분리**하는 기술이 개발되었습니다. 프로세스의 루트 디렉토리를 재설정함으로써 다른 프로세스와의 엑세스 공간을 구분지을 수 있었습니다.

이후  **Cgroup(control groups)**과 **네임스페이스(namespaces)**가 개발되었고, 이들은 컨테니어와 호스트에서 실행되는 다른 프로세스 사이에 벽을 만드는 **리눅스 커널** 기능들입니다. 

- Cgroup (Google에서 개발)

  - CPU, 메모리, Network Bandwith, HD i/o 등 프로세스 그룹의 **시스템 리소스 사용량을 관리**한다.

  - 예를 들어 특정 어플이 사용량이 너무 많다면, 해당 어플을 C group에 넣어 CPU와 메모리 사용 제한이 가능함.

  - 특정 애플리케이션을 위해 CPU, memory 자원을 할당해줌


- Namespaces (Red Hat에서 개발)

  - 하나의 시스템에서 **프로세스를 격리**시킬 수 있는 가상화 기술

  - 별개의 독립된 공간을 사용하는 것처럼, 격리된 환경을 제공하는 경량 프로세스 가상화 기술


프로세스를 격리 시켜주는 기술들이 만들어지면서 각각의 애플리케이션을 독립적인 환경에서 실행시킬 수 있게 되었습니다. 그로부터 몇 년후 이 기술들을 집약시켜 Linux 컨테이너 관리자의 최초의 구현체인 LXC(LinuX Container)가 탄생합니다.

![Desktop View](/assets/posts/lcx.webp){: width="972" height="589" }
_이미지 출처 : [Oracle Linux의 LXC 이해](https://forums.oracle.com/ords/apexds/post/understanding-lxc-and-docker-containers-on-oracle-linux-7995)_

그리고 LCX를 활용하여 세상에 탄생한 것이 바로 도커였습니다. 앞서 설명한 것처럼 도커 이전에도 컨테이너 기술(LCX)은 존재했습니다. 다만, 도커는 일반 사용자도 이를 잘 활용할 수 있도록, 계층화된 이미지와 간편한 CLI, 컨테이너 이미지 저장소 같은 기능들을 추가하여 선보였습니다.

 마치 마이크로소프트의 윈도우 운영체제가 GUI와 함께 사용자 친화적인 높은 접근성으로 시장에서 점유율을 높인 것처럼 도커도 비슷한 맥락으로 볼 수 있을 것 같습니다.(물론 윈도우가 점유한던 다른 요소들도 존재한다) 윈도우 이전에도 운영체제는 존재 했지만, 일반 사용자가 사용하기에 적합한 접근성과 인터페이스를 제공함으써 경쟁력을 높인 것과 유사합니다.

### 컨테이너 기술의 장점

- **자원 격리 및 보안 강화**: 컨테이너는 가상화 기술을 사용하여 응용 프로그램 간에 자원을 격리시키고, 호스트 시스템으로부터 <u>격리된 실행 환경을 제공</u>합니다. 이로써 응용 프로그램 간 간섭을 방지하고 보안을 강화할 수 있습니다.
- **효율성 및 이식성 향상**: 컨테이너는 응용 프로그램과 그에 필요한 모든 <u>종속성을 포함</u>하므로, 어디서든 쉽게 실행되고 이식될 수 있습니다. 이는 개발 및 운영 효율성을 향상시키며, 다양한 환경에서 <u>일관된 동작</u>을 가능케 합니다.
- **빠른 배포 및 확장성**: 컨테이너는 가벼우며 빠르게 시작되므로, 응용 프로그램을 <u>빠르게 배포하고 확장</u>할 수 있습니다. 이는 개발자들에게 신속한 피드백 제공과 서비스 확장에 큰 도움을 줍니다.
- **클라우드 환경과의 통합**: 컨테이너는 클라우드 환경에서 자주 사용되며, 다양한 클라우드 서비스와 통합될 수 있습니다. 이는 유연한 클라우드 네이티브 애플리케이션 개발을 가능케 하며, 마이크로서비스 아키텍처의 채택을 촉진합니다.
- **오픈소스 생태계의 성장**: Docker 및 Kubernetes와 같은 주요 컨테이너 기술들은 오픈소스로 개발되었고, 활발한 커뮤니티에 의해 지원되고 발전되고 있습니다. 이는 다양한 기업과 개발자들이 이 기술들을 채택하고 기여하게끔 만들었습니다.

---



## 도커란? 

![Desktop View](/assets/posts/01-primary-blue-docker-logo.png){: width="972" height="589" .w-75}
_이미지 출처 : [도커](https://www.docker.com/company/newsroom/media-resources/)_

컨테이너 기술을 사용하여 애플리케이션과 런타임 환경을 더 쉽게 만들고 실행하고 배포할 수 있도록 지원하는 도구입니다. 

**컨테이너** 안에 다양한 규격화된 물건들을 넣어 옮기듯이 마찬가지로 컨테이너를 사용하면 다양한 프로그램, 실행환경을 컨테이너로 추상화하고 동일한 인터페이스를 제공하여 프로그램의 배포 및 관리를 단순하게 해줍니다.

### 이미지와 컨테이너

도커 이미지란 코드, 런타임, 시스템 도구, 시스템 라이브러리 및 설정과 같은 **응용프로그램을 실행시키는데 필요한 모든 것을 포함하는** 가볍고 독립적이며 실행가능한 **소프트웨어 패키지**를 의미합니다.

그리고 컨테이너는 이러한 이미지(코드와 모든 종속성 & 실행환경 등을 패키지화)를 기반으로 빌드되고 애플리케이션을 서로 다른 컴퓨팅 환경에서도 빠르고 안정적으로 실행되는 소프트웨어의 표준 단위가 됩니다.

이런 이미지와 컨테이너의 관계는 프로그래밍 언어에서의 클래스와 인스턴스 관계와도 비슷하게 볼 수 있습니다. 이미지는 하나의 공유 가능(Sharable)한 추상적(abstract) 패키지 / 컨테이너는 이미지의 구체적인(concrete)한 실행 인스턴스


#### 도커 이미지 작동방식

- 도커파일로 생성된 이미지는 정확히 도커 파일에 작성된 커맨드 대로 동작을 하여 빌드됩니다. 그렇게 빌드된 도커 이미지는 빌드된 당시의 소스코드(애플리케이션)을 기반으로 합니다. 일종의 (소스코드 + 런타임 환경)**스냅샷**의 기능을 하게 되는 셈입니다.
- 따라서 이미 생성된 도커 이미지의 파일 시스템은 새롭게 수정(write)가 불가능하고 **오직 읽기(read only)만 가능**합니다.
- 만약 소스코드에 변경사항이 생겨 이를 반영해야 한다면, 기존에 빌드한 도커 이미지를 수정하는 것이 아닌, 새로운 도커 이미지를 생성해야합니다.



#### 이미지 레이어

![Desktop View](https://yqintl.alicdn.com/8e24f8f6608d9c81b68cb70e887f68ed03e2353b.png){: width="972" height="589" .w-75}
_도커 이미지 레이어_
도커 이미지는 기본적으로 레이어라는 개념을 가집니다. 레이어 개념을 도입함으로써 얻는 이득은 빌드시간의 단축과 데이터 자원의 효율적 사용입니다.

>레이어란?
>
>**파일시스템의 변경사항을 캡쳐하는 단위**, 스냅샷의 단위 개념으로 이해
>위에서 도커 이미지를 일종의 스냅샷에 비유, 여러 개의 레이어들(스냅샷 단위)이 합쳐진 것이 이미지(스냅샷)

- 도커 이미지는 union file system의 기반으로 동작한다.
- 서로 다른 레이어는 다른 이미지에 재사용될 수 있다. 
- 수정가능한 컨테니어 레이어는 새로운 이미지 레이어가 될 수 있다.

---

## 가상머신 VS 도커

![Desktop View](https://mblogthumb-phinf.pstatic.net/MjAyMDA1MDVfMTE0/MDAxNTg4NjY1ODIyNTcx._FcvmTEsMfxEFdq7L7R-fycjydfPOIf26pZ3EJlrDGQg.JCxNWy6dNo1q5BreeeTXshpmQcRiZ1NJ5MV4FHUL4mwg.PNG.sky00141/image.png?type=w800){: width="972" height="589" .w-50}
_가상 머신과 도커 컨테이너_

그렇다면 기존의 가상머신 기술에 비해 현재 도커의 컨테이너 기술이 더 각광받는 이유는 무엇일까요? 크게 두가지로 분류해서 말씀드릴 수 있을 것 같습니다. 

- 성능 (속도, 리소스 등)
- 애플리케이션 관리 프로세스의 편의성 (배포, 운영 등)


### 성능

하이퍼바이저 기반의 가상머신과 도커의 컨테이너 방식을 비교했을 때, 컨테이너는 하이퍼바이저, 게스트 OS가 필요하지 않으므로 비교적 더 가볍습니다.(=오버헤드가 더 적다).

가상머신은 애플리케이션을 실행하기 위해서 VM을 띄우고 자원을 할당한 다음, 게스트 OS를 부팅하여 어플리케이션을 실행해야 해서 훨씬 무겁고 복잡하게 실행됩니다. 이때 가상화한 게스트 OS 모두 호스트 OS 입장에서는 다 일종의 프로세스이기 때문에 컴퓨팅 리소스를 더 사용하는 것과 마찬가지입니다.

다음 논문은 가상머신과 도커 컨테이너과의 다양한 성능 테스트를 통해 이를 증명합니다. 아래 내용은 가상머신과 도커의 성능을 비교 연구한 논문에서 가져온 내용입니다. 

> [Performance Evaluation of Docker Container and Virtual Machine](https://www.sciencedirect.com/science/article/pii/S1877050920311315)
{: .prompt-info }


본 연구에서는 Sysbench, Phoronix, Apache benchmark 도구를 사용하여 KVM과 Docker를 시험 평가한 결과를 보여줍니다. CPU 성능, 메모리 처리량, 스토리지 Read/Write 등을 테스타합니다. Intel Xenon E5-2620 v3 프로세서 2개, 2.40GHz, 총 12개 코어 및 64GB RAM을 갖춘 HP 서버에서 동일한 조건을 맞추어 진행되었습니다. 

> 더 자세한 실험 환경과 방법은 논문을 참고바랍니다. 
{: .prompt-warning }

#### CPU

![Desktop View](/assets/posts/CPUTest1.png){: width="972" height="589" .w-75}_최대 소수 연산 속도 비교_

CPU의 연산 성능을 비교하기 위해 최대 소수 연산에 필요한 시간을 측정한 테스트 입니다. 도커 컨테이너와 가상머신을 비교하였을때 작업을 수행하는데 있어 도커가 훨씬 적은 시간이 소요되는 것을 볼 수 있습니다. 이는 하이퍼바이저의 존재여부에 따른 결과로 보입니다.

![Desktop View](/assets/posts/CPUTest2.png){: width="972" height="589" .w-75}_Zip 압축 속도 비교_

10GB의 파일 크기를 압축하는데 필요한 시간을 측정한 압축 속도 비교 결과입니다. 대량의 파일 압축을 수행할때, 도커 컨테이너의 성능이 가상 머신에 비해 훨씬 빠른 것으로 나타났습니다.

#### Memory

![Desktop View](/assets/posts/memoryTest.png){: width="972" height="589" .w-75}_메모리 성능 비교_
메모리 성능을 측정하는 데 필요한 4개의 하위 테스트(복사, 크기 조정, 추가, 트라이어드(추가 + 크기 조정 조합))로 이루어집니다. 데이터를 복사하고 크기를 늘리고, 조정하는 작업들의 성능을 측정하는 지표들에서 도커 컨테이너가 가상머신에 비해 압도적인 성능을 보여줍니다.

#### Disk I/O

![Desktop View](/assets/posts/diskIoTest.png){: width="972" height="589" .w-75}_Full screen width and center alignment_
하드디스크의 읽기/쓰기 성능을 측정하기 위해 레코드 크기 1MB, 파일크기 4GB를 기준으로 가상머신의 디스크 I/O 성능이 도커 컨테이너의 성능 대비 54% 이상 낮은 모습을 보여줍니다.

### 편의성

도커는 이러한 성능 차이 뿐아니라 성능에서오는 특성으로 인해 개발 및 배포 환경이 가상머신보다 편의성이 높습니다.

 컨테이너는 개발하고자 하는 애플리케이션과 그에 필요한 모든 의존성, 런타임 환경을 모두 포함하기 때문에 다른 환경에서도 쉽게 실행되고 이식될 수 있습니다. 이는 개발 시에 애플리케이션의 동작의 재현성을 보장해줌으로 개발 단계에서의 편의성을 보장해 줄 수 있습니다. 또한 가상머신에 비해 가볍고 빨라 배포 및 테스트에 유리합니다.


### 비교

|             | 가상머신              | 도커 컨테이너       |
| ----------- | --------------------- | ------------------- |
| 격리 수준   | 하드웨어              | 운영체제            |
| 운영 체제   | 공유하지 않음         | 공유함              |
| 실행시간    | 김                    | 적음                |
| 생성시간    | 몇 분                 | 몇 초               |
| 크기        | 큼 (GB 단위)          | 작음 (MB 단위)      |
| 이미지 구축 | 구축 및 관리가 어려움 | 구축 및 관리가 용이 |

- 가상 머신(VM)

  - VM와 내부에서 실행되는 모든 프로세스는 Host OS또는 Hypervisor와 독립되어 있음.
  - 가상 머신 플랫폼은 특정 VM(VM1)에 대한 가상화 프로세스를 관리하는 프로세스를 시작, Host OS는 그 하드웨어 자원을 일부 VM에 할당
  - 컨테이너와 다른 것은 VM 환경을 위해, 해당 VM만을 위한 커널을 부팅, 운영체제 프로세스 세트를 시작한다는 점
  - OS가 포함되어 컨테이너보다 VM의 크기가 훨씬 크다. (GB단위)
  - 애플리케이션을 띄우기까지 과정이 오래걸리고 복잡하다. 
  - OS까지 가상화 (맥에서 윈도우, 리눅스에서 윈도우를 돌리는)
  - 추가적으로 필요한 기능을 위해 VM 머신 벤더들에게 라이센스 비용을 지불해야 하기도 한다.
  - VM간에 완벽하게 격리되어 안정성이 높음
  - 사용법은 간단하지만 굉장히 느림


- 도커 컨테이너

  - 동일한 HostOS를 사용하므로 각 컨테이너마다 **동일한 커널**을 공유한다. (컨테이너가 제공하는 격리 기능 내부에 샌드박스가 있지만,)
  - 결과적으로 컨테이너 내부에서 실행되는 프로세스는 Host OS에서 확인이 가능함. (모든 프로세스를 나열할 수 있는 충분한 권한이 Host OS에 있음)
  - 컨테이너는 전체 OS를 내장할 필요가 없어서, 가볍고 일반적으로 5-100MB 크기를 가짐.
  - 컨테이너를 띄우는데 까지 걸리는 시간이 매우 빠르다.
  - 호스트 OS에 문제가 생기면 모든 컨테이너에 영향을 미친다.

---

## 마무리하며

앞서 살펴본 것과 같이 하이퍼 바이저 기반의 가상머신과 컨테이너는 각각의 시대에 맞게 발전하고 운영되고 확장되어 왔습니다. 
초기에는 가상머신을 기반으로 컴퓨팅 리소스를 효율적으로 사용하고자 노력하였고, 다양해지는 비지니스 구조와 요구사항을 반영하고 성능을 충족시키기 위한 노력들로 컨테이너 기술들이 발전해왔고 각광받아왔습니다. 가상 머신과 도커를 비교하며 두 기술과 차이를 이해하고, 상황에 맞는 기술을 선택하는 것에 있어 고려해볼만한 힌트들을 얻었습니다.

현재는 도커와 같은 컨테이너 뿐 아니라 대규모의 컨테이너를 조율하는 오케스트라 툴인 쿠버네티스에 맞추어 컨테이너의 표준이 정립되고, 이를 보조하는 수많은 기술들이 계속 탄생하고 발전되고 있습니다. 
앞으로 새로운 기술들을 접하고 사용하는 데 있어 이 글이 조금이라도 이해를 도와줄 수 있는 글이 되길 바라며 마칩니다.

<br>
---
## 참고자료

- [가상화(Virtualization)란?](https://www.redhat.com/ko/topics/virtualization/what-is-virtualization)
- [A Brief History of Containers: From the 1970s Till Now](https://blog.aquasec.com/a-brief-history-of-containers-from-1970s-chroot-to-docker-2016)
- [Understanding LXC and Docker Containers on Oracle Linux](https://forums.oracle.com/ords/apexds/post/understanding-lxc-and-docker-containers-on-oracle-linux-7995)
- [Performance Evaluation of Docker Container and Virtual Machine](https://www.sciencedirect.com/science/article/pii/S1877050920311315)
- [가상화 주요 용어 출처](http://www.virtual-space.co.kr/virtualization.html)
- [가상화란 ? Redhat](https://www.redhat.com/ko/topics/virtualization/what-is-virtualization)
- [[가상화] 하이퍼바이저와 가상화 ](https://suyeon96.tistory.com/52)
- [하이퍼바이저(Hypervisor) 종류 정리 (feat. 전가상화, 반가상화)](https://m.blog.naver.com/PostView.naver?blogId=sharedrecord&logNo=222633834165&categoryNo=34&proxyReferer=)
- [VMware](https://www.vmware.com/kr/topics/glossary/content/hypervisor.html)
- [[쿠버네티스] 컨테이너 한방 정리 #3](https://www.inflearn.com/blogs/3576)
- [흔들리는 도커(Docker)의 위상 - OCI와 CRI 중심으로 재편되는 컨테이너 생태계](https://www.samsungsds.com/kr/insights/docker.html)