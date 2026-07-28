---
layout: post
# published: false = 미발행 / true = 발행
published: true
title: 오케스트레이터 함수에서 호출 여부를 검증하고 싶을 때
description:
tags: [test, mock]
stage: draft
---

<!-- 핵심 요약 -->

`unittest.mock`의 Mock 검증 메서드

| 확인하고 싶은 것 | 쓰는 메서드 |
|---|---|
| 호출됐나? | `assert_called()` |
| 호출 안 됐나? | `assert_not_called()` |
| 정확히 1회 호출됐나? | `assert_called_once()` |
| 특정 인자로 호출됐나? | `assert_called_with(인자)` |
| 특정 인자로 정확히 1회 호출됐나? | `assert_called_once_with(인자)` |


```python
from unittest.mock import Mock

mock_func = Mock(return_value="data")   # 호출되면 "data"를 반환하는 가짜 함수

mock_func.assert_not_called()           # 아직 호출된 적 없다

mock_func("some_arg")                   # 테스트 대상 코드 안에서 호출됐다고 치면

mock_func.assert_called()                       # 호출됐다
mock_func.assert_called_once()                  # 정확히 1회 호출됐다
mock_func.assert_called_with("some_arg")        # 이 인자로 호출됐다
mock_func.assert_called_once_with("some_arg")   # 이 인자로 정확히 1회 호출됐다
```

---


<!-- 언제 이게 필요했는지 한두 문장 -->

주로 순수 함수(하나의 기능을 하는 함수)가 아닌, 특히 무언가 다른 함수들을 조립해서 흐름을 만드는 목적의 함수를 테스트할 때 무엇을 테스트 해야하는지 처음봤을때 막막했다. 
이런 성격의 함수는 특정한 인풋값에 대한 아웃풋 결과 값이 없는 경우들도 많아 처음보면 뭘 테스트 해야하는지 감이 안온다. 

그럴때는 주로 의도했던 순서가 잘지켜지는지, 함수간에 전달되는 데이터가 잘 전달되는지 테스트를 한다.
이때, 파이썬 테스트 프레임워크인 unittest에서 지원하는 Mock 객체를 활용할 수 있다. 

예를 들어 다음과 같은 예시 코드가 있다고 할 때, 

```python
def run_pipeline(extract, transform, load):
    data = extract()
    if not data:
        return
    cleaned = transform(data)
    load(cleaned)
```

처음 이런 코드를 보면 테스트하기 좀 막막해진다. (코드는 클로드에게 예시를 달라고 했다)
이 함수는 인자들은 있는데 return 값이 없어, 뭘 assertions 해야하지 하는 생각부터 든다. 

이 `run_pipeline` 함수가 무슨역할을 하는지 한줄로 적어보면 이런 느낌같이 느껴진다. 

>  `extract`, `transform`, `load` 함수들을 인자로 받아 이를 순차적으로 수행하는 역할을 해주는 일종의 오케스트레이터 함수

코드를 보면, `extract` 함수의 리턴값의 존재 유무에 따라, 분기되어 뒤 `transform`, `load` 함수들을 실행하거나 하지 않는다.
`run_pipeline` 함수에서 나올 수 있는 실행 흐름은 2가지정도 될거같다.

1. `extract`의 리턴값이 없으면 if 문에 따라서 return 된다.
2. `extract`의 리턴값이 존재하면 아래 `transform`, `load`를 호출한다.

어차피 코드대로 흘러가는거 아닌가? 뭔 분기문을 왜 테스트하고 있어, 뭘 이런걸 테스트하지라는 생각이 들기도 했는데,   
이는 "코드의 실행 순서를 테스트한다"라는 시선에서 바라보면 그렇게 보이는 것 같다.

"내가 설계한 시나리오대로 데이터가 누수 없이 의도한대로 흘러가는가를 테스트한다"라고 생각하면 조금 다르게 보인다. 

1. `extract`에서 추출한 데이터가 없을 경우에는 `transform`, `load` 함수에 전달할 데이터가 없어 호출하지 않는다.
2. `extract`에서 추출한 데이터를 `transform`에 전달하고, 전처리된 데이터를 `load` 함수에게 정상적으로 넘겨준다.


