---
name: regole-uso
description: Regole da seguire ogni volta che usi gli strumenti del server Odoo (cercare, leggere, creare, modificare, cancellare record, allegati, messaggi). Caricala prima di qualsiasi operazione su Odoo.
---

# Regole d'uso di Odoo

Rispondi in italiano, con parole semplici.

1. **Ambiente**: il connettore `odoo-test` è l'ambiente di prova, `odoo-produzione` sono i dati veri. Se sono collegati tutti e due e la richiesta non dice quale usare, chiedilo: non darlo per scontato. All'inizio chiama `get_current_context` su quel connettore e di' all'utente ambiente e azienda. Ogni risposta con dati di Odoo dice da quale ambiente vengono. Un connettore con un nome diverso: chiedi all'utente di che ambiente si tratta.
   - **Scritture in produzione**: prima di creare, modificare o cancellare su `odoo-produzione` scrivi "PRODUZIONE" nella richiesta di conferma. Se l'utente ha provato la stessa cosa in test, ricordaglielo.
2. **Leggere è libero. Scrivere no.** Prima di creare, modificare o cancellare di' in parole semplici cosa cambia e su quanti record, e aspetta un "sì" chiaro.
3. **Cancellare**: richiesta separata, mai dentro un altro lavoro. Per più record mostra prima l'elenco.
4. **Operazioni in blocco** (`create_records`, `update_records`): mostra prima 3 esempi e il numero totale.
5. **Documenti contabili e fiscali** (fatture, registrazioni): non confermarli, registrarli né annullarli se l'utente non lo chiede in modo esplicito.
6. **Dati personali**: avvisa quando un risultato contiene nomi, email, telefoni o indirizzi, prima di esportarlo o incollarlo altrove.
7. **Configurazione di Odoo** (utenti, permessi, moduli, impostazioni): non si fa con l'AI. Si fa da Odoo o si chiede a bwlab.
8. **Dopo ogni scrittura** rileggi il record e mostra il risultato.
9. **Totali e conteggi**: usa `aggregate_records`, non elencare righe.
10. **Fuori perimetro** (abilitare utenti o modelli, installare moduli, sviluppo, errori del server): non intervenire. Prepara la richiesta per help@bwlab.it o support@bwlab.it con oggetto, cosa non funziona, errore esatto, cosa è stato provato.
