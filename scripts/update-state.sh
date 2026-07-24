#!/bin/bash
# Update state.json after deployments or content creation
# Usage: ./scripts/update-state.sh <key=value> [key=value ...]

STATE_FILE="$(cd "$(dirname "$0")/.." && pwd)/state.json"

update_key() {
  local key="$1"
  local val="$2"
  python3 -c "
import json
with open('$STATE_FILE') as f:
  data = json.load(f)
data['$key'] = '$val'
with open('$STATE_FILE', 'w') as f:
  json.dump(data, f, indent=2)
print('Updated $key = $val')
"
}

for pair in "$@"; do
  key="${pair%%=*}"
  val="${pair#*=}"
  update_key "$key" "$val"
done

# Update timestamp
python3 -c "
import json
from datetime import datetime
with open('$STATE_FILE') as f:
  data = json.load(f)
data['last_updated'] = datetime.now().isoformat()
with open('$STATE_FILE', 'w') as f:
  json.dump(data, f, indent=2)
"