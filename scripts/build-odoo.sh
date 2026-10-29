#!/usr/bin/env bash
# Crea dist/odoo-assistant.zip da caricare in Claude Desktop (Customize › Plugins › Upload plugin).
# Il plugin è uguale per tutti i clienti: gli indirizzi di test e produzione li aggiunge il cliente come connettori.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
src=$root/plugins/odoo-assistant
out=$root/dist/odoo-assistant.zip

jq -e . "$src/.claude-plugin/plugin.json" > /dev/null
! grep -rq 'user_config' "$src" || { echo "Errore: user_config non funziona in Claude Desktop" >&2; exit 1; }

mkdir -p "$root/dist"
rm -f "$out"
(cd "$src" && zip -qr "$out" .)
unzip -l "$out" | grep -q ' \.claude-plugin/plugin\.json$' || { echo "Errore: plugin.json non alla radice" >&2; exit 1; }

echo "$out"
