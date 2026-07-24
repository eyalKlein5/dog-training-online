#!/bin/bash
# Deploy dog-training.online to Cloudflare Pages
# Usage: ./scripts/deploy.sh
# Token is passed as env var or read from state file

set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN="${CLOUDFLARE_API_TOKEN}"

if [ -z "$TOKEN" ]; then
  echo "ERROR: CLOUDFLARE_API_TOKEN not set"
  exit 1
fi

echo "=== Deploying dog-training.online ==="
cd "$DIR"

# Commit any pending changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add -A
  git commit -m "auto: deploy $(date +%Y-%m-%d_%H:%M)" 2>/dev/null || true
fi

# Push to GitHub
git push 2>/dev/null || echo "Push may have failed, continuing with wrangler..."

# Deploy via wrangler
python3 -c "
import os, subprocess
os.environ['CLOUDFLARE_API_TOKEN'] = '$TOKEN'
result = subprocess.run(['npx', 'wrangler', 'pages', 'deploy', '.', '--project-name=dog-training-intl', '--branch=main'], 
  capture_output=True, text=True, timeout=120)
if result.returncode == 0:
  print('✅ Deploy successful')
  print(result.stdout[-300:])
else:
  print('❌ Deploy failed')
  print(result.stderr[-300:])
"

echo "=== Done ==="