<p align="center">
<pre>
  ██████╗ ██╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗    ████████╗ ██████╗ ████████╗██╗  ██╗
 ██╔════╝ ╚██╗ ██╔╝██╔═══██╗██╔══██╗██╔════╝ ╚██╗ ██╔╝    ╚══██╔══╝██╔═══██╗╚══██╔══╝██║  ██║
 ██║  ███╗ ╚████╔╝ ██║   ██║██████╔╝██║  ███╗ ╚████╔╝        ██║   ██║   ██║   ██║   ███████║
 ██║   ██║  ╚██╔╝  ██║   ██║██╔══██╗██║   ██║  ╚██╔╝         ██║   ██║   ██║   ██║   ██║  ██║
 ╚██████╔╝   ██║   ╚██████╔╝██║  ██║╚██████╔╝   ██║          ██║   ╚██████╔╝   ██║   ██║  ██║
  ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝          ╚═╝    ╚═════╝    ╚═╝   ╚═╝  ╚═╝
</pre>
</p>

# Cloud-Native Go & Infrastructure Pipeline (AWS + Terraform)

This project demonstrates a production-ready, end-to-end DevOps lifecycle. I built this to showcase how a containerized Go application moves from a local environment to a fully automated AWS infrastructure using modern CI/CD practices.

[Magyar leírás](#magyar) | [English Version](#english)

---

<a name="magyar"></a>
## 🇭🇺 Magyar leírás

Ez a projekt egy teljes felhő-natív életciklust mutat be. A célom egy olyan rendszer építése volt, ahol a kód és az infrastruktúra elválaszthatatlan egységet alkot, és a telepítés teljesen automatizált.

### Mérnöki döntések

* **Go Backend:** A nagy teljesítmény és a minimális gépigény miatt választottam. A kódot úgy strukturáltam, hogy a handler logika leválasztható legyen, így biztosítva a teljes körű unit tesztelhetőséget.
* **Infrastruktúra kódként (Terraform):** Elkerültem az AWS konzolon való manuális kattintgatást. Az `eu-central-1` régióban minden erőforrás (S3, ECR, App Runner) kódból épül fel, biztosítva a környezetek közötti azonosságot.
* **Docker optimalizáció:** A **multi-stage build** technológiával elértem, hogy a végleges image mérete mindössze ~15MB legyen, ami kritikus a gyors skálázódás és a biztonság szempontjából.
* **Kubernetes (k3d):** A helyi fejlesztéshez k3d-t használtam, hogy szimuláljam a nagyvállalati környezetekben elvárt orchestrációs folyamatokat.

### CI/CD és Automatizáció
A projekt a Continuous Deployment elvét követi. A GitHub Actions workflow:
1.  **Tesztel:** Csak sikeres unit tesztek után indul el a build.
2.  **Buildel:** Elkészíti az optimalizált konténert.
3.  **Deployol:** Feltölti az ECR tárolóba, ahonnan az AWS App Runner automatikusan frissíti az éles környezetet (rolling update).

### Tanulságok
A projekt során mélyebb betekintést nyertem a Kubernetes hálózati és tárolási logikájába. A lokális fejlesztés közben felmerülő `ImagePullBackOff` hibák megoldása során sajátítottam el a konténer-runtime-ok (containerd) kezelését és az image-importálási folyamatokat.

---

<a name="english"></a>
## 🇺🇸 English Version

### Engineering Decisions & Architecture

* **Backend (Go):** I chose Go for its efficiency and native support for containerized environments. The core logic is decoupled from the server setup, allowing for 100% unit test coverage of the API handlers.
* **Infrastructure as Code (Terraform):** To ensure environment consistency, I avoided manual AWS console configuration. Everything (S3, ECR, IAM, and App Runner) is defined in HCL, making the entire stack reproducible and version-controlled.
* **Containerization (Docker):** I implemented a **multi-stage build** using Alpine Linux. This reduced the final image size to ~15MB, significantly improving deployment speed and reducing the security attack surface.
* **CI/CD (GitHub Actions):** I followed the **"Fail Fast"** principle. The pipeline automatically runs unit tests before building the Docker image. Deployment to AWS ECR and App Runner only happens if all tests pass.
* **Orchestration (Kubernetes):** While the production environment uses AWS App Runner, I included `k8s.yaml` for local testing with **k3d**. This mirrors an enterprise-grade "inner development loop."

### Lessons Learned (The "Human" Side)
During development, I hit a common hurdle: the local k3d cluster couldn't pull my local Docker image. Debugging the `ImagePullBackOff` error taught me the nuances of container runtimes (containerd) and the importance of `imagePullPolicy: IfNotPresent` and manual image importing (`k3d image import`) in local K8s development.

### Quick Start
1.  **Infrastructure:** `terraform init && terraform apply`
2.  **Local K8s Test:**
    ```bash
    k3d cluster create my-local-cloud
    k3d image import elso-alkalmazasom:latest -c my-local-cloud
    kubectl apply -f k8s.yml
    ```
3.  **Deployment:** Simply `git push origin master` to trigger the automated CI/CD pipeline.
