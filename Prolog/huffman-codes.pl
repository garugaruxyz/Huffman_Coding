%%%% -*- Mode: Prolog -*-

%%% huffman-codes.pl


%%% he_decode/3 Bits HuffmanTree Message

he_decode(Bits, HuffmanTree, Message) :-
    he_decode(Bits, HuffmanTree, HuffmanTree, Message), !.
he_decode([],_,node(S,_,nill,nill), Message):-
    Message = S.
he_decode(X,HuffmanTree,node(S,_,nill,nill), Message) :-
    he_decode(X, HuffmanTree, HuffmanTree, Rest),
    append(S, Rest, Message).
he_decode([X|XS],HuffmanTree,node(_,_,L,R), Message) :-
    X = 0 -> he_decode(XS,HuffmanTree,L, Message);
    X = 1, he_decode(XS,HuffmanTree,R, Message).


%%% he_encode/3 Message HuffmanTree Bits

he_encode([], _, Bits) :- Bits=[], !.
he_encode([X|Xs], HuffmanTree, Bits) :- !,
    find_bit(X, HuffmanTree, BitX),
    he_encode(Xs, HuffmanTree, BitXS),
    append(BitX, BitXS, Bits), !.

find_bit(X,node([X], _, nill, nill), Bit) :- Bit = [], !.
find_bit(X,node(S,_,L,R),Bit) :-
    member(X,S),
    find_bit(X,L,Rest) -> append([0], Rest,Bit);
    find_bit(X,R,Rest),
    append([1], Rest, Bit).


%%% he_encode_file/3 Filename HuffmanTree Bits

he_encode_file(Filename, HuffmanTree, Bits):-
    open(Filename, read, Str),
    read_file(Str, Lines),
    close(Str),
    convert(Lines, Messaggio),
    message(Messaggio),
    he_encode(Messaggio, HuffmanTree, Bits).

convert([X], Messaggio):-
    atom_chars(X, Messaggio).
convert([X, end_of_file], Messaggio):-
    atom_chars(X, Messaggio).
convert([X|T], Messaggio):-
    atom_chars(X, L),
    convert(T, Rest),
    append([L, [nl], Rest], Messaggio).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).


%%% he_generate_huffman_tree/2 SymbolsAndWeights HuffmanTree

he_generate_huffman_tree([], _).
he_generate_huffman_tree(SymbolsAndWeights, HuffmanTree) :-
    symbol_n_weights(SymbolsAndWeights),
    convertTree(SymbolsAndWeights, Tree),
    merge_sort(Tree, SortedTree),
    he_generate_huffman_tree(SortedTree, HuffmanTree, 1), !.
he_generate_huffman_tree([(S1, P1, L1, R1), (S2, P2, L2, R2)|Xs], HT, 1) :-
    PTot is P1 + P2,
    append(S1, S2, SN),
    R = node(S1, P1, L1, R1),
    L = node(S2, P2, L2, R2),
    Temp = (SN, PTot, L, R),
    append([Temp], Xs, Xn),
    merge_sort(Xn, SortedTree),
    he_generate_huffman_tree(SortedTree, HT, 1).
he_generate_huffman_tree([(S, P, L, R)], HuffmanTree, 1) :-
    HuffmanTree=node(S, P, L, R).

convertTree([], []).
convertTree([(S1, P1)|Xs], [(St1, P1, nill, nill)|Ys]) :-
    St1 = [S1],
    convertTree(Xs, Ys).



%%% he_generate_symbol_bits_table/2 HuffmanTree SymbolBitsTable

he_generate_symbol_bits_table(node(S, P, L, R), SymbolBitsTable) :-
    makeSBtable(S, node(S, P, L, R), SymbolBitsTable), !.
makeSBtable([H|T], HuffmanTree, SymbolBitsTable) :-
    he_encode([H], HuffmanTree, Bits),
    makeSBtable(T, HuffmanTree, SymbolBitsTableT),
    append([(H, Bits)], SymbolBitsTableT, SymbolBitsTable), !.
makeSBtable([],_,SymbolBitsTable) :- SymbolBitsTable = [], !.


%%% he_print_huffman_tree/1 HuffmanTree

he_print_huffman_tree(node(S, P, nill, nill)) :-
    write("Foglia:\n"),
    write("Simbolo: "),
    write(S),
    write("\nPeso: "),
    write(P),
    write("\n\n"),!.
he_print_huffman_tree(node(S, P, node(SL, PL, L, R), node(SR, PR, LR, RR))) :-
    write("Nodo:\n"),
    write("Simbolo: "),
    write(S),
    write("\nPeso: "),
    write(P),
    write("\nRamo sinistro: "),
    write(SL),
    write("\nRamo destro: "),
    write(SR),
    write("\n\n"),
    he_print_huffman_tree(node(SL, PL, L, R)),
    he_print_huffman_tree(node(SR, PR, LR, RR)),!.


symbol_n_weights([(S, P)|T]):- !,
    atom(S),
    number(P),
    symbol_n_weights(T).
symbol_n_weights([]).

message([]).
message([H|T]) :- atomic(H), message(T).

merge_sort([], []).
merge_sort([X], [X]).
merge_sort(List, Sorted) :-
    List=[_, _|_],
    halve(List, L1, L2),
    merge_sort(L1, Sorted1),
    merge_sort(L2, Sorted2),
    merge(Sorted1, Sorted2, Sorted).

merge([], L, L).
merge(L, [], L) :- L \= [].
merge([(SX, PX, LX, RX)|T1], [(SY, PY, LY, RY)|T2], [(SX, PX, LX, RX)|T]) :-
    PX=<PY,merge(T1,[(SY, PY, LY, RY)|T2],T).
merge([(SX, PX, LX, RX)|T1], [(SY, PY, LY, RY)|T2], [(SY, PY, LY, RY)|T]) :-
    PX>PY,merge([(SX, PX, LX, RX)|T1], T2, T).

halve(L, A, B) :- hv(L, L, A, B).
hv([], R, [], R).
hv([_], R, [], R).
hv([_, _|T], [X|L], [X|L1], R) :- hv(T, L, L1, R).

%%% end of file - huffman-codes.pl
