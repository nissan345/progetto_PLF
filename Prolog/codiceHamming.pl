/* #######################################################
# Corso di Programmazione Logica e Funzionale            #
# Progetto per la sessione invernale A.A. 2025/2026      #
# di Nasrine Aboufaris, Matricola: 321885                #
# e Alessia Giuseppetti, Matricola: 322984               #
# Anno di corso: Terzo                                   #
##########################################################
Specifica: Programma Prolog per la codifica/decodifica   #
di codici di Hamming e calcolo della distanza di Hamming #*/

/* Predicato principale del programma. Fornisce istruzioni all'utente e avvia il menu. */
main :- write('------------------------Benvenuto------------------------'), nl,
        write('Il seguente programma permette di utilizzare '), 
        write('i codici di Hamming generici (n,k)'), nl,
        write('per la codifica, decodifica e calcolo della '),
        write('distanza di Hamming tra due parole binarie.'), nl, 
        write('Si ricorda che la decodifica implementata permette '), 
        write('di individuare e correggere un singolo errore.'), nl,
        write('Istruzioni:'), nl,
        write('Scegliere dal menu una delle tre operazioni da eseguire.'), nl,
        write('Per la codifica e decodifica di Hamming: '), nl,
        write('  1. Inserire l\'indice di parità (numero intero >= 2)'), nl,
        write('  2. Inserire una parola binaria di lunghezza'), 
        write(' adeguata ai parametri del codice di Hamming calcolati in base a m.'), nl,
        write('Per il calcolo della distanza di Hamming: '), nl,
        write('  1. Inserire due parole binarie della stessa lunghezza.'), nl,
        mostra_istruzioni_input,
        write(' L\'esecuzione termina selezionando l\'apposita voce dal menu.'), nl,
        write('----------------------------------------------------------'), nl,
        menu.

/* Predicato che gestisce il menu principale.
   Mostra le opzioni disponibili e acquisisce la scelta dell'utente. */
menu :- nl, write('--- MENU PRINCIPALE ---'), nl,
        write(' 1. Codifica di Hamming'), nl,
        write(' 2. Decodifica di Hamming'), nl,
        write(' 3. Distanza di Hamming'), nl,
        write(' 4. Esci'), nl,
        write('Scelta: '),
        read(Opzione),
        esegui_opzione(Opzione).

/* Il predicato esegui_opzione(1) esegue la codifica di Hamming. Chiede il numero di bit di parità M,
   calcola il parametro k, valida la parola input P di lunghezza k ed esegue la codifica. 
     - Il primo argomento è l'opzione 1 della scelta dell'utente. */
esegui_opzione(1) :- !, 
                     parita(M),
                     parametri_hamming(M, K, _N),
                     acquisisci_parola(Parola, K),
                     write('Esecuzione codifica...'), nl,
                     codifica_parola(Parola, M),
                     menu.

/* Il predicato esegui_opzione(2) esegue la Decodifica di Hamming. Chiede il numero di bit di parità M, 
   calcola il parametro n, valida il codice ricevuto di lunghezza n ed esegue la decodifica. 
    - Il primo argomento è l'opzione 2 della scelta dell'utente. */
esegui_opzione(2) :- !, 
                     parita(M),
                     parametri_hamming(M, _K, N),
                     acquisisci_parola(Parola, N),
                     write('Esecuzione decodifica...'), nl,
                     decodifica_parola(Parola, M),
                     menu.

/* Il predicato esegui_opzione(3) calcola la distanza di Hamming tra due parole.
   Acquisisce due parole binarie, ne verifica la validità, controlla che abbiano la stessa lunghezza
   e calcola la distanza.
    - Il primo argomento è l'opzione 3 scelta dall'utente. */
esegui_opzione(3) :- !, 
                     write('Inserire la prima parola binaria: '), nl,
                     mostra_istruzioni_input,
                     acquisisci_parola_distanza(Parola1),
                     write('Inserire la seconda parola binaria: '), nl,
                     mostra_istruzioni_input,
                     acquisisci_parola_distanza(Parola2),
                     verifica_e_calcola_distanza(Parola1, Parola2),
                     menu.

/* Il predicato esegui_opzione(4) si occupa di terminare il programma. 
   Termina l'esecuzione del programma dopo aver stampato un messaggio di saluto.
   - Il primo argomento è l'opzione 4 scelta dall'utente. */
esegui_opzione(4) :- !, 
                     write('Esecuzione terminata. Arrivederci!'), nl.

/* Il predicato esegui_opzione(_) gestisce opzioni non valide. 
   Visualizza un messaggio di errore e torna al menu principale.
   - Il primo argomento è un'opzione non compresa tra 1 e 4. */
