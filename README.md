# Claude Code Spinner Verbs — Türkçe Paket

Claude Code terminalinde çalışırken varsayılan spinner yazısı yerine gerçek Türk enerjisi:

```
beni anlamadın ya, ben ona yanıyorum…
Adaya veda eden isim oluyor…
Horon tepiyor…
Marmaraya biniyor…
Düşeş atıyor…
```

## Gereksinimler

- Claude Code **v2.1.23** veya üzeri

## Kurulum

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/install.ps1 | iex
```

### Elle kurulum

1. `spinner-verbs.json` dosyasını bu repodan indirin
2. `spinnerVerbs` bloğunu `~/.claude/settings.json` dosyanıza ekleyin:

```json
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": ["İpe un seriyor", "Dört nala gidiyor", "..."]
  }
}
```

## Modlar

| Mod       | Davranış                                                 |
| --------- | -------------------------------------------------------- |
| `replace` | Yalnızca Türkçe fiiller gösterilir (varsayılan)          |
| `append`  | Türkçe fiiller Claude'un varsayılanlarıyla karışık gelir |

`~/.claude/settings.json` içindeki `"mode"` değerini değiştirerek geçiş yapabilirsiniz.

## Pakette neler var

- **Türk deyimleri** — İpe un seriyor, Göle maya çalıyor, Bir taşla iki kuş vuruyor…
- **Kültürel referanslar** — Koalisyon kuruyor, Elinin hamuruyla işe karışıyor, Düşeş atıyor…
- **80'ler-90'lar nostaljisi** — Kaseti kalemle sarıyor, başkası olma kendin ol, Kral FM dinliyor…

Tüm fiiller geneldir — çalışma durumunu, ruh halini veya karakteri anlatır; yazılım görevlerini değil.

## Kişiselleştirme

Hoşlanmadığın ifade mi var? Satırı sil. Düz JSON, compiler gerekmiyor.

## Lisans

MIT
