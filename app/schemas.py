from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional


# ---------- Eventos (Henry Olvera) ----------
class EventoCreate(BaseModel):
    titulo: str
    descripcion: Optional[str] = None
    fecha: str = Field(..., description="Fecha del evento en formato YYYY-MM-DD")
    ubicacion: str
    categoria: str
    cupo_maximo: int


class EventoOut(BaseModel):
    id: int
    titulo: str
    descripcion: Optional[str]
    fecha: str
    ubicacion: str
    categoria: str
    cupo_maximo: int
    cupo_disponible: int

    class Config:
        from_attributes = True


# ---------- Inscripciones (Domenika Arboleda) ----------
class InscripcionCreate(BaseModel):
    evento_id: int
    usuario: str


class InscripcionOut(BaseModel):
    id: int
    evento_id: int
    usuario: str
    estado: str
    fecha_inscripcion: datetime

    class Config:
        from_attributes = True


# ---------- Notificaciones (Enrique Rosado) ----------
class NotificacionCreate(BaseModel):
    usuario: str
    mensaje: str
    tipo: str = "info"


class NotificacionOut(BaseModel):
    id: int
    usuario: str
    mensaje: str
    tipo: str
    fecha: datetime
    leido: int

    class Config:
        from_attributes = True
