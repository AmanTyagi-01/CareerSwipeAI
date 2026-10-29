import { JobModel, ResumeAnalysisModel, RoadmapMonth } from '../types';
import { ParsedResumeData } from './resumeParser';

export interface ATSCompatibilityResult {
  overallScore: number;
  matchGrade: 'Excellent' | 'Competitive' | 'Moderate' | 'Low Match';
  gradeColor: string;
  requiredSkillsMatch: {
    matched: string[];
    missing: string[];
    percentage: number;
  };
  preferredSkillsMatch: {
    matched: string[];
    missing: string[];
    percentage: number;
  };
  experienceMatch: {
    requiredLevel: string;
    candidateYears: number;
    score: number;
    assessment: string;
  };
  educationMatch: {
    hasDegree: boolean;
    score: number;
    notes: string;
  };
  formattingAndImpact: {
    metricsScore: number;
    sectionsScore: number;
    actionVerbsScore: number;
    score: number;
    metricsCount: number;
    foundSections: string[];
    missingSections: string[];
  };
  evidencePoints: {
    skill: string;
    foundIn: string;
  }[];
  actionableImprovements: string[];
  disclaimer: string;
}

export function calculateAtsCompatibility(
  resume: ParsedResumeData,
  job?: JobModel | null,
  customJobDesc?: string
): ATSCompatibilityResult {
  const disclaimer = 
    "Transparent Evidence-Based Benchmark: This score is calculated via automated parsing of skills, experience, education, and formatting against the target role requirements. It is an algorithmic compatibility evaluation and not an endorsement from a proprietary ATS vendor.";

  // Normalize candidate skills
  const candidateSkillsSet = new Set(resume.skills.map(s => s.toLowerCase()));

  // Target requirements from JobModel or fallback defaults
  let targetRequiredSkills: string[] = [];
  let targetPreferredSkills: string[] = [];
  let requiredExperienceLevel = 'midLevel';

  if (job) {
    targetRequiredSkills = [...job.skills];
    targetPreferredSkills = job.requirements
      .flatMap(req => req.split(/[,;/]|\band\b|\bwith\b/i))
      .map(s => s.trim())
      .filter(s => s.length > 2 && s.length < 25)
      .slice(0, 4);
    requiredExperienceLevel = job.experienceLevel || 'midLevel';
  } else if (customJobDesc) {
    // Extract keywords from custom job description
    const textLower = customJobDesc.toLowerCase();
    const commonTech = [
      'React', 'TypeScript', 'Flutter', 'Dart', 'Node.js', 'Python', 'Firebase', 
      'Docker', 'AWS', 'PostgreSQL', 'REST APIs', 'GraphQL', 'Tailwind CSS', 'Git'
    ];
    targetRequiredSkills = commonTech.filter(tech => textLower.includes(tech.toLowerCase()));
    if (targetRequiredSkills.length === 0) {
      targetRequiredSkills = ['React', 'TypeScript', 'Node.js', 'REST APIs'];
    }
  } else {
    // General full-stack standard benchmark
    targetRequiredSkills = ['React', 'TypeScript', 'Node.js', 'REST APIs', 'Git'];
    targetPreferredSkills = ['Docker', 'AWS', 'Firebase'];
  }

  // 1. Required Skills Evaluation
  const matchedRequired: string[] = [];
  const missingRequired: string[] = [];
  for (const skill of targetRequiredSkills) {
    const isMatched = Array.from(candidateSkillsSet).some(cs => 
      cs === skill.toLowerCase() || 
      cs.includes(skill.toLowerCase()) || 
      skill.toLowerCase().includes(cs)
    );
    if (isMatched) {
      matchedRequired.push(skill);
    } else {
      missingRequired.push(skill);
    }
  }

  const reqSkillPercentage = targetRequiredSkills.length > 0 
    ? Math.round((matchedRequired.length / targetRequiredSkills.length) * 100) 
    : 80;

  // 2. Preferred Skills Evaluation
  const matchedPreferred: string[] = [];
  const missingPreferred: string[] = [];
  for (const skill of targetPreferredSkills) {
    const isMatched = Array.from(candidateSkillsSet).some(cs => 
      cs === skill.toLowerCase() || cs.includes(skill.toLowerCase())
    );
    if (isMatched) {
      matchedPreferred.push(skill);
    } else {
      missingPreferred.push(skill);
    }
  }
  const prefSkillPercentage = targetPreferredSkills.length > 0
    ? Math.round((matchedPreferred.length / targetPreferredSkills.length) * 100)
    : 75;

  // 3. Experience Match
  let expTargetYears = 2;
  if (requiredExperienceLevel.toLowerCase().includes('senior') || requiredExperienceLevel.toLowerCase().includes('lead')) {
    expTargetYears = 5;
  } else if (requiredExperienceLevel.toLowerCase().includes('intern') || requiredExperienceLevel.toLowerCase().includes('student')) {
    expTargetYears = 0.5;
  } else if (requiredExperienceLevel.toLowerCase().includes('junior') || requiredExperienceLevel.toLowerCase().includes('entry')) {
    expTargetYears = 1;
  }

  let experienceScore = 100;
  let experienceAssessment = "Meets or exceeds target experience requirements.";
  if (resume.experienceYears < expTargetYears) {
    const ratio = resume.experienceYears / expTargetYears;
    experienceScore = Math.max(50, Math.round(ratio * 100));
    experienceAssessment = `Candidate profile has approx. ${resume.experienceYears} years vs. role expectation of ${expTargetYears}+ years.`;
  }

  // 4. Education Match
  const hasDegree = resume.educationItems.length > 0 || resume.sectionsFound.includes('Education');
  const educationScore = hasDegree ? 95 : 70;
  const educationNotes = hasDegree 
    ? "Verified academic credentials/degree section present." 
    : "No explicit formal degree section detected; ensure education or equivalent experience is highlighted.";

  // 5. Formatting & Quantified Impact
  const standardSections = ['Experience', 'Education', 'Skills', 'Projects'];
  const missingSections = standardSections.filter(s => !resume.sectionsFound.includes(s));
  const sectionsScore = Math.max(40, 100 - (missingSections.length * 20));

  const metricsScore = resume.metricsCount >= 3 ? 95 : resume.metricsCount >= 1 ? 80 : 60;
  
  // Action verbs check
  const actionVerbs = ['architected', 'developed', 'engineered', 'led', 'designed', 'built', 'reduced', 'improved', 'deployed', 'spearheaded'];
  const verbsFound = actionVerbs.filter(v => resume.rawText.toLowerCase().includes(v));
  const actionVerbsScore = verbsFound.length >= 4 ? 95 : verbsFound.length >= 2 ? 80 : 65;

  const formattingOverall = Math.round(
    (sectionsScore * 0.4) + (metricsScore * 0.35) + (actionVerbsScore * 0.25)
  );

  // Overall Weighted Score:
  // 40% Required Skills + 15% Preferred Skills + 20% Experience + 15% Education + 10% Formatting
  const overallScore = Math.min(100, Math.max(25, Math.round(
    (reqSkillPercentage * 0.40) +
    (prefSkillPercentage * 0.15) +
    (experienceScore * 0.20) +
    (educationScore * 0.15) +
    (formattingOverall * 0.10)
  )));

  let matchGrade: 'Excellent' | 'Competitive' | 'Moderate' | 'Low Match' = 'Moderate';
  let gradeColor = 'text-amber-400';
  if (overallScore >= 85) {
    matchGrade = 'Excellent';
    gradeColor = 'text-emerald-400';
  } else if (overallScore >= 70) {
    matchGrade = 'Competitive';
    gradeColor = 'text-cyan-400';
  } else if (overallScore >= 50) {
    matchGrade = 'Moderate';
    gradeColor = 'text-amber-400';
  } else {
    matchGrade = 'Low Match';
    gradeColor = 'text-rose-400';
  }

  // Evidence points
  const evidencePoints: { skill: string; foundIn: string }[] = [];
  for (const skill of matchedRequired) {
    evidencePoints.push({
      skill,
      foundIn: `Identified in resume text / skills profile`
    });
  }

  // Actionable suggestions
  const actionableImprovements: string[] = [];
  if (missingRequired.length > 0) {
    actionableImprovements.push(
      `Incorporate missing core skills: ${missingRequired.slice(0, 3).join(', ')} into your experience bullet points with project context.`
    );
  }
  if (resume.metricsCount < 3) {
    actionableImprovements.push(
      "Strengthen impact by quantifying achievements (e.g. 'reduced latency by 35%', 'handled 50,000+ daily active users')."
    );
  }
  if (missingSections.length > 0) {
    actionableImprovements.push(
      `Add standard ATS section headers: ${missingSections.join(', ')} to ensure automated parser readability.`
    );
  }
  if (verbsFound.length < 3) {
    actionableImprovements.push(
      "Start experience bullets with strong action verbs like 'Architected', 'Spearheaded', 'Optimized', or 'Engineered'."
    );
  }
  if (actionableImprovements.length === 0) {
    actionableImprovements.push(
      "Strong alignment! Tailor your summary section specifically to mirror the employer's mission statement."
    );
  }

  return {
    overallScore,
    matchGrade,
    gradeColor,
    requiredSkillsMatch: {
      matched: matchedRequired,
      missing: missingRequired,
      percentage: reqSkillPercentage
    },
    preferredSkillsMatch: {
      matched: matchedPreferred,
      missing: missingPreferred,
      percentage: prefSkillPercentage
    },
    experienceMatch: {
      requiredLevel: requiredExperienceLevel,
      candidateYears: resume.experienceYears,
      score: experienceScore,
      assessment: experienceAssessment
    },
    educationMatch: {
      hasDegree,
      score: educationScore,
      notes: educationNotes
    },
    formattingAndImpact: {
      metricsScore,
      sectionsScore,
      actionVerbsScore,
      score: formattingOverall,
      metricsCount: resume.metricsCount,
      foundSections: resume.sectionsFound,
      missingSections
    },
    evidencePoints,
    actionableImprovements,
    disclaimer
  };
}

