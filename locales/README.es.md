<div align="center">

# Membrane (Español)

**Pipeline de contexto basado en actores para Swift.**

[English](../README.md) | [Español](README.es.md) | [日本語](README.ja.md) | [中文](README.zh-CN.md)

</div>

---

Membrane toma una solicitud de contexto, reparte el presupuesto, comprime lo que sobra y expulsa lo menos importante antes de emitir la petición final al modelo.

## Características Clave

- **Presupuesto Determinista:** Partición de tokens en 9 dominios con límites estrictos.
- **Compresión de Múltiples Niveles:** Transición dinámica entre niveles `full`, `gist` y `micro`.
- **Aislamiento por Actores:** Construido sobre la concurrencia de Swift 6.
