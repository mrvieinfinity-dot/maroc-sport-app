    allprojects {
        repositories {
            google()
            mavenCentral()
        }
    }

    // Rediriger le dossier build global
    val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
    rootProject.layout.buildDirectory.set(newBuildDir)

    subprojects {
        val newSubprojectBuildDir = newBuildDir.dir(name)
        layout.buildDirectory.set(newSubprojectBuildDir)
    }

    // S'assurer que tous les sous-projets dépendent de ":app"
    subprojects {
        evaluationDependsOn(":app")
    }

    // Tâche de nettoyage
    tasks.register<Delete>("clean") {
        delete(rootProject.layout.buildDirectory)
    }
