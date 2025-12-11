# Créer les volumes Docker
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

# Pull latest image
docker pull sonarqube:community

# Lancer SonarQube
docker run -d --name sonarqube -p 9000:9000 `
  -v sonarqube_data:/opt/sonarqube/data `
  -v sonarqube_logs:/opt/sonarqube/logs `
  -v sonarqube_extensions:/opt/sonarqube/extensions `
  sonarqube:community

Write-Host "Attendre que SonarQube soit prêt..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Vérifier que SonarQube répond
try {
    $response = Invoke-RestMethod -Uri "http://localhost:9000/api/system/status"
    Write-Host "SonarQube status: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "SonarQube n'est pas encore prêt, patientez..." -ForegroundColor Red
}

Write-Host "`nSonarQube est accessible sur http://localhost:9000" -ForegroundColor Green
Write-Host "Login: admin" -ForegroundColor Cyan
Write-Host "Password: admin" -ForegroundColor Cyan
