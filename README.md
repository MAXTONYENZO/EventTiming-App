# ⏱️ EventTiming

**Aplicación Móvil Multiplataforma en Flutter con Integración Firebase para la Gestión del Timing en Tiempo Real en Eventos Sociales**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat&logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-2026-FFCA28?style=flat&logo=firebase)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📋 Tabla de Contenidos

1. [Descripción del Proyecto](#descripción-del-proyecto)
2. [Problemática](#problemática)
3. [Pregunta Problema](#pregunta-problema)
4. [Objetivos SMART](#objetivos-smart)
5. [Arquitectura de la Solución](#arquitectura-de-la-solución)
6. [Stack Tecnológico](#stack-tecnológico)
7. [Estrategia de Seguridad](#estrategia-de-seguridad)
8. [Simulador de Costos](#simulador-de-costos)
9. [Estructura del Proyecto](#estructura-del-proyecto)
10. [Guía de Instalación y Despliegue](#guía-de-instalación-y-despliegue)
11. [Metodología](#metodología)
12. [Equipo](#equipo)
13. [Licencia](#licencia)

---

## 📱 Descripción del Proyecto

**EventTiming** es una aplicación móvil multiplataforma desarrollada en **Flutter** con integración **Firebase** que permite la gestión colaborativa del cronograma en tiempo real para eventos sociales (bodas, celebraciones y eventos corporativos). La app sincroniza a wedding planners, proveedores y novios en un solo ecosistema, reduciendo los tiempos de coordinación y mejorando la comunicación durante todo el ciclo del evento.

---

## 🎯 Problemática

Los organizadores de eventos y proveedores enfrentan una coordinación ineficiente debido a la falta de una herramienta móvil centralizada. Actualmente, la comunicación depende de canales fragmentados como WhatsApp, llamadas telefónicas y listas en papel, generando tres problemáticas críticas:

| # | Problemática | Impacto |
|---|--------------|---------|
| 1 | **Falta de visibilidad en tiempo real** del estado de las tareas | Incremento de la carga operativa en un **40%** durante las horas previas al evento |
| 2 | **Retrasos no comunicados oportunamente** | Desfases de hasta **30 minutos** en el cronograma |
| 3 | **Procesos manuales desactualizados** | Más de **2 horas diarias** dedicadas a actualizar y comunicar cambios |

---

## ❓ Pregunta Problema

> ¿De qué manera la implementación de una aplicación móvil multiplataforma en Flutter con integración Firebase y sincronización en tiempo real permite reducir en un **50% los tiempos de coordinación** entre wedding planners y proveedores durante la organización y ejecución de eventos sociales?

---

## 🎯 Objetivos SMART

### Objetivo General

> Desarrollar una aplicación móvil multiplataforma en Flutter con integración Firebase que permita la gestión del timing en tiempo real en eventos sociales, logrando una **reducción del 50% en los tiempos de coordinación** entre wedding planners y proveedores, y alcanzando una **calificación de usabilidad superior a 80 puntos en la escala SUS**, en un período de **8 semanas** con enfoque en dispositivo Android.

### Objetivos Específicos (3 Fases)

| Fase | Objetivo | Plazo | Criterio de Éxito |
|------|----------|-------|-------------------|
| **1** | **Investigación de Usuario y Prototipado UX/UI** | Semana 2 | Diseñar wireframes y prototipo en Figma, evaluando con 5 usuarios y alcanzando SUS > 85 |
| **2** | **Desarrollo Frontend e Integración API/Backend** | Semana 6 | Programar módulos en Flutter, integrar Firebase con tiempo de respuesta < 500 ms |
| **3** | **Pruebas en Dispositivos Reales y Medición** | Semana 8 | Probar en 10 dispositivos Android, con batería <5%/hora y SUS > 80 |

---

## 🏗️ Arquitectura de la Solución

La arquitectura sigue el patrón **Offline-First**: la app funciona sin conexión y sincroniza automáticamente al recuperar red.

```mermaid
graph TD
    A[Dispositivo Móvil<br>Flutter + Dart] --> B[Firebase Services]
    A --> C[SQLite/Drift<br>Offline-First]
    B --> D[Firestore<br>Base de Datos Tiempo Real]
    B --> E[Auth<br>Autenticación JWT]
    B --> F[Cloud Messaging<br>Notificaciones Push]
    B --> G[Storage<br>Evidencias Fotográficas]
    H[API REST<br>Servicios Externos] --> A
    I[Git/GitHub<br>Control de Versiones] -.-> A

🧰 Stack Tecnológico
Capa	Tecnología	Versión
Frontend	Flutter + Dart	3.x
State Management	Provider	^6.0.5
Base de Datos Cloud	Firebase Firestore	-
Base de Datos Local	SQLite / Drift	Offline-First
Autenticación	Firebase Auth (JWT)	^4.16.0
Notificaciones	Firebase Cloud Messaging	^14.6.5
Almacenamiento	Firebase Storage	^11.5.0
Seguridad	flutter_secure_storage + HTTPS	^9.0.0
Control de Versiones	Git / GitHub	-

🔒 Estrategia de Seguridad
Pilar	Tecnología	Descripción
Almacenamiento Cifrado	flutter_secure_storage	Utiliza EncryptedSharedPreferences en Android para cifrar tokens JWT y credenciales
Comunicación Segura	HTTPS / TLS	Todas las comunicaciones con Firebase y APIs externas viajan cifradas
Autenticación	Firebase Auth + JWT	Emite tokens renovables validados en cada petición
Control de Acceso	Firebase Security Rules	Control granular por roles: planner, proveedores, novios
