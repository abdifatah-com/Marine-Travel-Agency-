# 🛳️ Marine Travel Agency Management System (MTAMS)

> **A Premium Enterprise-Grade Management Solution**  
> Build manually from the ground up for maximum control, performance, and aesthetic excellence.

---

## 📽️ Presentation Slide Content (A to Z)

Use the sections below to populate your presentation slides. Each section is designed to be a standalone "Chapter" of the project.

### 📍 Chapter 1: The Vision & Core Objective
- **Goal**: To modernize marine travel operations through a centralized digital command center.
- **Problem Solved**: Replaces fragmented spreadsheets and manual record-keeping with a secure, real-time database.
- **Outcome**: Increased operational efficiency, accurate financial reporting, and a premium experience for both agents and administrators.

### 🏗️ Chapter 2: Technical Architecture (The Engine)
- **Framework**: ASP.NET Web Forms (.NET Framework 4.0).
- **Architecture**: N-Tier Inspired (UI / Logic / Database).
- **Data Handling**: Pure **ADO.NET** with `SqlHelper`. Zero ORM overhead for lightning-fast execution.
- **Validation**: Strict server-side validation paired with interactive client-side feedback.

### 💻 Chapter 3: The Modern Technology Stack
- **Frontend**: HTML5, Vanilla CSS3 (Custom Glassmorphism Design).
- **Scripts**: JavaScript (ES6+), Bootstrap 5 (Responsive Layout), FontAwesome 6 (Rich Iconography).
- **Interactions**: **SweetAlert2** for professional, high-end confirmation modals with background blur.
- **Backend**: C# (Code-Behind) + T-SQL (Stored Procedures).

### 🎨 Chapter 4: UI/UX & Design Philosophy
- **Aesthetic**: "Glassmorphism" – utilisant translucent layers and `backdrop-filter` blur for a premium digital feel.
- **User-Centric**: High-density layouts (`form-control-sm`) designed for professional efficiency.
- **Interactions**: Every system message is a professional modal, ensuring a high-end enterprise feel.
- **Responsiveness**: Fully fluid design that adapts from desktop to mobile command views.

### �️ Chapter 5: Operational Features (The "What")
- **Dashboards**: Real-time KPI tracking for revenue and trip density.
- **Trip Lifecycle**: Full management from creation to scheduling and pricing.
- **Booking Engine**: Sophisticated capacity-aware customer registration system.
- **Reporting**: Dynamic financial reports showing revenue per destination.

### � Chapter 6: Administrative Power & Security
- **RBAC**: Role-Based Access Control (Admin, Agent, User) enforced at the page level.
- **User Management**: Complete control over user profiles, credentials, and roles.
- **Privacy**: Password hashing and secure session persistence.
- **System Integrity**: All destructive actions (Delete/Update) protected by professional verification modals.

---

## 🗄️ Database Blueprint (`MarineTravelDB`)

**Tables & Relationships:**
- **Users**: Central identity store for all system actors.
- **Destinations**: Pre-configured locations for system-wide consistency.
- **Trips**: The core schedule – links ships to destinations and time slots.
- **Bookings**: The revenue driver – links customers to specific trips.

**Procedural Logic:**
- **Encapsulated**: 100% of data logic resides in **Stored Procedures**.
- **Secure**: Prevents SQL Injection through parameterization at the database level.
- **Atomic**: Ensures data consistency during complex booking or deletion operations.

---

## � Startup Manual (For Technical Review)

1. **Database**: Initialize via `App_Data/DatabaseSetup.sql`.
2. **Connectivity**: Update `web.config` with your SQL Instance string.
3. **App Pool**: Deploy via IIS with .NET CLR v4.0.
4. **Access**: Login at `/Login.aspx`.
   - **Admin**: `admin` / `password123`

---

> **Note to Presenter:** This project demonstrates the power of manual C# development combined with modern CSS techniques to create a software product that feels "SaaS-ready" while maintaining total codebase transparency.
