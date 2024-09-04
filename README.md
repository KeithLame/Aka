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
프로젝트 기간 : 2024.03.09 ~ 

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
| **1** | | Feat | 부모클래스 | 부모 클래스 생성하여 자주 사용하는 프로퍼티/메소드 미리 지정 | 1 H | |
| **2** | | Feat | Realm Manager | Realm 객체를 관리하는 매니저 생성 및 Realm의 CRUD 관리 | 5 H | |
| **3** | | Feat | API Manager | API 호출 객체, API를 호출하는 메인 기능 관리 | 3 H | |
| **4** | | Feat | API Model | API 응답으로 온 JSON에 맞추어 데이터를 Decode할 모델 생성 | 3 H | |
| **5** | | Feat | Consts | Literal 문자열 저장 및 고정으로 사용하는 데이터 저장할 객체 | 3 H | |
| **6** | | Feat | Util | 각 종 편의성(Formatter 등)과 관련된 기능 코드들 작성 | 5 H | |
| **7** | | Feat | FileManager | 이미지 저장을 위한 FileManager 객체 생성 및 이미지 저장 및 호출 관리 | 6 H | |
| **8** | | Feat | Model | Model 객체 생성 및 기능 관리 | 10 H | |
| **9** | | Feat | ViewModel | View에 필요한 데이터 처리 및 기능 관리 | 20 H | |
| **10** | | UI | View | View 객체 생성 및 화면 그리기 | 15 H | |
| **11** | | Feat | ViewController | ViewController 객체 내 View, ViewModel 관리 및 처리 | 20 H | |
| **12** | | UI/Feat | Cell | Cell UI 및 기능 관리 | 10 H | |
||||||**101 H**||

---
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
