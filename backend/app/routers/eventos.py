# Aporte de Henry Olvera
from datetime import date
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from .. import models, schemas
from ..database import get_db

router = APIRouter(prefix="/eventos", tags=["Eventos - Henry Olvera"])


def _calcular_cupo_disponible(db: Session, evento_id: int, cupo_maximo: int) -> int:
    inscritos = (
        db.query(models.Inscripcion)
        .filter(models.Inscripcion.evento_id == evento_id, models.Inscripcion.estado == "confirmado")
        .count()
    )
    return max(0, cupo_maximo - inscritos)


@router.post("", response_model=schemas.EventoOut, status_code=201)
def crear_evento(datos: schemas.EventoCreate, db: Session = Depends(get_db)):
    """Crea un nuevo evento con los datos básicos requeridos por el módulo de eventos."""

    try:
        fecha_evento = date.fromisoformat(datos.fecha)
    except ValueError:
        raise HTTPException(status_code=400, detail="Formato de fecha inválido. Use YYYY-MM-DD.")

    if datos.cupo_maximo <= 0:
        raise HTTPException(status_code=400, detail="El cupo máximo debe ser un número positivo.")

    nuevo_evento = models.Evento(
        titulo=datos.titulo.strip(),
        descripcion=(datos.descripcion or "").strip(),
        fecha=fecha_evento.isoformat(),
        ubicacion=datos.ubicacion.strip(),
        categoria=datos.categoria.strip(),
        cupo_maximo=datos.cupo_maximo,
    )

    db.add(nuevo_evento)
    db.commit()
    db.refresh(nuevo_evento)

    return schemas.EventoOut(
        id=nuevo_evento.id,
        titulo=nuevo_evento.titulo,
        descripcion=nuevo_evento.descripcion,
        fecha=nuevo_evento.fecha,
        ubicacion=nuevo_evento.ubicacion,
        categoria=nuevo_evento.categoria,
        cupo_maximo=nuevo_evento.cupo_maximo,
        cupo_disponible=nuevo_evento.cupo_maximo,
    )


@router.get("", response_model=List[schemas.EventoOut])
def ver_catalogo_de_eventos(
    categoria: Optional[str] = Query(None, description="Filtrar por categoría de evento"),
    fecha: Optional[str] = Query(None, description="Filtrar por fecha del evento en formato YYYY-MM-DD"),
    db: Session = Depends(get_db),
):
    """Devuelve el catálogo de eventos, con opción de filtrar por categoría y/o fecha."""

    consulta = db.query(models.Evento)

    if categoria:
        consulta = consulta.filter(models.Evento.categoria == categoria.strip())

    if fecha:
        try:
            date.fromisoformat(fecha)
        except ValueError:
            raise HTTPException(status_code=400, detail="Formato de fecha inválido. Use YYYY-MM-DD.")
        consulta = consulta.filter(models.Evento.fecha == fecha)

    eventos = consulta.order_by(models.Evento.fecha.asc()).all()

    resultados = []
    for evento in eventos:
        resultados.append(
            schemas.EventoOut(
                id=evento.id,
                titulo=evento.titulo,
                descripcion=evento.descripcion,
                fecha=evento.fecha,
                ubicacion=evento.ubicacion,
                categoria=evento.categoria,
                cupo_maximo=evento.cupo_maximo,
                cupo_disponible=_calcular_cupo_disponible(db, evento.id, evento.cupo_maximo),
            )
        )

    return resultados
