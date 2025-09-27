# Bitácora de Desarrollo - BusCEMinas
### Nota:
Esta bitácora documenta exclusivamente las tareas y avances realizados directamente sobre el repositorio del proyecto. No se registran actividades meta, como hacer la bitácora en sí misma o documentar fuentes externas; el enfoque es sobre cambios, implementaciones, refactorización, arreglos, limpieza, pruebas y documentación interna del propio proyecto.

---

## Sábado 20 de Septiembre, 2025 
Se realizó la reunión inicial del equipo, donde se analizaron los objetivos por alcanzar. Se revisó el enunciado de la tarea y se discutió la importancia de reforzar los conocimientos en programación funcional, recursividad y estructuras de datos mediante la implementación del juego Buscaminas.

Durante esta reunión también se dividieron las subtareas entre los integrantes: investigación de la lógica del juego, diseño de estructuras de datos en Racket, manejo de listas y modelado de funciones recursivas. Además, se acordó explorar las bibliotecas disponibles para construir la interfaz gráfica.

El equipo concluyó que la primera meta será implementar un tablero de prueba para poder validar la estructura de datos, se establecieron las carpetas principales y la estructura inicial de archivos para organizar el código de manera escalable.

## Lunes 22 de Septiembre, 2025

Investigación e implementación de la estructura base del proyecto, incluyendo componentes principales, carpetas de assets, y configuración inicial de dependencias y utilidades.

Se comienza con el desarrollo del tablero basico de ceros. El cual se establece como una matriz de un tamaño filas x columnas las cuales deben de ser dadas por el usuario en tiempo de ejecución. La matriz como tal se establece como una lista de listas y se crea una funcion de impresion de la misma para poder visualizarla de una manera más sencilla además de realizar las pruebas necesarias para probar su funcionamiento correcto.

## Martes 23 de Septiembre, 2025

Entre ambos compañeros del equipo se discute sobre la mejor manera de manejar la logica del juego. Se establece que inicialmente se trabará creando las funciones de posicionamiento de bombas la cual requiere la verificación de las celdas disponibles en la matriz y recorrer matrices segun un indice. Posteriormente se establece que se trabajrá con el posicionamiento random de las bombas para la dinamica de reinicio de juego y la cantidad de bombas que se deberá colocar según la dificultad que establezca como entrada el usuario. 

Una vez terminada la parte de posicionamiento de las bombas de manera correcta en la matriz se deberá pasar al posicionamiento de los numeros respecto a las minas que tengan adyacentes utilizando las 8 posibles combinaciones a las celdas que respectan. 

## Miercoles 24 de Septiembre, 2025

Desarrollo de interfaz grafica

Definicion de funciones base

## Jueves 25 de Septiembre, 2025

Se finalizan las funciones de posicionamiento de bombas y se combina con el trabajo del calculo de relleno de numeros adyactentes de la matriz apartir de las posiciones de las minas. 

Una vez finalizada la parte de logica del juego como tal se establece la conexión con la interfaz grafica además de configuración de la navegación dentro de la aplicación. Se definieron rutas y pantallas principales, asegurando una transición coherente entre vistas.

Se choca con el error del click derecho para colocar banderas, se establece en vez de error más como limitacion de libreria utilizada por una falta de  soporte nativo sencillo y consistente para distinguir botones del mouse en todas las plataformas. Se decidió en su lugar utilizar un toggle button para alternar entre revelar celdas y colocar banderas.

## Viernes 26 de Septiembre, 2025

Pruebas, correcciones y revision final. Se realizó un cleanup del código, agregando comentarios para mayor claridad, organizando el código en módulos, eliminando funciones y archivos innecesarios, y ajustando la interfaz para que sea más clara y ordenada.

## Sabado 27 de Septiembre, 2025

Ultimas modificaciones. Se realizaron pruebas de las funcionalidades y se completó la documentación interna, asegurando que los componentes y funciones principales estén claros y sean fáciles de entender.