vende(laGondoriana, trancosin, 35).
vende(laGondoriana, sanaSam, 35).

incluye(trancosin, athelas).
incluye(trancosin, cenizaBoromireana).

efecto(athelas, cura(desazon)).
efecto(athelas, cura(heridaDeOrco)).
efecto(cenizaBoromireana, cura(gripeA)).
efecto(cenizaBoromireana,potencia(deseoDePoder)).

estaEnfermo(eomer, heridaDeOrco). % eomer es varon
estaEnfermo(eomer, deseoDePoder).
estaEnfermo(eomund, desazon).
estaEnfermo(eowyn, heridaDeOrco). % eowyn es mujer

padre(eomund,eomer).

actividad(eomer, fecha(15,6,3014), compro(trancosin, laGondoriana)).
actividad(eomer, fecha(15,8,3014), preguntoPor(sanaSam, laGondoriana)).
actividad(eowyn, fecha(14,9,3014), preguntoPor(sanaSam, laGondoriana)).

/* =========== */
/* Generadores */
/* =========== */

esPersona(Persona) :-
    estaEnfermo(Persona, _).

esMedicamento(Medicamento) :-
    incluye(Medicamento, _).

esDroga(Droga) :-
    incluye(_, Droga).

/* =========== */
/*   Punto 1   */
/* =========== */

medicamentoUtil(Persona, Medicamento) :-
    sirveParaCurar(Medicamento, Persona),
    not( sirveParaPotenciar(Medicamento, Persona) ).

sirveParaCurar(Medicamento, Persona) :-
    estaEnfermo(Persona, Enfermedad),
    sirveParaCurarEnfermedad(Medicamento, Enfermedad).

sirveParaCurarEnfermedad(Medicamento, Enfermedad) :-
    incluye(Medicamento, Droga),
    efecto(Droga, cura(Enfermedad)).

sirveParaPotenciar(Medicamento, Persona) :-
    estaEnfermo(Persona, Enfermedad),
    incluye(Medicamento, Droga),
    efecto(Droga, potencia(Enfermedad)).

/* =========== */
/*   Punto 2   */
/* =========== */

medicamentoMilagroso(Persona, Medicamento) :-
    forall(  estaEnfermo(Persona, Enfermedad)  ,  sirveParaCurarEnfermedad(Medicamento, Enfermedad)  ),
    not(  sirveParaPotenciar(Medicamento, Persona)  ).

/* =========== */
/*   Punto 3   */
/* =========== */

drogaSimpatica(Droga) :-
    curaAlMenosCuatroEnfermedades(Droga),
    not(  tieneContraindicaciones(Droga)  ).

curaAlMenosCuatroEnfermedades(Droga) :-
    esDroga(Droga),
    findall(Enfermedad, efecto(Droga, cura(Enfermedad)) , Enfermedades),
    length(Enfermedades, Cantidad),
    Cantidad >= 4.

tieneContraindicaciones(Droga) :-
    efecto(Droga, potencia(_)).

drogaSimpatica(Droga) :-
    curaPersona(eomer, Enfermedad1, Droga),
    curaPersona(eowyn, Enfermedad2, Droga),
    Enfermedad1 \= Enfermedad2.

curaPersona(Persona, Enfermedad, Droga) :-
    efecto(Droga, cura(Enfermedad)),
    estaEnfermo(Persona, Enfermedad).

drogaSimpatica(Droga) :-
    incluye(Medicamento, Droga),
    vende(_,Medicamento, _),
    forall(  vende(_, Medicamento, Precio)  ,  Precio =< 10  ).

/* =========== */
/*   Punto 4   */
/* =========== */

tipoSuicida(Persona) :-
    actividad(Persona, _, compro(Medicamento,_)),
    not(  sirveParaCurar(Medicamento, Persona)  ),
    sirveParaPotenciar(Medicamento, Persona).

/* =========== */
/*   Punto 5   */
/* =========== */

tipoAhorrativo(Persona) :-
    esPersona(Persona),
    forall(  comproEn(Persona, Farmacia, Medicamento)  ,  preguntoEnOtraFarmaciaQueLoCobraMasCaro(Persona, Medicamento, Farmacia)  ).

comproEn(Persona, Farmacia, Medicamento) :-
    actividad(Persona, _, compro(Medicamento, Farmacia)).

preguntoEnOtraFarmaciaQueLoCobraMasCaro(Persona, Medicamento, Farmacia) :-
    actividad(Persona, _, preguntoPor(Medicamento, OtraFarmacia)),
    vende(Farmacia, Mecicamento, Precio),
    vende(OtraFarmacia, Mecicamento, OtroPrecio),
    OtraFarmacia \= Farmacia,
    Precio =< OtroPrecio.

/* =========== */
/*  Punto 6-a  */
/* =========== */

tipoActivoEn(Persona, Mes, Anio) :-
    actividad(Persona, fecha(_, Mes, Anio), _).

/* =========== */
/*  Punto 6-b  */
/* =========== */

diaProductivo(Fecha) :-
    actividad(Persona, Fecha, Actividad),
    actividadParaMedicamento(Actividad, Medicamento),
    medicamentoUtil(Medicamento, Persona).

actividadParaMedicamento(compra(Medicamento, _), Medicamento).

actividadParaMedicamento(preguntoPor(Medicamento, _), Medicamento).

/* =========== */
/*   Punto 7   */
/* =========== */

gastoTotal(Persona, GastoTotal) :-
    esPersona(Persona),
    findall(Precio,  gastoParcial(Persona, Precio),  Precios),
    sumlist(Precios, GastoTotal).

gastoParcial(Persona, Precio) :-
    actividad(Persona, _, compro(Medicamento, Farmacia)),
    vende(Farmacia, Medicamento, Precio).

/* =========== */
/*   Punto 8   */
/* =========== */

zafoDe(Persona, Enfermedad) :-
    estaEnfermo(Persona, Enfermedad),
    ancestro(Ancestro, Persona),
    not(estaEnfermo(Ancestro, Enfermedad)).

ancestro(Ancestro, Persona) :-
    padre(Ancestro, Persona).

ancestro(Ancestro, Persona) :-
    padre(Ancestro, OtraPersona),
    ancestro(OtraPersona, Persona).


