/* #######################################################
# Corso di Programmazione Logica e Funzionale            #
# Progetto per la sessione invernale A.A. 2025/2026      #
# di Nasrine Aboufaris, Matricola: 321885                #
# e Alessia Giuseppetti, Matricola: 322984               #
# Anno di corso: Terzo                                   #
##########################################################
Specifica: Programma Prolog per la codifica/decodifica   #
di codici di Hamming e calcolo della distanza di Hamming #*/

/* Predicato principale del programma. 
   Stampa il messaggio di benvenuto e avvia il ciclo principale del menu. */
main :- 
    mostra_benvenuto,
    ciclo_menu.

/* Predicato che gestisce il menu interattivo. 
   Mostra le opzioni disponibili, acquisisce la scelta dell'utente 
   ed esegue l'operazione corrispondente. */
ciclo_menu :-
    nl, write('Scegliere l\'operazione:'), nl,
    mostra_voci_menu,
    acquisisci_opzione(Opzione),
    esegui_scelta(Opzione).

/* --- INTERFACCIA UTENTE --- */

/* Predicato che stampa il messaggio di benvenuto e le informazioni iniziali. */
mostra_benvenuto :-
    nl, write('------------------------------------Benvenuto------------------------------------'), nl,
    write('Il seguente programma permette di utilizzare i codici di Hamming generici (n,k)'), nl,
    write('per la codifica, decodifica e calcolo della distanza di Hamming tra due parole'), nl,
    write('binarie.'), nl,
    write('Si ricorda che la decodifica implementata permette di individuare e correggere'), nl,
    write('un singolo errore.'), nl,
    write('Istruzioni:'), nl,
    write('Scegliere dal menu una delle tre operazioni da eseguire.'), nl,
    write('Per la codifica e decodifica di Hamming: '), nl,
    write(' 1. Inserire l\'indice di parità (numero intero >= 2)'), nl,
    write(' 2. Inserire una parola binaria di lunghezza adeguata ai parametri del codica di'), nl,
    write('    Hamming calcolati in base a m.'), nl,
    write('Per il calcolo della distanza di Hamming: '), nl,
    write(' 1. Inserire due parole binarie della stessa lunghezza'), nl,
    mostra_istruzioni_input,
    write('L\'esecuzione termina selezionando l\'apposita voce dal menu.'), nl,
    write('---------------------------------------------------------------------------------'), nl.

/* Predicato che visualizza le voci del menu principale. */
mostra_voci_menu :-
    write('1. Codifica di Hamming'), nl,
    write('2. Decodifica di Hamming'), nl,
    write('3. Distanza di Hamming'), nl,
    write('4. Esci'), nl.

/* Predicato che stampa le istruzioni per la formattazione dell'input. */
mostra_istruzioni_input :-
    write('Nota: le parole devono essere inserite nel seguente formato, es. [1,0,1,1].'), nl.

/* Predicato per l'acquisizione della scelta dell'utente:
   - il primo argomento e' la variabile che unifica con la scelta valida. */
acquisisci_opzione(Opzione) :-
    catch(read(Input), _, Input = non_valido),
    valida_e_unifica_opzione(Input, Opzione).

/* Predicato che valida l'opzione inserita e gestisce eventuali errori:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' l'opzione validata. */
valida_e_unifica_opzione(Input, Input) :- 
    opzione_valida(Input), !.
valida_e_unifica_opzione(_, Opzione) :-
    write('Opzione non valida. Riprovare.'), nl,
    ciclo_menu.

/* Predicato che verifica la validita' dell'opzione:
   - il primo argomento e' il valore da verificare (deve essere tra 1 e 4). */
opzione_valida(X) :- integer(X), between(1, 4, X).

/* --- GESTIONE DELLE SCELTE --- */

/* Predicato che termina l'esecuzione del programma:
   - il primo argomento e' l'opzione scelta (4). */
esegui_scelta(4) :- 
    !, nl, write('Esecuzione terminata'), nl.

/* Predicato che avvia la procedura di codifica:
   - il primo argomento e' l'opzione scelta (1). */
