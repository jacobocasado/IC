(deffacts Ramas
(Rama Computación_y_Sistemas_Inteligentes)
(Rama Ingeniería_del_Software)
(Rama Ingeniería_de_Computadores)
(Rama Sistemas_de_Información)
(Rama Tecnologías_de_la_Información)
)


(deffacts Estado_inicial_variables
(Preguntar_teoria_practicas)
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
?f <- (Preguntar_teoria_practicas)
=>
(printout t "Para comenzar, con la base de todas las asignaturas que has cursado, ¿tienes inclinación por las asignaturas TEORICAS o PRACTICAS? puedes responder NO" crlf)
(retract ?f)
(assert (Prefiere (read)))
)

(defrule preguntar_nota_media
?f <- (Preguntar_nota)
=>
(printout t "Introduce tu nota media a lo largo de estos años (aproximada, si no la sabes está en tu expediente):" crlf)
(retract ?f)
(assert (Calcular_nota (read)))
)

(defrule preguntar_si_es_trabajador
?f <- (Preguntar_trabajador)
=>
(printout t "¿Eres trabajador? Responde con SI, NO o NS:" crlf)
(assert (Es_trabajador (read)))
(retract ?f)
)

(defrule preguntar_doble_grado
?f <- (Preguntar_doble_grado)
=>
(printout t "Si pudieses realizar un doble grado, ¿harías el grado con ADE o MATES, o NINGUNO?" crlf)
(assert (Preferencia_doble_grado (read)))
(retract ?f)
)

(defrule preguntar_futuro_trabajo
?f <- (Preguntar_futuro_trabajo)
=>
(printout t "¿Y tienes pensado trabajar en una empresa PRIVADA, PUBLICA o dedicarte a la DOCENCIA? Si no lo sabes, responde con NS" crlf)
(assert (Futuro_trabajo (read)))
(retract ?f)
)

(defrule preguntar_hardware_software
?f <- (Preguntar_hardware_software)
=>
(printout t "Y de las asignaturas que han cursado, ¿te han gustado más las de HARDWARE o las de SOFTWARE? Si no lo sabes también puedes responder con NS" crlf)
(assert (Preferencia_hw_sw (read)))
(retract ?f)
)

(defrule deducir_hardware_software
?f <- (Deducir_software_o_hardware)
=>
(printout t "Vale... me falta una última cosa. Califica del 1 al 10 cuánto interes tienes por la tarea de escribir y desarrollar algoritmos, en base a tu experiencia:" crlf)
(assert (Deducir_hw_sw (read)))
(retract ?f)
)

(defrule calcular_nota_media_baja
(Calcular_nota ?nota)
(test (and (< ?nota 6) (>= ?nota 5)))
=>
(assert (Nota_media BAJA))
)

(defrule calcular_nota_media_media
(Calcular_nota ?nota)
(test (and (>= ?nota 6) (< ?nota 8)))
=>
(assert (Nota_media MEDIA))
)

(defrule calcular_nota_media_alta
(Calcular_nota ?nota)
(test (>= ?nota 8))
=>
(assert (Nota_media ALTA))
)


;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_nota_media
?f <- (Calcular_nota ?nota)
(test (or (< ?nota 5) (> ?nota 10)))
=>
(printout t "La nota media es incorrecta. Es un valor del 5 al 10." crlf)
(retract ?f)
(assert (Preguntar_nota))
)


