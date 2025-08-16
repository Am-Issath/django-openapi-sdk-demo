
#!/usr/bin/env bash
set -euo pipefail
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate   -i /local/openapi.yaml   -g typescript-fetch   -o /local/clients/ts-fetch
echo "TypeScript SDK generated → clients/ts-fetch"
