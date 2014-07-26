/* Relaciona al dueño con el  nombre del juguete                    */
/* y la cantidad de años que lo ha tenido                           */
duenio(andy, woody, 8). 
duenio(sam, jessie, 3). 
 
/* Relaciona al juguete con su nombre los juguetes son de la forma: */
/*   deTrapo(tematica)                                              */
/*   deAccion(tematica, partes)                                     */
/*   miniFiguras(tematica, cantidadDeFiguras)                       */
/*   caraDePapa(partes)                                             */
 
juguete(woody, deTrapo(vaquero)). 
juguete(jessie, deTrapo(vaquero)). 
juguete(buzz, deAccion(espacial, [original(casco)])). 
juguete(soldados, miniFiguras(soldado, 60)). 
juguete(monitosEnBarril, miniFiguras(mono, 50)). 
juguete(señorCaraDePapa, caraDePapa([ original(pieIzquierdo), original(pieDerecho), repuesto(nariz) ])).  
 
/* Dice si un juguete es raro                                       */
esRaro(deAccion(stacyMalibu, [original(sombrero)])).  
 
/* Dice si una persona es coleccionista                             */
esColeccionista(sam).

/***********/
/* Punto 1 */
/***********/

tematica( deTrapo(Tematica)       , Tematica ).
tematica( deAccion(Tematica,_)    , Tematica ).
tematica( miniFiguras(Tematica,_) , Tematica ).
tematica( caraDePapa(_)           , caraDePapa ).

esDePlastico( caraDePapa(_) ).
esDePlastico( miniFiguras(_,_) ).

esDeColeccion( deTrapo(_) ).
esDeColeccion( Juguete ) :-
  esMainstream( Juguete ),
  esRaro( Juguete ).

esMainstream( caraDePapa(_) ).
esMainstream( deAccion(_,_) ).

/***********/
/* Punto 2 */
/***********/

amigoFiel( Duenio, NombreJuguete ) :-
  juguete( NombreJuguete, Juguete ),
  not( esDePlastico(Juguete) ),
  jugueteMasAntiguo( Duenio, Juguete ).

jugueteMasAntiguo( Duenio, Juguete ) :-
  duenio( Duenio, Juguete, CantidadAnios ),
  forall( duenio( Duenio, _, OtraCantidadAnios ) , CantidadAnios >= OtraCantidadAnios ).

/***********/
/* Punto 3 */
/***********/

superValioso( NombreJuguete ) :-
  juguete( NombreJuguete, Juguete ),
  tieneTodasPiezasOriginales( Juguete ),
  not( esDeUnColeccionista( NombreJuguete ) ).
  
tieneTodasPiezasOriginales( Juguete ) :-
  forall( piezaJuguete( Juguete, Pieza ) , esOriginal( Pieza ) ).

piezaJuguete( Juguete , Parte ) :- 
  partesDeJuguete( Juguete, Partes ), 
  member( Parte, Partes ).

partesDeJuguete( deAccion( _ , Partes), Partes ).
partesDeJuguete( caraDePapa( Partes ), Partes ).

esOriginal( original(_) ).

esDeUnColeccionista( NombreJuguete ) :-
  duenio( Duenio, NombreJuguete, _ ),
  esColeccionista( Duenio ).

/***********/
/* Punto 4 */
/***********/

duoDinamico( Duenio, NombreJuguete1, NombreJuguete2 ) :-
  duenio( Duenio, NombreJuguete1, _ ),
  duenio( Duenio, NombreJuguete2, _ ),
  hacenBuenaPareja( NombreJuguete1, NombreJuguete2 ).

hacenBuenaPareja( woody, buzz ).
hacenBuenaPareja( NombreJuguete1, NombreJuguete2 ) :-
  tematicaNombreJuguete( NombreJuguete1, Tematica ),
  tematicaNombreJuguete( NombreJuguete2, Tematica ),
  NombreJuguete1 \= NombreJuguete2.

tematicaNombreJuguete( NombreJuguete, Tematica ) :-
  juguete( NombreJuguete, Juguete ),
  tematica( Juguete, Tematica ).

/***********/
/* Punto 5 */
/***********/

felicidad( Duenio, FelicidadTotal ) :-
  duenio( Duenio, _ , _ ),
  findall( FelicidadParcial, felicidadParcial(Duenio, FelicidadParcial), Felicidades ),
  sumlist( Felicidades, FelicidadTotal ).

felicidadParcial( Duenio, FelicidadParcial ) :-
  duenio( Duenio, NombreJuguete, _ ),
  juguete( NombreJuguete, Juguete ),
  felicidadJuguete( Juguete, FelicidadParcial ).

