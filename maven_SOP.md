# 📋 SOP: Maven Common & Debugging Commands

**Owner:** Prince Batra  
**Team:** Downtime Crew  
**Date Created:** 14-Apr-2025  
**Last Updated:** 14-Apr-2025  

---

## 📦 Stack Details

- **Component:** Apache Maven  
- **Application Type:** Java (Maven Project)  
- **System:** Local (Ubuntu/Windows/Mac)  

---

## 🌟 Purpose

This SOP provides local Maven usage for Java-based projects. It includes installation, commonly used Maven commands, and debugging tips. Ideal for building, testing, and troubleshooting Java apps.

---

## 🛠 Prerequisites (Install on Local System)

### ✅ Step 1: Install Java (JDK 11 or higher)

**Ubuntu:**
```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
java -version
```

**Mac (using Homebrew):**
```bash
brew install openjdk@17
```

**Windows:**  
👉 Download JDK from: [https://jdk.java.net](https://jdk.java.net)  
✅ Add to environment variables: `JAVA_HOME`

---

### ✅ Step 2: Install Maven

**Ubuntu:**
```bash
sudo apt update
sudo apt install maven -y
mvn -v
```

**Mac:**
```bash
brew install maven
```

**Windows:**  
👉 Download from: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)  
✅ Set `MAVEN_HOME` in environment variables.

---

## 📂 Example Java Maven Project Structure

Assume this folder exists:
```
java/
├── pom.xml
└── src/
    └── main/
        └── java/
```

Go into the folder:
```bash
cd java
```

---

## 📘 What is Maven?

Maven is a powerful build automation tool used primarily for Java projects. It helps developers manage:

Project builds (compiling and packaging code)

Dependencies (external libraries)

Testing and Reporting

Deployment

It uses an XML configuration file called pom.xml (Project Object Model), where you define your project details, dependencies, plugins, and build lifecycle.

## 🛠️ How Maven Works (Simple Explanation)

When you run a Maven command, it follows a lifecycle to perform actions like compiling code, running tests, and creating a JAR or WAR file.

For example:

You write code in src/main/java

You write tests in src/test/java

Maven compiles the code, runs tests, and packages it as a deployable file using pom.xml instructions.


## ✅ **Commonly Used Maven Commands**

---

### 1. **Clean compiled files**

- **Command:** 

```
mvn clean
```
Expected Output
```
[INFO] Deleting /path/to/project/target
[INFO] BUILD SUCCESS
```

- **Purpose:** Removes the `target/` directory with old build files.  
- **When to Use:** Before a fresh build to ensure no leftover files affect the process.

---

### 2. **Compile the project**

- **Command:** 

```
mvn compile
```  
Expected Output
```
[INFO] Compiling 1 source file to /path/to/project/target/classes
[INFO] BUILD SUCCESS
```

- **Purpose:** Converts source code into bytecode.  
- **When to Use:** To check for compilation errors before testing or packaging.

---

### 3. **Run unit tests**

- **Command:** 
```
mvn test
```  
Expected Output
```
[INFO] Running com.example.projectname.TestClass
[INFO] Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.012 sec
[INFO] BUILD SUCCESS
```

- **Purpose:** Runs test cases from `src/test/java` using test frameworks.  
- **When to Use:** To verify if individual components are working correctly.

---

### 4. **Create a JAR/WAR**

- **Command:** 

```
mvn package
```
Expected Output
```
[INFO] Building jar: /path/to/project/target/project-name-1.0-SNAPSHOT.jar
[INFO] BUILD SUCCESS
```

- **Purpose:** Packages compiled code into deployable artifacts like `.jar` or `.war`.  
- **When to Use:** When preparing the application for deployment or delivery.

---

### 5. **Install the Project Locally**

- **Command:**
```
mvn install
```
Expected Output
```
[INFO] BUILD SUCCESS
```

- **Purpose:** Installs built artifact into your local Maven repository.  
- **When to Use:** When you want the project available locally for use in other projects.

---

### 6. **Deploying the Project**

- **Command:**
```
mvn deploy
```
Expected Output
```
[INFO] BUILD SUCCESS
```

- **Purpose:** Uploads the artifact to a remote Maven repository.  
- **When to Use:** When sharing the project with teams or external applications.

---

### 7. **Validate the Project**

- **Command:**
```
mvn validate
```
Expected Output
```
[INFO] BUILD SUCCESS
```

- **Purpose:** Verifies if project structure and dependencies are correctly set.  
- **When to Use:** For checking proper project setup before proceeding.

---

### 8. **Run integration tests**

- **Command:** 
```
mvn verify
```  
Expected Output
```
[INFO] BUILD SUCCESS
```
- **Purpose:** Runs full test lifecycle including integration tests.  
- **When to Use:** To ensure the system works as a whole before deployment.

---

### 9. **Download all dependencies**

