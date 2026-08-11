from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from .. import models, schemas
from ..database import get_db

router = APIRouter(
    prefix="/notificaciones",
    tags=["Notificaciones - Enrique Rosado"]
)


# Responsable: Enrique Rosado | Escritura
@router.post("", response_model=schemas.NotificacionOut, status_code=201)
def generar_notificacion(
    datos: schemas.NotificacionCreate,
    db: Session = Depends(get_db)
):
    """Crea y guarda una nueva notificación para un usuario."""

    nueva_notificacion = models.Notificacion(
        usuario=datos.usuario,
        mensaje=datos.mensaje,
        tipo=datos.tipo
    )

    db.add(nueva_notificacion)
    db.commit()
    db.refresh(nueva_notificacion)

    return nueva_notificacion


# Responsable: Enrique Rosado | Lectura
@router.get("/{usuario}", response_model=List[schemas.NotificacionOut])
def ver_notificaciones(
    usuario: str,
    db: Session = Depends(get_db)
):
    """Devuelve las notificaciones de un usuario, de la más reciente a la más antigua."""

    notificaciones = (
        db.query(models.Notificacion)
        .filter(models.Notificacion.usuario == usuario)
        .order_by(models.Notificacion.fecha.desc())
        .all()
    )

    return notificaciones