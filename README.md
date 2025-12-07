# TP 28 : SonarQube - Analyse Qualité de Code

## 🎯 Objectif

Mettre en place **SonarQube en local** (Docker), créer un projet, générer un token, lancer l'analyse d'un projet Java Maven, puis interpréter les résultats (Quality Gate, bugs, code smells, vulnérabilités, couverture).

## 📋 Prérequis

```bash
# Vérifier Docker
docker --version

# Vérifier Java
java -version

# Vérifier Maven
mvn -version
```

**Requis:**
- Docker Desktop (ou Docker Engine)
- Navigateur Web
- JDK installé
- Maven (ou Maven Wrapper `mvnw`)
- Un projet Java Maven (avec `pom.xml`)

---

## 🐳 Étape 1 — Démarrer SonarQube (Docker)

### 1.1 Créer les volumes Docker

```bash
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions
```

> [!IMPORTANT]
> **Sans volumes**, toutes les données sont perdues quand le conteneur est supprimé!

### 1.2 Lancer SonarQube

```bash
docker run -d --name sonarqube -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:lts-community
```

**Windows PowerShell:**
```powershell
docker run -d --name sonarqube -p 9000:9000 `
  -v sonarqube_data:/opt/sonarqube/data `
  -v sonarqube_logs:/opt/sonarqube/logs `
  -v sonarqube_extensions:/opt/sonarqube/extensions `
  sonarqube:lts-community
```

> [!TIP]
> Si le port 9000 est occupé, utilisez `-p 9001:9000`, puis `http://localhost:9001`

### 1.3 Vérifier l'accès

**Ouvrir:** http://localhost:9000

**Identifiants par défaut:**
- Login: `admin`
- Password: `admin`

> [!NOTE]
> SonarQube demande de changer le mot de passe à la première connexion

![Login SonarQube](docs/screenshots/sonarqube-login.png)

---

## 📊 Étape 2 — Comprendre le Quality Gate

### Qu'est-ce qu'un Quality Gate ?

Le **Quality Gate** indique si le projet respecte les critères minimaux:
- ✅ Bugs
- ✅ Vulnérabilités
- ✅ Code Coverage
- ✅ Code Duplications
- ✅ Code Smells

### Quality Gate: Passed ✅

Toutes les conditions sont satisfaites.

![Quality Gate Passed](docs/screenshots/quality-gate-passed.png)

### Quality Gate: Failed ❌

Trop de bugs, couverture insuffisante, etc.

![Quality Gate Failed](docs/screenshots/quality-gate-failed.png)

> [!TIP]
> **Ordre de correction recommandé:**
> 1. ✅ **Bugs** (priorité absolue)
> 2. ✅ **Vulnerabilities / Security Hotspots**
> 3. ✅ **Code Smells** (progressivement)
> 4. ✅ **Coverage** (ajout de tests)

---

## 📁 Étape 3 — Créer un projet

### 3.1 Aller dans Projects

![Projects List](docs/screenshots/projects-list.png)

### 3.2 Cliquer "Create Project"

Bouton en haut à droite.

### 3.3 Choisir "Manually"

- **Project display name:** `Student_class` (nom lisible)
- **Project key:** `Student_class` (identifiant unique)

> [!IMPORTANT]
> La **project key** est utilisée dans la commande Maven:  
> `-Dsonar.projectKey=Student_class`

> [!WARNING]
> Éviter les espaces dans la project key. Utiliser `_` ou `-`

---

## 🔐 Étape 4 — Générer un token

### 4.1 Choisir "Locally"

Après création du projet, choisir l'option **"Locally"** (pas CI).

### 4.2 Générer le token

**Paramètres:**
- **Token name:** `Analyze "Student_class"`
- **Expiration:** 30 days (ou plus)
- Cliquer **Generate**

### 4.3 Copier le token

⚠️ **IMPORTANT:** Copier et sauvegarder le token en lieu sûr!

**Exemple de token:**
```
sqp_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9
```

> [!CAUTION]
> **Le token est un SECRET:**
> - Ne pas le publier
> - Ne pas le commiter dans Git
> - Si exposé, le révoquer immédiatement

---

## 🔍 Étape 5 — Lancer l'analyse Maven

### 5.1 Choisir Maven

SonarQube propose la commande selon le build tool (Maven/Gradle).

### 5.2 Commande d'analyse

**Linux/Mac:**
```bash
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=Student_class \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=VOTRE_TOKEN
```

**Windows (PowerShell):**
```powershell
mvn clean verify sonar:sonar `
  -Dsonar.projectKey=Student_class `
  -Dsonar.host.url=http://localhost:9000 `
  -Dsonar.login=VOTRE_TOKEN
