@def rss_pubdate = Date(2018, 8, 8)
@def rss = """La anticipada liberación de la versión 1.0 de..."""
@def published = "8 August 2018"
@def title = "Julia 1.0 Anunciando el release de Julia 1.0 (Spanish)"
@def authors = "the Julia developers"  

~~~
Translations:  <a href="/blog/2018/08/one-point-zero-zh_cn/">Simplified Chinese</a>, <a href="/blog/2018/08/one-point-zero-zh_tw/">Traditional Chinese</a>, <a href="/blog/2018/08/one-point-zero-es/">Spanish</a>
~~~

La anticipada liberación de la versión 1.0 de [Julia](https://julialang.org) es la culminación de casi una década de trabajo de construir un lenguaje para programadores ambiciosos. JuliaCon2018 celebró la ocasión con un evento donde la comunidad oficialmente [lanzó conjuntamente la versión
1.0.0.](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850)

El primer comunicado [público](/blog/2012/02/why-we-created-julia) de Julia fue hecho con
número de exigencias sobre el lenguaje:

> Queremos un lenguaje que sea de código abierto, con licencia liberal. Queremos la velocidad de C
> con el dinamismo de Ruby. Queremos un lenguaje que sea homoicónico, con macros verdaderos tipo Lisp,
> pero con notación matemática, obvia y familiar como Matlab. Queremos algo usable
> para programación general como Python, tan fácil para estadística como R, tan natural para procesamiento
> de cadenas como Perl, tan potente para álgebra lineal como Matlab, tan bueno uniendo programas juntos como
> un shell. Algo que sea sumamente sencillo de aprender, pero que mantenga a los hackers más serios
> felices. Queremos que sea interactivo y que sea compilado.

Una comunidad vibrante y fructífera ha crecido alrededor de este lenguaje, con gente de
todo el mundo iterativamente refinando y reformulado Julia para cumplir su meta. Más de 700
personas han contribuido a Julia en sí y aún más gente han hecho miles de asombrosos paquetes de código abierto. En resumen, hemos construido un lenguaje que es:

* **Rápido**: Julia fue diseñado desde el principio para tener alto rendimiento. Los programas de Julia se compilan a código nativo eficiente para muchas plataformas por medio de LLVM.
* **General**: Usa despacho múltiple como paradigma, facilitando expresar muchos patrones de
la programación orientada a objetos ó programación funcional. La biblioteca estándar provee
I/O asíncrono, control de procesos, logging, perfiles, un administrador de paquetes y más.
* **Técnico**: Sobresale en cómputo numérico con una sintaxis excelente para las matemáticas, amplio soporte para muchos tipos de datos, y pararelismo incluido por default. Su despacho múltiple es un embone natural para definir tipos de datos numéricos y de arreglos.
* **Opcionalmente tipado**: Julia tiene un lenguaje rico para describir tipos de datos, y la declaración de tipos puede ser usada para clarificar y solidificar programas.
* **Componible**: Los paquetes de Julia se pueden simultáneamente sin dificultad. Matrices de cantidades unitarias, ó datos de columnas tabuladas de divisas y colores -- todo funciona -- y a buena velocidad.

