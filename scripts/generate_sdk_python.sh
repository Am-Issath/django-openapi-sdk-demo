
#!/usr/bin/env bash
set -euo pipefail
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate   -i /local/openapi.yaml   -g python   -o /local/clients/python
echo "Python SDK generated → clients/python"
