# Étape 1 : build Maven
FROM maven:3.9.9-amazoncorretto-17 AS build
WORKDIR /app

# Copier uniquement le pom.xml pour télécharger les dépendances
COPY pom.xml .

# Télécharger les dépendances Maven
RUN mvn dependency:go-offline

# Copier le code source uniquement
COPY src ./src

# Construire l'application sans tests
RUN mvn clean package -DskipTests

# Étape 2 : image finale avec OpenJDK
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copier le jar construit depuis l'étape build
COPY --from=build /app/target/*.jar app.jar

# Exposer le port 8080
EXPOSE 8080

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
