# SPEC.md — CareerSwipe AI Specification

> **Status**: `FINALIZED`
>
> ⚠️ **Planning Lock**: Verified and finalized for multi-phase execution.

## Vision
CareerSwipe AI is an AI-driven career discovery, job and internship matching, ATS intelligence, and recruitment management platform. Built on Flutter, Riverpod, and Firebase, it combines an intuitive gesture-driven discovery experience with a rigorous, publication-grade "Editorial Utility" aesthetic inspired by classic newsprint and archival design systems (Spruce Green, warm archival paper, Newsreader serif, and Inter sans-serif).

## Goals
1. **Editorial Utility Design System Alignment** — Adopt the 59-screen Stitch blueprint design tokens (Spruce green `#1E4B38`, paper surfaces `#F9F9F8` / `#FBFBFA`, Newsreader serif, Inter sans-serif, strict 3-tier radii: 4px / 8px / 16px, minimal tactile paper depth) across all themes and shared widgets.
2. **Production Firebase Integration** — Replace all mock stubs in `auth_service.dart`, `job_service.dart`, `ai_service.dart`, and `notification_service.dart` with robust Firebase Auth, Cloud Firestore, Cloud Storage, and FCM-backed implementations while preserving graceful offline/demo fallbacks.
3. **Complete Candidate Experience** — Upgrade existing 23 screens and implement missing candidate flows: internships discovery & details, multi-step ATS analysis pipeline, career assistant, skill gap analysis, career roadmap, and account management.
4. **End-to-End Recruiter Suite** — Implement the 12 recruiter screens from scratch (dashboard, job requisitions, job creation wizard, internship creation, applicant pipeline funnel, candidate dossiers, talent search pool, interview scheduling, company trust profile, hiring analytics).
5. **System & Legal Completeness** — Implement utility, global search, error/maintenance, permissions, terms of service, and privacy policy screens matching the 59-screen blueprint specification.

## Non-Goals (Out of Scope)
- Altering the core architecture (Riverpod, go_router, repository pattern).
- Creating fake mock data or synthetic AI scores with `Math.random()`.
- Unsolicited visual improvisation deviating from the `/blueprint` HTML/PNG references.

## Constraints
- **Platform**: Flutter (Android, iOS, Web, Desktop compatibility).
- **Architecture**: Riverpod state management, GoRouter navigation, Repository pattern.
- **Design Tokens**: Defined in `/blueprint/editorial_utility/DESIGN.md` (Spruce `#1E4B38`, Paper `#F9F9F8`, Hairline `#E5E5E2`, Dark Charcoal `#121314`).
- **Typography**: Newsreader (Headlines) and Inter (Body/Labels) via Google Fonts with offline fallbacks.

## Success Criteria
- [ ] Phase 0: Design system (`lib/config/theme.dart`, `lib/theme/app_theme.dart`, `lib/theme/editorial_theme.dart`) and shared widgets (`glass_card.dart`, `custom_buttons.dart`, `loading_indicator.dart`, `animated_background.dart`, `app_brand_logo.dart`) reflect Editorial Utility tokens and pass all widget tests.
- [ ] Phase 1: Authentication, job persistence, ATS document parsing/analysis, and push notification services connect to live Firebase backend with offline fallback.
- [ ] Phase 2: All 23 existing candidate and core screens comply with blueprint layouts, copy, and real data providers.
- [ ] Phase 3: Missing candidate flows (screens 16, 18-23, 27-31, 36) fully implemented.
- [ ] Phase 4: Full recruiter module (screens 37-48) constructed with live Firestore querying and state management.
- [ ] Phase 5: System, utility, and legal screens (screens 49-59) fully integrated and verified.

---
*Last updated: 2026-11-23*
