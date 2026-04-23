---
name: spring-boot-init
description: Use when Spring Boot 새 프로젝트, Spring Initializr, 스프링 부트 앱 생성, 웹/JSON API 학습 프로젝트를 로컬에 만들어야 할 때.
---

# Spring Boot Init

Spring Initializr로 새 Spring Boot 프로젝트를 만든다.
기본은 학습과 실습에 맞춘 작은 프로젝트다.

## 기본값

- Language: Java
- Build: Maven 또는 사용자가 원하면 Gradle
- Packaging: jar
- Java: Initializr 기본값 또는 사용자가 지정한 LTS
- Dependencies: Spring Web
- JSON API 학습이면 Spring Web만으로 시작한다.
- JPA 학습이면 Spring Data JPA + H2를 추가한다.

## 흐름

1. 만들 위치와 프로젝트 이름을 확인한다.
2. 목적을 확인한다: 웹/JSON API, JPA, Security, Batch, 기타.
3. Spring Initializr metadata를 확인한다.
4. 필요한 의존성만 선택한다.
5. `starter.zip`을 다운로드하고 압축 해제한다.
6. wrapper로 테스트 또는 빌드를 실행한다.
7. 필요한 경우 `.http` 예제 파일과 README를 최소로 만든다.

## 질문

요구가 비어 있으면 짧게 묻는다.

```text
1. 어디에 만들까요?
   A. 현재 디렉터리
   B. ~/Desktop
   C. 직접 경로 입력

2. 목적은 무엇인가요?
   A. 웹 + JSON API
   B. JPA + H2
   C. Security
   D. 기타
```

## Initializr 예시

실제 버전과 dependency id는 생성 직전에 `https://start.spring.io/metadata/client`로 확인한다.

```bash
curl -s -G https://start.spring.io/starter.zip \
  -d type=maven-project \
  -d language=java \
  -d bootVersion="$BOOT_VERSION" \
  -d baseDir="$ARTIFACT" \
  -d groupId="$GROUP_ID" \
  -d artifactId="$ARTIFACT" \
  -d name="$ARTIFACT" \
  -d packageName="$PACKAGE_NAME" \
  -d packaging=jar \
  -d javaVersion="$JAVA_VERSION" \
  -d dependencies="$DEPENDENCIES" \
  -o starter.zip
```

## 검증

Maven:

```bash
chmod +x mvnw
./mvnw test
```

Gradle:

```bash
chmod +x gradlew
./gradlew test
```

## 규칙

- SNAPSHOT, M, RC 버전은 사용자가 명시하지 않으면 피한다.
- 의존성은 필요한 것만 넣는다.
- 현재 디렉터리에 덮어쓸 위험이 있으면 먼저 멈추고 확인한다.
- 생성 후 빌드/테스트 결과를 확인하기 전에는 완료라고 말하지 않는다.
