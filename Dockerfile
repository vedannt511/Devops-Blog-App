FROM eclipse-temurin:17-jdk-alpine
    
EXPOSE 8080
 
ENV APP_HOME /usr/src/app

WORKDIR $APP_HOME

COPY target/twitter-app-0.0.3.jar $APP_HOME/app.jar

ENTRYPOINT ["java","-jar","/usr/src/app/app.jar"]
