;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIALIZAR ESTADO


(deffacts Estado_inicial
(Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
(Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
(Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
(Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
(Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
(Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
(Jugada 0)
)

(defrule Elige_quien_comienza
=>
(printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
(assert (Turno (read)))
)

;;;;;;;;;;;;;;;;;;;;;;; MUESTRA POSICION ;;;;;;;;;;;;;;;;;;;;;;;
(defrule muestra_posicion
(declare (salience 10))
(muestra_posicion)
(Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
(Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
(Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
(Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
(Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
(Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
=>
(printout t crlf)
(printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
(printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
(printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
(printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
(printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
(printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
(printout t  crlf)
)

;;;; TABLERO DE ANALISIS ;;;;;;


(defrule crear_tablero_analisis
(Turno M)
(Tablero Juego ?f ?c ?j)
=>
(assert (Tablero Analisis ?f ?c ?j))
)

(defrule destruir_tablero_analisis
(Turno J)
?h <- (Tablero Analisis ?f ?c ?j)
=>
(retract ?h)
)

;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
(declare (salience 9999))
(Turno J)
=>
(assert (muestra_posicion))
)

(defrule jugada_contrario
?f <- (Turno J)
=>
(printout t "en que columna introduces la siguiente ficha? ")
(assert (Juega J (read)))
(retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
(declare (salience 1))
?f <- (Juega J ?c)
(test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?c)
(Tablero Juego 1 ?c ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule elegir_jugada_aleatoria
(declare (salience -9998))
?f <- (Turno M)
=>
(assert (Jugar (random 1 7)))
(retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
?f <- (Jugar ?c)
(Tablero Juego 1 ?c M|J)
=>
(retract ?f)
(assert (Turno M))
)

(defrule clisp_juega_sin_criterio
(declare (salience -9999))
?f<- (Jugar ?c)
=>
(printout t "JUEGO en la columna (sin criterio) " ?c crlf)
(retract ?f)
(assert (Juega M ?c))
(printout t "Juego sin razonar, que mal"  crlf)
)


;;;;;;; CLIPS JUEGA CON CRITERIO ;;;;;


(defrule ganaria
(declare (salience 9999))
?f <- (Turno M)
(Ganaria M ?i ?c)
=>
(printout t "Pongo finalmente la ficha en la columna " ?c " para ganar." crlf)
(assert (Juega M ?c))
(retract ?f)
)

(defrule bloquear_cuatro_linea_conectado
(declare (salience 9998))
?f <- (Turno M)
(3linea Juego ?orientacion ?i1 ?c1 ?i3 ?c3 J)
(or (Siguiente ?i3 ?c3 ?orientacion ?i4 ?c4) (Anterior ?i1 ?c1 ?orientacion ?i4 ?c4))
(Caeria Juego ?i4 ?c4)
;la ficha donde caeria es la siguiente a una en la que hay una ficha nuestra
(Tablero Juego ?i5 ?c5 M)
(or (Siguiente ?i4 ?c4 ?orientacion ?i5 ?c5) (Anterior ?i4 ?c4 ?orientacion ?i5 ?c5))
=>
(assert (Juega M ?c4))
(retract ?f)
(printout t "Juego en la columna " ?c4 " para evitar el cuatro en línea del rival, aprovechando y conectando con una ficha que ya tengo." crlf)
)

(defrule bloquear_cuatro_linea
(declare (salience 9997))
?f <- (Turno M)
(3linea Juego ?orientacion ?i1 ?c1 ?i3 ?c3 J)
(or (Siguiente ?i3 ?c3 ?orientacion ?i4 ?c4) (Anterior ?i1 ?c1 ?orientacion ?i4 ?c4))
(Caeria Juego ?i4 ?c4)
=>
(assert (Juega M ?c4))
(retract ?f)
(printout t "Juego en la columna " ?c4 " para evitar el cuatro en línea del rival." crlf)
)


(defrule bloquear_tres_linea
(declare (salience 9996))
?f <- (Turno M)
(Conectado Juego ?orientacion ?i1 ?c1 ?i2 ?c2 J)
(or (Siguiente ?i2 ?c2 ?orientacion ?i3 ?c3) (Anterior ?i1 ?c1 ?orientacion ?i3 ?c3))
(Caeria Juego ?i3 ?c3)
=>
(assert (Juega M ?c3))
(retract ?f)
(printout t "Juego en la columna " ?c3 " para evitar el tres en línea del rival." crlf)
)

(defrule poner_tres_linea
(declare (salience 9995))
?f <- (Turno M)
(Conectado Juego ?orientacion ?i1 ?c1 ?i2 ?c2 M)
(or (Siguiente ?i2 ?c2 ?orientacion ?i3 ?c3) (Anterior ?i1 ?c1 ?orientacion ?i3 ?c3))
(Caeria Juego ?i3 ?c3)
=>
(assert (Juega M ?c3))
(retract ?f)
(printout t "Juego en la columna " ?c3 " para conectar tres en linea." crlf)
)

(defrule poner_dos_linea_bloqueando
(declare (salience 9994))
?f <- (Turno M)
(Caeria Juego ?i ?c)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 J)
(or (Siguiente ?f2 ?c2 ?orientacion ?i ?c) (Anterior ?f2 ?c2 ?orientacion ?i ?c))
(or (Siguiente ?f1 ?c1 ?orientacion ?i ?c) (Anterior ?f1 ?c1 ?orientacion ?i ?c))
=>
(assert (Juega M ?c))
(retract ?f)
(printout t "Juego en la columna " ?c " para hacer un básico dos en linea, pero al lado del rival para bloquear un poco su avance." crlf)
)

(defrule poner_dos_linea
(declare (salience 9993))
?f <- (Turno M)
(Caeria Juego ?i ?c)
(Tablero Juego ?f1 ?c1 M)
(or (Siguiente ?f1 ?c1 ?orientacion ?i ?c) (Anterior ?f1 ?c1 ?orientacion ?i ?c))
=>
(assert (Juega M ?c))
(retract ?f)
(printout t "Juego en la columna " ?c " para hacer un básico dos en linea." crlf)
)

(defrule dominar_medio
?f <- (Turno M)
(Tablero Juego 6 4 _)
=>
(assert (Juega M 4))
(retract ?f)
(printout t "Juego en la columna 4 , central de la primera fila, al principio de la partida, para dominar el medio del mapa. Así puedo hacer más combinaciones que jugando en la esquina y evito que el rival me coloque su ficha aquí." crlf)
)

(defrule dominar_medio_cuando_rival_empieza
?f <- (Turno M)
(Tablero Juego 6 4 J)
=>
(assert (Juega M 3))
(retract ?f)
(printout t "Juego en la columna 3 , al lado del central de la primera fila, al principio de la partida, para dominar el medio del mapa, al lado de mi rival. Así puedo hacer más combinaciones que jugando en la esquina y evito que el rival me coloque su ficha aquí." crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(Tablero ?t ?i ?c4 ?jugador)
(test (= (+ ?c1 3) ?c4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?c  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
(declare (salience -9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;;;; ¡¡¡¡¡¡¡¡¡¡ Añadir conocimiento para que juege como vosotros jugariais !!!!!!!!!!!!

(defrule siguiente_horizontal
(Tablero Juego ?f ?c _)
(test (< ?c 7))
(test (> ?c 0))
=>
(assert (Siguiente ?f ?c horizontal ?f (+ ?c 1)))
(assert (Anterior ?f (+ ?c 1) horizontal ?f ?c))
)

(defrule siguiente_vertical
(Tablero Juego ?f ?c _)
(test (< ?f 6))
(test (> ?f 0))
=>
(assert (Siguiente ?f ?c vertical (+ ?f 1) ?c))
(assert (Anterior (+ ?f 1) ?c vertical ?f ?c))
)

(defrule siguiente_diagonal_directa
(Tablero Juego ?f ?c _)
(test (< ?f 6))
(test (> ?f 0))
=>
(assert (Siguiente ?f ?c diagonal_directa (+ ?f 1) (+ ?c 1)))
(assert (Anterior (+ ?f 1) (+ ?c 1) vertical ?f ?c))
)

(defrule siguiente_diagonal_inversa
(Tablero Juego ?f ?c _)
(test (< ?f 6))
(test (> ?f 0))
=>
(assert (Siguiente ?f ?c diagonal_inversa (- ?f 1) (+ ?c 1)))
(assert (Anterior (- ?f 1) (+ ?c 1) vertical ?f ?c))
)

(defrule conectado_dos_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(test (neq ?jugador _))
=>
(assert (Conectado ?t horizontal ?i ?c1 ?i ?c2 ?jugador))
)

(defrule conectado_dos_vertical
(declare (salience 9999))
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(test (neq ?jugador _))
=>
(assert (Conectado ?t vertical ?i1 ?c ?i2 ?c ?jugador))
)

(defrule conectado_dos_diagonal_directa
(declare (salience 9999))
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(test (neq ?jugador _))
=>
(assert (Conectado ?t diagonal_directa ?i ?c ?i1 ?c1 ?jugador))
)

(defrule conectado_dos_diagonal_inversa
(declare (salience 9999))
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (- ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(test (neq ?jugador _))
=>
(assert (Conectado ?t diagonal_inversa ?i ?c ?i1 ?c1 ?jugador))
)

(defrule conectado_tres_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(test (neq ?jugador _))
=>
(assert (3linea ?t horizontal ?i ?c1 ?i ?c3 ?jugador))
)

(defrule conectado_tres_vertical
(declare (salience 9999))
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(test (neq ?jugador _ ))
=>
(assert (3linea ?t vertical ?i1 ?c ?i3 ?c ?jugador))
)

(defrule conectado_tres_diagonal_directa
(declare (salience 9999))
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(test (neq ?jugador _))
=>
(assert (3linea ?t diagonal_directa ?i ?c ?i2 ?c2 ?jugador))
)

(defrule conectado_tres_diagonal_inversa
(declare (salience 9999))
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (- ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (- ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(test (neq ?jugador _))
=>
(assert (3linea ?t diagonal_inversa ?i ?c ?i2 ?c2 ?jugador))
)

(defrule caeria
(declare (salience 9999))
(Tablero ?t ?f ?c _)
(Siguiente ?f ?c vertical ?f1 ?c1)
(Tablero ?t ?f1 ?c1 ?jugador)
(test (neq ?jugador _))
=>
(assert (Caeria ?t ?f ?c))
)

(defrule caeria_fondo
(declare (salience 9999))
(Tablero ?t ?f ?c _)
(test (eq ?f 6))
=>
(assert (Caeria ?t ?f ?c))
)

(defrule borrar_caeria
(declare (salience 9999))
?h <- (Caeria Juego ?f ?c)
(Tablero ?t ?f ?c ?jugador)
(test (neq ?jugador _))
=>
(retract ?h)
)

(defrule ganaria_siguiente_jugada
(declare (salience 9999))
(3linea ?t ?orientacion ?i1 ?c1 ?i3 ?c3 ?jugador)
(or (Siguiente ?i3 ?c3 ?orientacion ?i4 ?c4) (Anterior ?i1 ?c1 ?orientacion ?i4 ?c4))
(Caeria ?t ?i4 ?c4)
=>
(printout t  " Ganaria porque tengo 3 en linea en " ?i1 ?c1 ?i3 ?c3 " y siguiente de " ?i3 ?c3 ?i4 ?c4 " y caeria en " ?i4 ?c4   crlf)

(assert (Ganaria ?jugador ?i4 ?c4))
)

(defrule borrar_ganaria
(declare (salience 9999))
?h <- (Ganaria ?jugador ?f ?c)
(Tablero Juego ?f ?c ?x)
(test (neq ?x _))
=>
(retract ?h)
)

;; 2 en linea y 1 al otro lado.
;;(defrule ganaria_poniendo_en_medio_siguiente
;;(Conectado ?t ?orientacion ?i ?c ?i1 ?c1 ?jugador)
;;(Siguiente ?i1 ?c1 ?orientacion ?i2 ?c2)
;;(Caeria ?t ?i2 ?c2)
;;(Siguiente ?i2 ?c2 ?orientacion ?i3 ?c3)
;;(Tablero ?t ?i3 ?c3 ?jugador)
;;=>
;;(assert (Ganaria ?jugador ?i2 ?c2))
;;)

;;(defrule ganaria_poniendo_en_medio_anterior
;;(Conectado ?t ?orientacion ?i ?c ?i1 ?c1 ?jugador)
;;(Anterior ?i ?c ?orientacion ?i2 ?c2)
;;(Caeria ?t ?i2 ?c2)
;;(Anterior ?i2 ?c2 ?orientacion ?i3 ?c3)
;;(Tablero ?t ?i3 ?c3 ?jugador)
;;=>
;;(assert (Ganaria ?jugador ?i2 ?c2))
;;)




