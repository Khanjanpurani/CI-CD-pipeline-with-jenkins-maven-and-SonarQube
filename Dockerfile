
FROM openjdk:11-jre-slim AS build

WORKDIR /app

COPY pom.xml .
RUN mvn clean package -DskipTests

COPY . .

FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/*.jar ./app.jar

CMD ["java", "-jar", "app.jar"]
