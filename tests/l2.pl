%% Starting point of the program
%% True iff the given Rule holds for the given Adjacent list, 
%% Label-list and starting point.
verify(FileName) :-
    see(FileName), read(A), read(L), read(Start), read(Rule), seen,
    check(A, L, Start, [], Rule), !
    .

%% True iff the given list contains an element that matches
%% the Head and the given lists matched the list following the Head.
%% Mainly used for getA and getL.
get([], _, _) :- fail.
get([[Head, Tail] | _], Head, Tail).
get([_ | Tail], Head, List) :- get(Tail, Head, List).

%% True iff the given list Adj/Labels matches the list 
%% on the row in which Head is. 
getA(A, Current, Adj) :- get(A, Current, Adj).
getL(L, Current, Labels) :- get(L, Current, Labels).

%% Allows the use of hasProp with multiple elemnts.
hasProp(_, [], _) :- fail.
hasProp(L, [Current | Tail], Prop) :- 
    hasProp(L, Current, Prop);
    hasProp(L, Tail, Prop)
    .
%% True iff the Labels of element Current in list L
%% contains the property Prop.
hasProp(L, Current, Prop) :-
    getL(L, Current, Labels),
    member(Prop, Labels)
    .

%% Checks all elements in the given list if each holds for the rule X
checkAll(_, _, [], _, _).
checkAll(A, L, [Current | Tail], Rec, X) :-
    check(A, L, Current, Rec, X),
    checkAll(A, L, Tail, [Current | Rec], X)
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EX 

check(A, L, Current, Rec, ex(X)) :-
    getA(A, Current, Adj),

    %% Since Poss is undefined, it will attempt each element in Adj
    %% and try to find a value which results in true. If one fails, 
    %% it will iterate to the next element. If one results in true, 
    %% we have found that ex(X) holds. If no elements results in true,
    %% the rule is false since no neighbours made the rule hold for X.
    member(Poss, Adj),
    check(A, L, Poss, Rec, X)
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EX End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AX

check(_, _, [], _, ax(_)).
check(A, L, [Current | Tail], Rec, ax(X)) :-
    check(A, L, Current, Rec, X), !,
    check(A, L, Tail, Rec, ax(X))
    .
check(A, L, Current, Rec, ax(X)) :-
    getA(A, Current, Adj),
    check(A, L, Adj, Rec, ax(X))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AX End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EF

check(A, L, Current, Rec, ef(X)) :- 
    not(member(Current, Rec)),
    check(A, L, Current, [], X)
    .
check(A, L, Current, Rec, ef(X)) :-
    not(member(Current, Rec)),
    getA(A, Current, Adj),
    member(Poss, Adj),
    check(A, L, Poss, [Current | Rec], ef(X))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EF End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AF

check(A, L, Current, Rec, af(X)) :-
    not(member(Current, Rec)),
    check(A, L, Current, [], X)
    .
check(A, L, Current, Rec, af(X)) :-
    not(member(Current, Rec)),
    check(A, L, Current, [Current | Rec], ax(af(X)))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AF End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EG 

check(_, _, Current, Rec, eg(_)) :- member(Current, Rec), !.
check(A, L, Current, Rec, eg(X)) :-
    check(A, L, Current, [], X),
    getA(A, Current, Adj),
    %% Iterates through Adj until a match is found for eg(X).
    member(Poss, Adj),
    check(A, L, Poss, [Current | Rec], eg(X))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EG End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AG

check(_, _, Current, Rec, ag(_)) :-
    member(Current, Rec), !
    .
check(A, L, Current, Rec, ag(X)) :-
    check(A, L, Current, [], X),
    check(A, L, Current, [Current | Rec], ax(ag(X)))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AG End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEG

check(_, L, Current, _, neg(X)) :-
    not(hasProp(L, Current, X))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEG End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AND

check(A, L, Current, _, and(X,Y)) :-
    check(A, L, Current, [], X),
    check(A, L, Current, [], Y)
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AND End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OR

check(A, L, Current, _, or(X,Y)) :-
    check(A, L, Current, [], X);
    check(A, L, Current, [], Y)
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OR End

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASECASE

check(_, L, Current, _, X) :-
    hasProp(L, Current, X)
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASECASE End