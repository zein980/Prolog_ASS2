create(R, C,X1, Y1, X2, Y2) :-
    length(InitialBoard, R),
    makeRow(C, InitialBoard),
    bom(InitialBoard,X1, Y1, Nextboard),
    bom(Nextboard, X2, Y2, NewBoard),
    flatten(NewBoard, New),
    search([[New, null]], [],R,C).


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
search(Open, Closed,_,_):-
  getState(Open, [CurrentState,Parent], _),
  printSolution([CurrentState,Parent], Closed).

search(Open, Closed,R,C):-
 getState(Open, CurrentNode, TmpOpen),
 getAllValidChildren(CurrentNode,TmpOpen,Closed,Children,R,C),
 addChildren(Children, TmpOpen, NewOpen),
 append(Closed, [CurrentNode], NewClosed),
 search(NewOpen, NewClosed,R,C).


getAllValidChildren(Node, Open, Closed, Children,R,C):-
  findall(Next, getNextState(Node, Open, Closed, Next,R,C), Children).

getNextState([State,_], Open, Closed, [Next,State],R,C):-
  move(State, Next,R,C),
  not(member([Next,_], Open)),
  not(member([Next,_], Closed)),
  isOkay(Next).

getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
   append(Open, Children, NewOpen).


printSolution([State, null],_):-
   write(State), nl.

printSolution([State, Parent], Closed):-
   member([Parent, GrandParent], Closed),
   printSolution([Parent, GrandParent], Closed),
   write(State), nl.

move(State,Next,R,C):-
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

vertical(State, Nexxt,R,C):-
  nth0(Emp, State, 0),
  NewR is R-1,
  Emp < NewR*C,
  Index is Emp + C,
  nth0(Index, State, Element),
  Element is 0,
  substitute(0, State,'D||' , Temp,Emp,0),
  substitute(Element, Temp,'D||', Nexxt,Index,0).


substitute(Element, [Element|T], NewElement, [NewElement|T],Count,Count):- !.
substitute(Element, [H|T], NewElement, [H|NewT],Index,Count):-
   New is Count+1,
   substitute(Element, T, NewElement, NewT,Index,New).


isOkay(_):- true.
