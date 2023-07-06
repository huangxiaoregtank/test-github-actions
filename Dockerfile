# Avoid using multi-stages build here to leverage on docker-caching to reduce build time on AWS Codebuild
FROM maven:3-openjdk-20 as build

WORKDIR /build

COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src

RUN mvn package -Dmaven.test.skip=true

ARG JAR_FILE=demo-0.0.1-SNAPSHOT.jar

WORKDIR /app

RUN cp /build/target/${JAR_FILE} /app/app.jar

ENTRYPOINT java -jar /app/app.jar
