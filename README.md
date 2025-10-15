# 📱 GanAssist

**GanAssist** is a companion application designed to work together with [**GanisPro**](#).  
By itself, GanAssist has no standalone functionality — its main purpose is to **receive GPS coordinates (points of interest)** from GanisPro running on another device, and then **send those coordinates to a navigation app** installed on the same device as GanAssist.

---

## 🔗 Connection between GanAssist and GanisPro

GanAssist and GanisPro communicate through a **Nearby connection** (Bluetooth or Wi-Fi Direct).

- **GanisPro** – runs on the secondary device (e.g., a passenger’s phone).  
  It allows users to create, import, or select GPS coordinates (points of interest).

- **GanAssist** – runs on the driver’s device, where it receives those coordinates from GanisPro and forwards them to the navigation application selected by the user (e.g., Google Maps, Waze, etc.).

---

## ⚙️ How it works

1. In **GanAssist**, the user selects the preferred navigation app installed on the device.  
2. **GanisPro** and **GanAssist** establish a Nearby connection.  
3. From **GanisPro**, the user selects a point of interest and sends it to the connected **GanAssist** device.  
4. **GanAssist** receives the coordinates and automatically forwards them to the chosen navigation app, opening the route directly.

---

## 🚗 Why this is useful

In real driving situations, drivers often use a navigation app to reach a destination.  
However, during the trip, it’s common to make **unscheduled stops** — for example at a gas station, restaurant, or store.  

Adding these intermediate points usually requires manual interaction with the navigation app, which:
- distracts the driver,
- increases the risk of accidents, and  
- is inconvenient while on the move.

With **GanisPro + GanAssist**, this process becomes much safer and easier:
- The passenger (or any assistant) selects a stop in **GanisPro**.  
- With a single tap, the coordinates are sent to **GanAssist** on the driver’s phone.  
- **GanAssist** instantly forwards the destination to the navigation app — without the driver touching their device.

---

## ✅ Key Features

- 🔄 Fast and secure GPS coordinate transfer between two nearby Android devices  
- 🚫 No manual input while driving  
- 👥 Designed for teamwork between driver and passenger (or dispatcher)  
- ⚡ Works with any navigation app supporting coordinate input  
- 🔒 No internet connection required (Nearby only)

---

## 🧭 Requirements

- **GanisPro** installed on the secondary device  
- **GanAssist** installed on the driver’s (main) device  
- **Nearby** connection (Bluetooth/Wi-Fi) enabled on both devices  

---

## 📦 Typical Setup

| Device | Application | Role |
|---------|--------------|------|
| Passenger’s device | GanisPro | Sends GPS points of interest |
| Driver’s device | GanAssist | Receives coordinates and forwards them to the navigation app |

---

## 🧩 Compatibility

- Android 7.0 (API 24) or higher  
- Developed with **Flutter 3.7.8 / Dart 2.19.5  
- Works with major navigation apps:  
  - Google Maps  
  - Waze  
  - HERE WeGo  
  - Sygic  

---

## ⚠️ Important

GanAssist **cannot function on its own**.  
It is designed **only** to be used together with **GanisPro**, through a Nearby connection between the two devices.

---

## 📄 License

This project is proprietary.  
All rights reserved © GanisDev, 2023.