;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_deduccion_hw_sw
?f <- (Deducir_hw_sw ?nota)
(test (or (< ?nota 0) (> ?nota 10)))
=>
(printout t "La nota media es incorrecta. Es un valor del 0 al 10." crlf)
(retract ?f)
(assert (Deducir_software_o_hardware))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_trabajador
?f <- (Es_trabajador ?trabajador)
(test (and (neq ?trabajador SI) (neq ?trabajador NO) (neq ?trabajador NS)))
=>
(printout t "Perdona, quizás me he explicado mal. " crlf)
(retract ?f)
(assert (Preguntar_trabajador))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_doble_grado
?f <- (Preferencia_doble_grado ?preferencia)
(test (and (neq ?preferencia ADE) (neq ?preferencia MATES) (neq ?preferencia NINGUNO)))
=>
(printout t "Perdona, quizás me he explicado mal. " crlf)
(retract ?f)
(assert (Preguntar_doble_grado))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_pregunta_teoria_o_practicas
?f <- (Prefiere ?r)
(test (neq ?r TEORICAS))
(test (neq ?r PRACTICAS))
(test (neq ?r NO))
=>
(retract ?f)
(assert (Preguntar_teoria_practicas))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_futuro_trabajo
?f <- (Futuro_trabajo ?r)
(test (neq ?r PRIVADA))
(test (neq ?r PUBLICA))
(test (neq ?r DOCENCIA))
(test (neq ?r NS))
=>
(retract ?f)
(assert (Preguntar_futuro_trabajo))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_hw_sw
?f <- (Preferencia_hw_sw ?r)
(test (neq ?r HARDWARE))
(test (neq ?r SOFTWARE))
(test (neq ?r NS))
(test (neq ?r AMBAS))
=>
(retract ?f)
(assert (Preguntar_hardware_software))
)


;;; Si el usuario no sabe si es trabajador o no, se le hace una pregunta un poco más práctica donde se le pregunta su grado de dedicación por las asignaturas de la carrera. ;;;
(defrule inferir_es_trabajador
?f <- (Es_trabajador NS)
=>
(printout t "Entiendo, no lo sabes. Y, del 1 al 10, ¿cuál es tu grado de compromiso con las asignaturas que has cursado? Siendo un 10 el máximo, claro: " crlf)
(retract ?f)
(assert (Inferir_trabajador (read)))
)

(defrule inferir_no_es_trabajador
(Inferir_trabajador ?nota)
(test (< ?nota 6))
=>
(assert (Es_trabajador NO))
)

(defrule inferir_si_es_trabajador
(Inferir_trabajador ?nota)
(test (>= ?nota 6))
=>
(assert (Es_trabajador SI))
)

(defrule inferir_prefiere_hardware
(Deducir_hw_sw ?nota)
(test (< ?nota 6))

=>
(assert (Preferencia_hw_sw HARDWARE))
)

(defrule inferir_prefiere_software
(Deducir_hw_sw ?nota)
(test (>= ?nota 6))
=>
(assert (Preferencia_hw_sw SOFTWARE))
)


;;; Si el usuario ha respondido que tiene más inclinación por las asignaturas teóricas, se le pregunta la nota media. ;;;
(defrule prefiere_teoria
(Prefiere TEORICAS)
=>
(printout t "Prefieres las asignaturas con más fundamento teórico..." crlf)
(printout t "Vale, sería interesante que me facilites tu nota media ahora: puede haber asignaturas que se te compliquen" crlf)
(assert (Preguntar_nota))
)


(defrule teoria_nota_media_baja
(Prefiere TEORICAS)
(Nota_media BAJA)
=>
(printout t "Vale, prefieres la teoría y tus notas no son altas, ¡pero no pasa nada! " crlf)
(printout t "Seguro que cuando encuentres tu especialidad, sacarás mejores notas." crlf)
(assert (Preguntar_futuro_trabajo))
)

(defrule teoria_nota_media_baja_no_sabe_donde_trabajar
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
=>
(assert (Preguntar_doble_grado))
)

(defrule teoria_nota_media_baja_no_sabe_donde_trabajar_no_doble_grado
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
(Preferencia_doble_grado NINGUNO) 
=>
(assert (Preguntar_trabajador))
)

(defrule teoria_nota_media_media
(Prefiere TEORICAS)
(Nota_media MEDIA)
=>
(printout t "Vale, prefieres la teoría y no tienes mala media." crlf)
(printout t "Vamos a continuar para terminar de dar la especialidad que más se ajuste a ti." crlf)
(assert (Preguntar_hardware_software))
)

(defrule teoria_nota_media_media_no_sabe_sw_o_hw
(Prefiere TEORICAS)
(Nota_media MEDIA)
(or (Preferencia_hw_sw NS) (Preferencia_hw_sw AMBAS))
=>
(printout t "Entiendo, tanto el software como el hardware te gustan por igual..." crlf)
(assert (Deducir_software_o_hardware))
)

