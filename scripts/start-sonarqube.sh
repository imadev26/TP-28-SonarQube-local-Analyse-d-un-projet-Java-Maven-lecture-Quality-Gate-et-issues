# Créer les volumes Docker
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

# Pull latest image
docker pull sonarqube:community

# Lancer SonarQube
docker run -d --name sonarqube -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:community

# Attendre que SonarQube démarre (peut prendre 1-2 min)
echo "Attendre que SonarQube soit prêt..."
sleep 60

# Vérifier que SonarQube répond
curl -s http://localhost:9000/api/system/status

echo "SonarQube est prêt sur http://localhost:9000"
echo "Login: admin"
echo "Password: admin"
