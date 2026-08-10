# EventoESPOL — Backend

Backend del proyecto de Lenguajes de Programación (2026): una plataforma para
organizar y gestionar eventos universitarios de la ESPOL.

- **Lenguaje / Framework:** Python 3.10+ con FastAPI
- **Patrón de arquitectura:** MVC (Model-View-Controller)
- **Base de datos:** SQLite (vía SQLAlchemy)

## Integrantes y módulos

| Integrante | Módulo | Endpoints |
|---|---|---|
| Henry Olvera | Eventos | `POST /eventos`, `GET /eventos` |
| Domenika Arboleda | Inscripciones | `POST /inscripciones`, `GET /inscripciones/{usuario}` |
| Enrique Rosado | Notificaciones | `POST /notificaciones`, `GET /notificaciones/{usuario}` |

## Cómo ejecutar el proyecto

1. Crear un entorno virtual (opcional pero recomendado):
   ```bash
   python3 -m venv venv
   source venv/bin/activate      # En Windows: venv\Scripts\activate
   ```

2. Instalar las dependencias:
   ```bash
   pip install -r requirements.txt
   ```

3. Levantar el servidor:
   ```bash
   uvicorn app.main:app --reload
   ```

4. Abrir en el navegador la documentación interactiva (Swagger UI):
   ```
   http://127.0.0.1:8000/docs
   ```
   Desde ahí se pueden probar todos los endpoints directamente.

## Estructura del proyecto

```
eventoespol-backend/
├── app/
│   ├── main.py           # Punto de entrada de la aplicación FastAPI
│   ├── database.py       # Configuración de la base de datos (SQLAlchemy)
│   ├── models.py         # Modelos de la base de datos (Evento, Inscripcion, Notificacion)
│   ├── schemas.py        # Esquemas Pydantic (validación de datos de entrada/salida)
│   └── routers/
│       ├── eventos.py         # Endpoints de Henry Olvera
│       ├── inscripciones.py   # Endpoints de Domenika Arboleda
│       └── notificaciones.py  # Endpoints de Enrique Rosado
├── requirements.txt
├── .gitignore
└── README.md
```
