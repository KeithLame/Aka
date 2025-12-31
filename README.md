# DoT

## ⚠️ Commit Convention ⚠️
```
- feat 		: 기능 추가
- docs 		: 문서 수정
- clean 	: 불필요한 코드 정리 / 버그 수정
- refactor 	: 코드 리팩토링
- create    	: 파일 생성/추가
- delete    	: 파일 제거
```

<p align="center">
	<img src = "https://github.com/DONOTINTO/DoT/assets/123792519/bae7f678-e82e-400e-9f87-e21b38558161" align="center" width="19.5%">
	<img src = "https://github.com/DONOTINTO/DoT/assets/123792519/060e8778-49a8-4934-a0a3-1ca563ede733" align="center" width="19.5%">
	<img src = "https://github.com/DONOTINTO/DoT/assets/123792519/bb7f3e3f-5bbc-4e05-b610-5226f0ccda9c" align="center" width="19.5%">
	<img src = "https://github.com/DONOTINTO/DoT/assets/123792519/7fd52e82-12d3-4a45-8563-5cd736cb4dc6" align="center" width="19.5%">
	<img src = "https://github.com/DONOTINTO/DoT/assets/123792519/5d00ca7c-9d87-4f37-b411-f0d385e0353c" align="center" width="19.5%">
</p>

## COLOR RGB
 - Black: 39/255 39/255 39/255
 - White: 241/255 241/255 241/255
 - Gray: 132/255 132/255 132/255
 - Blue: 0/255 96/255 209/255


## 앱 소개 및 기능
프로젝트 기간 : 2024.03.08 ~ 

- 여행에 필요한 예산 및 지출을 관리함과 동시에 여행 기록을 저장
- **Configuration** : 최소버전 16.0 / 세로모드 / 아이폰용 / 라이트 모드
- **v1.0 기능** : 환율 정보 / 예산 설정 / 지출 기록 / 여행 기록 저장
- 업데이트 : 공유, 검색, 다크 모드, 로그인, 위치 검색 및 저장


## 핵심 기능
- **환율 정보 |** API 통신 일 별 환율 정보 및 최근 환율 비교
- **예산 설정 |** 여행 예산 설정 시 적용된 환율 계산
- **지출 기록 |** 예산에서 지출 합계 계산, Realm을 통해 지출 금액, 사진, 품목, 메모 저장
- **여행 기록 |** List로 지출 기록을 모두 저장


## 기술 스택
**iOS(Swift)**
- **프레임워크**
    - UIKit - Code Base
- **라이브러리**
    - Snapkit(codebase UI)  / Realm / Alamofire / Kingfisher / PhotosUI / PHPickerConfiguration
    - UICollectionCompositional Layout / 
- **디자인 패턴**
    - MVC / MVVM / SingleTon / Delegate
- **버전 관리**
    - Git / Github / Github Desktop