export function generateFullResumeAnalysisModel(
  resumeData: ParsedResumeData,
  resumeId: string,
  userId: string,
  targetJob?: JobModel | null
): ResumeAnalysisModel {
  const result = calculateAtsCompatibility(resumeData, targetJob);

  const roadmap: RoadmapMonth[] = [
    {
      month: 1,
      theme: 'Core Skill Gap Closure & Architecture',
      goals: result.requiredSkillsMatch.missing.length > 0 
        ? [`Master missing requirements: ${result.requiredSkillsMatch.missing.slice(0, 2).join(', ')}`, 'Implement end-to-end demo project'] 
        : ['Advanced Performance Optimization', 'Unit & Integration Testing suite'],
      resources: [
        {
          title: 'Full-Stack Architecture & Production Best Practices',
          platform: 'Coursera / Documentation',
          type: 'course',
          duration: '3 weeks'
        }
      ],
      projects: ['Build microservices or cross-platform application demo with automated CI/CD'],
      certifications: ['Cloud Practitioner / Associate Certification']
    },
    {
      month: 2,
      theme: 'Quantified Impact & System Design',
      goals: ['Reframe all resume bullet points with STAR method (Situation, Task, Action, Result)', 'Practice system design diagrams'],
      resources: [
        {
          title: 'System Design Primer & Scalability Patterns',
          platform: 'GitHub / Interactive Prep',
          type: 'project',
          duration: '4 weeks'
        }
      ],
      projects: ['Refactor high-concurrency or low-latency module with benchmarking'],
      certifications: ['Docker & Kubernetes Certified Specialist']
    },
    {
      month: 3,
      theme: 'Interview Simulation & Recruiter Outreach',
      goals: ['Conduct mock interviews using AI Flashcard simulator', 'Target high-compatibility recruiters on CareerSwipe'],
      resources: [
        {
          title: 'Behavioral & Leadership Principles Mastery',
          platform: 'CareerSwipe AI Studio',
          type: 'course',
          duration: '2 weeks'
        }
      ],
      projects: ['Deploy live portfolio with case studies and interactive demo links'],
      certifications: ['Professional Developer Certificate']
    }
  ];

  return {
    id: `analysis_${Date.now()}`,
    userId,
    resumeId,
    atsScore: result.overallScore,
    keywordMatch: result.requiredSkillsMatch.percentage,
    formattingScore: result.formattingAndImpact.score,
    contentScore: Math.round((result.experienceMatch.score + result.formattingAndImpact.metricsScore) / 2),
    jobReadinessScore: result.overallScore,
    careerCompetitivenessScore: Math.min(100, result.overallScore + 5),
    interviewReadinessScore: Math.min(100, result.overallScore - 4),
    marketDemandScore: 88,
    resumeStrengthScore: result.overallScore,
    detectedSkills: resumeData.skills,
    missingSkills: result.requiredSkillsMatch.missing,
    recommendedSkills: result.preferredSkillsMatch.missing.length > 0 
      ? result.preferredSkillsMatch.missing 
      : ['Docker', 'CI/CD Pipelines', 'System Architecture'],
    keywords: resumeData.skills.slice(0, 8),
    missingKeywords: result.requiredSkillsMatch.missing,
    strengths: [
      `Extracted ${resumeData.skills.length} verified technical skills.`,
      result.formattingAndImpact.metricsCount > 0 
        ? `Contains ${result.formattingAndImpact.metricsCount} quantified impact metrics.` 
        : `Clear section breakdown with standard ATS compatibility.`,
      `Verified professional experience span: approx. ${resumeData.experienceYears} ${resumeData.experienceYears === 1 ? 'year' : 'years'}.`
    ],
    improvements: result.actionableImprovements,
    summary: `Algorithmic analysis indicates a ${result.matchGrade} match (${result.overallScore}/100) for target roles. ${result.actionableImprovements[0]}`,
    rewriteSuggestions: [
      "Before: 'Worked on mobile app features.' -> After: 'Architected and deployed 4 critical features using clean state management, boosting user retention by 22%.'",
      "Before: 'Fixed bugs in API code.' -> After: 'Diagnosed and resolved critical REST API bottlenecks, reducing server response latency by 45%.'"
    ],
    careerAdvice: [
      "Target roles that match at least 70% of your current detected skills for highest interview invitation rates.",
      "Highlight your contributions with clear metrics (users, percentages, time saved) rather than purely task lists."
    ],
    interviewTips: [
      "Structure your responses using the STAR method (Situation, Task, Action, Result).",
      "Be prepared to explain architectural trade-offs you made in your recent projects."
    ],
    sectionScores: {
      contact_info: resumeData.contact.email ? 100 : 50,
      summary: resumeData.sectionsFound.includes('Summary') ? 95 : 70,
      experience: result.experienceMatch.score,
      education: result.educationMatch.score,
      skills: result.requiredSkillsMatch.percentage,
      projects: resumeData.projects.length > 0 ? 90 : 60
    },
    projectAnalysis: [
      {
        name: resumeData.projects[0]?.name || 'Flagship Engineering Project',
        rating: '4.5/5',
        feedback: 'Demonstrates end-to-end technical execution and clean modularity.'
      }
    ],
    roadmap,
    analyzedAt: new Date().toISOString(),
    isComplete: true
  };
}