- **Command:** 
```
mvn dependency:resolve 
``` 
Expected Output
```
[INFO] Downloaded: junit:junit:4.13.2
[INFO] BUILD SUCCESS
```

- **Purpose:** Fetches all libraries defined in `pom.xml`.  
- **When to Use:** During initial setup or when dependencies fail to resolve.

---

### 10. **Print all dependencies**

- **Command:**
```
mvn dependency:tree
```
Expected Output
```
com.example.projectname:project-name:jar:1.0-SNAPSHOT
├── junit:junit:jar:4.13.2:test
└── org.springframework:spring-core:jar:5.3.8
```
- **Purpose:** Shows a tree of direct and transitive dependencies.  
- **When to Use:** To inspect or debug library conflicts and structure.

---

### 11. **Clean and build the project**

- **Command:** 
```
mvn clean install
```
Expected Output
```
[INFO] BUILD SUCCESS
```
- **Purpose:** Cleans old builds, compiles code, runs tests, installs locally.  
- **When to Use:** For a full clean rebuild and local installation.

---

### 12. **Skip tests during build**

- **Command:** 
```
mvn install -DskipTests
```
Expected Output
```
[INFO] Tests are skipped.
[INFO] BUILD SUCCESS
```
- **Purpose:** Builds and installs without running tests.  
- **When to Use:** During quick development cycles (avoid for production builds).

---

### 13. **Run a specific test**

- **Command:** 
```
mvn -Dtest=ClassName test
```  
Expected Output
```
[INFO] Running com.example.projectname.TestClass
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.005 sec
[INFO] BUILD SUCCESS
```
- **Purpose:** Runs only a specified test class or method.  
- **When to Use:** When focusing on or debugging a particular test.

---


## 😞 Debugging & Troubleshooting Commands


### 1. **Enable Debugging Output**

- **Command:**  
  ```bash
  mvn -X
  ```

- **Expected Output:**  
  ```bash
  [DEBUG] [INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ project-name ---
  [DEBUG] [INFO] BUILD SUCCESS
  ```

- **Purpose:**  
  This command shows detailed information about what Maven is doing during the build. It helps you understand what’s happening behind the scenes.

- **When to Use:**  
  Use this when your build fails or behaves unexpectedly. The detailed logs will help you find the problem.

---

### 2. **Print the Final POM (Project Configuration)**

- **Command:**  
  ```bash
  mvn help:effective-pom
  ```

- **Expected Output:**  
  ```bash
  [INFO] Scanning for projects...
  [INFO] Effective POM for project project-name: 1.0-SNAPSHOT
  ```

- **Purpose:**  
  This shows the full configuration Maven is using for your project. It includes settings from your `pom.xml` file and any parent settings it inherits.

- **When to Use:**  
  Use this when you want to see all the configurations Maven is using, especially if you're unsure which settings are being applied.

---

### 3. **Show Information About a Plugin**

- **Command:**  
  ```bash
  mvn help:describe -Dplugin=<plugin-name> -Ddetail
  ```

- **Expected Output:**  
  ```bash
  [INFO] Describing plugin org.apache.maven.plugins:maven-clean-plugin:3.1.0
  ```

- **Purpose:**  
  This shows detailed information about a specific Maven plugin, like its version and what it can do.

- **When to Use:**  
  Use this if you're having issues with a specific plugin and need to understand what it does or which version is being used.

---

### 4. **Force Maven to Update Dependencies**

- **Command:**  
  ```bash
  mvn clean install -U
  ```

- **Expected Output:**  
  ```bash
  [INFO] BUILD SUCCESS
  ```

- **Purpose:**  
  This forces Maven to download the latest versions of the libraries from the internet, even if it already has a copy in its local storage.

- **When to Use:**  
  Use this when you think Maven has old or outdated libraries stored and you need to update them.

---

### 5. **Check Your Maven Version**

- **Command:**  
  ```bash
  mvn -v
  ```

- **Expected Output:**  
  ```bash
  Apache Maven 3.6.3
  Maven home: /path/to/maven
  Java version: 1.8.0_252, vendor: Oracle Corporation
  ```

- **Purpose:**  
  This shows the version of Maven and Java you are using. It helps you ensure that your tools are up to date.

- **When to Use:**  
  Use this if you need to check which version of Maven or Java is installed, especially when you face compatibility issues.

---

### 6. **Show Effective Settings**

- **Command:**  
  ```bash
  mvn help:effective-settings
  ```

- **Expected Output:**  
  ```bash
  [INFO] Effective settings for Maven
  ```

- **Purpose:**  
  This shows the combined settings that Maven is using, including default settings and any custom configurations you've added.

- **When to Use:**  
  Use this when you want to see how Maven's settings are configured or troubleshoot issues related to settings and profiles.

---

## 🔚 End of SOP

| Date       | Author        | Change Description         |
|------------|---------------|----------------------------|
| 14-Apr-25  | Prince Batra  | Initial draft (local Maven SOP) |

---

