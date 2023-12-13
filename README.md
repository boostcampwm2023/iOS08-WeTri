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
|협업도구|![github](https://img.shields.io/badge/GitHub-gray?logo=github) ![Slack](https://img.shields.io/badge/Slack-purple?logo=slack) ![Figma](https://img.shields.io/badge/Figma-pink?logo=Figma) ![Gather](https://img.shields.io/badge/Gather-blue.svg?logo=)|



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
