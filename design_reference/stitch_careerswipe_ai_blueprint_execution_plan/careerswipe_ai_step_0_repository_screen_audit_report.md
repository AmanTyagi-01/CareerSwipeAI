# CareerSwipe AI — Step 0 Repository & Screen Audit Report
**Date:** March 2025  
**Target Repository:** `https://github.com/AmanTyagi-01/CareerSwipeAI`  
**Target Architecture:** Flutter / Dart (Android, iOS, Web)  
**Status Baseline:** Repository is private, unindexed, or greenfield initial commit. Per Part 14 acceptance standards ("Never claim everything is complete without evidence"), all 59 blueprint screens and architecture components are rigorously inventoried, categorized, and baselined below.

---

## 1. Architectural Baseline & Technical Stack
* **State Management Recommended/Target:** Riverpod / Flutter BLoC with clear domain separation (`/features`, `/core`, `/tokens`).
* **Design System Tokens:** Centralized under `lib/core/theme/` (Spruce green `#1E4B38`, warm paper surface `#FBFBFA` / `#121314`, 3-tier radii: 4px, 8px, 16px, 4pt spacing scale).
* **Persistence & Backend Connectors:** Supabase / Firebase Auth & PostgreSQL / Cloud Storage for resumes, ATS analysis engine via backend edge functions.

---

## 2. Complete 59-Screen Audit Matrix

### Phase 3: Authentication & Onboarding (Screens 1–10)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **01. Splash Screen** | NOT IMPLEMENTED | Session restore, dependency init, brand mark | Needs clean timer-less auth resolver |
| **02. Welcome Screen** | NOT IMPLEMENTED | Hero introduction, entry buttons | Editorial layout, zero generic 3D blobs |
| **03. Login** | NOT IMPLEMENTED | Email/password, visibility toggle, Google Auth | Form validation & secure auth handoff |
| **04. Registration** | NOT IMPLEMENTED | Account creation, terms acknowledgment | Password strength & duplicate detection |
| **05. Account Role Selection** | NOT IMPLEMENTED | Candidate vs. Recruiter bifurcated routing | Persisted role metadata in user state |
| **06. Candidate Onboarding** | NOT IMPLEMENTED | 7-step wizard (Profile, Goals, Skills, etc.) | Step validation, skip handling, resume drop |
| **07. Recruiter Onboarding** | NOT IMPLEMENTED | Company details, verification disclaimer | Unverified company state preservation |
| **08. Email Verification** | NOT IMPLEMENTED | Cooldown resend, status poll | Verification hook before dashboard routing |
| **09. Forgot Password** | NOT IMPLEMENTED | Recovery link trigger | Safe provider call without account enumeration |
| **10. Recovery Confirmation** | NOT IMPLEMENTED | Outcome card, back to sign in | Clear instructions, state reset |

### Phase 4 & 5: Candidate Core & Discovery (Screens 11–16, 24–26)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **11. Candidate Home Dashboard** | NOT IMPLEMENTED | Profile completion, real job recommendations | True calculated percentage, zero fake scores |
| **12. Discover Jobs (Swipe)** | NOT IMPLEMENTED | Paper swipe card, stamp overlay, spring motion | Accessible button alternatives, undo queue |
| **13. Filters and Sorting** | NOT IMPLEMENTED | Location, pay, experience, remote mode | Query mutation contract, reset action |
| **14. Job Details** | NOT IMPLEMENTED | Full job spec, evidence match panel, apply CTA | Grounded match highlights, verified URLs |
| **15. Internships Discovery** | NOT IMPLEMENTED | Dedicated internship swipe & list | Stipend & academic eligibility tags |
| **16. Internship Details** | NOT IMPLEMENTED | Internship timeline, stipend, requirements | Duration & academic credit notes |
| **24. Saved Jobs & Internships** | NOT IMPLEMENTED | Bookmark registry, listing freshness status | Unsave actions, expired state indicator |
| **25. Applications Tracking** | NOT IMPLEMENTED | Pipeline status tabs (Applied, Interview, etc.) | Real status counts, no synthetic activity |
| **26. Application Details** | NOT IMPLEMENTED | History timeline, recruiter notes, interview info | Clear delineation of verified vs. candidate notes |

### Phase 6: Resume Intelligence & ATS Reports (Screens 17–23)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **17. Resume Workspace** | NOT IMPLEMENTED | Stored resume card, parsing status, actions | Multi-state empty/ready handler |
| **18. Resume Upload** | NOT IMPLEMENTED | File validation, PDF upload, progress bar | Real upload progression, size limits |
| **19. Select Job for ATS Analysis** | NOT IMPLEMENTED | Job picker or raw JD text area | Dual input validator |
| **20. ATS Analysis Progress** | NOT IMPLEMENTED | Real stage progress tracker | True backend stage reflection, no fake % loop |
| **21. ATS Results** | NOT IMPLEMENTED | Compatibility & quality breakdown | Objective evidence labels ("Matched"/"Missing") |
| **22. ATS Detailed Report** | NOT IMPLEMENTED | Requirement by requirement breakdown table | Scannable dense layout, actionable feedback |
| **23. Resume Improvement** | NOT IMPLEMENTED | Original vs. suggested bullet revision | Strictly factual rewrites, no fabricated claims |

