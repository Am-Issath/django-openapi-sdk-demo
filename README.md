
# Django REST + OpenAPI → SDKs + CI (Demo)

Minimal, production-minded example showing how to:

- Generate an OpenAPI schema from Django REST Framework (DRF) using **drf-spectacular**
- Generate typed client SDKs (TypeScript + Python) using **openapi-generator**
- Catch breaking API changes with **openapi-diff**
- Automate the flow in **GitHub Actions**

> Works locally without Docker too, but the scripts use Docker for reproducibility.

---

## Quickstart

```bash
# 1) Create & activate a virtualenv (optional but recommended)
python -m venv .venv && source .venv/bin/activate

# 2) Install dependencies
pip install -r requirements.txt

# 3) Initialize Django (SQLite dev DB)
python manage.py migrate
python manage.py createsuperuser --username admin --email admin@example.com

# 4) Run the server
python manage.py runserver
# Swagger:  http://localhost:8000/api/docs/
# ReDoc:    http://localhost:8000/api/redoc/
# Raw spec: http://localhost:8000/api/schema/
```

### Sample API
- `GET /api/users/` — returns demo users (from the built-in Django `auth_user` table).

---

## Generate Schema (OpenAPI)

```bash
bash scripts/export_schema.sh
# → openapi.yaml
```

## Generate SDKs

(TypeScript fetch client)
```bash
bash scripts/generate_sdk_ts.sh
# → clients/ts-fetch/
```

(Python client)
```bash
bash scripts/generate_sdk_python.sh
# → clients/python/
```

## Check for Breaking Changes

You need two schema files (e.g., last release vs current). The script compares them with `openapi-diff`:

```bash
bash scripts/check_breaking_changes.sh path/to/openapi-old.yaml openapi.yaml
```

> In CI, host released schemas on **GitHub Releases**, **S3**, or any static host and `curl` them before comparing.

---

## Repo Structure

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

## GitHub Actions CI

On push to `main`, the workflow:
1. Exports schema (`openapi.yaml`)
2. Downloads previous released schema (example URL; change to your own)
3. Runs `openapi-diff`
4. Generates TypeScript + Python SDKs
5. (Optionally) publishes them to registries

> Be sure to set up registry credentials as secrets if you publish.

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

## Publish SDKs (Optional)

- **npm**: run `npm publish` from `clients/ts-fetch` (configure `package.json` & npm token)
- **PyPI**: build & upload from `clients/python` (configure `pyproject.toml` or `setup.py` / `twine`)

---

## License
MIT
