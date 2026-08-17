# Instrucciones para ti (Domenika Arboleda) — Frontend Inscripciones

Estos 2 archivos implementan tu pantalla de Inscripciones en Flutter:

- `inscripciones_viewmodel.dart` → va en `lib/viewmodels/`
- `inscripciones_screen.dart` → va en `lib/views/`

## Qué hacer

Igual que tus compañeros, como un commit separado del commit de la
estructura base:

1. En tu Codespace, ve a
   `frontend/eventoespol_app/lib/viewmodels/inscripciones_viewmodel.dart`,
   reemplaza su contenido por este archivo.
2. Ve a `frontend/eventoespol_app/lib/views/inscripciones_screen.dart`,
   reemplaza su contenido por este archivo.
3. Guarda ambos.
4. En la terminal, dentro de `frontend/eventoespol_app/`:
   ```bash
   git add lib/viewmodels/inscripciones_viewmodel.dart lib/views/inscripciones_screen.dart
   git commit -m "Implementa pantalla de Inscripciones en Flutter"
   git push
   ```

## Cómo probar tu pantalla

Con el backend corriendo y `flutter run` en la carpeta del frontend, tu
pantalla es la segunda pestaña ("Inscripciones"). El botón "+" abre un
formulario para elegir un evento (necesitas que Henry ya haya creado al
menos uno, o créalo tú de prueba desde `/docs` del backend) y confirmar la
inscripción — el backend valida automáticamente que haya cupo disponible.