felicidadJuguete( deTrapo(_) , Felicidad ) :-
  felicidadDeTrapo(Felicidad).

felicidadJuguete( miniFiguras(_,CantidadFiguras) , Felicidad ) :- 
  Felicidad is 20 * CantidadFiguras.

felicidadJuguete( caraDePapa(Partes), Felicidad ) :-
  findall( FelicidadParte, felicidadParte(Partes, FelicidadParte), Felicidades ),
  sumlist( Felicidades, Felicidad ).

felicidadJuguete( Juguete, 120 ) :-
  esDeAccion( Juguete ),
  esDeColeccionConDuenioColeccionista( Juguete ).

felicidadJuguete( Juguete , Felicidad ) :-
  esDeAccion(Juguete),
  not( esDeColeccionConDuenioColeccionista( Juguete ) ),
  felicidadDeTrapo( Felicidad ).

felicidadDeTrapo( 100 ).

esDeColeccionConDuenioColeccionista( Juguete ) :-
  esDeColeccion( Juguete ),
  duenio( Duenio, NombreJuguete, _ ),
  juguete( NombreJuguete, Juguete ),
  esColeccionista( Duenio ).

esDeAccion(deAccion(_,_)).

felicidadParte( Partes, Felicidad ) :-
  member( Parte, Partes ),
  felicidadParteJuguete( Parte, Felicidad ).

felicidadParteJuguete( original(_), 5 ).
felicidadParteJuguete( repuesto(_), 8 ).

/***********/
/* Punto 6 */
/***********/

puedeJugarCon( Alguien, NombreJuguete ) :-
  duenio( Alguien, NombreJuguete, _ ).

puedeJugarCon( Alguien, NombreJuguete ) :-
  puedePrestarlo( Persona, Alguien ),
  puedeJugarCon( Persona, NombreJuguete ).

puedePrestarlo( Duenio, Otro ) :-
  cantidadJuguetes(Duenio, Cantidad),
  cantidadJuguetes(Otro, OtraCantidad),
  Cantidad > OtraCantidad.

cantidadJuguetes(Duenio, Cantidad) :-
  findall( NombreJuguete, duenio( Duenio, NombreJuguete, _ ) , Juguetes ),
  length( Juguetes, Cantidad ).

/***********/
/* Punto 7 */
/***********/

podriaDonar( Duenio, Juguetes, Felicidad ) :-
  juguetesDelDuenio( Duenio, JuguetesDelDuenio ),
  subconjuntoPermutado( Juguetes, JuguetesDelDuenio ),
  cantidadFelicidad( Juguetes, OtraFelicidad ),
  esMenor( OtraFelicidad, Felicidad ).

/* Lo que se esperaba para el parcial es que hagan esto   */
/* Procederemos a hacerlo completo, pero OJO... es fumeta */

juguetesDelDuenio( Duenio, Juguetes ) :-
  duenio( Duenio, _, _ ),
  findall( Juguete, jugueteDeDuenio(Duenio, Juguete), Juguetes ).

jugueteDeDuenio( Duenio, Juguete ) :-
  duenio( Duenio, NombreJuguete, _ ),
  juguete( NombreJuguete, Juguete ).

subconjuntoPermutado(SubconjuntoPermutado, Conjunto) :-
  subconjunto( Subconjunto, Conjunto),
  permutation( Subconjunto,SubconjuntoPermutado ).

subconjunto( [], [] ).
subconjunto( Subconjunto, [_|Cola] ) :-
  subconjunto( Subconjunto, Cola ).
subconjunto( [X|Subconjunto], [X|Cola] ) :-
  subconjunto(Subconjunto, Cola).

cantidadFelicidad( [], 0 ).
cantidadFelicidad( [Juguete|Juguetes], FelicidadTotal ) :-
  felicidadJuguete( Juguete, FelicidadJuguete ),
  cantidadFelicidad( Juguetes, FelicidadJuguetes ),
  FelicidadTotal is FelicidadJuguete + FelicidadJuguetes.

esMenor( NumeroLigado, NumeroGenerado ) :-
  generarNumeroEnBaseA( NumeroLigado, NumeroGenerado ),
  NumeroGenerado > NumeroLigado.

generarNumeroEnBaseA( NumeroLigado, NumeroGenerado ) :-
  esNumero(Numero),
  NumeroGenerado is NumeroLigado + Numero.

esNumero(Numero) :- numero(0, Numero).

numero(Numero, Numero).
numero(Numero, Generado) :-
  Siguiente is Numero + 1,
  numero( Siguiente, Generado).



