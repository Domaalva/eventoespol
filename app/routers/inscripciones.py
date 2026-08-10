from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import models, schemas
from ..database import get_db

router = APIRouter(prefix="/inscripciones", tags=["Inscripciones - Domenika Arboleda"])


# Responsable: Domenika Arboleda | Escritura
@router.post("", response_model=schemas.InscripcionOut, status_code=201)
def inscribirse_a_evento(datos: schemas.InscripcionCreate, db: Session = Depends(get_db)):
    """Inscribe a un usuario en un evento, validando que exista cupo disponible."""
    evento = db.query(models.Evento).filter(models.Evento.id == datos.evento_id).first()
    if not evento:
        raise HTTPException(status_code=404, detail="Evento no encontrado")

    inscritos = (
        db.query(models.Inscripcion)
        .filter(models.Inscripcion.evento_id == datos.evento_id, models.Inscripcion.estado == "confirmado")
        .count()
    )
    if inscritos >= evento.cupo_maximo:
        raise HTTPException(status_code=400, detail="No hay cupo disponible para este evento")

    existente = (
        db.query(models.Inscripcion)
        .filter(models.Inscripcion.evento_id == datos.evento_id, models.Inscripcion.usuario == datos.usuario)
        .first()
    )
    if existente and existente.estado == "confirmado":
        raise HTTPException(status_code=400, detail="El usuario ya está inscrito en este evento")

    nueva = models.Inscripcion(evento_id=datos.evento_id, usuario=datos.usuario, estado="confirmado")
    db.add(nueva)
    db.commit()
    db.refresh(nueva)
    return nueva


# Responsable: Domenika Arboleda | Lectura
@router.get("/{usuario}", response_model=List[schemas.InscripcionOut])
def ver_mis_inscripciones(usuario: str, db: Session = Depends(get_db)):
    """Devuelve el listado de inscripciones (con su estado) de un usuario."""
    inscripciones = (
        db.query(models.Inscripcion).filter(models.Inscripcion.usuario == usuario).all()
    )
    return inscripciones


@router.delete("/{inscripcion_id}", response_model=schemas.InscripcionOut)
def cancelar_inscripcion(inscripcion_id: int, db: Session = Depends(get_db)):
    inscripcion = db.query(models.Inscripcion).filter(models.Inscripcion.id == inscripcion_id).first()
    if not inscripcion:
        raise HTTPException(status_code=404, detail="Inscripción no encontrada")
    inscripcion.estado = "cancelado"
    db.commit()
    db.refresh(inscripcion)
    return inscripcion
