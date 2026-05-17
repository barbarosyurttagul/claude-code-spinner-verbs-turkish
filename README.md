# Claude Code Spinner Verbs — Turkish Pack

300+ Turkish-flavoured verbs for the Claude Code terminal spinner.

While Claude grinds away in your terminal, instead of the default spinner text you get authentic Turkish energy:

> _Kafa patlatıyor…_
> _Tam gaz gidiyor…_
> _Baklava katmanlarını sayıyor…_
> _Kafayı yiyor…_
> _Nöronları ateşliyor…_

## Requirements

- Claude Code **v2.1.23** or later

## Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/install.ps1 | iex
```

### Manual

1. Download `spinner-verbs.json` from this repo
2. Copy the `spinnerVerbs` block into your `~/.claude/settings.json`:

```json
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": ["Düşünüyor", "Hesaplıyor", "..."]
  }
}
```

## Modes

| Mode      | Behaviour                                           |
| --------- | --------------------------------------------------- |
| `replace` | Only Turkish verbs shown (default)                  |
| `append`  | Turkish verbs mixed with Claude's built-in defaults |

Change `"mode"` in your `~/.claude/settings.json` to switch.

## What's in the pack

The verbs span four flavour categories:

- **-yor present-participle action words** — Düşünüyor, Hesaplıyor, Yırtıyor, Kaynıyor…
- **Turkish idioms & expressions** — Kafa patlatıyor, Kolları sıvıyor, Tam gaz gidiyor, Dişini sıkıyor…
- **Cultural Turkish references** — Çayı demliyor, Boğaz'a bakıyor, Kapalıçarşı'da kaybolmuş, Vapurda martılara bakıyor…
- **Energetic slang** — Makine gibi çalışıyor, Ejderha gibi nefes alıyor, Roket gibi fırlamaya hazır…

All verbs are generic — they describe effort, mood, or state, not coding tasks.

## License

MIT
