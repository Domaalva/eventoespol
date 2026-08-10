# Instrucciones — Estructura base

Este paquete contiene la estructura compartida del proyecto (la app de FastAPI,
la conexión a base de datos, los modelos y esquemas), más un **placeholder**
(borrador vacío) para cada uno de los tres módulos.

## Qué hacer con esto

1. Sube este contenido como el **primer commit** del repositorio (`git add .`,
   `git commit -m "Estructura base del proyecto"`, `git push`).
2. El proyecto YA corre en este punto (`uvicorn app.main:app --reload`), aunque
   los tres módulos todavía no hacen nada real — son solo el esqueleto.
3. Comparte con Henry y Enrique (agregándolos como colaboradores del repo) los
   paquetes `henry-eventos.zip` y `enrique-notificaciones.zip` que contienen
   SOLO su archivo final. Cada uno reemplaza su placeholder
   (`app/routers/eventos.py` o `app/routers/notificaciones.py`) por el archivo
   real, y hace su propio commit desde su propia cuenta de GitHub.
4. Tú (Domenika) haces lo mismo con tu archivo `app/routers/inscripciones.py`
   (paquete `domenika-inscripciones.zip`), como un commit separado y propio,
   igual que tus compañeros — así el historial de Git queda parejo para los tres.

## Resultado esperado en el historial de GitHub

- Commit 1 (quien arma el repo): "Estructura base del proyecto"
- Commit 2 (Henry, desde su cuenta): "Implementa endpoints de Eventos"
- Commit 3 (Domenika, desde su cuenta): "Implementa endpoints de Inscripciones"
- Commit 4 (Enrique, desde su cuenta): "Implementa endpoints de Notificaciones"

Con eso, el repositorio refleja con precisión quién implementó cada
funcionalidad, tal como lo pide la Sección 5 (Requerimientos Funcionales
Asignados) de la propuesta.
