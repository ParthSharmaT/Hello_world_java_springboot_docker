# Usa una imagen base de OpenJDK para ejecutar aplicaciones Java
FROM openjdk:17-jdk-slim

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el archivo JAR de la aplicación desde tu máquina local al contenedor
COPY target/hello-world-java-0.0.1-SNAPSHOT.jar /app/hello-world-java.jar

# Expone el puerto 8081 (puerto en el que tu aplicación Spring Boot se ejecuta por defecto)
EXPOSE 8081

# Comando para ejecutar el archivo JAR
ENTRYPOINT ["java", "-jar", "/app/hello-world-java.jar"]