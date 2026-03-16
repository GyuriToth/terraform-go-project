# Terraform & Go Cloud Project / Projekt

[English](#english) | [Magyar](#magyar)

---

<a name="english"></a>
# Terraform & Go Cloud Project (English)

A cloud-native application demonstrating a full DevOps lifecycle: from a Go backend to AWS deployment via Terraform and GitHub Actions.

## Project Components

### 1. Backend: Go API
- **[main.go](app/main.go)**: A lightweight API that greets the user and identifies the server hostname.
- **[main_test.go](app/main_test.go)**: Unit tests for the API handler.

### 2. Containerization: Docker
- **[Dockerfile](Dockerfile)**: A multi-stage build using Alpine Linux to ensure a minimal footprint (~15MB).

### 3. Infrastructure as Code (IaC): Terraform
- **[main.tf](main.tf)**: Provisions AWS resources in `eu-central-1`:
    - **S3 Bucket**: Scalable storage.
    - **ECR Repository**: Secure Docker image registry with `force_delete` and scan-on-push.
    - **IAM Roles**: App Runner service role with ECR access.
    - **App Runner Service**: Managed container execution with auto-deployment.

### 4. Automation: CI/CD
- **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)**: GitHub Actions pipeline that builds, tags, and pushes the image to Amazon ECR on every push to `master`.

### 5. Orchestration: Kubernetes
- **[k8s.yaml](k8s.yaml)**: Deployment and Service configurations for local orchestration (e.g., using k3d or minikube).

## ✅ Definition of Done
- **Local Runtime**: Pods are running in a k3d cluster and accessible via port-forwarding.
- **Cloud Runtime**: `terraform apply` executes successfully, providing a public HTTPS URL.
- **CI/CD Pipeline**: Green checks on the GitHub Actions tab for every push.
- **Cleanup**: `terraform destroy` and cluster deletion leave no stray resources or costs.

---

<a name="magyar"></a>
# Terraform & Go Cloud Projekt (Magyar)

Egy professzionális cloud-native alkalmazás, amely bemutatja a teljes DevOps életciklust: a Go backendtől az AWS-ig, Terraform és GitHub Actions segítségével.

## Projekt Komponensei

### 1. Backend: Go API
- **[main.go](app/main.go)**: Egy könnyű API, amely üdvözli a felhasználót és azonosítja a szerver gépnevét.
- **[main_test.go](app/main_test.go)**: Unit tesztek az API-hoz.

### 2. Konténerizáció: Docker
- **[Dockerfile](Dockerfile)**: Többlépcsős (multi-stage) build Alpine Linux alapon a minimális méret érdekében (~15MB).

### 3. Felhő (IaC): Terraform
- **[main.tf](main.tf)**: AWS erőforrások kezelése az `eu-central-1` régióban:
    - **S3 Bucket**: Skálázható tárhely.
    - **ECR Repository**: Biztonságos Docker image tároló `force_delete` és push-kori szkennelés funkciókkal.
    - **IAM Szerepkörök**: App Runner jogosultságok az ECR eléréséhez.
    - **App Runner Service**: Menedzselt konténerfuttatás automatikus deploymenttel.

### 4. Automatizáció: CI/CD
- **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)**: GitHub Actions pipeline, amely minden `master` ágra történő push esetén buildeli és feltolja az image-et az Amazon ECR-be.

### 5. Orchestration: Kubernetes
- **[k8s.yaml](k8s.yaml)**: Deployment és Service konfigurációk helyi futtatáshoz (pl. k3d vagy minikube használatával).

## Késznek Tekintési Feltételek
- **Helyi futás**: A k3d fürtben a podok futnak és port-forward után elérhetőek.
- **Felhő futás**: A `terraform apply` sikeresen lefut és publikus HTTPS címet ad.
- **CI/CD Pipeline**: Zöld pipák a GitHub Actions fülön minden push után.
- **Takarítás**: A `terraform destroy` és fürt törlés maradéktalanul eltávolít minden erőforrást.
