# syntax=docker/dockerfile:1
# Edge (Nginx) terminates TLS / HTTP-2 / HTTP-3 (QUIC); this image only
# serves plain HTTP on 8080. No QUIC/TLS cost inside Java by design.

FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /builder
COPY gradlew settings.gradle.kts build.gradle.kts ./
COPY gradle ./gradle

RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew dependencies --no-daemon

COPY src ./src
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre-alpine AS extractor
WORKDIR /builder
COPY --from=builder /builder/build/libs/*.jar app.jar
# Spring Boot 4 dropped the old `layertools` jarmode; `tools` is its
# replacement and produces the same layered directory layout.
RUN java -Djarmode=tools -jar app.jar extract \
    --layers dependencies,spring-boot-loader,snapshot-dependencies,application \
    --launcher --destination extracted

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# curl for HEALTHCHECK (same layer, no cache left behind).
RUN apk add --no-cache curl \
    && addgroup -S appgroup \
    && adduser -S appuser -u 10001 -G appgroup

USER 10001:10001

COPY --from=extractor --chown=10001:10001 /builder/extracted/dependencies/ ./
COPY --from=extractor --chown=10001:10001 /builder/extracted/spring-boot-loader/ ./
COPY --from=extractor --chown=10001:10001 /builder/extracted/snapshot-dependencies/ ./
COPY --from=extractor --chown=10001:10001 /builder/extracted/application/ ./

ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"
ENV PORT=8080
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