;;; Si el usuario ha respondido que tiene más inclinación por las asignaturas prácticas, se le pregunta cuán trabajador es. ;;;
(defrule prefiere_practicas
(Prefiere PRACTICAS)
=>
(printout t "Prefieres las asignaturas con más fundamento práctico..." crlf)
(printout t "Entonces necesito ver tu grado de compromiso con la materia." crlf)
(assert (Preguntar_trabajador))
)

(defrule prefiere_practicas_no_es_trabajador
(Prefiere PRACTICAS)
(Es_trabajador NO)
=>
(assert (Preguntar_nota))
)

(defrule prefiere_practicas_no_es_trabajador_nota_media_media
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media MEDIA)
=>
(assert (Preguntar_hardware_software))
)

(defrule prefiere_practicas_no_es_trabajador_nota_media_media_no_sabe_sw_o_hw
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media MEDIA)
(or (Preferencia_hw_sw NS) (Preferencia_hw_sw AMBAS))
=>
(printout t "Entiendo, tanto el software como el hardware te gustan por igual..." crlf)
(assert (Deducir_software_o_hardware))
)


;;; Si el usuario ha respondido que no tiene inclinación por ninguna de las dos
	Se pasa a preguntar si el alumno haría un doble grado con ADE o MATES, en caso
	de que tuviese la opción ;;;
(defrule prefiere_ninguna_entre_teoria_practica
(Prefiere NO)
=>
(printout t "Al decirme que no supongo que te gustan ambas por igual, entiendo..." crlf)
(assert (Preguntar_doble_grado))
)

(defrule prefiere_ninguna_entre_teoria_practica_ade
(Prefiere NO)
(Preferencia_doble_grado ADE) 
=>
(printout t "Entiendo, prefieres ADE, un perfil más dedicado a los datos y al manejo de la información... " crlf)
(assert (Preguntar_futuro_trabajo))
)

(defrule prefiere_ninguna_entre_teoria_practica_ade_publica_o_docencia_ambas
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(Futuro_trabajo NS)
=>
(printout t "Vale, no tienes claro donde trabajar; no pasa nada." crlf)
(assert (Preguntar_hardware_software))
)

(defrule prefiere_ninguna_entre_teoria_practica_ade_publica_o_docencia_ns_deducir_hw_sw
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(Futuro_trabajo NS)
(or (Preferencia_hw_sw NS) (Preferencia_hw_sw AMBAS))
=>
(printout t "Entiendo, tanto el software como el hardware te gustan por igual..." crlf)
(assert (Deducir_software_o_hardware))
)

(defrule prefiere_ninguna_entre_teoria_practica_ade_publica_o_docencia
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(or (Futuro_trabajo PUBLICA) (Futuro_trabajo DOCENCIA))
=>
(printout t "Es decir, te gusta más el lado empresarial de la informática y con posiblidad de trabajar en empresas públicas o ser docente..." crlf)
(assert (Preguntar_hardware_software))
)

(defrule prefiere_ninguna_entre_teoria_practica_ade_publica_o_docencia_ambas_hw_sw_ambas
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(or (Futuro_trabajo PUBLICA) (Futuro_trabajo DOCENCIA))
(or (Preferencia_hw_sw NS) (Preferencia_hw_sw AMBAS))
=>
(printout t "Entiendo, tanto el software como el hardware te gustan por igual..." crlf)
(assert (Deducir_software_o_hardware))
)

(defrule prefiere_ninguna_entre_teoria_practica_mates
(Prefiere NO)
(Preferencia_doble_grado MATES) 
=>
(printout t "Entiendo, prefieres matemáticas, un perfil más orientado a los algoritmos y su funcionamiento interno, al entender más de matemáticas." crlf)
(assert (Preguntar_trabajador))
)

(defrule prefiere_ninguna_entre_teoria_practica_ninguno
(Prefiere NO)
(Preferencia_doble_grado NINGUNO) 
=>
(printout t "Entiendo, prefieres un perfil completo de informático. " crlf)
(assert (Preguntar_hardware_software))
)

(defrule veredicto_ic_1
(Prefiere TEORICAS)
(Nota_media BAJA)
(or (Futuro_trabajo PRIVADA) (Futuro_trabajo DOCENCIA))
=>
(assert (Consejo Ingeniería_de_Computadores "texto"))
(printout t "INGENIERIA DE COMPUTADORES" crlf)
)