esegui_opzione(_) :- write('Opzione non valida. Riprovare.'), nl,
                     menu.

/* --- GESTIONE INPUT --- */

/* Predicato che mostra le istruzioni per l'inserimento delle parole binarie. */
mostra_istruzioni_input :- 
    write('Nota: Le parole devono essere inserite nel formato lista, es. [1,0,1,1].'), nl,
    write('Assicurarsi di usare le parentesi quadre e il punto finale.'), nl.

/* Il predicato parita(M) acquisisce da tastiera il numero di bit di parità scelto 
   dall'utente e ne verifica la validità, assicurandosi che il numero 
   sia maggiore o uguale a 2. */
parita(M) :- 
    write('Inserire il numero di bit di parità (M >= 2): '), 
    catch(read(Input), _, fail),
    valida_parita(Input, M).

/* Predicato che valida l'input per m:
   - il primo argomento e' l'input letto;
   - il secondo argomento e' il valore validato restituito. */
valida_parita(Input, M) :- integer(Input), Input >= 2, !, M = Input.
valida_parita(_, M) :- write('Errore: valore non valido.'), nl, parita(M).

/* Il predicato parametri_hamming(M, K, N) calcola i parametri k(bit di dati) ed n(bit totali)
   per il codice di Hamming.
    - Il primo argomento rappresenta il numero di bit di parità.
    - Il secondo argomento rappresenta il numero di bit di dati.
    - Il terzo argomento rappresenta il numero totale di bit. 
   Esempio: parametri_hamming(3, K, N) calcola K=4 e N=7. */
parametri_hamming(M, K, N) :- 
    K is 2^M - 1 - M,
    N is 2^M - 1.

/* Il predicato acquisisci_parola acquisisce una parola binaria dall'input
   e la valida rispetto alla lunghezza specificata. 
   - Il primo argomento è la parola validata in output.
   - Il secondo argomento è la lunghezza attesa della parola. */
acquisisci_parola(Parola, Lunghezza) :- 
    write('Inserire la parola binaria di lunghezza '), write(Lunghezza), write(': '),
    catch(read(Input), _, gestisci_errore_lettura(Parola, Lunghezza)),
    elabora_input(Input, Lunghezza, Parola).

/* Predicato ausiliario per gestire errori di sintassi nella read. */
gestisci_errore_lettura(Parola, Lunghezza) :- 
    write(' Assicurarsi di usare le parentesi quadre e il punto finale.'), nl,
    acquisisci_parola(Parola, Lunghezza).

/* Il predicato elabora_input gestisce la validazione dell'input e la ricorsione
   in caso di errore. Se l'input è valido, unifica Parola con Input; 
   altrimenti, stampa un messaggio di errore e richiede nuovo input.
   - Il primo argomento è l'input letto da tastiera.
   - Il secondo argomento è la lunghezza attesa.
   - Il terzo argomento è l'output validato. */
elabora_input(Input, Lunghezza, Parola) :- 
    is_list(Input), length(Input, Lunghezza), maplist(bit_valido, Input), !, Parola = Input.
elabora_input(_, Lunghezza, Parola) :- 
    write('Errore: Devi inserire una lista di '), write(Lunghezza), write(' bit (0 o 1).'), nl,
    acquisisci_parola(Parola, Lunghezza).

/* Il fatto bit_valido definisce i bit validi per il codice di Hamming.
   Un bit è valido se è 0 o 1.
   - L'unico argomento rappresenta il bit da verificare. */
bit_valido(0).
bit_valido(1).

/* Il predicato acquisisci_parola_distanza acquisisce una parola binaria generica dall'input
   e la valida. 
   - L'unico argomento è la parola validata in output. */
acquisisci_parola_distanza(Parola) :- 
    catch(read(Input), _, fail),
    (is_list(Input), maplist(bit_valido, Input) -> Parola = Input ; 
     write('Lista non valida. Inserire una lista di soli 0 e 1 (es. [1,0,1]).'), nl,
     acquisisci_parola_distanza(Parola)).

/* --- LOGICA DI CODIFICA --- */

/* Il predicato lista_parita genera la lista delle posizioni dei bit di parità per un dato numero M.
   Le posizioni sono le potenze di 2 fino a 2^(M-1).
   - Il primo argomento è il numero di bit di parità.
   - Il secondo argomento è la lista delle posizioni dei bit di parità. */
lista_parita(M, Lista) :- 
    M1 is M - 1,
    findall(P, (between(0, M1, Exp), P is 2^Exp), Lista).

