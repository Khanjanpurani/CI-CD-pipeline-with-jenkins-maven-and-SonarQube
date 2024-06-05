FROM maven:3.8.1-openjdk-11 AS build

WORKDIR /app

COPY . /app

RUN mvn clean package 

FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/*.jar /app/your-app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/your-app.jar"]
