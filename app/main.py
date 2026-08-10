from fastapi import FastAPI

from . import models
from .database import engine
from .routers import eventos, inscripciones, notificaciones

models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="EventoESPOL API",
    description="Backend del proyecto de Lenguajes de Programación - Organización de eventos ESPOL",
    version="0.1.0",
)

app.include_router(eventos.router)
app.include_router(inscripciones.router)
app.include_router(notificaciones.router)


@app.get("/", tags=["Health"])
def root():
    return {"status": "ok", "app": "EventoESPOL API"}
