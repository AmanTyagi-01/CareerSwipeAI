# CareerSwipe AI — Complete Developer Handoff & Architecture Package
**Version:** 4.11.0-SEC (Production Release)  
**Target Architecture:** Flutter / Dart (iOS, Android, Web) & WebAssembly Core  
**Design Standard:** Editorial Utility (`#1E4B38` Spruce Green, `#F9F9F8` Paper Surface, Newsreader Serif & Inter Sans)  
**Total Blueprint Screens:** 59 of 59 Delivered & Audited (100% Canvas Alignment)

---

## 1. Executive Summary & Design System Specifications

### 1.1 Color Tokens & Material Palette
```css
:root {
  /* Brand Primitives */
  --color-primary: #1E4B38;         /* Deep Spruce Green - Primary CTAs, brand emblems */
  --color-primary-container: #2A634D;
  --color-on-primary: #FFFFFF;
  --color-primary-light: #EBF3EE;   /* Subtle Spruce tint for highlights & active pills */

  /* Neutral Paper Surfaces (Light Mode / Editorial Baseline) */
  --color-surface: #F9F9F8;         /* Warm archival paper background */
  --color-surface-dim: #DADAD9;
  --color-surface-bright: #FFFFFF;
  --color-surface-container-lowest: #FFFFFF;
  --color-surface-container-low: #F3F4F3;
  --color-surface-container-mid: #ECECEC;
  --color-surface-container-high: #E3E4E3;

  /* Typography Colors */
  --color-on-surface: #191C1B;      /* Primary text (high legibility) */
  --color-on-surface-variant: #424945; /* Secondary captions & metadata */
  --color-outline: #717974;         /* Hairline separators & border strokes */
  --color-outline-variant: #C2C8C3;

  /* Semantic Alerts & Signals */
  --color-success: #1B5E20;         /* Verified commit / SLA passed */
  --color-success-container: #C8E6C9;
  --color-warning: #B78103;         /* Pending SLA / 18h window */
  --color-danger: #BA1A1A;          /* Account shred / Irreversible purge */
  --color-danger-container: #FFDAD6;
}
```

### 1.2 Typography Hierarchy
* **Primary Editorial Display & Headings:** `Newsreader` (Google Fonts, serif, optical size 6pt–72pt).
  * Headline Large: `font-serif font-normal text-3xl tracking-tight leading-snug` (Titles, Screen names)
  * Headline Medium: `font-serif font-normal text-2xl tracking-normal` (Section banners, card titles)
  * Headline Small: `font-serif font-medium text-xl leading-normal`
* **Functional UI, Inputs, Body & Data:** `Inter` (sans-serif, weights 400, 500, 600, 700).
  * Body Regular: `font-sans text-sm leading-relaxed text-on-surface-variant`
  * UI Accent / Label: `font-sans text-xs font-semibold tracking-wide uppercase`
* **Telemetry, Audit Hashes & Tokens:** `JetBrains Mono` / `SF Mono` (monospace).
  * Hashes & Shas: `font-mono text-xs tracking-wider text-outline`

### 1.3 Layout & Elevation Rules
* **Grid Base:** 4pt / 8pt hard rhythm (`p-2`, `p-4`, `p-6`, `gap-3`, `gap-4`).
* **Radius Hierarchy:**
  * Micro (Chips, Pills, Badges): `rounded-full` or `rounded-md` (`4px–6px`)
  * Standard Components (Cards, Textareas, Inputs): `rounded-lg` (`8px`)
  * Large Floating Modules (Swipe Deck cards, Bottom Sheets): `rounded-2xl` (`16px`)
* **Shadows:** Minimal, paper-like tactile depth (`0 1px 3px rgba(0,0,0,0.06)`, `0 4px 12px rgba(0,0,0,0.04)`). Zero excessive glowing gradients.

---

## 2. Complete 59-Screen Routing Tree & State Architecture

