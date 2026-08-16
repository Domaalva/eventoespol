# Instrucciones — Frontend base (Flutter)

Este paquete es el "esqueleto" del frontend: la app ya compila y navega
entre las 3 pantallas, pero Eventos, Inscripciones y Notificaciones son
placeholders vacíos, cada uno con un `TODO` a nombre de quien debe
completarlo.

## Qué hacer

1. Descomprime esto dentro de la carpeta `frontend/` de tu repositorio
   (junto a la carpeta `app/` del backend).
2. Súbelo como el primer commit del frontend: `git add .`,
   `git commit -m "Estructura base del frontend Flutter"`, `git push`.
3. Comparte con Henry y Enrique los paquetes `henry-eventos-frontend.zip` y
   `enrique-notificaciones-frontend.zip`. Cada uno reemplaza SUS DOS archivos
   (el `_viewmodel.dart` y el `_screen.dart` de su módulo) y hace su propio
   commit desde su propia cuenta.
4. Tú (Domenika) haces lo mismo con `domenika-inscripciones-frontend.zip`,
   como un commit separado y propio.

## Resultado esperado en el historial de GitHub (frontend)

- Commit 1 (quien arma el repo): "Estructura base del frontend Flutter"
- Commit 2 (Henry): "Implementa pantalla de Eventos en Flutter"
- Commit 3 (Domenika): "Implementa pantalla de Inscripciones en Flutter"
- Commit 4 (Enrique): "Implementa pantalla de Notificaciones en Flutter"

## IMPORTANTE antes de correr la app

Abre `lib/services/api_service.dart` y revisa la línea:

```dart
static const String baseUrl = "http://127.0.0.1:8000";
```

Si tu backend corre en un Codespace, reemplaza esa URL por la URL pública
que Codespaces te da para el puerto 8000 (algo como
`https://tu-codespace-8000.app.github.dev`), o la app no podrá conectarse.