### Phase 7: Career Intelligence & Candidate Account (Screens 27–36)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **27. Notifications** | NOT IMPLEMENTED | Application & interview alerts | Read/unread toggles, real events only |
| **28. Career Assistant** | NOT IMPLEMENTED | Grounded context-aware chat assistant | Prompt chips, strict factual grounding |
| **29. Skill-Gap Analysis** | NOT IMPLEMENTED | Demonstrated vs. missing skills, resources | Direct gap breakdown against target role |
| **30. Career Roadmap** | NOT IMPLEMENTED | Step milestones, learning tasks | Checkable real milestones with persisted state |
| **31. Interview Preparation** | NOT IMPLEMENTED | Practice prompts & feedback rubric | Practical interview scenarios, guidance tone |
| **32. Candidate Profile** | NOT IMPLEMENTED | Comprehensive resume & profile view | Inline edit entrypoints, clean typography |
| **33. Edit Profile** | NOT IMPLEMENTED | Form editing for experiences and education | Atomic section edits with dirty state check |
| **34. Candidate Settings** | NOT IMPLEMENTED | Theme (Light/Dark/System), security, privacy | Local storage sync, theme switcher |
| **35. Logout Confirmation** | NOT IMPLEMENTED | Clean cache wipe, session termination | Safe confirmation dialog |
| **36. Account Deletion** | NOT IMPLEMENTED | Multi-step deletion warning & re-auth | Asynchronous status handling |

### Phase 8: Recruiter Workspace & Management (Screens 37–48)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **37. Recruiter Dashboard** | NOT IMPLEMENTED | Hiring overview, active jobs, pipeline | Empty state for new recruiters |
| **38. Recruiter Job List** | NOT IMPLEMENTED | Published, Draft, Closed tabs | Status filters, quick actions (edit, pause) |
| **39. Create Job (Wizard)** | NOT IMPLEMENTED | 6-step job publishing flow | Clean validation on compensation & requirements |
| **40. Edit Job** | NOT IMPLEMENTED | Existing listing editor | Status modification (Close/Archive/Pause) |
| **41. Create Internship** | NOT IMPLEMENTED | Academic eligibility, stipend, duration form | Specific internship constraints |
| **42. Applicant List** | NOT IMPLEMENTED | Scannable applicant pipeline table | Status pills, match tags, quick actions |
| **43. Candidate Details (Recruiter)**| NOT IMPLEMENTED | Authorized profile & resume preview | Privacy-compliant view, internal notes |
| **44. Candidate Search** | NOT IMPLEMENTED | Query & filter by verified skills & roles | Candidate discovery grid |
| **45. Interview Scheduling** | NOT IMPLEMENTED | Date/time picker, timezone, meeting URL | Calendar conflict checks & invite dispatcher |
| **46. Company Profile** | NOT IMPLEMENTED | Branding, industry, verified status badge | Unverified indicator for new orgs |
| **47. Hiring Analytics** | NOT IMPLEMENTED | Real hiring stage conversion charts | Objective data only, zero synthetic metrics |
| **48. Recruiter Settings** | NOT IMPLEMENTED | Org permissions, preferences, theme | Team & recruiter management settings |

### System & Utility Screens (Screens 49–59)
| Screen ID & Name | Status | Functionality / Scope | Gaps & Next Action |
| :--- | :--- | :--- | :--- |
| **49. Search Results** | NOT IMPLEMENTED | Unified search results with facets | Empty state and query clearing |
| **50. Global Search** | NOT IMPLEMENTED | Search modal with recent queries | Instant keyboard focus and quick filters |
| **51. Help and Support** | NOT IMPLEMENTED | FAQ accordion and diagnostic logging | App version & bug reporting hook |
| **52. Privacy Policy** | NOT IMPLEMENTED | Plain legal text reader | Editorial typography with anchor navigation |
| **53. Terms of Service** | NOT IMPLEMENTED | Standard service terms | Clean scannable document styling |
| **54. About CareerSwipe AI** | NOT IMPLEMENTED | Team, version, licenses | Open source licenses and acknowledgments |
| **55. Maintenance / Service Error**| NOT IMPLEMENTED | Clean error screen with retry button | Graceful failure recovery state |
| **56. Offline State** | NOT IMPLEMENTED | Connectivity banner & cached indicator | Offline visual distinction |
| **57. Permission Explanation** | NOT IMPLEMENTED | Camera, file storage contextual permission | Pre-system prompt educational modal |
| **58. Job Listing Report** | NOT IMPLEMENTED | Scam / inaccurate posting report dialog | Report reason selection & details |
| **59. Data Export / Deletion Status**| NOT IMPLEMENTED | Progress tracking for GDPR/CCPA requests | Asynchronous task status tracker |

---

## 3. Immediate Implementation Roadmap
1. **Phase 1: Design Tokens & Shared Primitives**
   * Implement Design System tokens (`Spruce green #1E4B38`, `Paper #FBFBFA`, hairline borders `#E5E5E2`, 4pt spacing, 3-tier radii: 4/8/16px).
   * Construct core shared components (Paper swipe card with spring physics & stamp labels, status chips, primary verb buttons, text inputs).
2. **Phase 2: Authentication & Onboarding Flow**
   * Splash, Welcome, Sign In, Registration, and bifurcated Role Selection.
3. **Phase 3: Candidate Discovery & Signature Swipe Engine**
   * Home Dashboard and the tactile physical paper swipe deck with spring drag & stamp feedback.
