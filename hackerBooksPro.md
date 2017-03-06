#HackerBooksLite

## Nuevo Foundation

Por lo visto, han creado un nuevo Foundation que cambia las antiguas clases por structs sin el NS. 

VER EL VIDEO Y EL CÓDIGO

## Errores y Opcionales

Cada vez que llamas a un método de Foundation que puede devolver un nil, tenemos dos rutas en el código:
* con nil
* sin nil

En Objective-C era muy fácil ignorar la ruta de nil cuando era tan improbable que no hacía falta tenerla en cuenta.

Aquí la cosa no es tan sencilla, ya que si lo ignoras, te se llena el código de !, cosa que no recomiendo.

Si no lo ignoras, toca lanzar un error, lo cual también es viral: todas las funciones llamantes tendrán que gestionar el error.

HAY QUE BUSCAR UNA SOLUCIÓN.
VER EN EL CÓDIGO DE SWIFT CÓMO LO HACEN EN APPLE

## Inicializador Señorito

En el nuevo Foundation, algunos de los inits que antes devolvían nil para indicar error, ahora lanzan un error.

Por si fuera poco, hay init?. Esto es un caos. Hay que escribir a la lista para ver qué coño es lo recomendado.

Hay que reconsiderar el init señorito.