Prueba Julia bajando la [versión 1.0 ahora](https://julialang.org/downloads/). Si estás actualizando código de Julia 0.6 o versiones anteriores, te recomendamos que primero uses la versión 0.7 como transición.
Una vez que tu código esté libre de advertencias (*warnings*), puedes cambiarlo a 1.0 sin ninguna pérdida de funcionalidad. Los paquetes registrados están aprovechando esta etapa de transición y liberando sus actualizaciones compatibles con 1.0.

La ventaja más importante de Julia 1.0 es, por supuesto, es un compromiso de estabilidad de API: El código que escribes para Julia 1.0 seguirá funcionando en 1.1, 1.2, etc. El lenguaje está "completo".
Los desarrolladores principales y la comunidad pueden enfocarse en la paquetería, herramientas, y nuevas funcionalidades construidas sobre una base sólida.

Sin embargo, Julia 1.0 no es solamente sobre estabilidad, también introduce nuevas y poderosas innovaciones del lenguaje.
Algunas de estas novedades desde la versión 0.6 incluyen:

* Un nuevo e incluido [administrador de paquetes](https://docs.julialang.org/en/latest/stdlib/Pkg/) trae enormes mejoras de rendimiento y facilita más que nunca la instalación de paquetes y sus dependencias. También soporta ambientes particulares para cada proyecto y registros de estado exactos para una aplicación para poderla compartir con los demás - y tu futuro yo. Finalmente, el rediseño también introduce  soporte integrado para paquetes privados y repositorios. Tú puedes instalar y administrar paqueterías  privadas con las mismas herramientas que el ecosistema de paquetería abierta. La [presentación de JuliaCon](https://www.youtube.com/watch?v=GBi__3nF-rM) resume el nuevo diseño y capacidades.
* Julia tiene una nueva [representación canónica para valores faltantes](/blog/2018/06/missing). Poder representar y trabajar con datos faltantes es fundamental para estadísticas y ciencias de datos. En estilo Juliano,  la nueva solución es general, componible y rápida. Cualquier colección general puede eficientemente  soportar valores faltantes simplemente al permitir que elementos incluyan el valor predefinido `missing`. El rendimiento de dadas colecciones "tipadas como uniones" hubieran sido demasiado lento en versiones anteriores  de Julia, pero mejoras en el compilador permiten ahora que en Julia sea comparable a la velocidad de valores faltantes en C ó C++ en otros sistemas, mientras que sigue siendo mucho más general y flexible.
* El tipo `String` ahora puede contener datos arbitrarios. Tu programa no fallará después de horas ó días porque  un solo byte de Unicode era inválido. Todos los datos de cadenas de caracteres son preservados mientras que se indica cuáles caracteres son válidos o inválidos, permitiendo que sus aplicaciones sean conveniente y seguramente usadas en datos reales con todas sus  inevitables complicaciones.
* "Broadcasting" ya es una ventaja clave con sintaxis conveniente -- y ahora es más poderosa que nunca. En Julia 1.0 es fácil [extender broadcasting a tipos del usuario](/blog/2018/05/extensible-broadcast-fusion) e implementarlo  en cálculos optimizados para GPUs y hardware vectorizado, pavimentando el camino para aún más mejoras en el futuro.
* Las tuplas con nombre son rasgo nuevo que permite representar y accesar datos por nombre y de manera eficiente. Puedes, por ejemplo,  representar una hilera de datos como `row =
  (name="Julia", version=v"1.0.0", releases=8)` y accesar su columna `version` como
  `row.version` con la misma velocidad que el inconveniente `row[2]`.
* El operador punto ahora puede ser sobrecargado, permitiendo así que tipos usen la sintaxis `obj.propiedad` para  comportamientos que no sea accesar o fijar campos de structs. Esto es especialmente útil para facilitar  la interoperabilidad con lenguajes basados en clases como Python y Java. Esto también permite sobrecargar la  sintaxis para obtener una columna de datos y que empate con la de tuplas nombradas: puedes escribir  `tabla.versión` para accesar la columna `versión` de una tabla ó `row.versión` accesa el campo  `versión` de una sola hilera.
* El optimizador de Julia se ha vuelto mucho más listo en demasiadas maneras como para aquí enlistarlas, pero  algunas de ellas vale la pena mencionar. El optimizador ahora nos permite propagar constantes a través de llamadas  a funciones, permitiendo mucha mejor eliminación de código muerto y evaluación estática que antes. El compilador  ahora también es mucho mejor evitando alocaciones de *wrappers* efímeros alrededor de objetos longevos, permitiendo a los programadores a usar abstracciones de alto nivel sin costo de rendimiento.
* Los constructores de tipos paramétricos ahora se llaman con la misma sintaxis con la que se declaran. Esto  elimina una barrera rebuscada pero confusa de sintaxis.
* El protocolo de iteración ha sido completamente rediseñado para facilitar implementar muchos tipos de iterables. En vez de —`start`, `next`, `done`—uno ahora define métodos de uno y dos argumentos para la función `iterate`. Esto frecuentemente permite que la iteración se defina con un sólo método y un valor por default para el estado inicial. Aunado a lo anterior, es posible implementar iteradores que solo saben si han terminado  una vez que han intentado y fallado en producir un valor -- justo el tipo de iteradores que son ubicuos en I/O, producidores/consumidores, etc. Julia puede expresar estos iteradores directa y correctamente.
* Las reglas de alcance han sido simplificadas. Las construcciones que introducen alcances locales ahora lo hacen de manera consistente, sin importar los enlaces globales para nombre preexistentes o no. Esto elimina la distinción de alcances "duros/suaves" que previamente existía y significa que Julia siempre puede determinar estáticamente si variables son locales o globales.
* El lenguaje en sí es significativamente más esbelto, con muchos componentes siendo escindidos a paquetes en la "biblioteca estándar" que es liberada con Julia pero que no es parte del lenguaje "base". Si los necesitas, solo necesitas importar (sin instalar) pero no estarás coaccionada a hacerlo. En el futuro, esto permitirá que las bibliotecas estándar sean versionadas y actualizadas independientemente de Julia, permitiendo que evolucionen y se mejoren más rápido.
* Hemos revisado extensamente todas las APIs de Julia para mejorar la consistencia y usabilidad. Muchos nombres tradicionales rebuscados y patrones ineficientes han sido renombrados o refactorizados para empatar elegantemente con las capacidades de Julia. Esto ha promovido cambios para trabajar con colecciones de manera más consistente y coherente, y asegurar que el orden de los argumentos sea un estándar consistente a lo largo del lenguaje, y para incorporar los (ahora más rápidos) argumentos "keyword" en las APIs apropiadas.
* Un gran número de paquetería externa ha sido específicamente construida alrededor de las ventajas de Julia 1.0, tales como:
  * El ecosistema de procesamiento y manipulación de manejo de datos fue reorganizado alrededor de los valores faltantes.
  * [Cassette.jl](https://github.com/jrevels/Cassette.jl) provee un poderoso mecanismo para inyectar pases de transformación de código al compilador de Julia, permitiendo análisis post-hoc y extensión de código existente. Además de la instrumentación para programadores como un debugger y un profiler, esto también puede implementar diferenciación automática para tareas de *machine learning*.
  * Se ha incrementado enormemente el soporte para arquitecturas heterogéneas y se ha desacoplado aún más del funcionamiento interno del compilador. Los Intel KNLs funcionan en Julia. Los GPUs de Nvidia son programados usando [CUDANative.jl](https://github.com/JuliaGPU/CUDAnative.jl) y un port para los TPUs de Google está siendo desarrollado.


Éstas son solo algunas de las mejoras. Para una lista completa de los cambios, lee el archivo [0.7 NEWS](https://docs.julialang.org/en/release-0.7/NEWS/). En el post
original [“Why We Created Julia” blog post](/blog/2012/02/why-we-created-julia) en 2012, escribimos

> No está completo, pero es tiempo de liberar la versión 1.0 del lenguaje que creamos llamado
> [Julia](https://julialang.org).

Tal vez nos adelantamos un poco con la versión 1.0, pero el tiempo finalmente ha llegado y es un release fantástico.
Estamos verdaderamente orgullosos de lo que hemos logrado con los miles de programadores que han contribuido en tantas maneras a este lenguaje
verdaderamente moderno para programación general y numérica.
