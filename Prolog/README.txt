README.txt - huffman-codes.pl

Richiesta del progetto: 

Implementare in Prolog una libreria per la compressione e la decompressione 
di “documenti” basato sul metodo di Huffman.

Legenda parametri:
Message è una lista di atomi.
 Es: [Simbolo1, Simbolo2 .... SimboloN]
 
Bits è una lista di 0 e 1.
 Es: [0,1,1,0 ...]
 
SymbolsAndWeights è una lista di coppie simobolo peso.
 Es: [(Simbolo1, Peso1), (Simbolo1, Peso1) ... (SimboloN, PesoN)]

SymbolBitsTable è una lista di coppie simbolo e la sua codifica in bit.
 Es: [(Simbolo1, 101), (Simbolo2, 111), ..... (SimboloN, BitN)]
 
HuffmanTree è la radice dell'albero di huffmna impostata in questo modo: node(Simbolo, Peso, NodoSinistro, NodoDestro).
 Es: node([a,b,c,d], 6, node([a,b,c], 3, node([a,b], 2, node([a], 1, nill, nill), node([b], 1, nill, nill)), node([c], 1, nill, nill)), node([d], 3, nill, nill))

Predicati Principali:
he_decode(Bits, HuffmanTree, Message):
 La funzione he-decode decodifica i Bits in base all'HuffmanTree e restituisce il messaggio relativo.

he_encode(Message, HuffmanTree, Bits):
 La funzione he-encode codifica il Message in base all'HuffmanTree e restituisce i Bits che compongono
 il messaggio codificato.

he_encode_file(Filename, HuffmanTree, Bits):
 La funzione he-encode-file legge un testo da un file e poi richiama he-encode su quanto letto.
 Il file dovrà contenre un testo che verrà convertito come messaggio. 
 Ogni riga del file deve terminare con un punto.
 L'HuffmanTree dovrà avere al suo interno l'atomo nl con peso pari al numero di righe-1.

he_generate_huffman_tree(SymbolsAndWeights, HuffmanTree):
 La funzione he_generate_huffman_tree crea un HuffmanTree in base alla tabella SymbolsAndWeights passata.

he_generate_symbol_bits_table(HuffmanTree, SymbolBitsTable):
 La funzione he_generate_symbol_bits_table crea una tabella SymbolsAndWeights in base 
 all' HuffmanTree passato.

he_print_huffman_tree(HuffmanTree):
 Predicato che stampa a terminale un Huffman Tree.

Predicati ausiliari:

symbol_n_weights(SymbolAndWeights):
 Predicato che Verifica che la lista SymbolAndWheights data sia valida, quindi composta da un atomo come simbolo e un numero come peso.
 
makeSBtable(HuffmanTree,HuffmanTree,SymbolBitsTable):
 Predicato aux per la creazione della SymbolBitsTable. Esegue l'encode sui simboli presenti nella radice dell'HuffmanTree. Tramite il primo ricaviamo il simbolo mentre il secondo viene utilizzato per 

merge_sort(Lista, ListaOrdinata):
 Predicato che ordina la Lista in modo crescente allintenrno di ListaOrdinata attraverso la merge sort.
 
halve(Lista, Lista1, Lista2):
 Predicato che divide Lista in 2 metà all'interno di Lista1 e Lista1.

hv(Lista, Lista, A, B):
 Predicato aux per la divisione in 2 metà della lista.
 
merge(Lista1, Lista2, ListaOrdinata):
 Predicato aux per la merge sort che si occupa della merge tra lista1 e Lista2 all'interno della lista ordinata.

find_bit(Simbolo, HuffmanTree, Bit):
 Predicato che codifica un singolo simbolo attraverso HuffmanTree.

convertTree(SymbolsAndWeights, Tree):
 Predicato aux per la creazione dell'albero di Huffman che converte la lista SymbolsAndWeights Aggiungendo (... ,nill,nill) ad ogni coppia della lista per renderle foglie di un albero

convert(Lista):
 Predicato aux per la codifica da file che converte una lista di linee di testo da file in un messaggio per la codifica
message(Messaggio):
 Predicato che verifica che Messaggio sia valido, ossia una lista di atomi.

I predicati devono fallire se ci sono errori o se codifica e/o decodifica non possono essere completate.