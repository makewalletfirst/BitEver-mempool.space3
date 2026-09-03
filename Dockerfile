# 1. 빌드 스테이지
FROM node:18 AS builder
WORKDIR /app

# 프론트엔드 디렉토리 복사
COPY frontend/ ./frontend/

# 준비하신 파비콘 파일로 소스 내 리소스 덮어쓰기 (빌드 전 교체)
COPY bitever-favicon.png ./frontend/src/resources/favicon.png
COPY bitever-favicon.svg ./frontend/src/resources/favicon.svg
# 호환성을 위해 png 파일을 ico 파일명으로도 복사해 둡니다.
COPY bitever-favicon.png ./frontend/src/resources/favicon.ico

# 의존성 설치 및 빌드 진행
WORKDIR /app/frontend
RUN npm install
# 빌드 시 메모리 부족 방지를 위해 NODE_OPTIONS 추가
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

# 2. 프로덕션 스테이지
# 공식 멤풀 프론트엔드의 Nginx 설정과 라우팅 규칙을 상속받기 위해 베이스로 사용
FROM mempool/frontend:v3.0.0

# 커스텀으로 빌드된 결과물(수정된 해시 로직 + 파비콘)을 Nginx 웹 루트로 복사하여 덮어쓰기
COPY --from=builder /app/frontend/dist/mempool/browser /usr/share/nginx/html/
