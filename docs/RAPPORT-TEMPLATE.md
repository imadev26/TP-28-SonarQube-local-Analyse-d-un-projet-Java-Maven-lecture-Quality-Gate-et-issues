# Rapport d'Analyse SonarQube - TP28

**Étudiant:** [Votre nom]  
**Date:** [Date]  
**Projet analysé:** [Nom du projet]

---

## 1. Configuration SonarQube

### 1.1 Démarrage Docker

- [ ] Volumes créés (`sonarqube_data`, `sonarqube_logs`, `sonarqube_extensions`)
- [ ] Conteneur SonarQube démarré
- [ ] Accès à http://localhost:9000 fonctionnel
- [ ] Connexion avec `admin`/`admin` réussie
- [ ] Mot de passe changé

**Capture d'écran:**

[Insérer capture du login SonarQube]

---

## 2. Création du Projet

### 2.1 Configuration

**Project display name:** [...]  
**Project key:** [...]  
**Mode d'analyse:** Locally

### 2.2 Token généré

**Token name:** [...]  
**Expiration:** [...]  
**Token:** `sqp_...` *(masqué dans le rapport)*

- [ ] Token copié et sauvegardé en sécurité

---

## 3. Analyse Maven

### 3.1 Commande exécutée

```bash
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=[...] \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=[TOKEN]
```

### 3.2 Résultat de l'exécution

**Statut:**
- [ ] BUILD SUCCESS
- [ ] ANALYSIS SUCCESSFUL

**Durée de l'analyse:** [... secondes]

**Capture terminal:**

[Insérer capture du résultat Maven]

---

## 4. Résultats de l'Analyse

### 4.1 Quality Gate

**Statut:** [ ] Passed ✅ / [ ] Failed ❌

**Capture Overview:**

[Insérer capture Quality Gate]

### 4.2 Métriques Principales

| Métrique | Valeur | Grade |
|----------|--------|-------|
| **Reliability** (Bugs) | [...] | [...] |
| **Security** (Vulnerabilities) | [...] | [...] |
| **Security Hotspots** | [...] | [...] |
| **Maintainability** (Code Smells) | [...] | [...] |
| **Coverage** | [...]% | [...] |
| **Duplications** | [...]% | [...] |
| **Technical Debt** | [...] | - |

---

## 5. Analyse Détaillée des Issues

### 5.1 Bugs (Reliability)

**Nombre total:** [...]

**Top 3 bugs identifiés:**

1. **[Nom du bug]**
   - Fichier: [...]
   - Ligne: [...]
   - Sévérité: [...]
   - Description: [...]

2. **[Nom du bug]**
   - Fichier: [...]
   - Ligne: [...]
   - Sévérité: [...]
   - Description: [...]

3. **[Nom du bug]**
   - Fichier: [...]
   - Ligne: [...]
   - Sévérité: [...]
   - Description: [...]

### 5.2 Vulnerabilities (Security)

**Nombre total:** [...]

**Liste:**

[Décrire les vulnérabilités trouvées]

### 5.3 Code Smells (Maintainability)

**Nombre total:** [...]

**Top 3 code smells:**

1. [...]
2. [...]
3. [...]

### 5.4 Security Hotspots

**Nombre total:** [...]

**À vérifier:**

[Liste des hotspots]

---

## 6. Couverture de Tests

### 6.1 Statistiques

- **Coverage globale:** [...]%
- **Lines to cover:** [...]
- **Uncovered lines:** [...]

### 6.2 Analyse

[Commenter la couverture: suffisante? zones non testées?]

---

## 7. Duplications

- **Duplicated blocks:** [...]
- **Duplicated lines:** [...]%

**Fichiers concernés:**

[Lister les fichiers avec duplication]

---

## 8. Actions Correctives Proposées

### Priorité 1 (Critique)

- [ ] Corriger bug: [...]
- [ ] Corriger vulnerability: [...]

### Priorité 2 (Important)

- [ ] Corriger code smell: [...]
- [ ] Ajouter tests pour: [...]

### Priorité 3 (Amélioration)

- [ ] Réduire duplication dans: [...]
- [ ] Améliorer complexité de: [...]

---

## 9. Conclusion

### Points positifs

- [...]
- [...]

### Points à améliorer

- [...]
- [...]

### Leçons apprises

1. **SonarQube:** [Ce que j'ai compris sur SonarQube]
2. **Qualité code:** [Ce que j'ai appris sur la qualité]
3. **Métriques:** [Importance des métriques]

---

## 10. Annexes

### Commandes utilisées

```bash
# Démarrer SonarQube
docker run -d --name sonarqube -p 9000:9000 ...

# Analyser le projet
mvn clean verify sonar:sonar ...
```

### Captures d'écran

1. Login SonarQube
2. Quality Gate
3. Issues détaillées
4. Coverage
5. Code avec annotations

---

**Signature:**  
[Votre nom]  
[Date]