esegui_scelta(1) :- 
    !, gestione_codifica, 
    ciclo_menu.

/* Predicato che avvia la procedura di decodifica:
   - il primo argomento e' l'opzione scelta (2). */
esegui_scelta(2) :- 
    !, gestione_decodifica, 
    ciclo_menu.

/* Predicato che avvia la procedura di calcolo della distanza:
   - il primo argomento e' l'opzione scelta (3). */
esegui_scelta(3) :- 
    !, gestione_distanza, 
    ciclo_menu.

/* --- GESTIONE FLUSSI SPECIFICI --- */

/* Predicato che gestisce il flusso per l'operazione di codifica.
   Acquisisce i parametri e la parola, esegue il calcolo e stampa il risultato. */
gestione_codifica :-
    nl, write('Codifica di Hamming'), nl,
    richiedi_m(M),
    parametri_hamming(M, K, N),
    write('Parametri: n = '), write(N), write(', k = '), write(K), nl,
    richiedi_parola(Parola, K),
    codifica_pura(Parola, M, Codice),
    write('Parola codificata: '), write(Codice), nl.

/* Predicato che gestisce il flusso per l'operazione di decodifica.
   Acquisisce i parametri e la parola ricevuta, esegue la correzione e mostra l'esito. */
gestione_decodifica :-
    nl, write('Decodifica di Hamming'), nl,
    richiedi_m(M),
    parametri_hamming(M, K, N),
    write('Parametri: n = '), write(N), write(', k = '), write(K), nl,
    richiedi_parola(Parola, N),
    decodifica_pura(Parola, M, Risultato),
    mostra_risultato_decodifica(Risultato).

/* Predicato che gestisce il flusso per il calcolo della distanza di Hamming.
   Acquisisce due parole binarie e ne calcola la distanza. */
gestione_distanza :-
    nl, write('Distanza di Hamming'), nl,
    write('Inserire la prima parola binaria'), nl,
    mostra_istruzioni_input,
    acquisisci_parola_generica(P1, 'Errore: inserire parola di soli 0 e 1.'),
    length(P1, LunghezzaP1),
    write('Inserire la seconda parola (lunghezza '), write(LunghezzaP1), write(')'), nl,
    mostra_istruzioni_input,
    acquisisci_parola_distanza(P2, LunghezzaP1),
    verifica_e_calcola_distanza(P1, P2).

/* --- ACQUISIZIONE DATI --- */

/* Predicato che richiede all'utente il parametro m (bit di parità):
   - il primo argomento e' la variabile che unifica con il valore valido. */
richiedi_m(M) :-
    write('Il bit di parità deve essere maggiore o uguale a 2'), nl,
    write('Inserire il bit di parità scelto: '),
    catch(read(Input), _, Input = err),
    valida_e_unifica_m(Input, M).

/* Predicato che valida l'input per il parametro m:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' il valore validato. */
valida_e_unifica_m(Input, Input) :- 
    integer(Input), Input >= 2, !.
valida_e_unifica_m(_, M) :-
    write('Errore: valore non valido.'), nl, 
    richiedi_m(M).

/* Predicato che richiede una parola binaria di lunghezza specifica:
   - il primo argomento e' la parola acquisita;
   - il secondo argomento e' la lunghezza attesa. */
richiedi_parola(Parola, Lun) :-
    write('Inserire parola binaria di lunghezza '), write(Lun), nl,
    mostra_istruzioni_input,
    catch(read(Input), _, Input = err),
    valida_e_unifica_parola(Input, Lun, Parola).

/* Predicato che valida la lunghezza e il contenuto della parola inserita:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' la lunghezza richiesta;
   - il terzo argomento e' la parola validata. */
valida_e_unifica_parola(Input, Lun, Input) :-
    is_list(Input), length(Input, Lun), verifica_bit(Input), !.
valida_e_unifica_parola(_, Lun, Parola) :-
    write('Errore: devi inserire esattamente '), write(Lun), write(' bit (0 o 1).'), nl,
    richiedi_parola(Parola, Lun).

