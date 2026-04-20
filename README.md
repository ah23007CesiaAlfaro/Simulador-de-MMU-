 Simulador de Gestión de Memoria (MMU)
Descripción
Este proyecto consiste en una simulación de gestión de memoria virtual desarrollada en PSeInt. El programa implementa los componentes fundamentales de una unidad de gestión de memoria (MMU), incluyendo la traducción de direcciones físicas, la visualización del mapa de bits de la RAM y la comparación de rendimiento entre los algoritmos de reemplazo de páginas FIFO (First-In, First-Out) y OPT (Óptimo).
Instrucciones de Ejecución
Para ejecutar el simulador, siga estos pasos:
1.	Software Requerido: Asegúrese de tener instalado Pseint.
2.	Configuración del Entorno:
·	Abra PSeInt.
·	Vaya a Configurar > Opciones del Lenguaje (perfiles).
·	Seleccione un perfil "Flexible" o el estándar por defecto.
·	Verifica  tener habilitada la función “utilizar indices en arreglos y cadenas en base 0”(Configurar >Personalizar>habilitar>guardar)
3.	Ejecución:
·	Abra el archivo SimuladorMMU_cma.psc en PSeInt.
·	Presione el botón verde "Ejecutar" (F9).
·	El programa desplegará automáticamente las Fases 1 a 4 en la consola y mostrará el cuadro comparativo de fallos de página al finalizar.
Análisis de Rendimiento.
Tras ejecutar la simulación con la secuencia de referencia proporcionada, se obtuvieron los siguientes resultados:
·	Fallos FIFO: 9
·	Fallos OPT: 7
¿Por qué el algoritmo Óptimo (OPT) tuvo mejor rendimiento?
La diferencia de rendimiento radica en la "visibilidad" de cada algoritmo sobre la secuencia de referencias futuras:
·	FIFO (First-In, First-Out): Es un algoritmo "ciego". Reemplaza la página que lleva más tiempo en memoria, independientemente de si esa página será utilizada inmediatamente después o no. Esto causa que, a menudo, se expulsen páginas que son necesarias en el corto plazo, aumentando los fallos innecesariamente.
·	OPT (Óptimo): Este algoritmo posee capacidad de "previsión". Al producirse un fallo, busca en la secuencia de referencias futuras y selecciona como víctima para el reemplazo a la página que tardará más tiempo en volver a ser utilizada. Al eliminar la página "menos útil" a futuro, maximiza la tasa de aciertos y, por ende, minimiza el número de fallos.
Justificación de las Limitaciones de OPT

Aunque el algoritmo OPT es matemáticamente superior (como lo demuestran los resultados obtenidos), su implementación en sistemas operativos reales es teóricamente imposible por las siguientes razones:
1.	Falta de Conocimiento del Futuro: Los sistemas operativos no pueden predecir exactamente qué páginas solicitará un proceso en el futuro, ya que esto depende de la interacción del usuario y de la lógica dinámica del software.

2.	Costo Computacional: Incluso si se intentara predecir el futuro, el costo de calcular la distancia de cada página en la memoria contra una secuencia futura sería prohibitivo para un sistema operativo que necesita procesar instrucciones en microsegundos.
Conclusión: 
En este proyecto se desarrolló una herramienta de simulación funcional capaz de emular los procesos de gestión de memoria virtual y reemplazo de páginas. Tras comparar los algoritmos FIFO y OPT, se concluye que el rendimiento de OPT es superior, logrando una reducción significativa en los fallos de página. Se justifica esta diferencia debido a la capacidad de OPT para seleccionar la víctima óptima basada en el futuro de la secuencia. No obstante, se reconoce que en entornos de producción reales, la implementación de tales algoritmos está limitada por la imposibilidad de predecir el comportamiento del usuario o de los procesos, consolidando al modelo OPT como la referencia base (benchmark) para el diseño de futuros sistemas de gestión de memoria.
