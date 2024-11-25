# Use OpenJDK as the base image
FROM openjdk:21-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml for dependency resolution
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Grant execute permission to the Maven wrapper
RUN chmod +x mvnw

# Install dependencies (leveraging Docker caching)
RUN ./mvnw dependency:resolve

# Copy the entire project to the container
COPY . .

# Grant execute permission again in case permissions were lost
RUN chmod +x mvnw

# Build the application
RUN ./mvnw package -DskipTests

# Copy the built JAR file to the final location
RUN cp target/Bank-Server-1.0-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]