/* Predicato per l'acquisizione di una parola binaria senza vincoli di lunghezza:
   - il primo argomento e' la parola acquisita;
   - il secondo argomento e' il messaggio di errore da mostrare in caso di fallimento. */
acquisisci_parola_generica(Parola, MsgErrore) :-
    catch(read(Input), _, Input = err),
    valida_parola_generica(Input, Parola, MsgErrore).

/* Predicato che valida una parola generica:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' la parola validata;
   - il terzo argomento e' il messaggio di errore. */
valida_parola_generica(Input, Input, _) :-
    is_list(Input), verifica_bit(Input), !.
valida_parola_generica(_, Parola, MsgErrore) :-
    write(MsgErrore), nl,
    acquisisci_parola_generica(Parola, MsgErrore).

/* Predicato che acquisisce la seconda parola per il calcolo della distanza, verificandone la lunghezza:
   - il primo argomento e' la parola acquisita;
   - il secondo argomento e' la lunghezza della prima parola (riferimento). */
acquisisci_parola_distanza(Parola, Lun) :-
    catch(read(Input), _, Input = err),
    valida_seconda_parola(Input, Lun, Parola).

/* Predicato che valida la seconda parola controllando lunghezza e contenuto:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' la lunghezza attesa;
   - il terzo argomento e' la parola validata. */
valida_seconda_parola(Input, Lun, Input) :-
    is_list(Input), length(Input, Lun), verifica_bit(Input), !.
valida_seconda_parola(_, Lun, Parola) :-
    write('Errore: lunghezza diversa dalla prima parola o caratteri non validi.'), nl,
    write('Inserire la seconda parola (lunghezza '), write(Lun), write(')'), nl,
    mostra_istruzioni_input,
    acquisisci_parola_distanza(Parola, Lun).

/* Predicato che verifica se una lista contiene solo bit (0 o 1):
   - il primo argomento e' la lista da verificare. */
verifica_bit([]).
verifica_bit([0|Coda]) :- verifica_bit(Coda).
verifica_bit([1|Coda]) :- verifica_bit(Coda).

/* --- CALCOLI E LOGICA DI HAMMING --- */

/* Predicato che calcola i parametri n e k dato m:
   - il primo argomento e' m (bit di parita');
   - il secondo argomento e' k (bit di dati);
   - il terzo argomento e' n (lunghezza totale). */
parametri_hamming(M, K, N) :-
    potenza_due(M, PotenzaDueM),
    N is PotenzaDueM - 1,
    K is N - M.

/* Predicato che calcola la potenza di due in modo ricorsivo:
   - il primo argomento e' l'esponente;
   - il secondo argomento e' il risultato. */
potenza_due(0, 1) :- !.
potenza_due(N, Risultato) :- 
    N > 0, N1 is N - 1, 
    potenza_due(N1, R1), 
    Risultato is 2 * R1.

/* Predicato che verifica se un numero e' una potenza di due (bitwise):
   - il primo argomento e' il numero da verificare. */
e_potenza_di_due(X) :- X > 0, (X /\ (X - 1)) =:= 0.

/* Predicato che esegue la codifica di Hamming completa:
   - il primo argomento e' la lista dei bit di dati;
   - il secondo argomento e' il numero di bit di parita';
   - il terzo argomento e' il codice finale calcolato. */
codifica_pura(Dati, M, CodiceFinale) :-
    espandi_dati(Dati, 1, CodiceEspanso),
    genera_posizioni_parita(M, Posizioni),
    riempi_parita(Posizioni, CodiceEspanso, CodiceFinale).

/* Predicato che espande la lista dati inserendo zeri nelle posizioni di parita':
   - il primo argomento e' la lista dati;
   - il secondo argomento e' il contatore di posizione corrente;
   - il terzo argomento e' la lista espansa. */
espandi_dati([], _, []).
espandi_dati(Dati, Pos, [0|RestoCodice]) :-
    e_potenza_di_due(Pos), !,
    PosSucc is Pos + 1,
    espandi_dati(Dati, PosSucc, RestoCodice).
espandi_dati([Bit|RestoDati], Pos, [Bit|RestoCodice]) :-
    PosSucc is Pos + 1,
    espandi_dati(RestoDati, PosSucc, RestoCodice).

