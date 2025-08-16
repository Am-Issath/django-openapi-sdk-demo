
#!/usr/bin/env bash
set -euo pipefail
if [ $# -ne 2 ]; then
  echo "Usage: $0 <old_openapi.yaml> <new_openapi.yaml>"
  exit 1
fi
OLD=$1
NEW=$2
docker run --rm -v ${PWD}:/specs openapitools/openapi-diff:latest   /specs/${OLD} /specs/${NEW}