```

**Windows (CMD):**
```cmd
mvn clean verify sonar:sonar ^
  -Dsonar.projectKey=Student_class ^
  -Dsonar.host.url=http://localhost:9000 ^
  -Dsonar.login=VOTRE_TOKEN
```

### 5.3 Se placer dans le dossier Maven

```bash
cd chemin/vers/projet/avec/pom.xml
```

### 5.4 Exécuter la commande

**Résultat attendu:**
```
[INFO] ANALYSIS SUCCESSFUL
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

> [!NOTE]
> **Étapes Maven:**
> 1. `clean` : Nettoie le build
> 2. `verify` : Compile + lance les tests
> 3. `sonar:sonar` : Envoie le rapport à SonarQube

---

## 📈 Étape 6 — Consulter les résultats

### 6.1 Ouvrir le projet

**Projects** → Sélectionner `Student_class`

### 6.2 Sections principales

| Section | Description |
|---------|-------------|
| **Overview** | Résumé + Quality Gate |
| **Issues** | Liste détaillée (Bugs, Code Smells, etc.) |
| **Security Hotspots** | Points de sécurité à valider |
| **Measures** | Métriques (duplication, complexité) |
| **Code** | Code annoté avec explications |
| **Activity** | Historique des analyses |

### 6.3 Interpréter les métriques

**Reliability (Bugs):**
- 🐛 **Bugs:** Erreurs de code à corriger

**Security:**
- 🔓 **Vulnerabilities:** Failles de sécurité
- 🔍 **Security Hotspots:** À vérifier manuellement

**Maintainability:**
- 💩 **Code Smells:** Problèmes de qualité (non bloquants)
- ⏱️ **Technical Debt:** Temps estimé pour corriger

**Coverage:**
- ✅ **Coverage:** % de code testé
- 📊 **Lines to cover:** Lignes non testées

**Duplications:**
- 📋 **Duplicated blocks:** Blocs de code dupliqués

---

## 🐛 Dépannage

### Erreur 401 / Unauthorized

**Cause:** Token invalide

**Solution:**
```bash
# Régénérer un token dans SonarQube
# Relancer la commande Maven avec le nouveau token
```

### Connection refused

**Cause:** SonarQube non démarré ou mauvaise URL

**Solution:**
```bash
# Vérifier que SonarQube tourne
docker ps | grep sonarqube

# Vérifier l'URL
curl http://localhost:9000
```

### Projet introuvable

**Cause:** `sonar.projectKey` différent

**Solution:**
```bash
# Vérifier la clé dans SonarQube
# Corriger dans la commande Maven
```

### Analyse très lente

**Cause:** Machine chargée / SonarQube pas ready

**Solution:**
```bash
# Attendre que SonarQube soit complètement démarré
docker logs sonarqube

# Rechercher: "SonarQube is operational"
```

---

## 📝 Mini-Récap (Compte Rendu)

À inclure dans votre rapport:

1. ✅ **SonarQube** tourne en local via Docker sur `localhost:9000`
2. ✅ **Projet** créé en mode "Manually"
3. ✅ **Token** généré et utilisé dans Maven
4. ✅ **Analyse** déclenchée via `mvn clean verify sonar:sonar`
5. ✅ **Quality Gate** lu et compris
6. ✅ **Issues** identifiées (bugs, smells, vulnerabilities)

### Checklist de validation

- [ ] SonarQube accessible sur http://localhost:9000
- [ ] Projet créé avec succès
- [ ] Token généré et copié
- [ ] Commande Maven exécutée sans erreur
- [ ] Résultats visibles dans SonarQube
- [ ] Quality Gate Passed/Failed identifié
- [ ] Au moins 3 issues analysées

---

## 🛠️ Commandes Utiles

```bash
# Démarrer SonarQube
docker start sonarqube

# Arrêter SonarQube
docker stop sonarqube

# Voir les logs
docker logs -f sonarqube

# Supprimer le conteneur (⚠️ garde les volumes)
docker rm sonarqube

# Supprimer tout (conteneur + volumes)
docker rm sonarqube
docker volume rm sonarqube_data sonarqube_logs sonarqube_extensions

# Analyse rapide (skip tests)
mvn sonar:sonar -DskipTests \
  -Dsonar.projectKey=Student_class \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=VOTRE_TOKEN
```

---

## 👨‍💻 Auteur

**Imad ADAOUMOUM**

## 📄 License

Ce projet est réalisé dans un cadre académique.
