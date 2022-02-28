README.txt - huffman-codes.lisp

;;; huffman-codes.lisp
 
;;;Legenda parametri

bits -> è una sequenza (lista) di 0 ed 1
huffman-tree -> è un albero di Huffman (la sua radice), ogni nodo è formato del tipo
    (((simboloSX . simboloDX) (+ pesoSX pesoDX)) (nodoSX nodoDX)))
i nodi foglia sono invece una coppia ( <simbolo> . <peso> )
message -> è una lista di “simboli” (simboli, caratteri o altre strutture dati Common Lisp; e.g., liste);
filename -> è una stringa (o un pathname) che denota un documento nel File System
symbols-n-weights ->  è una lista di coppie simbolo-peso ( <simbolo> . <peso> )
symbol-bits-table è una lista di coppie ( <simbolo> . <bits> )


;;; he-decode (bits huffman-tree) -> message

he-decode fa un primo controllo dei parametri formali in modo da capire se possano esere 
computati o meno. In caso positivo li passa alla funzione decodifica
;;; decodifica (bits node hu-tree)->bits
decodifica che continua a decodificare i bit finchè non finiscono o non trova un errore.
Se il bit letto è diverso da 0 o 1, restituisce errore
se non ci sono più bit da decodificare e non è riuscita a trovare un nodo foglia restituisce errore
se trova un nodo foglia fa la cons del simbolo con l'eventuale continuo di simboli decodificati
ripartendo dalla radice


;;; he-encode (message huffman-tree) -> bits

La funzione he-encode permette di ottenere una lista di bit (0 e 1) creata codificando 
il messaggio con l'albero di Huffman, quest'ultimo viene trasformato in una lista di coppie
ognuna contente un simbolo e una la rispettiva codifica in bit, ottenuta tramite la funzione 
he-generate-symbol-bits-table per ogni simbolo del messaggio cerco lo stesso nella lista appena
generata in modo da poter aggiungere i rispettivi bits alla lista da restituire.


;;; he-encode-file (filename huffman-tree) -> bits

La funzione he-encode-file permette di decodificare il messaggio contenuto nel file di testo,
sfruttiamo la funzione lettura per leggere il contenuto del file come una stringa per poi trasformare 
quest'ultima come una lista di caratteri tramite la funzione coerce.
La lista di caratteri ottenuta e l'albero di Huffman (passato come parametro formale a he-encode-file)
vengono passati alla funzione he-encode in modo che possa poi codificare il messaggio.


;;; he-generate-huffman-tree (symbols-n-weights) -> huffman-tree

La funzione he-generate-huffman-tree permette la creazione dell'albero di Huffman data
una lista di coppie (simbolo peso). Se uno degli elemento di questa lista non risponde al 
formato corretto l'interprete restituirà errore
Si cercano le prime due coppie con peso minore da questi due si creerà un novo nodo
che vedremo come una nuova coppia tramite la funzione new-node, il primo elemento di 
questa nuova coppia è la coppia contente la lista dei due simboli e la somma dei loro rispettivi pesi,
il secondo elemento è un'altra coppia formata dai due minori.
unify controlla se è possibile unificare una coppia per generare un nuovo nodo, in caso positivo 
richiamiamo sostituisci per effettuare questo lavoro
Tramite sostituisci andiamo a sostituire questa nuova coppia con il primo minore che troviamo nella 
lista a cui verrà rimosso l'altro minore.
Si continua così finchè non mi resta una lista contente un solo elemento, a questo punto restituisco
il primo elemento ovvero un albero di Huffman

Dato che l'albero di Huffman è un albero binario sfrutto la cons per la creazione di
quest' ultimo, dato che mi permette di avere una coppia di puntatori.

new-node mi permette di creare il nuovo nodo dati due nodi, ovvero i due nodi minori trovati

minori mi restituisce la coppia dei due minori trovati grazie a minore1 e minore2
minore1 mi permette di trovare il primo nodo con peso minore all'interno della lista 
minore2 invece mi permette di trovare il secondo nodo con peso minore all'interno della lista  
Le funzioni che trovano i due minori fanno controlli sia nel caso che siano 
delle foglie (ovvero delle coppie simbolo peso) che dei nodi creati con new-node


;;; he-generate-symbol-bits-table (huffman-tree) -> symbol-bits-table

he-generate-symbol-bits-table dato un Huffman Tree genera una lista di coppie (<simbolo> <bits>).
Viene fatto un primo controllo sul parametro formale per poi sfruttare la funzione bits-table.
bits-table visita l'albero e ogni volta che trova un nodo foglia aggiunge alla lista da restituire 
una coppia (<simbolo> <bits>), dove simbolo è preso dal nodo foglia mentre bits è una lista di 0 e 1,
si aggiunge uno 0 ogni volta che si visita un ramo sinistro ed invece un 1 ogni volta che si visita un ramo destro.


;;; he-print-huffman-tree (huffman-tree &optional (indent-level 0)) -> nil

La funzione he-print-huffman-tree stampa a terminale un Huffman Tree.
Se il valore di indent è quello di defualt (0) vengono stampati i nodi senza indentazione,
ovvero un nodo sotto l'altro senza risaltare il livello. Per preparare l'albero usiamo la funzione 
print-no-indent al quale viene passato come parametro formale l'Huffman Tree.
Se indent assume un qualunque valore diverso da 0, allora viene stampato l'albero con indentazione
grazie a print-indent, questa funzione aggiunge un tab ogni volta che andiamo più in profondità,
la visualizzazione è quindi orizzontale.

