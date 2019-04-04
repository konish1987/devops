FROM maven:3.6.0-jdk-8-slim AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn package

FROM tomcat:9.0-jre8-alpine
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/devops-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/devops-0.0.1-SNAPSHOT.war

HEALTHCHECK --interval=1m --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost:8080/wizard/ || exit 1
