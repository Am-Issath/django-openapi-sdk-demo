# Django REST + OpenAPI → SDKs + CI (Demo)

Minimal, production-minded example showing how to:

- Generate an OpenAPI schema from Django REST Framework (DRF) using **drf-spectacular**
- Generate typed client SDKs (TypeScript + Python) using **openapi-generator**
- Catch breaking API changes with **openapi-diff**
- Automate the flow in **GitHub Actions**

> Works locally without Docker too, but the scripts use Docker for reproducibility.

---

## 🛠 Prerequisites

- Python 3.10+
- pip
- (Optional) Docker (used for SDK generation and diff checks)
- Node.js (if you want to test the TypeScript SDK)

---

## Quickstart: Run the Django API

```bash
# 1) Clone this repo
git clone yhttps://github.com/Am-Issath/django-openapi-sdk-demo.git && cd django-openapi-sdk-demo

# 2) Create & activate a virtual environment (recommended)
python -m venv .venv
source .venv/bin/activate   # Linux/macOS
.venv\Scripts\activate      # Windows

# 3) Install Python dependencies
pip install -r requirements.txt

# 4) Set up database (SQLite for demo)
python manage.py migrate

# 5) Create a superuser (to log into admin)
python manage.py createsuperuser --username admin --email admin@example.com

# 6) Run the server
python manage.py runserver

# 5) Run the server
python manage.py runserver
```

Visit your browser:

- Swagger: http://localhost:8000/api/docs/
- ReDoc: http://localhost:8000/api/redoc/
- Raw spec: http://localhost:8000/api/schema/

### 📌 Sample API

- `GET /api/users/` — returns demo users (from the built-in Django `auth_user` table).

---

## 📄 Step 1: Export the OpenAPI Schema

```bash
bash scripts/export_schema.sh
# → openapi.yaml
```

This generates openapi.yaml at the project root.
You can commit this file to version control.

## 📦 Step 2: Generate SDKs

### Generate a TypeScript client

```bash
bash scripts/generate_sdk_ts.sh
# → clients/ts-fetch/
```

### Generate a Python client

```bash
bash scripts/generate_sdk_python.sh
# → clients/python/
```

Now your API has ready-to-use typed clients!

## 🛡 Step 3: Detect Breaking Changes

You need two schema files (e.g., last release vs current). The script compares them with `openapi-diff`:

```bash
bash scripts/check_breaking_changes.sh path/to/openapi-old.yaml openapi.yaml
```

- ✅ Compatible changes (e.g. adding a new optional field) → safe.
- ❌ Breaking changes (e.g. removing a property) → flagged.

> 👉 In real projects, store released schemas in GitHub Releases, S3, or any static host and fetch them during CI.

> In CI, host released schemas on **GitHub Releases**, **S3**, or any static host and `curl` them before comparing.

---

## 📂 Repo Structure

```
.
├── clients/
│   └── .gitkeep
├── manage.py
├── project/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── api/
│   ├── __init__.py
│   ├── serializers.py
│   ├── views.py
│   └── urls.py
├── scripts/
│   ├── export_schema.sh
│   ├── generate_sdk_python.sh
│   ├── generate_sdk_ts.sh
│   └── check_breaking_changes.sh
├── requirements.txt
├── .gitignore
└── .github/workflows/api-pipeline.yml
```

---

## 🤖 Step 4: GitHub Actions CI/CD

This repo includes `.github/workflows/api-pipeline.yml`
On every push to `main`, it will:

1. Exports the schema (`openapi.yaml`)
2. Download the last released schema (example URL)
3. Run `openapi-diff` to check compatibility
4. Generate SDKs (TypeScript + Python)
5. (Optional) Publish SDKs to npm/PyPI

> You’ll need to set up registry credentials in GitHub secrets if publishing.

---

## Example: Using the Generated TS Client

```ts
// src/example.ts
import { UsersApi } from "../clients/ts-fetch";

const api = new UsersApi({ basePath: "http://localhost:8000" });

async function main() {
  const users = await api.getUsers();
  console.log(users[0]?.email);
}
main();
```

## Example: Using the Generated Python Client

```py
from clients.python import UsersApi, ApiClient, Configuration

config = Configuration(host="http://localhost:8000")
api_client = ApiClient(config)
users = UsersApi(api_client).get_users()
print(users[0].email)
```

---

## 🚢 Optional: Publish SDKs

- **npm**: run `npm publish` from `clients/ts-fetch` (configure `package.json` & npm token)
- **PyPI**: build & upload from `clients/python` (configure `pyproject.toml` or `setup.py` / `twine`)

---

---

## ✅ You Just Learned How To…

- Build an OpenAPI schema from Django REST.

- Auto-generate SDKs for frontend + backend.

- Prevent breaking changes with automated diff checks.

- Automate the whole thing in CI/CD.

---

## License

MIT
