# odoo-assistant

Plugin di **bwlab** per i clienti Odoo. Insegna all'assistente AI (Claude o Codex) come collegarsi a Odoo e come lavorarci in sicurezza: cercare, leggere e, se autorizzato, modificare i dati parlando in italiano.

Il plugin contiene solo istruzioni. Il collegamento vero a Odoo (server MCP) lo aggiunge ogni cliente a parte, con il proprio indirizzo e il proprio login.

## Cosa contiene

| Skill | A cosa serve |
|---|---|
| `setup` | Guida passo passo al collegamento: connettori, login, permessi, prova, soluzione dei problemi più comuni. |
| `regole-uso` | Regole che l'AI segue a ogni operazione su Odoo: conferma prima di scrivere, attenzione alla produzione, niente configurazione, dati personali. |

Il plugin è uguale per tutti i clienti: dentro non ci sono indirizzi né credenziali.

## Dove funziona

| App | Plugin | Collegamento a Odoo |
|---|---|---|
| Claude Desktop, claude.ai (chat e Cowork) | Sì | Sì |
| Claude Code (terminale o scheda Code) | Sì | Sì |
| Codex (terminale o app desktop) | Sì | Sì |
| ChatGPT (sito o app) | No | Sì, solo il connettore: le regole d'uso non arrivano |

## 1. Installare il plugin

### Claude Desktop e claude.ai
1. Scarica `odoo-assistant.zip` (lo prepara bwlab, vedi "Per bwlab" più sotto).
2. **Customize › Plugins › Upload plugin** e scegli il file.

### Claude Code
```
claude plugin marketplace add bwlab/odoo-assistant
claude plugin install odoo-assistant@bwlab-odoo-assistant
```

### Codex (terminale e app desktop)
```
codex plugin marketplace add bwlab/odoo-assistant
codex plugin add odoo-assistant@bwlab-odoo-assistant
```
Il terminale e l'app desktop di Codex usano le stesse impostazioni: dopo l'installazione da terminale, riavvia l'app desktop e il plugin c'è.

## 2. Collegare Odoo

Ogni ambiente è un connettore separato, con questi nomi esatti:

| Nome | Ambiente |
|---|---|
| `odoo-test` | prova |
| `odoo-produzione` | dati veri |

Gli indirizzi li dà bwlab e finiscono con `/mcp`. Si può collegare uno solo dei due ambienti o tutti e due. Consigliato: iniziare da `odoo-test`.

Dopo l'installazione basta chiedere all'AI "collega Odoo" (in Claude anche `/odoo-assistant:setup`): la skill `setup` guida ogni passo. In breve:

- **Claude Desktop / claude.ai**: Customize › Connectors › Aggiungi connettore personalizzato, poi **Collega** e login Odoo.
- **Claude Code**:
  ```
  claude mcp add --scope user --transport http odoo-test <indirizzo-test>
  ```
  poi `/mcp` › Authenticate.
- **Codex**:
  ```
  codex mcp add odoo-test --url <indirizzo-test>
  codex mcp login odoo-test
  ```
- **ChatGPT**: Impostazioni › App e connettori › Modalità sviluppatore, poi **Crea app** con accesso OAuth.

L'accesso usa il login Odoo normale dell'utente: nessuna chiave da copiare.

## 3. Permessi

Nella schermata di login c'è la casella **"Consenti di creare e modificare dati"**:
- tolta: sola lettura, l'AI può solo cercare e leggere (consigliato la prima settimana);
- lasciata: l'AI può anche creare, modificare e cancellare, con gli stessi diritti Odoo dell'utente.

Si cambia ripetendo il login.

## 4. Regole che l'AI segue

- Dice sempre da quale ambiente vengono i dati. Se sono collegati test e produzione e la richiesta non lo dice, chiede quale usare.
- Leggere è libero. Prima di ogni scrittura dice cosa cambia e su quanti record, e aspetta un "sì".
- In produzione scrive "PRODUZIONE" nella richiesta di conferma.
- Le cancellazioni sono sempre una richiesta a parte.
- Non conferma, registra né annulla fatture e registrazioni contabili se l'utente non lo chiede in modo esplicito.
- Avvisa quando un risultato contiene dati personali.
- Non tocca la configurazione di Odoo (utenti, permessi, moduli, impostazioni): quella si fa da Odoo o con bwlab.

## 5. Problemi comuni

| Cosa succede | Cosa fare |
|---|---|
| Login ok ma ogni richiesta dà 403 | L'utente non è nel gruppo "MCP User": scrivere a bwlab. |
| 401 dopo un po' | Collegamento scaduto: rifare il login. |
| Non si vedono strumenti di scrittura | Consenso dato in sola lettura: rifare il login lasciando la casella. |
| "Troppe richieste" | Limite al minuto: aspettare qualche minuto. |
| Il login non si apre | Provare un altro browser o sbloccare i popup. |

Per tutto il resto: **help@bwlab.it** o **support@bwlab.it**, con nome dell'azienda, cosa non funziona, errore esatto e cosa è stato provato.

## Per bwlab

### Struttura
```
.claude-plugin/marketplace.json          catalogo (letto da Claude Code e Codex)
plugins/odoo-assistant/
  .claude-plugin/plugin.json             nome, versione, descrizione
  skills/setup/SKILL.md                  guida al collegamento
  skills/regole-uso/SKILL.md             regole d'uso
scripts/build-odoo.sh                    crea lo zip per Claude Desktop
prompt-odoo-mcp.md                       prompt di collegamento per app senza plugin
```

### Pacchetto per Claude Desktop
```
scripts/build-odoo.sh
```
Crea `dist/odoo-assistant.zip` (cartella esclusa da git). Lo script controlla che `plugin.json` sia valido e alla radice dello zip, e che non ci sia `user_config`, che Claude Desktop ignora.

### Nuova versione
1. Modifica le skill.
2. Alza `version` in `plugins/odoo-assistant/.claude-plugin/plugin.json`.
3. Rigenera lo zip e mandalo ai clienti Claude Desktop.
4. Claude Code e Codex prendono l'aggiornamento dal repo.

### `prompt-odoo-mcp.md`
Prompt da incollare in un'app che non supporta i plugin (ChatGPT, Copilot, Gemini…). Prima di consegnarlo sostituisci i segnaposto `{{NOME_CLIENTE}}`, `{{NOME_AZIENDA}}`, `{{URL_MCP}}`, `{{AMBIENTE}}`, `{{DB}}`, `{{SLUG}}`.
