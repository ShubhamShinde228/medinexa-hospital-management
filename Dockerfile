FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline

COPY . .

RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

RUN sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

COPY --from=build /app/target/Hospital_System.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 10000

CMD ["catalina.sh", "run"]
