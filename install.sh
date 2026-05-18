#!/usr/bin/env bash
#
# install.sh — Claude Code için Türkçe spinner fiillerini kurar.
# macOS / Linux. Gereksinimler: bash, curl, jq.
#
set -euo pipefail

# --- config ---
REPO_RAW_URL="https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/spinner-verbs.json"
SETTINGS_DIR="${HOME}/.claude"
SETTINGS_FILE="${SETTINGS_DIR}/settings.json"

# --- pretty output ---
say()  { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m==>\033[0m %s\n" "$*" >&2; }

# --- prerequisites ---
for cmd in curl jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "'$cmd' kurulu değil, gerekli."
    case "$cmd" in
      jq)
        err "  macOS:  brew install jq"
        err "  Debian: sudo apt-get install jq"
        ;;
    esac
    exit 1
  fi
done

# --- fetch the verbs ---
say "GitHub'dan son fiiller çekiliyor..."
TMP_VERBS="$(mktemp)"
trap 'rm -f "$TMP_VERBS"' EXIT

if ! curl -fsSL "$REPO_RAW_URL" -o "$TMP_VERBS"; then
  err "Fiiller çekilemedi. İnternet bağlantını veya şu URL'yi kontrol et:"
  err "  $REPO_RAW_URL"
  exit 1
fi

if ! jq empty "$TMP_VERBS" 2>/dev/null; then
  err "İndirilen dosya geçerli JSON değil. Bir şeyleri mahvetmeden duruyorum."
  exit 1
fi

# --- ensure settings dir exists ---
mkdir -p "$SETTINGS_DIR"

# --- decide what to do with existing settings ---
ACTION="install"
if [[ -f "$SETTINGS_FILE" ]]; then
  warn "Mevcut ayar dosyası bulundu: $SETTINGS_FILE"
  echo
  echo "  [m] Birleştir  — diğer ayarları koru, sadece spinnerVerbs'i değiştir"
  echo "  [o] Üstüne yaz — tüm dosyayı Türkçe fiillerle değiştir"
  echo "  [c] İptal"
  echo
  read -rp "Ne yapalım? [m/o/c]: " CHOICE </dev/tty
  case "$(echo "$CHOICE" | tr '[:upper:]' '[:lower:]')" in
    m) ACTION="merge" ;;
    o) ACTION="overwrite" ;;
    c|*) say "Tamam, hiçbir şey yapılmadı."; exit 0 ;;
  esac
fi

# --- back up if a file exists ---
if [[ -f "$SETTINGS_FILE" ]]; then
  BACKUP="${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP"
  say "Mevcut ayarlar yedeklendi: $BACKUP"
fi

# --- write the new file ---
case "$ACTION" in
  install|overwrite)
    cp "$TMP_VERBS" "$SETTINGS_FILE"
    ;;
  merge)
    MERGED="$(mktemp)"
    jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TMP_VERBS" > "$MERGED"
    if ! jq empty "$MERGED" 2>/dev/null; then
      err "Birleştirme geçersiz JSON üretti. Orijinal ayarların dokunulmadan duruyor."
      rm -f "$MERGED"
      exit 1
    fi
    mv "$MERGED" "$SETTINGS_FILE"
    ;;
esac

say "Tamam. Yeni spinner'ı görmek için Claude Code'u yeniden başlat."
say "Fikrin değişirse eski ayarların .bak dosyasında duruyor."