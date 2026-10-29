---
name: setup
description: Guida l'utente a completare il collegamento a Odoo (login, permessi, prova). Usala al primo avvio del plugin, quando l'utente scrive /odoo-assistant:setup, o quando dice che Odoo non risponde o non è collegato.
---

# Inizializzazione del collegamento a Odoo

Guida l'utente un passo alla volta, in italiano, con frasi brevi. Aspetta il "fatto" prima di passare al passo dopo. L'installazione di Odoo è seguita da bwlab (lmassa@bwlab.it; supporto: help@bwlab.it o support@bwlab.it).

## 1. Aggiungere i connettori
Il plugin non contiene gli indirizzi: l'utente aggiunge da solo un connettore per ogni ambiente, così può cambiarli quando vuole. I nomi devono essere esattamente questi:

| Nome | Ambiente | Indirizzo |
|---|---|---|
| `odoo-test` | prova | quello di test dato da bwlab, finisce con `/mcp` |
| `odoo-produzione` | dati veri | quello di produzione dato da bwlab, finisce con `/mcp` |

Chiedi prima quali ambienti vuole collegare: possono essere uno o tutti e due. Consiglia di iniziare da `odoo-test`. Poi chiedi dove sta lavorando.

**Claude Desktop o claude.ai (chat e Cowork)**
1. **Customize › Connectors › Aggiungi connettore personalizzato**.
2. Nome `odoo-test` (o `odoo-produzione`), indirizzo del relativo ambiente.
3. **Collega**: si apre il login di Odoo di quell'ambiente. Accede con le sue credenziali normali. Nessuna chiave da copiare.
4. Ripete per l'altro ambiente.
- Piano Free: è ammesso un solo connettore, quindi un solo ambiente.
- Piani Team ed Enterprise: il connettore lo aggiunge il proprietario dell'organizzazione; l'utente fa solo **Collega**.

**Claude Code (terminale o scheda Code)**
Fagli eseguire nel terminale, con l'indirizzo giusto:
```
claude mcp add --scope user --transport http odoo-test <indirizzo-test>
claude mcp add --scope user --transport http odoo-produzione <indirizzo-produzione>
```
Poi in Claude scrive `/mcp`, sceglie il connettore e **Authenticate**: si apre il login di Odoo.

**Cambiare un indirizzo**
- Desktop: rimuovi il connettore da **Customize › Connectors** e aggiungilo di nuovo con lo stesso nome e il nuovo indirizzo, poi **Collega**.
- Claude Code: `claude mcp remove --scope user odoo-test`, poi di nuovo `claude mcp add` come sopra.

## 2. Permessi (schermata di consenso)
- Nella schermata c'è la casella **"Consenti di creare e modificare dati"**.
- Casella tolta = sola lettura: l'AI cerca e legge, e gli strumenti di scrittura non compaiono. Consiglialo per la prima settimana.
- Casella lasciata = anche creare, modificare e cancellare, con i diritti Odoo dell'utente.
- Si cambia ripetendo il login.

## 3. Prova
Per ogni connettore collegato (`odoo-test`, `odoo-produzione`), chiama tu i suoi strumenti, uno alla volta, e mostra l'esito in parole semplici dicendo sempre di quale ambiente si tratta:
1. `get_current_context`: deve dire utente e azienda. Chiedi all'utente se l'azienda è giusta.
2. `aggregate_records` sul modello `res.partner`, senza raggruppamenti utili (conteggio): deve dare un numero.
3. Una lettura con `search_records` su `sale.order`, limite 3.

Se tutte vanno: collegamento completo. Ricorda all'utente che i dati di Odoo passano nella conversazione con l'AI.

## 4. Se non funziona
| Cosa succede | Cosa fare |
|---|---|
| Login ok ma ogni richiesta dà 403 | L'utente non è nel gruppo "MCP User". Richiesta a bwlab. |
| Errore 404 "No database is selected" | Problema del server. Richiesta a bwlab con l'errore esatto. |
| 401 dopo un po' | Collegamento scaduto: rifai il login (Desktop: Customize › Connectors › Collega; Claude Code: `/mcp` › Authenticate). |
| Il pulsante Collega è grigio | Piano Team/Enterprise: il connettore va aggiunto dal proprietario dell'organizzazione. Altrimenti aggiorna l'app o prova da claude.ai. |
| Non vedi strumenti di scrittura | Hai dato il consenso in sola lettura. Ripeti il login lasciando la casella. |
| "Troppe richieste" | Limite al minuto: aspetta qualche minuto. |
| Il login non si apre | Altro browser o sblocca i popup; se persiste, bwlab. |

Per ogni richiesta a bwlab prepara il testo per help@bwlab.it o support@bwlab.it: oggetto con il nome azienda, cosa non funziona, **errore esatto**, cosa è stato provato.

## 5. Chiave API (solo se il login non è possibile)
Prima conferma con bwlab. In Odoo: Il mio profilo › Sicurezza dell'account › Nuova chiave API, accesso **Solo MCP**. La chiave si vede una sola volta: va nel gestore di password. **Non incollarla mai in questa conversazione.** Se succede, revocala dal profilo e creane una nuova.