/* Predicato che genera la lista delle posizioni di parita' (1, 2, 4...):
   - il primo argomento e' m;
   - il secondo argomento e' la lista delle posizioni. */
genera_posizioni_parita(M, Lista) :- genera_pos_ric(0, M, Lista).

/* Predicato ausiliario per la generazione ricorsiva delle posizioni:
   - il primo argomento e' l'esponente corrente;
   - il secondo argomento e' il limite m;
   - il terzo argomento e' la lista costruita. */
genera_pos_ric(Exp, M, []) :- Exp >= M, !.
genera_pos_ric(Exp, M, [Val|Resto]) :-
    potenza_due(Exp, Val), ESucc is Exp + 1,
    genera_pos_ric(ESucc, M, Resto).

/* Predicato che calcola e inserisce i bit di parita' nel codice:
   - il primo argomento e' la lista delle posizioni di parita';
   - il secondo argomento e' il codice attuale;
   - il terzo argomento e' il codice aggiornato. */
riempi_parita([], Codice, Codice).
riempi_parita([P|RestoP], CodiceIn, CodiceOut) :-
    calcola_bit_singolo(CodiceIn, P, Bit),
    sostituisci_bit(CodiceIn, P, Bit, CodiceProssimo),
    riempi_parita(RestoP, CodiceProssimo, CodiceOut).

/* Predicato che calcola il valore di un singolo bit di parita' P:
   - il primo argomento e' la lista dei bit;
   - il secondo argomento e' la posizione P;
   - il terzo argomento e' il valore del bit (0 o 1). */
calcola_bit_singolo(Lista, P, Bit) :-
    scansiona_parita(Lista, 1, P, 0, Somma),
    Bit is Somma mod 2.

/* Predicato che scansiona la lista per sommare i bit controllati da P:
   - il primo argomento e' la lista residua;
   - il secondo argomento e' l'indice corrente;
   - il terzo argomento e' la posizione P;
   - il quarto argomento e' l'accumulatore;
   - il quinto argomento e' il totale. */
scansiona_parita([], _, _, Acc, Acc).
scansiona_parita([Bit|Resto], Indice, P, Acc, Totale) :-
    (Indice /\ P) > 0, !,
    NuovoAcc is Acc + Bit, Prossimo is Indice + 1,
    scansiona_parita(Resto, Prossimo, P, NuovoAcc, Totale).
scansiona_parita([_|Resto], Indice, P, Acc, Totale) :-
    Prossimo is Indice + 1,
    scansiona_parita(Resto, Prossimo, P, Acc, Totale).

/* Predicato che sostituisce un elemento nella lista alla posizione specificata:
   - il primo argomento e' la lista originale;
   - il secondo argomento e' la posizione;
   - il terzo argomento e' il nuovo valore;
   - il quarto argomento e' la lista modificata. */
sostituisci_bit([_|C], 1, Val, [Val|C]) :- !.
sostituisci_bit([T|C], Pos, Val, [T|Resto]) :-
    Pos > 1, P1 is Pos - 1,
    sostituisci_bit(C, P1, Val, Resto).

/* --- LOGICA DI DECODIFICA --- */

/* Predicato che esegue la decodifica di Hamming:
   - il primo argomento e' il codice ricevuto;
   - il secondo argomento e' m;
   - il terzo argomento e' una struttura risultato con l'esito. */
decodifica_pura(Codice, M, Risultato) :-
    genera_posizioni_parita(M, Posizioni),
    calcola_sindrome(Codice, Posizioni, Sindrome),
    crea_risultato(Sindrome, Codice, Risultato).

/* Predicato che calcola la sindrome sommando le posizioni errate:
   - il primo argomento e' il codice;
   - il secondo argomento e' la lista posizioni parita';
   - il terzo argomento e' la sindrome calcolata. */
calcola_sindrome(_, [], 0).
calcola_sindrome(Codice, [P|Resto], Sindrome) :-
    calcola_sindrome(Codice, Resto, SindromeParz),
    calcola_bit_singolo(Codice, P, Controllo),
    aggiorna_sindrome(Controllo, P, SindromeParz, Sindrome).

