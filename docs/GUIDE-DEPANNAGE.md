# Guide de Dépannage - SonarQube

## 🔧 Problèmes Courants

### 1. Erreur 401 / Unauthorized

**Symptôme:**
```
[ERROR] Not authorized. Please check the user token
```

**Causes possibles:**
- Token invalide ou expiré
- Token mal copié (espaces)
- Token révoqué

**Solutions:**

```bash
# 1. Regénérer un token dans SonarQube
# Projects → Your Project → Administration → Security

# 2. Vérifier qu'il n'y a pas d'espaces
echo "sqp_abc123..." | wc -c

# 3. Relancer avec le nouveau token
mvn sonar:sonar -Dsonar.login=NOUVEAU_TOKEN
```

---

### 2. Connection refused

**Symptôme:**
```
[ERROR] Failed to connect to http://localhost:9000
```

**Causes:**
- SonarQube non démarré
- Port incorrect
- Firewall bloque la connexion

**Solutions:**

```bash
# Vérifier que le conteneur tourne
docker ps | grep sonarqube

# Vérifier les logs
docker logs sonarqube

# Redémarrer SonarQube
docker restart sonarqube

# Attendre 1-2 minutes, puis tester
curl http://localhost:9000/api/system/status
```

---

### 3. Projet introuvable

**Symptôme:**
```
[ERROR] Project not found: Student_class
```

**Cause:**
- `sonar.projectKey` différent du nom dans SonarQube

**Solution:**

```bash
# Vérifier la clé dans SonarQube
# Projects → Your Project → Project Information

# Utiliser exactement la même clé
mvn sonar:sonar -Dsonar.projectKey=BONNE_CLE
```

---

### 4. SonarQube ne démarre pas

**Symptôme:**
```
docker logs sonarqube
# Erreurs Elasticsearch
```

**Cause:** Sur Linux, `vm.max_map_count` trop bas

**Solution Linux:**

```bash
# Temporaire
sudo sysctl -w vm.max_map_count=262144

# Permanent
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

**Solution Windows/Mac:**
- Généralement pas nécessaire
- Augmenter la RAM allouée à Docker Desktop

---

### 5. Analyse très lente

**Symptôme:**
- L'analyse prend plus de 10 minutes

**Causes:**
- Projet très gros
- CPU/RAM insuffisant
- SonarQube pas complètement prêt

**Solutions:**

```bash
# 1. Vérifier que SonarQube est opérationnel
docker logs sonarqube | grep "SonarQube is operational"

# 2. Augmenter la mémoire Docker
# Docker Desktop → Settings → Resources → Memory: 4GB min

# 3. Skip les tests si déjà exécutés
mvn sonar:sonar -DskipTests \
  -Dsonar.projectKey=... \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=...
```

---

### 6. Port 9000 déjà utilisé

**Symptôme:**
```
docker: Error response from daemon: Ports are not available
```

**Solution:**

```bash
# Option 1: Utiliser un autre port
docker run -d --name sonarqube -p 9001:9000 ...

# Puis adapter l'URL
mvn sonar:sonar -Dsonar.host.url=http://localhost:9001 ...

# Option 2: Libérer le port 9000
# Windows
netstat -ano | findstr :9000
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :9000
kill -9 <PID>
```

---

### 7. Build Failed (erreurs compilation)

**Symptôme:**
```
[ERROR] Failed to execute goal ... compile
```

**Cause:**
- Code ne compile pas
- Dépendances manquantes

**Solution:**

```bash
# 1. Tester la compilation seule
mvn clean compile

# 2. Réparer les erreurs de code

# 3. Forcer le téléchargement des dépendances
mvn clean install -U

# 4. Si besoin, skip les tests
mvn sonar:sonar -DskipTests
```

---

### 8. Coverage à 0%

**Symptôme:**
- Coverage: 0.0%
- Mais les tests passent

**Causes:**
- JaCoCo pas configuré
- Tests dans mauvais répertoire

**Solution:**

Ajouter dans `pom.xml`:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.10</version>
      <executions>
        <execution>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
        </execution>
        <execution>
          <id>report</id>
          <phase>verify</phase>
          <goals>
            <goal>report</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

---

## 📊 Vérifications Utiles

### Statut SonarQube

```bash
# API status
curl -s http://localhost:9000/api/system/status | jq

# Health
curl -s http://localhost:9000/api/system/health | jq
```

### Logs détaillés

```bash
# Temps réel
docker logs -f sonarqube

# Dernières 100 lignes
docker logs --tail 100 sonarqube

# Rechercher erreurs
docker logs sonarqube 2>&1 | grep -i error
```

### Informations conteneur

```bash
# Stats ressources
docker stats sonarqube

# Inspecter
docker inspect sonarqube

# Entrer dans le conteneur
docker exec -it sonarqube sh
```

---

## 🆘 Réinitialisation Complète

Si tout échoue:

```bash
# 1. Arrêter et supprimer
docker stop sonarqube
docker rm sonarqube

# 2. Supprimer les volumes (⚠️ perte données)
docker volume rm sonarqube_data sonarqube_logs sonarqube_extensions

# 3. Recréer tout
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

docker run -d --name sonarqube -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:lts-community

# 4. Attendre 2 minutes
sleep 120

# 5. Tester
curl http://localhost:9000
```

---

**Toujours pas résolu?** Consulter les logs Docker et la documentation SonarQube: https://docs.sonarqube.org
