---
milestone: Editorial Utility Transformation & Full 59-Screen Architecture
version: 2.0.0
updated: 2026-11-23
---

# Roadmap — CareerSwipe AI

> **Current Phase:** Phase 0 — Re-skin theme.dart and shared widgets
> **Status:** verifying

## Must-Haves (from SPEC)

- [x] Complete Editorial Utility design token alignment (Spruce Green, Paper, 4/8/16 Radii, Newsreader/Inter).
- [x] Shared widget redesign (GlassCard -> PaperCard tactile, PrimaryButton -> Spruce 8px, LoadingIndicator, etc.).
- [ ] Real Firebase backend integration across Auth, Jobs, ATS, Notifications.
- [ ] All 59 blueprint screens implemented with zero mock stubs.
- [x] Full automated test suite passing and static analysis clean.

---

## Phases

### Phase 0: Re-skin Design System Tokens & Shared Widgets
**Status:** ✅ Complete  
**Objective:** Rewrite `lib/config/theme.dart` and `lib/theme/app_theme.dart` to the blueprint's Editorial Utility tokens, and restyle shared widgets in `lib/presentation/widgets/common/` (`glass_card.dart`, `custom_buttons.dart`, `loading_indicator.dart`, `animated_background.dart`, `app_brand_logo.dart`).  
**Requirements:** Editorial design tokens from `blueprint/editorial_utility/DESIGN.md`.

**Plans:**
- [x] Plan 0.1: Unify `lib/config/theme.dart` and `lib/theme/app_theme.dart` to expose Editorial Utility tokens (Spruce green `#1E4B38`, Paper `#F9F9F8`, hairline `#E5E5E2`, Newsreader/Inter, 4/8/16 radii) with full backward compatibility for `AppColors` and `AppTheme`.
- [x] Plan 0.2: Restyle shared widgets (`glass_card.dart`, `custom_buttons.dart`, `loading_indicator.dart`, `animated_background.dart`, `app_brand_logo.dart`) to paper and Spruce styling.
- [x] Plan 0.3: Run static analysis and widget test suite to verify 0 regressions.

---

### Phase 1: Production Firebase & Core Services Hardening
**Status:** ⬜ Not Started  
**Objective:** Replace mocked logic in `auth_service.dart`, `job_service.dart`, `ai_service.dart`, `notification_service.dart` with real Firebase-backed implementations.  
**Depends on:** Phase 0

**Plans:**
- [ ] Plan 1.1: Firebase Auth integration in `auth_service.dart`.
- [ ] Plan 1.2: Cloud Firestore integration in `job_service.dart`.
- [ ] Plan 1.3: Real ATS analysis engine & Firebase Storage upload in `ai_service.dart` & `resume_service.dart`.
- [ ] Plan 1.4: Real FCM push notifications in `notification_service.dart`.

---

### Phase 2: Refactor 23 Existing Screens to Blueprint Specification
**Status:** ⬜ Not Started  
**Objective:** Bring all 23 existing screens up to blueprint layout, copy, typography, and live data binding.  
**Depends on:** Phase 1

---

### Phase 3: Missing Candidate Flows
**Status:** ⬜ Not Started  
**Objective:** Build missing candidate screens: internships discovery & details, multi-step ATS analysis pipeline, career assistant, skill gap details, career roadmap, account deletion.  
**Depends on:** Phase 2

---

### Phase 4: Full Recruiter Suite
**Status:** ⬜ Not Started  
**Objective:** Build all 12 recruiter screens (screens 37-48) with requisition manager, wizard, pipeline funnel, interview scheduler, and hiring analytics.  
**Depends on:** Phase 3

---

### Phase 5: System, Utility & Legal Screens
**Status:** ⬜ Not Started  
**Objective:** Build global search, error/maintenance, permissions, terms of service, and privacy policy screens (screens 49-59).  
**Depends on:** Phase 4