### Group A: Phase 3 — Authentication & Onboarding (Screens 1–10)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **01** | `Splash Screen — CareerSwipe AI` | Mobile Blank | `/auth/splash` | `AuthStatusNotifier`, WebAssembly enclave warm-up |
| **02** | `Welcome — CareerSwipe AI` | Mobile Stack | `/auth/welcome` | Onboarding entrypoint, role selector dispatch |
| **03** | `Sign In — Candidate Dossier` | Mobile Stack | `/auth/login` | Google SSO, OAuth WebAuthn seed, TLS handshake audit |
| **04** | `Candidate Registration — CareerSwipe AI`| Mobile Blank | `/auth/register` | Password entropy validator, domain attestation |
| **05** | `Account Role Selection` | Mobile Stack | `/auth/role-select` | Bifurcated state: `Role.candidate` vs `Role.recruiter` |
| **06** | `Candidate Onboarding — Skills Step` | Mobile Stack | `/onboarding/candidate` | Step 3 of 7 wizard, skill ledger chips, no synthetic dials |
| **07** | `Recruiter Onboarding — Org Setup` | Mobile Stack | `/onboarding/recruiter` | Corporate domain matching, unverified badge init |
| **08** | `Email Verification — Security Token` | Mobile Stack | `/auth/verify-token` | 6-digit cryptographic PIN buffer, 60s cooldown timer |
| **09** | `Forgot Password — Account Recovery` | Mobile Stack | `/auth/forgot-password` | Non-enumerating credential dispatch |
| **10** | `Recovery Confirmation — Token Dispatched`| Mobile Stack | `/auth/recovery-confirm`| 1-time handshake instructions & status banner |

### Group B: Phase 4 & 5 — Candidate Discovery & Tracking (Screens 11–16, 24–26)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **11** | `Candidate Home Dashboard` | Mobile Tab | `/candidate/home` | 78% profile strength metric, immediate match feed |
| **12** | `Discover Jobs — Swipe Deck` | Mobile Tab | `/candidate/swipe` | Physical paper card, spring kinematics, 2x2 facts grid |
| **13** | `Filters & Sorting` | Mobile Stack | `/candidate/filters` | Tri-state switches (Remote/EU/Comp), keyword tags |
| **14** | `Job Details — Senior Backend Engineer` | Mobile Stack | `/candidate/job/:id` | Grounded match citations, fixed bottom action bar |
| **15** | `Internships Discovery` | Mobile Tab | `/candidate/internships`| Stipend filter, academic eligibility validators |
| **16** | `Internship Details — Cloudflare Research`| Mobile Stack | `/candidate/internship/:id`| €3,800/mo stipend + housing, 30 ECTS credits, mentor pairing |
| **24** | `Saved Jobs & Internships` | Mobile Tab | `/candidate/saved` | Expiration watchdogs, offline sync ledger |
| **25** | `Applications Tracking` | Mobile Tab | `/candidate/applications`| Multi-stage timeline (Applied, Screened, Panel, Offer) |
| **26** | `Application Details — Stripe` | Mobile Stack | `/candidate/application/:id`| Recruiter audit notes vs. private candidate scratchpad |

### Group C: Phase 6 — Resume Intelligence & ATS Reports (Screens 17–23)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **17** | `Resume Workspace & Versioning` | Mobile Tab | `/resume/workspace` | Multi-version LaTeX / PDF repository ledger |
| **18** | `Resume Upload & Dossier Ingestion` | Mobile Stack | `/resume/upload` | Drag-and-drop Wasm parser, local AST extraction |
| **19** | `Select Job for ATS Analysis` | Mobile Stack | `/ats/select-job` | Requisition selector vs raw job description textarea |
| **20** | `ATS Analysis Progress Tracker` | Mobile Stack | `/ats/progress` | 4-stage pipeline telemetry, stdout extraction logs |
| **21** | `ATS Match Results & Breakdown` | Mobile Stack | `/ats/results/:id` | 7/9 verified requirements, gap pills, score attribution |
| **22** | `ATS Detailed Report — Stripe Systems` | Mobile Stack | `/ats/report/:id` | Dense requirement comparison matrix, citations |
| **23** | `Resume Improvement — Factual Bullet Revisions` | Mobile Stack | `/resume/revisions` | Git commit-grounded bullet enhancement, patch generator |

### Group D: Phase 7 — Career Intelligence & Candidate Account (Screens 27–36)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **27** | `Notifications Center — CareerSwipe AI` | Mobile Stack | `/notifications` | 48-hour interview windows, ATS gap alerts, SLA pings |
| **28** | `Career Assistant — Interview Prep` | Mobile Chat | `/assistant/chat` | Grounded context-aware LLM, zero hallucinated tips |
| **29** | `Skill-Gap Analysis — Stripe Systems` | Mobile Tab | `/candidate/skill-gap`| Objective AST alignment deficit drills (gRPC / Raft) |
| **30** | `Career Roadmap — Alex Vance` | Mobile Tab | `/candidate/roadmap` | Milestone index (64%), L6 principal engineer track |
| **31** | `Interview Preparation — Stripe Simulation`| Mobile Tab | `/candidate/interview-prep`| Idempotency scenario, scoring rubric evaluation |
| **32** | `Candidate Profile & Verified Skills` | Mobile Tab | `/candidate/profile` | Public cryptographic dossier, attested GitHub commits |
| **33** | `Edit Profile — Candidate Dossier` | Mobile Stack | `/candidate/profile/edit`| Dirty-state tracker, blind PII evaluation toggle |
| **34** | `Candidate Settings & Privacy` | Mobile Stack | `/candidate/settings` | EU pay threshold strict filter, zero synthetic AI toggle |
| **35** | `Logout Confirmation — CareerSwipe AI` | Mobile Stack | `/auth/logout` | Hardware session teardown, ephemeral key purge |
| **36** | `Account Deletion — CareerSwipe AI` | Mobile Stack | `/account/delete` | GDPR Art. 17 cryptographic shred, confirmation phrase |