```python
def run_pipeline(extract, transform, load):
    data = extract() # extract의 반환값을 어떻게 내 마음대로?
    if not data:
        return
    cleaned = transform(data)
    load(cleaned)
```

이때 여기서는 `extract`나, `transform`, `load` 함수들의 동작을 실제로 호출하여 테스트하지는 않는다. 그건 그 함수의 단위테스트에서 다룬다. 
따라서 위 관점에서 1번을 테스트하려면 `extract`가 추출한 데이터가 없는 상황을 모방해야한다.  
이때 Mock 객체를 활용할 수 있다. Mock 객체로 실제 extract 함수를 호출하는 대신 동작을 흉내낼 수 있다.

Mock 객체를 생성할 때, `return_value` 인자로 원하는 반환값을 반환하도록 모킹이 가능하다.

```python 
from unittest.mock import Mock

def test_추출데이터가_없으면_변환하지_않는다():
    mock_extract = Mock(return_value=[])
    mock_transform = Mock()
    mock_load = Mock()

    run_pipeline(mock_extract, mock_transform, mock_load)
    
    mock_extract.assert_called()
    mock_transform.assert_not_called()
    mock_load.assert_not_called()
```

이때 실제로 mocking한 함수가 호출되었는지 assert하려면 mock 객체의 `assert_called` 를 호출하면 된다. 
내부에 `raise AssertionError` 가 있어 별도의 assert문을 사용하지 않아도 된다. 

호출되지 않았음을 확인하려면 `assert_not_called` 를 호출하면 된다.

```python
def test_추출데이터가_있으면_변환_후_적재한다():
    mock_extract = Mock(return_value=["raw"])
    mock_transform = Mock(return_value=["cleaned"])
    mock_load = Mock()

    run_pipeline(mock_extract, mock_transform, mock_load)

    mock_extract.assert_called_once()
    mock_transform.assert_called_once_with(["raw"])      # extract가 추출한 데이터가 그대로 전달됐나
    mock_load.assert_called_once_with(["cleaned"])       # transform이 전처리한 데이터가 그대로 전달됐나
```

만일 해당 함수가 실행중에 정확히 한번 호출되었는지 확인하고 싶다면 `assert_called_once`를 호출한다.  
여기에 넘겨지는 인자까지 같이 확인을 하고 싶다면 `assert_called_once_with`. 이름이 직관적이라 금방 와닿는다. 

Mock 객체에 지정해준 `mock_extract.return_value` 로 실제 지정해둔 값을 반환받을 수 있다.


나름대로 정리해보면 위와 같은 오케스트레이터 함수에 대한 테스트는 주로 다음과 같은 의의를 갖는다고 생각한다. 

1. 실제 코드에 의도했던, 프로세스대로 수행이 되는지, 흐름에 대한 검증 목적이 있을 수 있다.  
    - 내가 의도한 대로 흐름이 동작한다 라는 것을 테스트를 통해 검증할 수 있다. 
    - 만일 예외처리 코드가 있다면 예외도 의도한대로 처리되는지 흐름 검증이 가능하다. 
2. 함수간 데이터의 전달이 잘되는지?
    - 이런 함수들의 특징은 서로 데이터를 주고 받는다는 것. 
    - 위의 이유와 함께 데이터의 흐름에 대해서 검증하는 것도 의미가 있다.
3. 실제로 실행비용의 절감
    - 매번 전체 흐름을 돌려가며 테스트하기엔 비용을 아낄 수 있다.
    - 현재는 예시코드가 단순해서 그렇지, 만일 실제 실행함수가 외부 시스템을 호출하거나하면, 실행이 불가하거나, 원하는 테스트 상황을 만들기 힘들수 있다.
4. 그냥 이 테스트 자체가 문서. 
    - 이 테스트를 보면 어떤 흐름으로 가는지 코드보는 것보다 빠를 수 있다. 
    - 나중에 이 코드가 변경될 때 내 의도를 미래세대에 전달해줄 수 있다.


---

만일 다음과 같이 인자로 받는 값이 없는 경우에는 어떻게 확인할 수 있을까?

```python
def run_pipeline():
    data = extract()
    if not data:
        return
    cleaned = transform(data)
    load(cleaned)
```

