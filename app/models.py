from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

from .database import Base


class Evento(Base):
    __tablename__ = "eventos"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    descripcion = Column(String, nullable=True)
    fecha = Column(String, nullable=False)  # ISO date string
    ubicacion = Column(String, nullable=False)
    categoria = Column(String, nullable=False)
    cupo_maximo = Column(Integer, nullable=False)

    inscripciones = relationship("Inscripcion", back_populates="evento")


class Inscripcion(Base):
    __tablename__ = "inscripciones"

    id = Column(Integer, primary_key=True, index=True)
    evento_id = Column(Integer, ForeignKey("eventos.id"), nullable=False)
    usuario = Column(String, nullable=False)
    estado = Column(String, default="confirmado")  # confirmado / cancelado
    fecha_inscripcion = Column(DateTime, default=datetime.utcnow)

    evento = relationship("Evento", back_populates="inscripciones")


class Notificacion(Base):
    __tablename__ = "notificaciones"

    id = Column(Integer, primary_key=True, index=True)
    usuario = Column(String, nullable=False)
    mensaje = Column(String, nullable=False)
    tipo = Column(String, default="info")  # info / recordatorio / cambio
    fecha = Column(DateTime, default=datetime.utcnow)
    leido = Column(Integer, default=0)  # 0 = no leído, 1 = leído
