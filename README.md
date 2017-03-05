#KeepCoding IV Edición - KeepCoding Master Bootcampo - Programación iOS Avanzada - Práctica HackerBooks Pro

**Lo descrito anteriormente se encuentra en la rama #master** 

**Voy  continuar con el resto de puntos en una rama diferente**

--
Funcionalidad requerida
- [X] Persistencia con Core Data
- [X] Gestión sobre iPhone (o iPad)
- [X] Descarga asíncrona de JSON, imágenes y PDF
- [X] Gestión favoritos y pdf’s (Fundamentos iOS)
- [X] Guardado el último libro abierto
- [X] Secciones en la tabla mediante los Tag
- [X] Incorporación de anotaciones a pdf’s, a las que se puede añadir:
  * [X] Título
  * [X] Texto
  * [X] Foto (del carrete, album o cámara -en el simulador el icono está deshabilitado al no encontrarse el dispositivo-)
- [X] Se Secciones en la tabla mediante los Tagse muestran en un map
- [X] Busqueda de libros por titulo, tag y autor
- [X] Compartir las anotaciones en al menos una red social

##Desafíos
- [X] El ultimo libro se guarda ademas en iCLoud (NSUbiquitousKeyValueStore) aparte de Userdefaults
- [X] Todas las tareas largas dentro de “background tasks”.
- [ ] Anotaciones asociadas a la página del libro. 
- [ ] Indicar cuando una página tenga una anotación disponible.
- [ ] Guardar en el modelo la última página leída y muestrar esta información en la celda del libro (como hace la App de Kindle).
- [ ] Mostrar una notificación cuando se llega al final del libro.
- [ ] Dos nuevos Tags (secciones) de (Que sea NSFetchedResultsController quién los muestre): 
 * [ ] Recent: Libros leídos recientemente (en los últimos 7 dias)
 * [ ] Finished: Libros leídos completamente.
- [ ] ¿Cómo harías para que el usuario pueda añadir “subrayados” al texto de los libros?
  * Pues como se puede realizar actualemente en iBooks, mediante un el un gesto de "Long press gesture" y detectar la posición del gesture, de esta forma se puede almacenar en BDD y poder pintar de alguna forma sobre el PDF

##Super Desafío
- [ ] Permitir la búsqueda de texto dentro del libro