/* Il predicato posizione_parita calcola, dato un indice, se la posizione è potenza di due o meno.
    - L'unico argomento indica la posizione che gli viene passata. */
posizione_parita(Pos) :- Pos > 0, (Pos /\ (Pos - 1)) =:= 0.

/* Il predicato inserisci_bit inserisce bit di dati nelle posizioni non di parità di un codice Hamming, 
   lasciando dei segnaposti (0) per i bit di parità. 
    - Il primo argomento rappresenta la posizione corrente nel codice.
    - Il secondo argomento è la lista di bit di dati da inserire.
    - Il terzo argomento è il codice risultante con i bit di dati nelle posizioni appropriate. */
inserisci_bit(_, [], []) :- !.
inserisci_bit(Pos, Dati, [0|RestoCodice]) :-
    posizione_parita(Pos), !,
    PosSucc is Pos + 1,
    inserisci_bit(PosSucc, Dati, RestoCodice).
inserisci_bit(Pos, [Bit|RestoDati], [Bit|RestoCodice]) :-
    PosSucc is Pos + 1,
    inserisci_bit(PosSucc, RestoDati, RestoCodice).

/* Il predicato calcolo_parita calcola il valore dei bit di parità per una specifica posizione P
   in una lista di bit. (Versione Ottimizzata con findall)
    - Il primo argomento è la lista di bit su cui operare.
    - Il secondo argomento indica la posizione del bit di parità da calcolare.
    - Il terzo argomento è il valore calcolato del bit di parità. */
calcolo_parita(Lista, PosP, ValoreParita) :-
    findall(1, (nth1(Indice, Lista, 1), (Indice /\ PosP) > 0), Uni),
    length(Uni, Conteggio),
    ValoreParita is Conteggio mod 2.

/* Il predicato calcola_tutte_parita calcola tutti i bit di parità per una lista di posizioni
   e li inserisce nel codice.
   - Il primo argomento è la lista delle posizioni dei bit di parità.
   - Il secondo argomento è il codice temporaneo.
   - Il terzo argomento è il codice completo con tutti i bit di parità calcolati. */
calcola_tutte_parita([], Codice, Codice).
calcola_tutte_parita([P|RestoP], CodiceTemp, CodiceFinale) :-
    calcolo_parita(CodiceTemp, P, ValoreP),
    sostituisci_elemento(CodiceTemp, P, ValoreP, CodiceAggiornato),
    calcola_tutte_parita(RestoP, CodiceAggiornato, CodiceFinale).

/* Il predicato codifica_parola implementa la codifica di Hamming per una parola di dati.
   - Il primo argomento è la parola di dati da codificare.
   - Il secondo argomento è il numero di bit di parità.
   Il predicato inserisce i bit di dati nelle posizioni appropriate,
   calcola i bit di parità e produce il codice di Hamming finale. */
codifica_parola(Parola, M) :-
    lista_parita(M, PosizioniParita),
    inserisci_bit(1, Parola, CodiceTemp),
    calcola_tutte_parita(PosizioniParita, CodiceTemp, CodiceHamming),
    write('Codice Hamming: '), write(CodiceHamming), nl.

/* Il predicato sostituisci_elemento sostituisce l'elemento in una specifica posizione di una lista.
   - Il primo argomento è la lista originale.
   - Il secondo argomento è la posizione dell'elemento da sostituire.
   - Il terzo argomento è il nuovo valore da inserire.
   - Il quarto argomento è la lista risultante dopo la sostituzione. */
sostituisci_elemento([_|Coda], 1, X, [X|Coda]) :- !.
sostituisci_elemento([Testa|Coda], Pos, X, [Testa|NuovaCoda]) :- 
    Pos > 1, Pos1 is Pos - 1,
    sostituisci_elemento(Coda, Pos1, X, NuovaCoda).

/* --- LOGICA DI DECODIFICA --- */

/* Il predicato calcola_sindrome calcola la sindrome per un codice Hamming ricevuto.
   La sindrome rappresenta la somma delle posizioni dei bit di parità che risultano errati.
   Se la sindrome è 0, non ci sono errori, in caso contrario indica la posizione dell'errore.
    - Il primo argomento è il codice di Hamming da analizzare.
    - Il secondo argomento è la lista delle posizioni dei bit di parità.
    - Il terzo argomento è il valore calcolato della sindrome. */
calcola_sindrome(_, [], 0).
calcola_sindrome(Parola, [P|Resto], Sindrome) :-
    calcolo_parita(Parola, P, Check),
    calcola_sindrome(Parola, Resto, SindromeParziale),
    (Check =:= 1 -> Sindrome is SindromeParziale + P ; Sindrome is SindromeParziale).