/* Predicato che aggiorna la sindrome se il controllo di parita' fallisce:
   - il primo argomento e' l'esito del controllo (1 = errore);
   - il secondo argomento e' la posizione P;
   - il terzo argomento e' la sindrome parziale;
   - il quarto argomento e' la sindrome aggiornata. */
aggiorna_sindrome(1, P, Parz, Tot) :- Tot is Parz + P, !.
aggiorna_sindrome(_, _, Parz, Parz).

/* Predicato che crea la struttura risultato in base alla sindrome:
   - il primo argomento e' la sindrome;
   - il secondo argomento e' il codice;
   - il terzo argomento e' il risultato formattato. */
crea_risultato(0, Codice, risultato(Dati, nessun_errore, 0)) :-
    estrai_dati(Codice, 1, Dati).
crea_risultato(Sindrome, Codice, risultato(Dati, errore_corretto, Sindrome)) :-
    length(Codice, L), Sindrome =< L, !,
    correggi_bit(Codice, Sindrome, Corretta),
    estrai_dati(Corretta, 1, Dati).
crea_risultato(Sindrome, _, risultato([], errore_critico, Sindrome)).

/* Predicato che inverte un bit alla posizione indicata per correggere l'errore:
   - il primo argomento e' la lista;
   - il secondo argomento e' la posizione;
   - il terzo argomento e' la lista corretta. */
correggi_bit([Bit|T], 1, [Nuovo|T]) :- !, Nuovo is 1 - Bit.
correggi_bit([H|T], Pos, [H|Resto]) :-
    Pos > 1, P1 is Pos - 1,
    correggi_bit(T, P1, Resto).

/* Predicato che estrae i bit di dati rimuovendo quelli di parita':
   - il primo argomento e' la lista completa;
   - il secondo argomento e' il contatore posizione;
   - il terzo argomento e' la lista dati. */
estrai_dati([], _, []).
estrai_dati([_|Resto], Pos, Dati) :-
    e_potenza_di_due(Pos), !,
    Prossimo is Pos + 1,
    estrai_dati(Resto, Prossimo, Dati).
estrai_dati([Bit|Resto], Pos, [Bit|Dati]) :-
    Prossimo is Pos + 1,
    estrai_dati(Resto, Prossimo, Dati).

/* --- VISUALIZZAZIONE RISULTATI --- */

/* Predicato che stampa l'esito della decodifica (Nessun errore). */
mostra_risultato_decodifica(risultato(Dati, nessun_errore, _)) :-
    write('Nessun errore rilevato.'), nl,
    write('Parola decodificata: '), write(Dati), nl.

/* Predicato che stampa l'esito della decodifica (Errore corretto). */
mostra_risultato_decodifica(risultato(Dati, errore_corretto, Pos)) :-
    write('Errore corretto in posizione '), write(Pos), nl,
    write('Parola decodificata: '), write(Dati), nl.

/* Predicato che stampa l'esito della decodifica (Errore critico). */
mostra_risultato_decodifica(risultato(_, errore_critico, Pos)) :-
    write('Errore critico: Posizione errore '), write(Pos),
    write(' fuori dal range.'), nl.

/* --- CALCOLO DELLA DISTANZA --- */

/* Predicato che calcola e stampa la distanza di Hamming tra due parole:
   - il primo argomento e' la prima parola;
   - il secondo argomento e' la seconda parola. */
verifica_e_calcola_distanza(P1, P2) :-
    calcolo_distanza_ric(P1, P2, Dist),
    write('Distanza di Hamming: '), write(Dist), nl.

/* Predicato che calcola ricorsivamente la distanza tra due liste:
   - il primo argomento e' la prima lista;
   - il secondo argomento e' la seconda lista;
   - il terzo argomento e' la distanza calcolata. */
calcolo_distanza_ric([], [], 0).
calcolo_distanza_ric([T1|C1], [T2|C2], Dist) :-
    calcolo_distanza_ric(C1, C2, Resto),
    Diff is xor(T1, T2),
    Dist is Resto + Diff.