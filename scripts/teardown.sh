#!/usr/bin/env bash
# Deletes every Cloudflare resource this build creates, so a rehearsal can be
# wiped before the real take. Fill in the lists below for each build.
#
#   ./scripts/teardown.sh          # asks before deleting
#   ./scripts/teardown.sh --yes    # no prompt
#
# Requires the cf CLI (npm i -g cf) and node.
set -euo pipefail

WORKERS=()      # Worker names, e.g. ("my-build")
D1=()           # D1 database names
KV=()           # KV namespace titles
R2=()           # R2 bucket names (must be empty)
QUEUES=()       # Queue names

# Look up a resource ID by name from a cf list command's JSON output.
# usage: id_for <name> <name-field> <id-field> <cf list args...>
id_for() {
  local name=$1 name_field=$2 id_field=$3; shift 3
  cf "$@" | node -e '
    const [name, nf, idf] = process.argv.slice(1);
    let s = ""; process.stdin.on("data", d => s += d).on("end", () => {
      const hit = JSON.parse(s).find(r => r[nf] === name);
      if (hit) console.log(hit[idf]);
    });' "$name" "$name_field" "$id_field"
}

total=$(( ${#WORKERS[@]} + ${#D1[@]} + ${#KV[@]} + ${#R2[@]} + ${#QUEUES[@]} ))
if (( total == 0 )); then
  echo "Nothing to tear down. Fill in the resource lists in $0." >&2
  exit 1
fi

echo "This will permanently delete:"
for w in "${WORKERS[@]}"; do echo "  Worker  $w"; done
for d in "${D1[@]}";      do echo "  D1      $d"; done
for k in "${KV[@]}";      do echo "  KV      $k"; done
for b in "${R2[@]}";      do echo "  R2      $b"; done
for q in "${QUEUES[@]}";  do echo "  Queue   $q"; done
cf accounts list | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>console.log("Account: "+JSON.parse(s).map(a=>a.name).join(", ")))'

if [[ "${1:-}" != "--yes" ]]; then
  read -rp "Type 'delete' to continue: " ok
  [[ "$ok" == "delete" ]] || { echo "Aborted."; exit 1; }
fi

# Queues before Workers, so consumers don't block the Worker delete.
for q in "${QUEUES[@]}"; do
  id=$(id_for "$q" queue_name queue_id queues list)
  [[ -n "$id" ]] && cf queues delete "$id" && echo "✓ queue $q" || echo "- queue $q not found"
done

for w in "${WORKERS[@]}"; do
  cf workers delete "$w" >/dev/null 2>&1 && echo "✓ worker $w" || echo "- worker $w not found"
done

for d in "${D1[@]}"; do
  id=$(id_for "$d" name uuid d1 list)
  [[ -n "$id" ]] && cf d1 delete "$id" && echo "✓ d1 $d" || echo "- d1 $d not found"
done

for k in "${KV[@]}"; do
  id=$(id_for "$k" title id kv namespaces list)
  [[ -n "$id" ]] && cf kv namespaces delete "$id" && echo "✓ kv $k" || echo "- kv $k not found"
done

# R2 buckets must be empty before they can be deleted.
for b in "${R2[@]}"; do
  if cf r2 buckets delete "$b" >/dev/null 2>&1; then
    echo "✓ r2 $b"
  else
    echo "! r2 $b: empty it first (dashboard → R2 → $b → delete objects), then rerun"
  fi
done

echo "Done."
