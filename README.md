# Project: Terraform & Go Cloud

[Magyar](#magyar) | [English](#english)

---

<a name="magyar"></a>
# Terraform & Go Cloud Projekt (Magyar)

Ez a projekt bemutatja a modern felhő-natív fejlesztési folyamatokat (DevOps). A célom az volt, hogy egy teljes életciklust építsek fel: a Go backend kódtól kezdve a konténerizáción át egészen az automatizált AWS felhős telepítésig.

## A projekt felépítése

### 1. Backend: Go API
- **[main.go](app/main.go)**: Egy könnyű, hatékony API, amely üdvözli a felhasználót és azonosítja a szerver gépnevét. Ez segít vizualizálni a terheléselosztást vagy a Kubernetes skálázódást.
- **[main_test.go](app/main_test.go)**: Unit tesztek, amelyek biztosítják az API üzleti logikájának helyességét még a build előtt.

### 2. Konténerizáció: Docker
- **[Dockerfile](Dockerfile)**: Többlépcsős (multi-stage) buildet alkalmaztam Alpine Linux alapon. Így az elkészült image mérete minimális (~15MB), ami gyorsabb letöltést és kisebb biztonsági kockázatot jelent.

### 3. Felhő (IaC): Terraform
- **[main.tf](main.tf)**: Ebben a fájlban definiáltam az összes AWS erőforrást az `eu-central-1` régióban. Használtam S3 tárhelyet, ECR-t az image-ek tárolására, és App Runnert a konténer futtatásához. Fontosnak tartottam az IAM szerepkörök pontos beállítását is.

### 4. Automatizáció: CI/CD
- **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)**: Egy automatizált pipeline-t építettem, amely minden feltoláskor (push) lefuttatja a teszteket, buildeli az új image-et, és biztonságosan frissíti az AWS környezetet.

### 5. Orchestration: Kubernetes
- **[k8s.yaml](k8s.yaml)**: Készítettem Kubernetes konfigurációkat is, hogy az alkalmazás könnyen tesztelhető legyen helyi fürtökben (pl. k3d vagy minikube).

## Telepítési útmutató

### Amire szükséged lesz
- **Terraform**: Az infrastruktúra automatizálásához.
- **Docker**: A build folyamathoz.
- **AWS CLI**: Megfelelő jogosultságokkal (Access Key & Secret Key).

### Helyi futtatás és tesztelés
1. Terraform inicializálása:
   ```bash
   terraform init
   ```
2. Terv ellenőrzése:
   ```bash
   terraform plan
   ```
3. Infrastruktúra létrehozása (opcionális):
   ```bash
   terraform apply
   ```

### Automatikus Deployment
A projekt úgy van beállítva, hogy minden `git push` után automatikusan frissüljön az AWS-ben. Ez biztosítja a folyamatos kiszállítást (Continuous Delivery):
```bash
git add .
git commit -m "Új funkció hozzáadása"
git push origin master
```

---

<a name="english"></a>
# Terraform & Go Cloud Project (English)

This is a personal project where I showcase my ability to build and automate a modern cloud-native environment. I designed this to demonstrate a full DevOps lifecycle—starting from a Go-based backend and moving through Dockerization to fully automated AWS deployment using Terraform and GitHub Actions.

## Project Architecture

### 1. Backend: Go API
- **[main.go](app/main.go)**: A lightweight API that handles basic requests and identifies the host machine. I designed it this way to make scaling (Kubernetes/Load Balancers) easy to observe.
- **[main_test.go](app/main_test.go)**: Unit tests included to ensure that core logic is validated before any build or deployment occurs.

### 2. Containerization: Docker
- **[Dockerfile](Dockerfile)**: I used a multi-stage build pattern based on Alpine Linux. This keeps the final image footprint extremely small (~15MB), making it efficient to store and fast to deploy.

### 3. Infrastructure as Code (IaC): Terraform
- **[main.tf](main.tf)**: All AWS resources are provisioned via Terraform in the `eu-central-1` region. This includes an S3 bucket for storage, ECR for image management, and AWS App Runner for managed container hosting, all tied together with secure IAM roles.

### 4. Automation: CI/CD
- **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)**: I built a robust pipeline that triggers on every push to `master`. It handles testing, building, and pushing the new image to ECR, ensuring that only verified code reaches the cloud.

### 5. Orchestration: Kubernetes
- **[k8s.yaml](k8s.yaml)**: These configurations allow for local testing and orchestration using clusters like k3d or minikube, mirroring how the app would behave in an enterprise environment.

## Setup Guide

### Prerequisites
- **Terraform**: For infrastructure automation.
- **Docker**: For local builds.
- **AWS CLI**: Configured with valid programmatic access (Access Key & Secret Key).

### Local Setup & Testing
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Verify the changes:
   ```bash
   terraform plan
   ```
3. (Optional) Spin up the cloud environment:
   ```bash
   terraform apply
   ```

### Deployment
Designed for a smooth developer experience—simply push your changes, and the CI/CD pipeline takes care of the rest:
```bash
git add .
git commit -m "Add feature high-level summary"
git push origin master
```