### Group E: Phase 8 — Recruiter Workspace & Management (Screens 37–48)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **37** | `Recruiter Dashboard — Stripe EMEA` | Mobile Tab | `/recruiter/dashboard` | Active candidate pipeline, schedule, 48h SLA relay |
| **38** | `Recruiter Job Postings — Stripe EMEA` | Mobile Tab | `/recruiter/jobs` | Published, Draft, Closed tabs; candidate velocity |
| **39** | `Create Job Requisition — Step 3` | Mobile Stack | `/recruiter/jobs/create`| Pay transparency validator (<=25% delta), algorithmic weights |
| **40** | `Edit Job Requisition — Manager` | Mobile Stack | `/recruiter/jobs/edit/:id`| Live job editor, pause/duplicate/close, audit history |
| **41** | `Create Internship — Fellowships` | Mobile Stack | `/recruiter/internship/create`| Guaranteed living stipend (€4,200/mo), 30 ECTS credits |
| **42** | `Applicant Pipeline — Senior Backend` | Mobile Tab | `/recruiter/pipeline/:jobId`| Scannable candidate data grid, stage filter, CSV export |
| **43** | `Candidate Details — Recruiter View` | Mobile Stack | `/recruiter/candidate/:id`| Commit provenance inspector, comp ledger, internal notes |
| **44** | `Candidate Search & Talent Pool` | Mobile Tab | `/recruiter/search` | Syntactic parser (`Go AND Raft`), batch invite triggers |
| **45** | `Interview Scheduling — Tech Round` | Mobile Stack | `/recruiter/schedule/:id`| Timezone synchronization, Google Meet bridge, RFC 5545 |
| **46** | `Company Profile & Trust Verification`| Mobile Tab | `/recruiter/company` | Tier 1 badge, EU pay transparency pledge, seat manager |
| **47** | `Hiring Analytics & Pipeline Funnel` | Mobile Tab | `/recruiter/analytics` | Deterministic funnel without synthetic conversions |
| **48** | `Recruiter Workspace Settings` | Mobile Tab | `/recruiter/settings` | Consolidated in Company Profile & Trust Settings |

### Group F: System, Legal & Utility Screens (Screens 49–59)
| Screen # | Screen Title | Device / Type | Route Path | Core State & Services |
| :--- | :--- | :--- | :--- | :--- |
| **49** | `Search Results — CareerSwipe AI` | Mobile Tab | `/search/results` | Query syntax chips, multi-facet count badges |
| **50** | `Global Search — CareerSwipe AI` | Mobile Blank | `/search/global` | Full-screen modal, recent queries with dismiss, trending nodes |
| **51** | `Help & Support — CareerSwipe AI` | Mobile Stack | `/support` | Protocol FAQ accordion, diagnostic telemetry snapshot |
| **52** | `Privacy Policy — CareerSwipe AI` | Mobile Stack | `/legal/privacy` | Editorial reader, anchor pills, DPO contact, GDPR 13/14 |
| **53** | `Terms of Service & Candidate Covenant`| Mobile Stack | `/legal/terms` | 48h SLA clause, anti-ghosting penalty, SHA-256 seal |
| **54** | `About CareerSwipe AI` | Mobile Stack | `/about` | Enclave mesh latency telemetry, architecture specs matrix |
| **55** | `Service Maintenance & Error (ERR-503)`| Mobile Stack | `/error/503` | Enclave sync breakdown, retry handshake CTA |
| **56** | `Offline State & Cached Storage` | Mobile Stack | `/error/offline` | Cached dossier access banner, local storage decryptor |
| **57** | `Permission Explanation Advisory` | Mobile Stack | `/permissions/advisory`| Pre-permission educational dialogs (Wasm, Git, Biometrics) |
| **58** | `Job Listing Report Dialog` | Mobile Stack | `/job/report` | Modal dialog for reporting fraudulent / ghost listings |
| **59** | `Data Export / Deletion Status` | Mobile Stack | `/account/export-status`| Asynchronous cryptographic task ledger tracker |

