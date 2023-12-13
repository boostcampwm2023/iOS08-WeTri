# WeTri

<div align="center">
<img src="https://github.com/JongPyoAhn/Python/assets/68585628/5629bb2c-a641-4306-a689-c46a7f7299fd" width="30%"/>
</div>

> **우리가 함께 만드는, 트라이애슬론 🏃🏻 | 🏊‍♂️ | 🚴**
>
> **개발기간: 2023.11.06 ~ 2023.12.15**

## 🎙️ 소개

트라이애슬론 커뮤니티와 수영, 달리기, 사이클링에 대한 기록을 할 수 있습니다.

또한 **실시간 랜덤매칭으로 서로 경쟁하며 운동할 수 있는**앱 입니다.


|                                   iOS                                   |                                   iOS                                   |                                  iOS                                   |                                 BE                                  |                                  BE                                   |
| :---------------------------------------------------------------------: | :---------------------------------------------------------------------: | :--------------------------------------------------------------------: | :-----------------------------------------------------------------: | :-------------------------------------------------------------------: |
| <img src="https://github.com/JongPyoAhn.png" width=400px alt="안종표"/> | <img src="https://github.com/MaraMincho.png" width=400px alt="정다함"/> | <img src="https://github.com/WhiteHyun.png" width=400px alt="홍승현"/> | <img src="https://github.com/sjy982.png" width=400px alt="신정용"/> | <img src="https://github.com/wonholim.png" width=400px alt="임원호"/> |
|              [S020\_안종표](https://github.com/JongPyoAhn)              |              [S035\_정다함](https://github.com/MaraMincho)              |              [S043\_홍승현](https://github.com/WhiteHyun)              |              [J078\_신정용](https://github.com/sjy982)              |              [J130\_임원호](https://github.com/wonholim)              |



<br/>

## 🔥 프로젝트 주요 화면


|로그인화면|기록확인화면|지도화면|
|:-:|:-:|:-:|
|![RPReplay_Final1702430990](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/9fe7e8b7-34ad-48ad-a5b7-a3f8246a5c77)|![RPReplay_Final1702430990](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/0eb18767-4cea-4a96-aaad-b3796cd0743f)|![Simulator Screen Recording - iPhone 15 Pro - 2023-12-13 at 10 40 08](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/f8d7faa7-d511-432f-aa43-67794a959ef3)|


|타이머화면|기록화면|
|:-:|:-:|
|![Screen Recording 2023-12-13 at 9 12 51 AM](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/47af5cc9-efa7-4485-bf38-a2624ad0b1c9)|![Screen Recording 2023-12-13 at 9 12 51 AM](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/699cae83-6fa0-4384-8954-22501c13adad)|
|운동선택 및 매칭 화면|-|
|![Screen Recording 2023-12-13 at 9 12 51 AM](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/5b73add5-a547-4043-9fea-bf36872a17da)|-|

<br/>

## 🏗️ 아키텍처

### 🍎 iOS

#### ModularArchitecture

![image](https://hackmd.io/_uploads/rJn3AYLLa.png)

- Feature 단위로 모듈을 나눠서 개발하였습니다.
    - 각 Demo앱을 만들어서 앱을 동작함으로써 기능별로 앱을 수정하거나 실행할 때, 프로젝트 빌드 시간을 80% 줄임으로써 일의 효율을 높였습니다.

#### Clean Architecture & MVVM-C

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/b337eaae-2393-417a-8a3c-7716b5a05e64)

- 각 Feature 내부에서 CleanArchitecture를 통해 Data, Domain, Presentation으로 레이어를 분리하였습니다.
- DataLayer
    - DTO와 Repository를 통해 비즈니스 로직이 서버와의 독립성을 갖도록 하였습니다.
- PresentationLayer
    - Coordinator를 통해 AppCoordinator가 Feature간의 이동을 담당하도록 하여서 화면간의 전환이 용이하도록 하였습니다.
    - MVVM을 통해 ViewModel이 ViewController의 input에 관련된 비즈니스 로직을 처리하고 output을 통해 처리결과를 전송했습니다.
- DomainLayer
    - Entity를 정의하였습니다.
    - UseCase를 통해 비즈니스로직을 처리하였습니다.
    - Repository와의 DIP를 통해 서로의 구현체에 관해 느슨한 구조를 유지할 수 있도록 하였습니다.



### 💻 BE

#### BE 아키텍처

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/19d51b08-9e9d-4dc1-b85f-4104a9ec25e8)

