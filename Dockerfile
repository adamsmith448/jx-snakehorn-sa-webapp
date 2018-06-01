FROM maven:3.5-jdk-8-alpine as BUILD

COPY . /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

# Environment Variable that defines the endpoint of sentiment-analysis python api.
ENV SA_LOGIC_API_URL http://localhost:5000

FROM openjdk:8-jdk-alpine
ENV PORT 8080
EXPOSE 8080
COPY --from=BUILD /usr/src/app/target/*.jar /opt/app.jar
WORKDIR /opt
CMD ["java", "-jar", "app.jar", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]