## API
[Open API 제공목록_Open API 제공목록 - 상세 : 한국수출입은행 메인한글홈페이지](https://www.koreaexim.go.kr/ir/HPHKIR020M01?apino=2&viewtype=C&searchselect=&searchword=)

한국수출입 은행

- 일일 1000회 콜 수 제한
- 현금 환전 시 예상 금액: 원금 + (원금 1.75%)

- URL: https://www.koreaexim.go.kr/site/program/financial/exchangeJSON
- query:
    - authkey - ""
    - searchdate - 날짜 (format ex - 20240223)
    - data - AP01
- 응답

```json
[
	{
		"result": 1,
		"cur_unit": "USD",
		"ttb": "1,317.69",
		"tts": "1,344.31",
		"deal_bas_r": "1,331",
		"bkpr": "1,331",
		"yy_efee_r": "0",
		"ten_dd_efee_r": "0",
		"kftc_bkpr": "1,331",
		"kftc_deal_bas_r": "1,331",
		"cur_nm": "미국 달러"
	}
]
```


## 공수 산정
| Index | Sub Index | (UI/Feat) | Contents | DeTail | Expect | Actual |
|:-:|:-:|:-:|:-:|:-| :-: | :-: |
| **1** | | Feat | 부모클래스 | 부모 클래스 생성하여 자주 사용하는 프로퍼티/메소드 미리 지정 | 1 H | 30M |
| **2** | | Feat | Realm Manager | Realm 객체를 관리하는 매니저 생성 및 Realm의 CRUD 관리 | 5 H | 1H |
| **3** | | Feat | API Manager | API 호출 객체, API를 호출하는 메인 기능 관리 | 3 H | |
| **4** | | Feat | API Model | API 응답으로 온 JSON에 맞추어 데이터를 Decode할 모델 생성 | 3 H | |
| **5** | | Feat | Consts | Literal 문자열 저장 및 고정으로 사용하는 데이터 저장할 객체 | 3 H | 2 H |
| **6** | | Feat | Util | 각 종 편의성(Formatter 등)과 관련된 기능 코드들 작성 | | |
| | **6 - 1** | | | Date Util | 3H | 4H |
| | **6 - 2** | | | Number Util | 1H | 1H |
| **7** | | Feat | FileManager | 이미지 저장을 위한 FileManager 객체 생성 및 이미지 저장 및 호출 관리 | 6 H | |
| **8** | | Feat | Model | Model 객체 생성 및 기능 관리 | | |
| | **8 - 1** | | | Observable - ViewModel에서 사용할 관찰자(값 변화 탐지용) | 1H | 30 M |
| | **8 - 2** | | | TripInfoRepository - Realm 데이터베이스 모델 | 30 M | 30 M |
| | **8 - 3** | | | DashboardCompositionalLayout - 레이아웃 | 3 H | 3H |
| **9** | | Feat | ViewModel | View에 필요한 데이터 처리 및 기능 관리 | | |
| | **9 - 1** | | | CreateTrip ViewModel | 3H | 4H |
| | **9 - 2** | | | Dashboard ViewModel | 3H | 2H |
| | **9 - 3** | | | Calendar ViewModel | 3H | 3H |
| **10** | | UI | View | View 객체 생성 및 화면 그리기 | | |
| | **10 - 1** | | | Dashboard View | 3H | 1H |
| | **10 - 2** | | | CreateTrip View | 2H | 1H 30M |
| | **10 - 3** | | | Calendar View | 1H | 1H |
| **11** | | Feat | ViewController | ViewController 객체 내 View, ViewModel 관리 및 처리 | | |
| | **11 - 1** | | | Dashboard VC | 4H | 3H |
| | **11 - 2** | | | CreateTrip VC | 4H | 6H |
| | **11 - 3** | | | Calendar VC | 2H | 4H |
| **12** | | UI/Feat | Cell | Cell UI 및 기능 관리 | | |
| | **12 - 1** | | | IntroCollectionViewCell | 1H | 1H |
| | **12 - 2** | | | CalendarCustomCell | 2H | 4H |
| | **12 - 3** | | | ExchangeRateCell | 3H | 1H |
| | **12 - 4** | | | ExchangeRateHeaderCell | 2H | 2H |
||||||**101 H**||

## 데이터베이스 구조

환율 정보(ExchangeRate)

| Date(PK - Date) | cur_unit(String) | deal_bas_r(String) | cur_nm(String) |
| --- | --- | --- | --- |

여행 정보(TripInfo)

| ID (PK - Object ID) | 여행 제목(String) | 인원(Int) | 통화(String) | 예산(Double) | 시작일(Date) | 종료일(Date) | 세부 기록(FK)[TripDetailInfo.id] |
| --- | --- | --- | --- | --- | --- | --- | --- |

여행 세부 기록(TripDetailInfo)

| id(PK - Object ID) | 지출(Double) | 카테고리(Enum) | 사진(UIImage?) | 메모(String?) | 날짜(Date?) | 맵 정보(FK)[MapInfo.id?] |
| --- | --- | --- | --- | --- | --- | --- |

맵 정보(MapInfo)
| id(PK - Object ID) | identifier(String) | latitude(Double?) | longitude(Double?) |
| --- | --- | --- | --- |


## Iteration
### Iteration - 1 ( 3월 4일 ~ 3월 7일)
- 프로젝트 기획
- 디자인
- Database 설계
- 프로젝트 생성
- 프로젝트 기본 세팅
- 공수산정 작성
- UI(피그마) 수정
- 앱 아이콘 및 리소스 정리

### Iteration - 2 ( 3월 8일 ~ 3월 10일)
- CollectionView Compositional Layout 구성하기
- 메인 화면 2개 만들기
- Collection View용 View Model
- API용 View Model
- 환율 API Model
- Consts(Color, Font)

### Iteration - 3 ( 3월 11일 ~ 3월 13일)
- Realm CRUD 기능 구현
- API 통신 및 데이터 저장
- Main VC 화면 구현
	- Collection View Compositional Layout 적용
	- Diffable DataSource 적용
	- 환율 데이터 적용(API)

### 회고
3월 8일(목)

Diffable DataSource를 적용하는데 다음 두가지 어려움이 있어 고민만 하다 시간이 많이 버려졌다.

1. 여러 섹션에 들어가는 데이터가 다른경우
2. View Model의 영역

위 문제들은 다음과 같이 해결하려한다.

1. collectionView에서 필요한 데이터 타입만을 모은 Hashable한 구조체를 만든다.
2. View Model은 어디까지나 비즈니스 로직 영역이기 때문에, Cell을 그려준다거나 하는 부분들은 모두 Controller에서 하는것이 맞을 것 같다.   
UI를 통해 들어오거나, 로직 처리가 필요한 경우만 Input Observer를 통해 체크하여 로직을 돌리고 output을 통해 View에게 다시 전달해주기만 하면 될 것 같다.   
내일은 이 부분을 인지하고 다시 코드를 수정해볼 생각이다.

---
3월 9일(금)

Calendar 구간 설정 구현에서 많이 애먹었다.

다음 문제들이 있었다.
1. custom cell을 어떻게 구성할 것인가
2. fsCalendar titleLabel의 높이가 center가 아님
3. 그 외 셀 선택 및 처리 문제 등등

1번의 경우 선택했을 때 표시될 원과, 선택 구간 표시 View(좌,우)로 나누었다. 이는 인터넷에서 참고하였다.
2번의 경우 fsCalendar cell의 프로퍼티로 titleLabel을 찾을 수 있었다. 이를 contentView의 centerY와 일치하게 변경해주었다.
그 외 fsCalendar에서 제공하는 selection 기능을 모두 꺼버리고 커스텀 cell로 모두 해결하였다. 장점이라면, deselected 처리까지 selected에서 가능캐 하여 viewModel의 deselected의 observer를 없앨 수 있었다.
다만 아직 리팩토리할 여지가 많이 남아있다. fsCalendar도 collectionview로 이루어져있기 때문에, Diffable Datasource를 적용할 수 만 있다면, 애니메이션 처리가 자연스러워질 것 같다. 가능 여부는 더 살펴봐야 할 것 같다.

---
3월 10일(일)

Calendar의 버그를 수정 및 기능들을 추가하였다.

기간을 설정하면 커스텀cell에 색칠된 영역의 높이가 조금씩 차이가 났다. 모두 동일한 코드가 적용되는데 다른것이 이상해서, 각 셀별로 높이를 보았더니, 홀수번째 셀은 56.0 짝수번째 셀은 55.5로 적용되어 round 함수를 통해 모두 동일하게 맞추어 주어 버그를 수정했다.

그 외로는 completion 클로저를 만들어 CreateTrip VC쪽으로 Date 데이터를 넘겨주었다.

오늘은 딱히 막힘은 없었다.

---
3월 11일(월)

Realm CRUD를 설정하여 Realm에 데이터를 추가해주었고, 이를 Trip Card Section에 적용해주었다.

---
3월 12일(화)

CollectionView Compositional Layout을 설정해주는데는 어려움이 없었지만, Diffable DataSource는 처음이라 많이 어려웠다.
특히, Section별로 데이터 모델이 달랐기 때문에 이를 적용하기 위한 방법을 찾는데 고군분투했다.
이는 SnapShot의 특성인 Hashable한 데이터를 활용하여 AnyHashable로 모든 Hashable한 데이터 모델을 넣을 수 있도록 설정해주었다.

그 뒤 Section별로 필요한 데이터로 형변환해서 사용해주었다.

---
3월 13일(수)

환율 Section을 추가해주었고
어제와 마찬가지로 Diffable이 문제였는데, Header를 설정하는 방법이 Section별로 Registration하는 방법과는 조금 상이하여 적용하는데 시간이 조금 걸렸다.
다행히 크게 어렵진 않았다.

아쉬웠던건 컨디션이 안좋아서 오늘 계획했던 API까지는 완성시키진 못했다.

---
3월 14일(목)

API나 Realm을 통해 가공되는 DTO객체와 View나 ViewController에서 관리하는 객체로 변경해주었다.
이렇게 한 이유는 API에서 전송되는 프로퍼티(?)나 Realm이 마이그레이션된다면 DTO와 관리객체만 변경해주면 되기 때문이다.
종속성을 조금 더 덜어내는 과정이라고 이해했다. 다만 처음 접한 개념이고 처음 적용을하다보니 간단한 데이터였지만 3시간이나 걸려버렸다.