- NestJs의 life cycle을 의미하기도 합니다.
- Module에는 Controller, Service, Repository등이 포함되어 있고 저희는 이러한 Module 단위로 작업을 진행했습니다.
- Exception Filter는 Global로 둠으로써 모든 예외는 한 곳에서 처리되도록 구현했습니다.
- 예외가 발생하지 않으면 Global Interceptor에 들어오게 됩니다.역할은 iOS와 맞춰둔 데이터 형식으로 Format 합니다.

#### BE 배포 구조

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/edfb7da2-8bed-4f68-b8c8-e51de033e525)

#### BE 인프라 아키텍처

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/0468d0aa-0067-499f-9062-985161dbdd60)

## 💪 기술 스택

|분류| 기술 스택 |
|:-------:|:----------------:|
|공통|![WebSocket](https://img.shields.io/badge/WebSocket-orange)|
|iOS|![Xcode](https://img.shields.io/badge/Xcode-v15.0.1-white?logo=xcode) ![Swift](https://img.shields.io/badge/Swift-v5.9.0-white?logo=swift) ![Tuist](https://img.shields.io/badge/Tuist-v3.33.4-white.svg?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYwIiBoZWlnaHQ9IjE2MCIgdmlld0JveD0iMCAwIDE2MCAxNjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjgwIiBmaWxsPSJ1cmwoI3BhaW50MF9saW5lYXIpIi8+CjxwYXRoIGQ9Ik0zOS42NjY3IDExNS42MUMzOS42NjY3IDExNS42MSA1Ni41IDEyOSA4MC41IDEyOUMxMDQuNSAxMjkgMTIxLjMzMyAxMTUuNjEgMTIxLjMzMyAxMTUuNjEiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iNCIvPgo8cGF0aCBkPSJNMzUgOTIuODc4MUMzNSA5Mi44NzgxIDY0LjE2NjcgMTI4IDgwLjUgMTI4Qzk2LjgzMzMgMTI4IDEyNiA5Mi44NzgxIDEyNiA5Mi44NzgxIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjQiLz4KPHBhdGggZD0iTTM1IDY0Ljc4MDVDMzUgNjQuNzgwNSA2NC4xNjY3IDEyOCA4MC41IDEyOEM5Ni44MzMzIDEyOCAxMjYgNjQuNzgwNSAxMjYgNjQuNzgwNSIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSI0Ii8+CjxwYXRoIGQ9Ik01My42NjY3IDQwLjE5NTFDNTMuNjY2NyA0MC4xOTUxIDcyLjAwMDIgMTI4IDgwLjUwMDEgMTI4Qzg5IDEyOCAxMDcuMzMzIDQwLjE5NTEgMTA3LjMzMyA0MC4xOTUxIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjQiLz4KPGxpbmUgeDE9IjgwLjgzMzMiIHkxPSIxMjgiIHgyPSI4MC44MzMzIiB5Mj0iMzIiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iNCIvPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iODAiIHkxPSIwIiB4Mj0iODAiIHkyPSIxNjAiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIj4KPHN0b3Agc3RvcC1jb2xvcj0iIzYyMzZGRiIvPgo8c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiMzMDAwREEiLz4KPC9saW5lYXJHcmFkaWVudD4KPC9kZWZzPgo8L3N2Zz4K)|
|BE| ![NodeJS](https://img.shields.io/badge/node.js-v18.18-green?logo=node.js) ![NestJS](https://img.shields.io/badge/NestJS-v10.2.1-red?logo=NestJS) ![TypeScript](https://img.shields.io/badge/TypeScript-v5.1.3-blue?logo=TypeScript) ![Redis](https://img.shields.io/badge/Redis-v7.0.13-red?logo=redis) ![MySQL](https://img.shields.io/badge/MySQL-v8.0-blue?logo=MySQL) ![TypeORM](https://img.shields.io/badge/TypeORM-black) ![Nginx](https://img.shields.io/badge/Nginx-1.10.3-009639?logo=Nginx) |
|배포도구| ![Naver Cloud Platform](https://img.shields.io/badge/NaverCloudPlatform-black?logo=naver) ![PM2](https://img.shields.io/badge/PM2-v5.3.0-9cf?logo=pm2) ![Docker](https://img.shields.io/badge/Docker-v24.0.6-blue?logo=docker) ![Docker Swarm](https://img.shields.io/badge/DockerSwarm-blue?logo=dockerswarm) |
|협업도구|![github](https://img.shields.io/badge/GitHub-gray?logo=github) ![Slack](https://img.shields.io/badge/Slack-purple?logo=slack) ![Figma](https://img.shields.io/badge/Figma-pink?logo=Figma) ![Gather](https://img.shields.io/badge/Gather-gray.svg?logo=data:image/png;base64,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)|



## 💪 We-Challenges

> WeTri를 프로젝트를 진행하면서, 우리가 마주한 문제를 어떻게 해결했는지, 기록해보았어요!

### S020_안종표 - `겨우 이미지 하나에 처리할게 산더미..?`

|메모리 스파이크 처리 전|메모리 스파이크 처리 후|
|:-:|:-:|
|<img src="https://github.com/JongPyoAhn/Python/assets/68585628/0beb36c8-9004-4a9e-a358-dd8aa0f88d9b">|<img src="https://github.com/JongPyoAhn/Python/assets/68585628/6f8fcacd-7f27-4013-be0e-7fc3e40d271d">|

이미지 데이터를 서버에 보낼 때, JSON이 아닌 **`Multipart/form-data`** 형식을 통해 데이터를 보내는 과정에서 일어났던 문제점과 사용자로부터 이미지를 입력받으면서 발생한 `메모리관련 이슈와 최적화 과정`을 공유해드리고 싶습니다.

> 이 모든 과정을 더 깊이 있게 탐구하고 싶으시다면, 아래 링크를 방문해 주세요. 저와 팀원간 여정을 담은 기술 문서와 함께, 이 기능을 실제로 구현하기까지의 스토리를 공유하고 있습니다.

### [💾 이미지 처리와 최적화 그리고 메모리 스파이크 해결!](https://github.com/boostcampwm2023/iOS08-WeTri/wiki#-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%B2%98%EB%A6%AC%EC%99%80-%EC%B5%9C%EC%A0%81%ED%99%94-%EA%B7%B8%EB%A6%AC%EA%B3%A0-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%8A%A4%ED%8C%8C%EC%9D%B4%ED%81%AC-%ED%95%B4%EA%B2%B0) 👈 클릭


<br/>

### S035_정다함 - `Details in the Devil, GPS 칼만필터로 뽀개기`

![image](https://hackmd.io/_uploads/Bk0s2YBUT.png)

아이폰에서 제공하는 CoreLocation데이터를 통해서 위치정보의 값들과 **칼만필터**를 통해서 노이즈를 줄이는 방법을 고안하였습니다.칼만필터가 뭘까? 백지 상태에서부터 끝날때는 자이로 센서를 활용한 위치 보정방식을 고안하여 리팩토링 하고싶다는 생각까지 여정을 공유하고 싶습니다.


> 이 모든 과정을 더 깊이 있게 탐구하고 싶으시다면, 아래 링크를 방문해 주세요. 저와 팀원간 여정을 담은 기술 문서와 함께, 이 기능을 실제로 구현하기까지의 스토리를 공유하고 있습니다.

### [🗺️ GPS 오차를 보정하기 위한 칼만 필터 구현기](https://github.com/boostcampwm2023/iOS08-WeTri/wiki/GPS%EC%98%A4%EC%B0%A8%EB%A5%BC-%EB%B3%B4%EC%A0%95%ED%95%98%EA%B8%B0-%EC%9C%84%ED%95%9C-%EC%B9%BC%EB%A7%8C-%ED%95%84%ED%84%B0-%EA%B5%AC%ED%98%84%EA%B8%B0-%F0%9F%97%BA%EF%B8%8F) 👈 클릭

<br/>

### S043_홍승현 - `헬스킷, 소켓, 맵킷, 렛츠고`

![image](https://hackmd.io/_uploads/rk0sqiVLp.png)

HealthKit의 건강 데이터, WebSocket의 실시간 통신, MapKit의 지도 기반 화면까지. 이 세 가지의 기술이 어떻게 하나의 화면에서 조화롭게 작동할 수 있도록 했을까요? 저는 이 세 가지를 결합하여 사용자들이 운동 거리를 실시간으로 확인할 수 있도록 UI를 구성했고, 동시에 사용자들이 운동하며 지나온 거리를 지도를 통해 확인할 수 있도록 구현했습니다. 이 과정에서 제가 마주한 도전과 성공, 그리고 때로는 실패한 순간들을 공유하고 싶습니다.

> 이 모든 과정을 더 깊이 있게 탐구하고 싶으시다면, 아래 링크를 방문해 주세요. 저와 팀원간 여정을 담은 기술 문서와 함께, 이 기능을 실제로 구현하기까지의 스토리를 공유하고 있습니다.

### [🗺️ HealthKit, MapKit, WebSocket, 렛츠고! 좌충우돌 프로젝트 기행](https://github.com/boostcampwm2023/iOS08-WeTri/wiki#%EF%B8%8F-healthkit-mapkit-websocket-렛츠고-좌충우돌-프로젝트-기행) 👈 클릭

<br/>

### J078_신정용 - `분산 환경에서 WebSocket과 Redis를 활용한 나의 여정`

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/57972338/b5360598-cfe1-488d-aae5-351932daffa6)

WebSocket Server는 분산 환경에서 독릭접인 존재입니다. 
이 여러 WebSocket Server 간의 어떻게 메시지를 교환하고, 사용자 세션 및 상태 정보를 동기화 시킬 수 있었을까요?
저는 Redis와 Redis pub/sub을 이용해서 구현해줬습니다.

> 이 모든 과정을 더 깊이 있게 탐구하고 싶으시다면, 아래 링크를 방문해 주세요. 저와 팀원간 여정을 담은 기술 문서와 함께, 이 기능을 실제로 구현하기까지의 스토리를 공유하고 있습니다.

### [🐣 분산 환경에서 WebSocket과 Redis를 활용한 나의 여정](https://github.com/boostcampwm2023/iOS08-WeTri/wiki#-%EB%B6%84%EC%82%B0-%ED%99%98%EA%B2%BD%EC%97%90%EC%84%9C-websocket%EA%B3%BC-redis%EB%A5%BC-%ED%99%9C%EC%9A%A9%ED%95%9C-%EB%82%98%EC%9D%98-%EC%97%AC%EC%A0%95) 👈 클릭

<br/>

### J130_임원호 - `클라우드 VPC 환경 구축도 CI/CD도 처음이었던, WeTri 인프라 구축`

![image](https://github.com/boostcampwm2023/iOS08-WeTri/assets/56383948/0468d0aa-0067-499f-9062-985161dbdd60)

WeTri 프로젝트를 진행하면서, 클라우드 인프라, 배포에 대해 걱정하지 않도록 **`책임`** 을 지고 학습하고 구축해보았습니다. Classic 환경에서 VPC 환경으로, 수동 배포에서 자동 배포를 구현하면서 발생했던 **`문제를 어떻게 해결했는지 글`** 로 담았습니다.

> 이 모든 과정을 더 깊이 있게 탐구하고 싶으시다면, 아래 링크를 방문해 주세요. 저와 팀원간 여정을 담은 기술 문서와 함께, 이 기능을 실제로 구현하기까지의 스토리를 공유하고 있습니다.

### [☁️ Wetri 클라우드 인프라와 CI/CD 구축](https://github.com/boostcampwm2023/iOS08-WeTri/wiki#%EF%B8%8F-wetri-%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%9D%B8%ED%94%84%EB%9D%BC%EC%99%80-cicd-%EA%B5%AC%EC%B6%95) 👈 클릭

<br/>

### 🤔 Branch Strategy

![image.png](https://hackmd.io/_uploads/BkqiYQI7T.png)

- WeTri 팀은 Git Flow를 간소화해서 사용해요

### 🤝 Merge Strategy

- `squash merge`를 사용합니다.
- approve한 사람이 최소 **2명 이상**이어야 merge 가능합니다.
