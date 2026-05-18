#!/usr/bin/env bash
set -euo pipefail

VERBS_URL="https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/spinner-verbs.json"
SETTINGS_FILE="${HOME}/.claude/settings.json"
SETTINGS_DIR="${HOME}/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[turkish-verbs]${NC} $*"; }
warn()    { echo -e "${YELLOW}[turkish-verbs]${NC} $*"; }
error()   { echo -e "${RED}[turkish-verbs]${NC} $*" >&2; }

# Check dependencies
for cmd in curl jq; do
  if ! command -v "$cmd" &>/dev/null; then
    error "Required command not found: $cmd"
    error "Install it and try again."
    exit 1
  fi
done

# Fetch verbs
info "Fetching Turkish spinner verbs..."
VERBS_JSON=$(curl -fsSL "$VERBS_URL") || {
  error "Failed to download verbs from $VERBS_URL"
  exit 1
}

# Validate JSON
if ! echo "$VERBS_JSON" | jq empty 2>/dev/null; then
  error "Downloaded JSON is invalid. Aborting."
  exit 1
fi

SPINNER_VERBS_BLOCK=$(echo "$VERBS_JSON" | jq '.spinnerVerbs')

# Create settings dir if needed
mkdir -p "$SETTINGS_DIR"

if [ ! -f "$SETTINGS_FILE" ]; then
  # No existing settings — write fresh
  echo "$VERBS_JSON" | jq '{spinnerVerbs: .spinnerVerbs}' > "$SETTINGS_FILE"
  info "Created $SETTINGS_FILE with Turkish spinner verbs."
else
  warn "Existing settings file found at $SETTINGS_FILE"
  echo ""
  echo "  [m] Merge   — replace only spinnerVerbs, keep all other settings"
  echo "  [o] Overwrite — replace entire settings file"
  echo "  [c] Cancel"
  echo ""
  read -rp "Choose an option [m/o/c]: " choice

  case "$(echo "$choice" | tr '[:upper:]' '[:lower:]')" in
    m)
      BACKUP="${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
      cp "$SETTINGS_FILE" "$BACKUP"
      warn "Backed up existing settings to $BACKUP"
      MERGED=$(jq --argjson sv "$SPINNER_VERBS_BLOCK" '.spinnerVerbs = $sv' "$SETTINGS_FILE")
      echo "$MERGED" > "$SETTINGS_FILE"
      info "Merged Turkish spinner verbs into $SETTINGS_FILE"
      ;;
    o)
      BACKUP="${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
      cp "$SETTINGS_FILE" "$BACKUP"
      warn "Backed up existing settings to $BACKUP"
      echo "$VERBS_JSON" | jq '{spinnerVerbs: .spinnerVerbs}' > "$SETTINGS_FILE"
      info "Overwrote $SETTINGS_FILE with Turkish spinner verbs."
      ;;
    c)
      info "Cancelled. No changes made."
      exit 0
      ;;
    *)
      error "Invalid choice. Aborting."
      exit 1
      ;;
  esac
fi

info "Done! Restart Claude Code to see Turkish verbs in action."