---

## 3. Core Component Architectures

### 3.1 The Signature Swipe Card (`JobCard`)
```dart
class JobSwipeCard extends StatelessWidget {
  final JobPosting requisition;
  final VoidCallback onSwipeRight; // Apply via Vault
  final VoidCallback onSwipeLeft;  // Pass / Skip
  final VoidCallback onSave;

  const JobSwipeCard({
    required this.requisition,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Company Logo, Match Index Pill (e.g. 96.4% Match), Verified Commit Stamp
          _buildCardHeader(context),
          // Editorial Role Title in Newsreader serif
          _buildRoleTitle(requisition.title),
          // 2x2 Fact Matrix: Guaranteed Base Comp, Location / Hub, Team Size, Ingress SLA
          _buildFactsMatrix(requisition),
          // Verified Tech Stack Chips (Go, Raft, CockroachDB)
          _buildSkillChips(requisition.requiredSkills),
          const Spacer(),
          // Tactile Action Toolbar: Discard (X), Bookmark, Vault Apply (Checkmark)
          _buildActionToolbar(context),
        ],
      ),
    );
  }
}
```

### 3.2 Provenance & Match Breakdown Pill
```html
<!-- Reusable Signal Fit Tag -->
<div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-50 border border-emerald-200">
  <span class="w-1.5 h-1.5 rounded-full bg-emerald-600 animate-pulse"></span>
  <span class="font-sans text-xs font-semibold text-emerald-900 tracking-wide">
    94.8% SIGNAL MATCH · STAGE 3: TECH PANEL
  </span>
</div>
```

---

## 4. API & Data Contracts

### 4.1 Candidate Dossier Payload (JSON Schema)
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "CandidateDossier",
  "type": "object",
  "properties": {
    "candidate_id": { "type": "string", "pattern": "^CAN-[0-9]{4}-[A-Z]{3}$" },
    "gpg_fingerprint": { "type": "string" },
    "verified_name": { "type": "string" },
    "target_role": { "type": "string" },
    "compensation_floor_eur": { "type": "integer", "minimum": 50000 },
    "strict_comp_filter": { "type": "boolean" },
    "mobility_tier": { "type": "string", "enum": ["EU_CITIZEN", "UK_SETTLED", "US_REMOTE"] },
    "verified_commits_count": { "type": "integer" },
    "repositories": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "repo_url": { "type": "string" },
          "attested_prs": { "type": "integer" },
          "primary_language": { "type": "string" },
          "architecture_focus": { "type": "string" }
        }
      }
    },
    "anonymize_pii_for_screening": { "type": "boolean" }
  },
  "required": ["candidate_id", "gpg_fingerprint", "compensation_floor_eur", "strict_comp_filter"]
}
```

### 4.2 Requisition & SLA Enforcement Contract
```json
{
  "requisition_id": "REQ-IRE-409",
  "hiring_entity": "Stripe Ireland Ltd.",
  "entity_id": "IE9827341M",
  "base_salary_eur": {
    "min": 115000,
    "max": 140000,
    "spread_delta_percent": 21.74,
    "eu_directive_2023_970_compliant": true
  },
  "zero_ghosting_sla": {
    "response_window_hours": 48,
    "breach_penalty": "TIER_ROUTING_SUSPENSION",
    "enforced": true
  },
  "algorithmic_weights": {
    "raft_paxos_consensus": "CRITICAL",
    "go_concurrency": "HIGH_PRIORITY",
    "db_sharding": "HIGH_PRIORITY"
  }
}
```

---

## 5. Security, GDPR & Statutory Compliance Guarantees
1. **Zero-Synthetic AI Pledge:** No candidate resumes or telemetry are ever leaked, indexed, or used to fine-tune foundation LLMs.
2. **Ephemeral WebAssembly Parsing:** Resumes in PDF or LaTeX formats are parsed locally on the client device inside a sandboxed Wasm module. Raw documents are never retained on remote servers.
3. **Cryptographic Account Shred (GDPR Art. 17):** Irreversible cryptographic key purge destroying master dossiers across all enclave relays within 120 seconds of user initiation.
4. **Pay Transparency (EU Directive 2023/970):** All salary ranges are certified with a maximum spread delta $\le 25\%$ prior to posting broadcast.
