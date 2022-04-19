(deffacts Ramas
(Rama Computación_y_Sistemas_Inteligentes)
(Rama Ingeniería_del_Software)
(Rama Ingeniería_de_Computadores)
(Rama Sistemas_de_Información)
(Rama Tecnologías_de_la_Información)
)


(deffacts Estado_inicial_variables
(Gusta Matematicas DESCONOCIDO)
(Gusta Hardware DESCONOCIDO)
(Gusta Programar DESCONOCIDO) 
(Prefiere DESCONOCIDO)
(Gusta Mucha_carga DESCONOCIDO)
(Gusta Doble_grado DESCONOCIDO)
)

;;; Bienvenida ;;;

(defrule welcome
(declare (salience 9999))
=>
(printout t "Bienvenido al sistema experto de recomendación." crlf)
)

;;; La primera pregunta que se le hace al usuario es si tiene inclinación por las asignaturas teóricas o prácticas. Obviamente, el usuario puede decir que no. ;;;
;;; En los tres casos se seguirán cauces distintos ;;;


(defrule preguntar_teoria_o_practicas
(declare (salience 9999))
=>
(printout t "Para comenzar, con la base de todas las asignaturas que has cursado, ¿tienes inclinación por las asignaturas TEORICAS o PRACTICAS? puedes responder NO" crlf)
(assert (Prefiere (read)))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule check_pregunta_teoria_o_practicas
?f <- (Prefiere ?r)
(test (neq ?r DESCONOCIDO))
(test (neq ?r TEORICAS))
(test (neq ?r PRACTICAS))
(test (neq ?r NO))
=>
(printout t "Necesito que especifiques si tienes inclinación por las asignaturas TEORICAS o PRACTICAS? puedes responder NO." crlf)
(retract ?f)
(assert (Prefiere (read)))
)

;;; Como el usuario la ha respondido bien, avanza a la siguiente pregunta. ;;;


;;; Si el usuario ha respondido que tiene más inclinación por las asignaturas teóricas, se le pregunta la nota media. ;;;
(defrule prefiere_teoria
(Prefiere ?r)
(test (eq ?r TEORICAS))
=>
(printout t "Prefieres las asignaturas con más fundamento teórico..." crlf)
(printout t "Vale, sería interesante que me facilites tu nota media ahora: puede haber asignaturas que se te compliquen" crlf)
(assert (Preguntar_nota))
)


;;; Si el usuario ha respondido que tiene más inclinación por las asignaturas prácticas, se le pregunta cuán trabajador es. ;;;
(defrule prefiere_practicas
(Prefiere ?r)
(test (eq ?r PRACTICAS))
=>
(printout t "Prefieres las asignaturas con más fundamento práctico..." crlf)
(printout t "Entonces necesito ver tu grado de compromiso con la materia." crlf)
(assert (Preguntar_trabajador))
)

(defrule preguntar_nota_media
?f <- (Preguntar_nota)
=>
(printout t "Introduce tu nota:" crlf)
(assert (Calcular_nota (read)))
(retract ?f)
)

(defrule preguntar_si_es_trabajador
?f <- (Preguntar_trabajador)
=>
(printout t "¿Eres trabajador? Responde con SI o NO:" crlf)
(assert (Es_trabajador (read)))
(retract ?f)
)


(defrule calcular_nota_media_baja
(Calcular_nota ?nota)
(test (< ?nota 6))
=>
(assert (Deduccion nota_media BAJA))
)

(defrule calcular_nota_media_media
(Calcular_nota ?nota)
(test (and (>= ?nota 6) (< ?nota 8)))
=>
(assert (Deduccion nota_media MEDIA))
)

(defrule calcular_nota_media_alta
(Calcular_nota ?nota)
(test (>= ?nota 8))
=>
(assert (Deduccion nota_media ALTA))
)

(defrule nota_calculada
(Deduccion nota_media ?nota)
(test (neq ?nota NO))
=>
(printout t "Tu nota es " ?nota crlf)
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_nota_media
?f <- (Calcular_nota ?nota)
(test (or (< ?nota 5) (> ?nota 10)))
=>
(printout t "Necesito que especifiques bien tu nota media. Puedes consultarla en el expediente de la UGR. Es un valor del 1 al 10" crlf)
(retract ?f)
(assert (Preguntar_nota))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_nota_media
?f <- (Es_trabajador ?trabajador)
(test (and (neq ?trabajador SI) (neq ?trabajador NO)))
=>
(printout t "Tienes que responder si eres trabajador o no; no vale que no lo sepas. Pregúntate a ti mismo!!!" crlf)
(retract ?f)
(assert (Preguntar_trabajador))
)






