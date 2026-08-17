# EventoESPOL

Plataforma web y móvil para organizar y gestionar eventos universitarios de
la ESPOL. Proyecto final de la asignatura Lenguajes de Programación (2026).

## Integrantes

| Integrante | Módulo | Backend | Frontend |
|---|---|---|---|
| Henry Olvera | Eventos | `app/routers/eventos.py` | `frontend/eventoespol_app/lib/views/eventos_screen.dart` |
| Domenika Arboleda | Inscripciones | `app/routers/inscripciones.py` | `frontend/eventoespol_app/lib/views/inscripciones_screen.dart` |
| Enrique Rosado | Notificaciones | `app/routers/notificaciones.py` | `frontend/eventoespol_app/lib/views/notificaciones_screen.dart` |

## Estructura del proyecto

```
eventoespol/
├── app/                        # Backend (Python / FastAPI)
│   ├── main.py
│   ├── database.py
│   ├── models.py
│   ├── schemas.py
│   └── routers/
│       ├── eventos.py
│       ├── inscripciones.py
│       └── notificaciones.py
├── requirements.txt             # Dependencias del backend
├── frontend/
│   └── eventoespol_app/         # Frontend (Dart / Flutter)
│       ├── lib/
│       │   ├── main.dart
│       │   ├── theme.dart
│       │   ├── models/
│       │   ├── services/
│       │   ├── viewmodels/
│       │   └── views/
│       └── pubspec.yaml         # Dependencias del frontend
└── README.md
```

## Requisitos y versiones

**Backend**
- Python 3.10 o superior
- FastAPI >= 0.110
- Uvicorn >= 0.29
- SQLAlchemy >= 2.0
- Pydantic >= 2.6
- Base de datos: SQLite (no requiere instalación aparte)

**Frontend**
- Flutter SDK (canal `stable`, versión 3.19 o superior) — incluye Dart
- Paquetes: `provider`, `http`, `intl`, `cupertino_icons` (ver
  `frontend/eventoespol_app/pubspec.yaml` para versiones exactas)

## Cómo probar el backend

1. Instalar las dependencias (desde la raíz del proyecto):
   ```bash
   pip install -r requirements.txt
   ```

2. Levantar el servidor:
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0
   ```
   Si el comando `uvicorn` no se reconoce, usar:
   ```bash
   python3 -m uvicorn app.main:app --reload --host 0.0.0.0
   ```

3. Abrir la documentación interactiva (Swagger UI) en el navegador:
   ```
   http://127.0.0.1:8000/docs
   ```
   Desde ahí se pueden probar todos los endpoints (crear eventos,
   inscribirse, generar notificaciones, etc.) sin necesidad de herramientas
   adicionales como Postman.

## Cómo probar el frontend

1. Instalar el SDK de Flutter (si no lo tienes):
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable --depth 1
   export PATH="$PATH:$(pwd)/flutter/bin"
   ```

2. Instalar las dependencias del proyecto:
   ```bash
   cd frontend/eventoespol_app
   flutter pub get
   ```

3. Configurar la URL del backend: abrir
   `lib/services/api_service.dart` y verificar que `baseUrl` apunte al
   backend que se está usando (por defecto `http://127.0.0.1:8000` para uso
   local; si el backend corre en un Codespace, usar la URL pública que
   Codespaces asigna al puerto 8000).

4. Correr la app (como página web, la forma más simple de probarla sin
   emulador):
   ```bash
   flutter run -d web-server --web-port 5000
   ```
   Y abrir `http://127.0.0.1:5000` (o la URL pública equivalente) en el
   navegador.

   Alternativamente, con un dispositivo o emulador Android/iOS conectado:
   ```bash
   flutter run
   ```

**Nota sobre CORS:** el backend incluye `CORSMiddleware` configurado para
aceptar peticiones desde cualquier origen (`allow_origins=["*"]`), necesario
para que el frontend (servido en un puerto/dominio distinto) pueda
comunicarse con la API sin ser bloqueado por el navegador.

## Arquitectura

- **Backend:** patrón MVC — los routers exponen los endpoints REST, los
  modelos (SQLAlchemy) representan las entidades (Evento, Inscripción,
  Notificación), y los esquemas (Pydantic) validan los datos de entrada y
  salida.
- **Frontend:** patrón MVVM — las vistas (Flutter widgets) se comunican con
  ViewModels (`ChangeNotifier` + `Provider`) que gestionan el estado y
  consumen la API a través de un servicio HTTP compartido
  (`api_service.dart`).

## Funcionalidades por estado

Ver la sección "Implementación" del informe del proyecto para el detalle de
qué funcionalidades están completas y cuáles quedan pendientes por
integrante.
