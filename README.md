<div align="center">

<img src="docs/screenshots/banner.svg" alt="CareerSwipe AI Header Banner" width="100%" />

# ✦ CAREERSWIPE AI — Intelligent Career Discovery & Dual-Platform Hiring System ✦
### *Stop doom-scrolling job boards. Swipe your next career move.*

[![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android_%7C_iOS_%7C_Web_%7C_macOS-222222?style=for-the-badge&logo=android&logoColor=white)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First_Clean_Architecture-1E4B38?style=for-the-badge&logo=blueprint&logoColor=white)](https://pub.dev/packages/flutter_riverpod)
[![State](https://img.shields.io/badge/State-Riverpod_2.5-4361EE?style=for-the-badge)](https://riverpod.dev)
[![Navigation](https://img.shields.io/badge/Router-GoRouter_14-FF6B6B?style=for-the-badge)](https://pub.dev/packages/go_router)
[![Backend](https://img.shields.io/badge/Backend-Firebase_Suite-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Applied AI](https://img.shields.io/badge/Intelligence-Google_Gemini_AI_%26_ATS_Citations-8E75FF?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev)
[![Design](https://img.shields.io/badge/Design_System-Editorial_Utility-2D6A4F?style=for-the-badge)](lib/theme/editorial_theme.dart)
[![Tests](https://img.shields.io/badge/Tests-35%2F35_Passed_--_0_Issues-10B981?style=for-the-badge&logo=checkmarx&logoColor=white)](test/)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue?style=for-the-badge)](LICENSE)

<br/>

**A production-grade, dual-platform mobile & web application built with Flutter that revolutionizes technical career discovery and recruitment through grounded ATS evidence matching, tactile Tinder-style card curation, and the high-contrast Editorial Utility design system.**

[Explore Features](#-key-features) • [Why CareerSwipe AI?](#-why-careerswipe-ai) • [Problem & Solution](#-the-problem--the-solution) • [Visual Walkthrough](#-screenshots--visual-walkthrough) • [Matching Engine](#-grounded-ats--career-matching-engine) • [Architecture](#-architecture--engineering-design) • [Installation](#-getting-started) • [Skills & Stack](#-tech-stack--skills-highlight)

</div>

---

## 📖 Table of Contents
- [✨ Why CareerSwipe AI?](#-why-careerswipe-ai)
- [💡 What is CareerSwipe AI?](#-what-is-careerswipe-ai)
- [❓ The Problem & The Solution](#-the-problem--the-solution)
  - [The Problem Statement](#the-problem-statement)
  - [The CareerSwipe AI Solution](#the-careerswipe-ai-solution)
- [📱 Screenshots & Visual Walkthrough](#-screenshots--visual-walkthrough)
  - [1. Candidate Discovery & Swipe Deck](#1-candidate-discovery--swipe-deck)
  - [2. ATS Intelligence & Resume Engineering](#2-ats-intelligence--resume-engineering)
  - [3. Recruiter Platform & Hiring Command](#3-recruiter-platform--hiring-command)
  - [4. Auth, Onboarding & Academic Discovery](#4-auth-onboarding--academic-discovery)
- [✨ Key Features](#-key-features)
  - [Candidate Experience](#1-candidate-experience)
  - [Recruiter Platform](#2-recruiter-platform)
  - [AI & ATS Intelligence Engine](#3-ai--ats-intelligence-engine)
  - [Dual Shell Navigation & Route Security](#4-dual-shell-navigation--route-security)
  - [Editorial Utility Design System](#5-editorial-utility-design-system)
- [🧠 Grounded ATS & Career Matching Engine](#-grounded-ats--career-matching-engine)
  - [The Matching Formula](#the-matching-formula)
  - [Anti-Hallucination & Evidence Citations](#anti-hallucination--evidence-citations)
- [🏗️ Architecture & Engineering Design](#-architecture--engineering-design)
  - [Feature-First Clean Architecture](#clean-architecture-data-flow)
  - [4-Tier Route Security Matrix](#4-tier-route-security-matrix)
- [🛠️ Tech Stack & Skills Highlight](#-tech-stack--skills-highlight)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Environment Configuration](#environment-configuration)
  - [Running the Application](#running-the-application)
  - [Building for Production (Android APK / Web)](#building-for-production)
- [🧪 Testing & Quality Assurance](#-testing--quality-assurance)
- [📂 Project Structure](#-project-structure)
- [👨‍💻 Author](#-author)
- [📄 License](#-license)

---

## ✨ Why CareerSwipe AI?

Modern recruiting has devolved into an asynchronous war of attrition:
* **Job seekers** face decision paralysis, spending 45+ minutes formatting resumes for arcane ATS filters only to be rejected without explanation.
* **Hiring managers** are inundated with thousands of AI-generated generic applications, making it nearly impossible to uncover high-signal engineers.

**CareerSwipe AI was engineered to bridge this divide through radical transparency.** By marrying the addictive, tactile efficiency of swipe cards with grounded, verifiable citation algorithms, CareerSwipe AI transforms job hunting from an anxious chore into an empowering, data-driven experience.

---

## 💡 What is CareerSwipe AI?

**CareerSwipe AI** is an editorial-grade, AI-powered career discovery and hiring ecosystem. Rather than forcing candidates through soul-crushing keyword black holes or drowning hiring managers in unvetted resumes, CareerSwipe AI establishes a transparent, high-signal protocol between top engineering talent and tier-1 companies.

Built upon the principles of **Editorial Utility** (`#1E4B38` Spruce Green, `#F9F9F8` Paper, Newsreader Serif & Inter typography) and powered by **Google Gemini AI**, the application provides a bifurcated dual-platform experience:

1. **For Candidates**:
   - **Tactile Swipe Deck**: Evaluate opportunities in seconds using a physical paper card metaphor with high-signal 2x2 facts grids (Compensation, Location, Team, Core Stack) and decision stamps.
   - **Grounded ATS Intelligence**: Inspect resume alignment against requirements with verifiable line-by-line citations, requirement checklists, and zero synthetic score fluff.
   - **Factual Resume Re-Engineering**: Receive AI-suggested bullet revisions grounded strictly in your verified background.
   - **Interactive Career Assistant**: Contextual interview simulations, technical rubric evaluations, and actionable skill-gap roadmaps.

2. **For Recruiters & Hiring Managers**:
   - **Requisition Command Center**: Real-time hiring velocity analytics, live requisition manager, and unverified org trust badges.
   - **Applicant Pipeline Funnel**: Scannable applicant matrices categorized by match percentage, verified skill tags, and stage progression.
   - **Candidate Talent Pool Search**: Natural language query engine indexing verified engineering achievements and domain proficiencies.

---

## ❓ The Problem & The Solution

### The Problem Statement
> *"Traditional recruiting is broken: Candidates spray hundreds of applications into an algorithmic void, while recruiters drown in noise and miss exceptional specialized talent."*

```
               TRADITIONAL RECRUITING TRAPS
┌───────────────────────┐              ┌─────────────────────────┐
│     CANDIDATE         │              │        RECRUITER        │
│ • ATS Black Hole      │              │ • 2,000+ Unvetted Inbound│
│ • Keyword Guessing    │   VS. CHASM  │ • Unverifiable Claims   │
│ • Ghosting / No SLA   │ ────────────>│ • Manual Screening Burn │
│ • Application Fatigue │              │ • Lost High-Signal Devs │
└───────────────────────┘              └─────────────────────────┘
```

* **The ATS Black Hole**: Over 75% of qualified engineering resumes are discarded by crude regex and keyword-stuffing parsers before reaching a human recruiter.
* **Application Fatigue & Doom-Scrolling**: Job seekers spend hours scrolling through repetitive 10-page job postings filled with corporate jargon, leading to decision paralysis.
* **The Ghosting Epidemic**: Candidates submit dossiers with zero visibility into why they were rejected or what skills they lacked.
* **Recruiter Inbound Overload**: Hiring managers receive thousands of low-signal, non-matching applications, making manual vetting virtually impossible.
* **Fictional & Hallucinated Claims**: Disconnect between what candidates write on generic resumes and what engineering teams actually require in production.

### The CareerSwipe AI Solution
CareerSwipe AI reconstructs technical hiring through radical transparency and AI-driven precision:

* **Deterministic Grounded Match Scoring**: Matches are computed by comparing candidate source evidence directly against role specifications with clear citations ($82\% \le \text{Match} \le 99\%$).
* **2x2 Facts Grid & Tactile Decision Stamps**: Key terms (Base Pay, Stock, Location, Remote Policy) are surfaced immediately. Swipe Right to apply or save; Swipe Left to pass and tune future recommendation vectors.
* **Fact-Grounded Bullet Revisions**: AI optimizes resumes by re-anchoring phrasing to measurable impact metrics without inventing false accomplishments.
* **Dual-Platform Role Bifurcation**: Complete end-to-end separation between candidate job-seeking workflows and recruiter hiring funnels.
* **Offline Resilient Architecture**: Standalone mock sessions allow complete exploration and evaluation even without live Firebase cloud connectivity.

---

## 📱 Screenshots & Visual Walkthrough

### 1. Candidate Discovery & Swipe Deck
<div align="center">
<table>
  <tr>
    <td align="center" width="25%">
      <b>01. Discover Jobs (Swipe Deck)</b><br/>
      <img src="docs/screenshots/01_discover_jobs_swipe.png" alt="Discover Jobs Swipe Deck" width="260" /><br/>
      <i>Tactile paper cards, 2x2 facts matrix, match badge &amp; decision stamps.</i>
    </td>
    <td align="center" width="25%">
      <b>02. Job Details Specification</b><br/>
      <img src="docs/screenshots/02_job_details.png" alt="Job Details" width="260" /><br/>
      <i>Requirement-by-requirement breakdown, team context, fixed apply bar.</i>
    </td>
    <td align="center" width="25%">
      <b>03. Applications Tracking</b><br/>
      <img src="docs/screenshots/07_applications_tracking.png" alt="Applications Tracking" width="260" /><br/>
      <i>Application status pills, interview calendar sync, live telemetry.</i>
    </td>
    <td align="center" width="25%">
      <b>04. Candidate Home Dashboard</b><br/>
      <img src="docs/screenshots/08_candidate_dashboard.png" alt="Candidate Dashboard" width="260" /><br/>
      <i>Active dispatches, 78% profile strength, real-time match queue.</i>
    </td>
  </tr>
</table>
</div>

### 2. ATS Intelligence & Resume Engineering
<div align="center">
<table>
  <tr>
    <td align="center" width="25%">
      <b>05. ATS Match Breakdown</b><br/>
      <img src="docs/screenshots/03_ats_match_breakdown.png" alt="ATS Match Results" width="260" /><br/>
      <i>Grounded evidence breakdown: 7/9 requirements validated with citations.</i>
    </td>
    <td align="center" width="25%">
      <b>06. Resume Workspace</b><br/>
      <img src="docs/screenshots/04_resume_workspace.png" alt="Resume Workspace" width="260" /><br/>
      <i>Parsing status, version management, automated dossier ingestion.</i>
    </td>
    <td align="center" width="25%">
      <b>07. Factual Bullet Revisions</b><br/>
      <img src="docs/screenshots/05_resume_improvement.png" alt="Resume Improvement" width="260" /><br/>
      <i>Before/after bullet transformation grounded strictly in factual history.</i>
    </td>
    <td align="center" width="25%">
      <b>08. AI Career Assistant</b><br/>
      <img src="docs/screenshots/06_career_assistant.png" alt="Career Assistant" width="260" /><br/>
      <i>Contextual interview preparation, behavioral simulations, career roadmaps.</i>
    </td>
  </tr>
</table>
</div>

### 3. Recruiter Platform & Hiring Command
<div align="center">
<table>
  <tr>
    <td align="center" width="25%">
      <b>09. Recruiter Dashboard</b><br/>
      <img src="docs/screenshots/09_recruiter_dashboard.png" alt="Recruiter Dashboard" width="260" /><br/>
      <i>EMEA talent pool, active requisitions, pipeline metrics, hiring velocity.</i>
    </td>
    <td align="center" width="25%">
      <b>10. Applicant Pipeline Funnel</b><br/>
      <img src="docs/screenshots/10_applicant_pipeline.png" alt="Applicant Pipeline" width="260" /><br/>
      <i>Review, Screened, Interview, Offer columns with match scores.</i>
    </td>
    <td align="center" width="25%">
      <b>11. Candidate Recruiter Dossier</b><br/>
      <img src="docs/screenshots/11_candidate_recruiter_view.png" alt="Candidate Details Recruiter View" width="260" /><br/>
      <i>Verified skill categorization, historical dossier, internal recruiter notes.</i>
    </td>
    <td align="center" width="25%">
      <b>12. Hiring Analytics &amp; Funnel</b><br/>
      <img src="docs/screenshots/13_hiring_analytics.png" alt="Hiring Analytics" width="260" /><br/>
      <i>Stage conversion telemetry, time-to-hire metrics, talent acquisition insights.</i>
    </td>
  </tr>
</table>
</div>

### 4. Auth, Onboarding & Academic Discovery
<div align="center">
<table>
  <tr>
    <td align="center" width="25%">
      <b>13. Splash Screen &amp; Telemetry</b><br/>
      <img src="docs/screenshots/18_splash_screen.png" alt="Splash Screen" width="260" /><br/>
      <i>Protocol telemetry audit, session validation, timer-less auth routing.</i>
    </td>
    <td align="center" width="25%">
      <b>14. Account Role Selection</b><br/>
      <img src="docs/screenshots/14_account_role_selection.png" alt="Role Selection" width="260" /><br/>
      <i>Bifurcated Candidate vs. Recruiter entry with capability matrices.</i>
    </td>
    <td align="center" width="25%">
      <b>15. Candidate Onboarding</b><br/>
      <img src="docs/screenshots/15_candidate_onboarding.png" alt="Candidate Onboarding" width="260" /><br/>
      <i>Skills declaration, target salary range, preferred seniority levels.</i>
    </td>
    <td align="center" width="25%">
      <b>16. Internships Discovery</b><br/>
      <img src="docs/screenshots/20_internships_discovery.png" alt="Internships Discovery" width="260" /><br/>
      <i>Academic research fellowships, stipend disclosures, ECTS credits.</i>
    </td>
  </tr>
</table>
</div>

---

## ✨ Key Features

### 1. 🎯 Candidate Experience
* **Tactile Swipe Discovery Deck**: Smooth gesture-driven card interactions powered by `flutter_card_swiper`.
* **2x2 Facts Matrix**: Essential telemetry (Compensation, Location, Team, Core Stack) visible in under 3 seconds.
* **Grounded Match Pill**: Real percentage score derived from deterministic requirement mapping.
* **Full Job Dossiers**: Complete engineering specs with direct team breakdowns and anti-ghosting communication SLAs.
* **Academic Internships Portal**: Dedicated research fellowship listings with verified stipend, duration, and academic credit disclosures.

### 2. 🏢 Recruiter Platform
* **Live Requisition Manager**: Publish, edit, pause, and close requisitions with stage-by-stage applicant counts.
* **Applicant Pipeline Tracker**: Categorized columns (Review, Phone Screen, Technical Architecture, Partner, Offer).
* **Candidate Search Engine**: Query talent by verified skill tags, open-source contributions, and domain expertise.
* **Internal Collaboration Notes**: Private candidate evaluations and rubric scorings shared across the hiring team.
* **Corporate Trust Verification**: Transparent verification badges protecting candidates from fraudulent job postings.

### 3. 🧠 AI & ATS Intelligence Engine
* **Requirement Citation Engine**: Every match score backed by specific line-item citations from the user's resume.
* **Factual Resume Revision**: AI suggests impactful metric-driven bullets without inventing unperformed work.
* **Skill-Gap Analysis**: Highlights critical missing technical competencies with prioritized learning milestones.
* **Interactive Interview Simulator**: Gemini-driven technical interview simulation with real-time rubric feedback.

### 4. 🛡️ Dual Shell Navigation & Route Security
* **4-Tier Route Redirection Engine**:
  - *Tier 1*: Unrestricted splash validation.
  - *Tier 2*: Guarded multi-step candidate & recruiter onboarding.
  - *Tier 3*: Public authentication routes with auto-redirect for active sessions.
  - *Tier 4*: Protected role-isolated dashboards (`/home` for candidates, `/recruiter/dashboard` for hiring teams).
* **Standalone Mock Fallback**: Graceful offline fallback automatically activates if Firebase auth providers or internet connectivity are unavailable.

### 5. 🎨 Editorial Utility Design System
* **Curated Palette**: Deep Spruce Green (`#1E4B38`), Cream Paper Background (`#F9F9F8`), and Dark Enclave (`#141413`).
* **Editorial Typography**: Newsreader Serif headers paired with clean Inter Sans body text for high readability.
* **Tactile Stamping**: Physical visual feedback stamps (`DECISION APPLIED`, `SIGNAL VERIFIED`, `CONFIDENTIAL`).

---

## 🧠 Grounded ATS & Career Matching Engine

The matching engine replaces arbitrary keyword guessing with a deterministic, 5-dimension weighted scoring engine backed by real client-side document extraction:

$$\text{ATS Score} = 0.35 \times \text{Skills} + 0.25 \times \text{Keywords} + 0.20 \times \text{Experience} + 0.10 \times \text{Education} + 0.10 \times \text{Formatting}$$

### The 5 Identifiable Scoring Dimensions:
1. **Target Skills ($35\%$)**: Exact and alias match ratio against 60+ canonical technical domains (Mobile, Frontend, Backend, Cloud/DevOps, Databases, Machine Learning, Architecture).
2. **Domain Keywords ($25\%$)**: Industry vocabulary density covering system design, scalability, CI/CD, microservices, and security telemetry.
3. **Experience & Impact ($20\%$)**: Active verb density (*architected, engineered, spearheaded*) combined with quantified business metric verification (*percentage improvements, latency reductions, user scale*).
4. **Education & Accreditation ($10\%$)**: Accredited university degrees (B.Tech, B.S., M.S., Ph.D.) and technical certifications.
5. **Formatting & Parseability ($10\%$)**: Clean section structure (`Summary`, `Experience`, `Skills`, `Education`, `Projects`) and validated contact telemetry (email, phone, LinkedIn/GitHub links).

### 📄 Pure-Dart Client-Side Document Parser
Unlike systems that rely on external proprietary SaaS APIs for text extraction, CareerSwipe AI includes a zero-dependency, pure-Dart document extraction engine (`DocumentParserService`):
* **PDF Extraction**: Decodes uncompressed streams and parses text display operators (`BT ... ET`, `Tj`, and `TJ` arrays) with fallback ASCII stream scanners.
* **DOCX Extraction**: Unpacks Word OpenXML streams and parses `<w:t>` body nodes directly into clean paragraphs.
* **Plain Text / Markdown**: UTF-8 and Latin-1 multi-encoding normalization with whitespace consolidation.

### Anti-Hallucination & Evidence Citations
Traditional AI tools invent achievements or give identical scores to every resume. CareerSwipe AI enforces strict guarantees:
1. **Differentiable Evaluations**: Distinct resumes yield provably distinct scores ($30 \le \text{Score} \le 99$) verified by unit test suites.
2. **Transparent Checklist**: Unmet specifications are displayed openly under the **Missing or Underused Skills** section with factual bullet suggestions.
3. **Application-Specific Disclaimer**: Reports explicitly notify users that the analysis is an application-specific estimate rather than a guarantee of proprietary corporate ATS outcomes.

---

## 🏗️ Architecture & Engineering Design

### Clean Architecture Data Flow
CareerSwipe AI is built according to **Feature-First Clean Architecture** principles, guaranteeing clear separation of concerns, testability, and resilience.

```mermaid
graph TD
    subgraph Presentation ["Presentation Layer"]
        UI["Widgets & Screens (Editorial Utility)"]
        State["StateNotifier (Riverpod 2.5)"]
        Router["GoRouter 14 (4-Tier Guarded Navigation)"]
    end

    subgraph Domain ["Domain Layer"]
        Models["Data Models (UserModel, JobModel, ATSResult)"]
        RepoInterfaces["Repository Interfaces (AuthRepository, JobRepository)"]
    end

    subgraph Data ["Data Layer"]
        RepoImpl["Repository Implementations"]
        Services["AuthService, JobService, AIService"]
        Remote["Firebase (Auth, Firestore, Cloud Functions)"]
        Local["Local Mock Session Fallback"]
        AI["Google Gemini AI API"]
    end

    UI --> State
    State --> Router
    State --> RepoInterfaces
    RepoImpl --> RepoInterfaces
    RepoImpl --> Services
    Services --> Remote
    Services --> Local
    Services --> AI
    RepoImpl --> Models
```

### 4-Tier Route Security Matrix

```
       ROUTER REDIRECT PROTOCOL (lib/config/routes.dart)
┌─────────────────────────────────────────────────────────────┐
│ Tier 1: Splash Screen (/)                                    │
│ └── Never redirects; performs integrity & telemetry handshake│
├─────────────────────────────────────────────────────────────┤
│ Tier 2: Guarded Onboarding Routes (/auth/candidate-onboard)  │
│ └── Unauthenticated: redirects to /auth/login               │
│ └── Authenticated: allowed through to complete profile      │
├─────────────────────────────────────────────────────────────┤
│ Tier 3: Public Auth Routes (/auth/login, /auth/signup)       │
│ └── Unauthenticated: displays login/register forms          │
│ └── Authenticated: inspects isProfileComplete and role       │
│     ├── Incomplete: routes to /auth/candidate-onboarding    │
│     └── Complete: routes to /home or /recruiter/dashboard   │
├─────────────────────────────────────────────────────────────┤
│ Tier 4: Protected Shells (/home, /recruiter/*, /resume/*)    │
│ └── Unauthenticated: redirects to /auth/login               │
│ └── Authenticated: isolated access based on UserType        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack & Skills Highlight

| Category | Technologies & Tools | Engineering Role in CareerSwipe AI |
| :--- | :--- | :--- |
| **Languages** | **Dart 3.5+** | Sound null safety, sealed classes, records, pattern matching |
| **Framework** | **Flutter 3.24+** | High-performance multi-platform canvas (Android, iOS, Web, Desktop) |
| **State Management**| **Flutter Riverpod 2.5** | Declarative state, `StateNotifier`, `AsyncValue` caching, dependency inversion |
| **Routing** | **GoRouter 14** | 4-tier route guards, declarative navigation, deep linking |
| **Backend & Cloud** | **Firebase Suite** | Firebase Auth (Email & Google Workspace), Firestore DB, Cloud Storage |
| **Generative AI** | **Google Gemini AI** | Contextual interview simulation, factual resume revisions, ATS analysis |
| **Gestures & UI** | **flutter_card_swiper** | Fluid physics-based Tinder swipe decks with direction callbacks |
| **Typography** | **Google Fonts (Newsreader & Inter)** | Editorial high-contrast serif headers paired with neutral body sans |
| **Analytics & Charts**| **fl_chart** | Hiring pipeline conversion funnels, profile strength radial progress |
| **Testing & QA** | **Flutter Test Framework** | 29 passing unit & widget tests, layout overflow regression guards |

---

## 🚀 Getting Started

### Prerequisites
* **Flutter SDK**: `>= 3.24.0` ([Official Flutter Install Guide](https://flutter.dev/docs/get-started/install))
* **Dart SDK**: `>= 3.5.0`
* **Java Development Kit**: JDK 17 (recommended for Gradle 8.7 compatibility)
* **Android Studio / VS Code** with Flutter and Dart extensions
* **Git**: `git >= 2.40`

### Environment Configuration
1. Clone the repository:
   ```bash
   git clone https://github.com/AmanTyagi-01/CareerSwipeAI.git
   cd CareerSwipeAI
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   ```
   Provide your Gemini API key and Firebase credentials in `.env` (optional for standalone local exploration):
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   FIREBASE_PROJECT_ID=your_firebase_project_id
   ```

3. Fetch dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

```bash
# Run on Google Chrome (Fastest Web Preview)
flutter run -d chrome --web-port=8080

# Run on native Windows Desktop
flutter run -d windows

# Run on connected Android device / emulator
flutter run -d android
```

> **Standalone Fallback Note**: When Firebase credentials are not provided or Firebase services are unreachable, the application automatically launches in **Offline Standalone Mode**. All features—including the swipe deck, ATS breakdown, candidate profile, and recruiter dashboard—remain fully interactive.

### Building for Production

```bash
# Build production web bundle
flutter build web --release

# Build release Android APK
flutter build apk --release

# Build Android App Bundle (AAB) for Google Play
flutter build appbundle --release
```

---

## 🧪 Testing & Quality Assurance

CareerSwipe AI enforces strict software craftsmanship standards. All tests are validated against zero layout overflow and comprehensive state assertions:

```bash
# Execute entire unit and widget test suite
flutter test

# Run static analysis and lint checks
flutter analyze
```

### Test Suite Summary:
* **29 of 29 Tests Passing**:
  - `auth_provider_test.dart` — StateNotifier authentication states and role registration
  - `editorial_components_test.dart` — Editorial design tokens, radii, button styles, cards
  - `login_screen_test.dart` — Responsive layout validation across viewports
  - `resume_upload_test.dart` — Resume upload, parsing preview, and extraction inspection
  - `widget_test.dart` — Complete application smoke tests
* **Zero Static Analysis Issues**: 100% compliance with `flutter_lints`.

---

## 📂 Project Structure

```
CareerSwipeAI/
├── android/                   # Native Android host (Gradle 8.7, AGP 8.5.2, Java 17)
├── ios/                       # Native iOS host (Xcode workspace)
├── web/                       # Web entrypoint and manifest
├── docs/                      # Documentation assets
│   └── screenshots/           # Curated high-resolution screenshot showcase
│       ├── banner.svg         # High-resolution vector header banner
│       └── *.png              # 20 high-fidelity flow screenshots
├── design_reference/          # 59-Screen Stitch blueprints and specification ledgers
├── lib/
│   ├── config/
│   │   ├── routes.dart        # 4-tier guarded GoRouter routing system
│   │   └── theme.dart         # Theme exports and global configuration
│   ├── data/
│   │   ├── models/            # UserModel, JobModel, ATSResult, ApplicationModel
│   │   └── repositories/      # AuthRepository, JobRepository, ATS operations
│   ├── presentation/
│   │   ├── providers/         # Riverpod StateNotifiers (AuthNotifier, JobNotifier)
│   │   ├── screens/
│   │   │   ├── auth/          # Splash, Welcome, Login, Signup, Onboarding, Roles
│   │   │   ├── candidate/     # Candidate Dashboard, Profile, Skills, Roadmap
│   │   │   ├── recruiter/     # Recruiter Dashboard, Requisitions, Applicant Funnel
│   │   │   ├── jobs/          # Swipe Deck, Job Details, Filters, Internships
│   │   │   ├── resume/        # Resume Workspace, ATS Reports, Bullet Improvement
│   │   │   └── ai/            # Career Assistant, Interview Simulator
│   │   └── widgets/
│   │       ├── common/        # Buttons, text fields, loaders, animated cards
│   │       └── editorial/     # DecisionStamp, EditorialCard, FactsMatrix2x2, Badges
│   ├── services/
│   │   ├── auth_service.dart  # Firebase Auth + local standalone session engine
│   │   └── job_service.dart   # Job ingestion, ATS parsing, and match calculations
│   ├── theme/
│   │   ├── app_theme.dart     # Legacy & base Material 3 theme definitions
│   │   └── editorial_theme.dart # Editorial Utility design tokens & typography
│   └── main.dart              # Application entrypoint with Riverpod ProviderScope
├── test/                      # Comprehensive unit and widget tests (29 passing)
├── pubspec.yaml               # Flutter dependencies and asset configuration
└── README.md                  # Project documentation
```

---

## 👨‍💻 Author

**Aman Tyagi**
* 🌐 GitHub: [@AmanTyagi-01](https://github.com/AmanTyagi-01)
* 💼 Passionate about Flutter, Mobile Architecture, Clean Code, and Applied Generative AI.

---

## 📄 License

```
Copyright 2026 Aman Tyagi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

<div align="center">
  <sub>Engineered with precision for modern multi-platform careers by Aman Tyagi.</sub>
</div>
