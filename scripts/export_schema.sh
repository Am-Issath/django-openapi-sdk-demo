
#!/usr/bin/env bash
set -euo pipefail
python manage.py spectacular --file openapi.yaml
echo "Schema exported → openapi.yaml"