(defrule veredicto_ic_2
(Prefiere TEORICAS)
(Nota_media MEDIA)
(Preferencia_hw_sw HARDWARE)
=>
(assert (Consejo Ingeniería_de_Computadores "texto"))
(printout t "INGENIERIA DE COMPUTADORES" crlf)
)

(defrule veredicto_ic_3
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media MEDIA)
(Preferencia_hw_sw HARDWARE)
=>
(assert (Consejo Ingeniería_de_Computadores "texto"))
(printout t "INGENIERIA DE COMPUTADORES" crlf)
)

(defrule veredicto_ic_4
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(or (Futuro_trabajo PUBLICA) (Futuro_trabajo DOCENCIA) (Futuro_trabajo NO))
(Preferencia_hw_sw HARDWARE)
=>
(assert (Consejo Ingeniería_de_Computadores "texto"))
(printout t "INGENIERIA DE COMPUTADORES" crlf)
)

(defrule veredicto_tic_1
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo PUBLICA) 
=>
(assert (Consejo Tecnologías_de_la_Información "texto"))
(printout t "TECNOLOGIAS DE LA INFORMACION Y COMUNICACION" crlf)
)

(defrule veredicto_tic_2
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
(Preferencia_doble_grado ADE) 
=>
(assert (Consejo Tecnologías_de_la_Información "texto"))
(printout t "TECNOLOGIAS DE LA INFORMACION Y COMUNICACION" crlf)
)

(defrule veredicto_tic_3
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
(Preferencia_doble_grado NINGUNO) 
(Es_trabajador NO)
=>
(assert (Consejo Tecnologías_de_la_Información "texto"))
(printout t "TECNOLOGIAS DE LA INFORMACION Y COMUNICACION" crlf)
)

(defrule veredicto_tic_4
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media BAJA)
=>
(assert (Consejo Tecnologías_de_la_Información "texto"))
(printout t "TECNOLOGIAS DE LA INFORMACION Y COMUNICACION" crlf)
)


(defrule veredicto_is_1
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
(Preferencia_doble_grado NINGUNO) 
(Es_trabajador SI)
=>
(assert (Consejo Ingeniería_del_Software "texto"))
(printout t "INGENIERIA DEL SOFTWARE" crlf)
)

(defrule veredicto_is_2
(Prefiere TEORICAS)
(Nota_media MEDIA)
(Preferencia_hw_sw SOFTWARE)
=>
(assert (Consejo Ingeniería_del_Software "texto"))
(printout t "INGENIERIA DEL SOFTWARE" crlf)
)

(defrule veredicto_is_3
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media MEDIA)
(Preferencia_hw_sw SOFTWARE)
=>
(assert (Consejo Ingeniería_del_Software "texto"))
(printout t "INGENIERIA DEL SOFTWARE" crlf)
)

(defrule veredicto_is_4
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(or (Futuro_trabajo PUBLICA) (Futuro_trabajo DOCENCIA) (Futuro_trabajo NS))
(Preferencia_hw_sw SOFTWARE)
=>
(assert (Consejo Ingeniería_del_Software "texto"))
(printout t "INGENIERIA DEL SOFTWARE" crlf)
)

(defrule veredicto_csi_1
(Prefiere TEORICAS)
(Nota_media BAJA)
(Futuro_trabajo NS) 
(Preferencia_doble_grado MATES) 
=>
(assert (Consejo Computación_y_Sistemas_Inteligentes "texto"))
(printout t "COMPUTACION Y SISTEMAS INTELIGENTES" crlf)
)

(defrule veredicto_si_1
(Prefiere PRACTICAS)
(Es_trabajador SI)
=>
(assert (Consejo Sistemas_de_Información "texto"))
(printout t "SISTEMAS DE LA INFORMACIÓN" crlf)
)

(defrule veredicto_si_2
(Prefiere PRACTICAS)
(Es_trabajador NO)
(Nota_media ALTA)
=>
(assert (Consejo Sistemas_de_Información "texto"))
(printout t "SISTEMAS DE LA INFORMACIÓN" crlf)
)

(defrule veredicto_si_3
(Prefiere NO)
(Preferencia_doble_grado ADE) 
(Futuro_trabajo PRIVADA)
=>
(assert (Consejo Sistemas_de_Información "texto"))
(printout t "SISTEMAS DE LA INFORMACIÓN" crlf)
)











