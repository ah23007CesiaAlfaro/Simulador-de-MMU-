# Simulador de Gestión de Memoria (MMU)

Este proyecto es una simulación de gestión de memoria virtual desarrollada en **PSeInt**. El programa implementa los componentes fundamentales de una Unidad de Gestión de Memoria (MMU), permitiendo visualizar la traducción de direcciones físicas, el mapa de bits de la RAM y comparar el rendimiento entre algoritmos de reemplazo de páginas.

##  Descripción
El simulador permite evaluar y contrastar dos algoritmos clásicos de reemplazo de páginas:
* **FIFO (First-In, First-Out):** Reemplaza la página que lleva más tiempo en memoria.
* **OPT (Óptimo):** Selecciona como víctima la página que no será utilizada por el periodo de tiempo más largo en el futuro.

##  Instrucciones de Ejecución

### Requisitos previos
* [PSeInt](http://pseint.sourceforge.net/) instalado.

### Configuración del Entorno
Para que el simulador funcione correctamente, es necesario ajustar la configuración de PSeInt:

1.  Abra PSeInt.
2.  Vaya a **Configurar > Opciones del Lenguaje (perfiles)**.
3.  Seleccione un perfil **"Flexible"** o el estándar por defecto.
4.  **Importante:** Verifique tener habilitada la función **“utilizar indices en arreglos y cadenas en base 0”** (Configurar > Personalizar > Habilitar > Guardar).

### Ejecución
1.  Abra el archivo `SimuladorMMU_cma.psc` en PSeInt.
2.  Presione el botón verde **"Ejecutar" (F9)**.
3.  El programa desplegará automáticamente las Fases 1 a 4 en la consola y mostrará el cuadro comparativo de fallos de página al finalizar.

## 📊 Análisis de Rendimiento

Tras ejecutar la simulación con la secuencia de referencia proporcionada, se obtuvieron los siguientes resultados:

| Algoritmo | Fallos de Página |
| :--- | :---: |
| **FIFO** | 9 |
| **OPT** | 7 |

### ¿Por qué el algoritmo Óptimo (OPT) tuvo mejor rendimiento?
La diferencia radica en la "visibilidad" sobre la secuencia de referencias futuras:

* **FIFO (First-In, First-Out):** Es un algoritmo "ciego". Reemplaza la página que lleva más tiempo en memoria, independientemente de si será necesaria inmediatamente después. Esto provoca a menudo la expulsión de páginas críticas a corto plazo.
* **OPT (Óptimo):** Posee capacidad de "previsión". Al producirse un fallo, analiza las referencias futuras y selecciona como víctima a la página que tardará más tiempo en volver a ser utilizada. Al eliminar la página "menos útil" a futuro, maximiza la tasa de aciertos.

## Limitaciones del Algoritmo OPT
Aunque el algoritmo OPT es matemáticamente superior (como lo demuestran los resultados), su implementación en sistemas operativos reales es **teóricamente imposible** debido a:

1.  **Falta de Conocimiento del Futuro:** Los SO no pueden predecir exactamente qué páginas solicitará un proceso, ya que depende de la interacción del usuario y la lógica dinámica.
2.  **Costo Computacional:** Calcular la distancia de cada página contra una secuencia futura sería prohibitivo para un sistema que requiere respuestas en microsegundos.

El modelo OPT sirve principalmente como **benchmark** (referencia) para el diseño de futuros sistemas de gestión de memoria.

## Conclusión
Se desarrolló una herramienta de simulación funcional capaz de emular los procesos de gestión de memoria virtual. Se concluye que el rendimiento de OPT es superior, logrando una reducción significativa en los fallos de página al optimizar la selección de la víctima. No obstante, se reconoce que su aplicación está limitada a entornos de investigación y evaluación teórica.

---
*Proyecto desarrollado con fines académicos.*
