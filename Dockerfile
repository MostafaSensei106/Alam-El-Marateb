FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /builder
COPY gradlew settings.gradle.kts build.gradle.kts ./
COPY gradle ./gradle
RUN ./gradlew dependencies --no-daemon

COPY src ./src
RUN ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre-alpine AS extractor
WORKDIR /builder
COPY --from=builder /builder/build/libs/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser:appgroup

COPY --from=extractor --chown=appuser:appgroup /builder/dependencies/ ./
COPY --from=extractor --chown=appuser:appgroup /builder/spring-boot-loader/ ./
COPY --from=extractor --chown=appuser:appgroup /builder/snapshot-dependencies/ ./
COPY --from=extractor --chown=appuser:appgroup /builder/application/ ./

ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]