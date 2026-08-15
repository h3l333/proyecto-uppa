# Sistema de Gestión de Prácticas Profesionales - UPPA

Documentación de análisis y diseño (UML) del sistema de gestión de prácticas profesionales de la Universidad de UPPA. El sistema permite a los alumnos registrar y consultar sus prácticas profesionales, a los tutores y responsables de empresa hacer seguimiento de ellas, y al administrador gestionar empresas, convenios y asignaciones.

## Estructura del proyecto

```
.
├── diagrama-casos-uso.puml              Diagrama de casos de uso general
├── diagrama-clases.puml                 Diagrama de clases del dominio
├── especificaciones-cu-md/              Especificación textual de cada caso de uso (CU-01 a CU-16)
├── diagramas-de-actividad-puml/         Diagrama de actividad por caso de uso
├── diagramas-de-comunicacion-puml/      Diagrama de comunicación por caso de uso
└── diagramas-de-secuencia-puml/         Diagrama de secuencia por caso de uso
```

Todos los diagramas están en formato [PlantUML](https://plantuml.com/) (`.puml`). Pueden renderizarse con la extensión de PlantUML de VS Code, con el plugin de IntelliJ, o con el servidor local/online de PlantUML.

Un [workflow de GitHub Actions](.github/workflows/render-diagrams.yml) genera automáticamente un `.svg` por cada `.puml` en cada push a `main`. El `README.md` de cada subcarpeta de diagramas ([actividad](diagramas-de-actividad-puml/README.md), [comunicación](diagramas-de-comunicacion-puml/README.md), [secuencia](diagramas-de-secuencia-puml/README.md)) los embebe para poder verlos directamente en GitHub sin instalar nada.

## Actores del sistema

| Actor                          | Rol                                                                              |
| ------------------------------ | -------------------------------------------------------------------------------- |
| Alumno                         | Registra y consulta el estado de su práctica profesional.                        |
| Tutor / Responsable de Empresa | Genera informes de avance y consulta el seguimiento de las prácticas a su cargo. |
| Administrador del Sistema      | Gestiona empresas, convenios, y asigna responsables y tutores.                   |
| Sistema de Correo Electrónico  | Envía notificaciones automáticas (alta de práctica, vencimiento de convenio).    |

## Casos de uso

| CU    | Nombre                                       | Tipo                                   | Actor principal                |
| ----- | -------------------------------------------- | -------------------------------------- | ------------------------------ |
| CU-01 | Registrar Práctica Profesional               | Base                                   | Alumno                         |
| CU-02 | Generar Informe de Avance                    | Base                                   | Tutor / Responsable de Empresa |
| CU-03 | Consultar Estado                             | Base                                   | Alumno                         |
| CU-04 | Consultar Seguimiento de Práctica            | Base                                   | Tutor / Responsable de Empresa |
| CU-05 | Registrar Empresa                            | Base                                   | Administrador del Sistema      |
| CU-06 | Registrar Convenio                           | Base                                   | Administrador del Sistema      |
| CU-07 | Asignar Responsable a Empresa                | Base                                   | Administrador del Sistema      |
| CU-08 | Asignar Tutor a Área Profesional             | Base                                   | Administrador del Sistema      |
| CU-09 | Consultar Convenios Próximos a Vencer        | Base                                   | Administrador del Sistema      |
| CU-10 | Verificar Vigencia del Convenio              | Include (de CU-01)                     | Sistema                        |
| CU-11 | Verificar Práctica Única por Ciclo Lectivo   | Include (de CU-01)                     | Sistema                        |
| CU-12 | Verificar Cupo Disponible en Empresa Pública | Extend (de CU-01)                      | Alumno                         |
| CU-13 | Proponer Tutor Académico Compatible          | Include (de CU-01)                     | Sistema                        |
| CU-14 | Seleccionar Responsable Compatible           | Include (de CU-01)                     | Alumno                         |
| CU-15 | Notificar Alta de Práctica                   | Base (automático) / Include (de CU-01) | Sistema de Correo Electrónico  |
| CU-16 | Notificar sobre Vencimiento                  | Base (automático)                      | Sistema de Correo Electrónico  |

CU-01 incluye a CU-10, CU-11, CU-13, CU-14 y CU-15; CU-12 extiende a CU-01.

![Diagrama de casos de uso](diagrama-casos-uso.svg)

## Modelo de dominio (resumen)

- **Persona** es la superclase de `Administrador`, `ResponsableEmpresa`, `Docente` (con `DocenteNoTutor` y `TutorAcademico`) y `Alumno`.
- **Empresa** se especializa en `SectorPublico` (con control de cupo) y `SectorPrivado`; agrupa `Convenio`s, `ResponsableEmpresa`s y `Practica`s.
- **Practica** es la entidad central: se vincula a un `Alumno`, un `TutorAcademico`, un `ResponsableEmpresa`, un `Convenio`, un `CicloLectivo`, y acumula `InformeDeAvance`s y `Notificacion`es. Se valida contra `ReglasDeNegocios` (límite de prácticas por año).
- **AreaProfesional** conecta `TutorAcademico` y `ResponsableEmpresa` según afinidad, y se usa para proponer tutores/responsables compatibles durante el registro de una práctica.

![Diagrama de clases](diagrama-clases.svg)

Ver [diagrama-clases.puml](diagrama-clases.puml) para el detalle completo de atributos, métodos y cardinalidades.

## Cómo leer los diagramas de comunicación

PlantUML no tiene un renderer nativo para diagramas de comunicación UML. Por eso, los archivos en `diagramas-de-comunicacion-puml/` se representan como diagramas de objetos: una línea por cada par de participantes que interactúan, con una nota adjunta que lista los mensajes numerados intercambiados en ese enlace (el número corresponde al orden de la secuencia UML equivalente). La numeración está sincronizada con el diagrama de secuencia del mismo caso de uso.
