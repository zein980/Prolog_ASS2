create(R, C,X1, Y1, X2, Y2) :-
    length(InitialBoard, R),
    makeRow(C, InitialBoard),
    bom(InitialBoard,X1, Y1, Nextboard),
    bom(Nextboard, X2, Y2, NewBoard),
    flatten(NewBoard, New),
    search([[New, null,0,x,0]], [],R,C).


makeRow(_, []).
makeRow(C, [Row|Rows]) :-
    length(Row, C),
    maplist(=(0), Row),
    makeRow(C, Rows).

bom(Board, XBom, YBom, NewBoard) :-
    nth1(XBom, Board, Row),
    nth1(YBom, Row, _),
    change(YBom, Row, 'Bom', NewRow),
    change(XBom, Board, NewRow, NewBoard).

change(W, L, X, R) :-
    append(A, [_|B], L),
    NewW is W - 1,
    length(A, NewW),
    append(A, [X|B], R).

search(Open, Closed,R,C):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _),
    isGoal(CurrentState,R,C),
    write(G),
    write(" is maximum number of dominoes that can be placed."), nl,
    printSolution([CurrentState,Parent,G,H,F], Closed).

search(Open, Closed,R,C):-
 getBestState(Open, CurrentNode, TmpOpen),
 getAllValidChildren(CurrentNode,TmpOpen,Closed,Children,R,C),
 addChildren(Children, TmpOpen, NewOpen),
 append(Closed, [CurrentNode], NewClosed),
 search(NewOpen, NewClosed,R,C).


getAllValidChildren(Node, Open, Closed, Children,R,C):-
  findall(Next, getNextState(Node, Open, Closed, Next,R,C), Children).

isGoal(State,R, C):-
not(isEmptyHorizontal(State,C)),
not(isEmptyVertical(State,R, C)).

getNextState([State,_,G,_,_], Open, Closed, [Next,State,NewG,NewH,NewF],R,C):-
move(State, Next,MC,R,C),
calculateH(Next, NewH),
NewG is G + MC,
NewF is NewG + NewH,
( not(member([Next,_,_,_,_], Open)) ; memberButBetter(Next,Open,NewF) ),
( not(member([Next,_,_,_,_],Closed));memberButBetter(Next,Closed,NewF)).

calculateH(State, H):-
sum(State, 'D-_', H_dominoes),
sum(State, 'D||', V_dominoes),
  H is (H_dominoes/2) + (V_dominoes/2).

memberButBetter(Next, List, NewF):-
findall(F, member([Next,_,_,_,F], List), Numbers),
min_list(Numbers, MinOldF),
MinOldF > NewF.

getBestState(Open, BestChild, Rest):-
findMin(Open, BestChild),
delete(Open, BestChild, Rest).

% Greedy best-first search
findMin([X], X):- !.
findMin([Head|T], Min):-
findMin(T, TmpMin),
Head = [_,_,_,HeadH,HeadF],
TmpMin = [_,_,_,TmpH,TmpF],
(TmpF < HeadF -> Min = TmpMin ; Min = Head).

addChildren(Children, Open, NewOpen):-
   append(Open, Children, NewOpen).


printSolution([State, null, G, H, F],_):-
   write([State,G, H, F]), nl.

printSolution([State, Parent, G, H, F], Closed):-
   member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
   printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
   write([State, G, H, F]), nl.

move(State,Next,1,R,C):-
  horizontal(State,Next,C);vertical(State,Next,R,C).


horizontal(State, Next,C):-
  nth0(Empty, State, 0),
  New is C-1,
  not(New is Empty mod C),
  Index is Empty + 1,
  nth0(Index, State, Element),
  Element is 0,
  substitute(0, State,'D-_' , Temp,Empty,0),
  substitute(Element, Temp,'D-_', Next,Index,0).

isEmptyHorizontal(State,C):-
  nth0(Empty, State, 0),
  New is C-1,
  not(New is Empty mod C),
  Index is Empty + 1,
  nth0(Index, State, Element),
  Element is 0.

vertical(State, Nexxt,R,C):-
  nth0(Emp, State, 0),
  NewR is R-1,
  Emp < NewR*C,
  Index is Emp + C,
  nth0(Index, State, Element),
  Element is 0,
  substitute(0, State,'D||' , Temp,Emp,0),
  substitute(Element, Temp,'D||', Nexxt,Index,0).

isEmptyVertical(State,R, C):-
  nth0(Emp, State, 0),
  NewR is R-1,
  Emp < NewR*C,
  Index is Emp + C,
  nth0(Index, State, Element),
  Element is 0.

sum([] , _,0).

sum([H|T] , H,NewCount):-
 sum(T,H,OldCount),
 NewCount is OldCount +1.

sum([H|T] , H2,Count):-
 dif(H,H2),
 sum(T,H2,Count).

substitute(Element, [Element|T], NewElement, [NewElement|T],Count,Count):- !.
substitute(Element, [H|T], NewElement, [H|NewT],Index,Count):-
   New is Count+1,
   substitute(Element, T, NewElement, NewT,Index,New).