/* Il predicato decodifica_parola implementa la decodifica completa di un codice di Hamming.
   Calcola la sindrome del codice ricevuto: se è zero non ci sono errori, altrimenti 
   corregge l'errore nella posizione indicata e estrae i bit di dati.
   - Il primo argomento CodiceRicevuto è il codice Hamming da decodificare.
   - Il secondo argomento M è il numero di bit di parità utilizzati. */
decodifica_parola(CodiceRicevuto, M) :-
    lista_parita(M, PosizioniParita),
    calcola_sindrome(CodiceRicevuto, PosizioniParita, Sindrome),
    analizza_sindrome(Sindrome, CodiceRicevuto).

/* Predicato che analizza la sindrome e stampa il risultato:
   - il primo argomento e' la sindrome;
   - il secondo argomento e' il codice ricevuto. */
analizza_sindrome(0, Codice) :-
    write('Nessun errore trovato.'), nl,
    estrai_dati(Codice, Dati),
    write('Parola decodificata: '), write(Dati), nl.

analizza_sindrome(Sindrome, Codice) :-
    Sindrome > 0,
    write('Errore trovato in posizione: '), write(Sindrome), nl,
    length(Codice, Len),
    (Sindrome =< Len ->
        correggi_errore(Codice, Sindrome, CodiceCorretto),
        estrai_dati(CodiceCorretto, Dati),
        write('Parola decodificata e corretta: '), write(Dati), nl
    ;
        write('Errore critico: Posizione errore fuori dal range.'), nl
    ).

/* Il predicato correggi_errore corregge un singolo errore bit in un codice di Hamming
   invertendo il valore del bit nella posizione specificata (0 diventa 1, 1 diventa 0).
   - Il primo argomento è il codice originale contenente l'errore.
   - Il segundo argomento è la posizione del bit errato.
   - Il terzo argomento è il codice con l'errore corretto. */
correggi_errore(Lista, Pos, ListaCorretta) :-
    nth1(Pos, Lista, BitVecchio),
    BitNuovo is 1 - BitVecchio,
    sostituisci_elemento(Lista, Pos, BitNuovo, ListaCorretta).

/* Il predicato estrai_dati estrae i bit di dati da un codice di Hamming,
   rimuovendo i bit di parità che si trovano nelle posizioni che sono potenze di 2.
   - Il primo argomento è il codice Hamming completo.
   - Il secondo argomento è la lista contenente solo i bit di dati. */
estrai_dati(Codice, Dati) :- estrazione_ricorsiva(Codice, 1, Dati).

/* Predicato ricorsivo per estrai_dati che effettua l'estrazione effettiva
   dei bit di dati, saltando i bit di parità nelle posizioni che sono potenze di 2.
   - Il primo argomento è la porzione rimanente del codice da processare.
   - Il secondo argomento è la posizione corrente nel codice (contatore).
   - Il terzo argomento è la lista accumulata dei bit di dati estratti. */
estrazione_ricorsiva([], _, []).
estrazione_ricorsiva([_|Resto], Pos, Dati) :-
    posizione_parita(Pos), !,
    PosSucc is Pos + 1,
    estrazione_ricorsiva(Resto, PosSucc, Dati).
estrazione_ricorsiva([Bit|Resto], Pos, [Bit|Dati]) :-
    PosSucc is Pos + 1,
    estrazione_ricorsiva(Resto, PosSucc, Dati).

/* --- DISTANZA DI HAMMING --- */

/* Il predicato verifica_e_calcola_distanza verifica che due liste abbiano la stessa lunghezza
   e calcola la distanza.
   - Il primo argomento rappresenta la prima lista da confrontare.
   - Il secondo argomento rappresenta la seconda lista da confrontare. */
verifica_e_calcola_distanza(P1, P2) :-
    length(P1, L1), length(P2, L2),
    (L1 =:= L2 -> 
        calcolo_distanza(P1, P2, Distanza),
        write('Distanza di Hamming: '), write(Distanza), nl
    ;
        write('Errore: Lunghezze diverse ('), write(L1), write(' vs '), write(L2), write(').'), nl
    ).

/* Predicato che esegue il calcolo di Hamming in maniera ricorsiva (Ottimizzato con XOR funzione). 
    - il primo argomento indica la prima lista inserita;
    - il secondo argomento indica la seconda lista inserita;
    - il terzo argomento è la distanza di Hamming risultante. */
calcolo_distanza([], [], 0).
calcolo_distanza([H1|T1], [H2|T2], Dist) :-
    calcolo_distanza(T1, T2, DistResto),
    Diff is xor(H1, H2),    
    Dist is DistResto + Diff.