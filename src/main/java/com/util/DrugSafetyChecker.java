package com.util;

import java.util.*;

/**
 * Clinical Decision Support System (CDSS) — Drug-Drug Interaction Checker.
 * Evaluates combination safety of prescribed medications.
 */
public class DrugSafetyChecker {

    public static class InteractionResult {
        private String drugA;
        private String drugB;
        private String severity; // SEVERE, MODERATE, MILD
        private String description;
        private String recommendation;

        public InteractionResult(String drugA, String drugB, String severity, String description, String recommendation) {
            this.drugA = drugA;
            this.drugB = drugB;
            this.severity = severity;
            this.description = description;
            this.recommendation = recommendation;
        }

        public String getDrugA() { return drugA; }
        public String getDrugB() { return drugB; }
        public String getSeverity() { return severity; }
        public String getDescription() { return description; }
        public String getRecommendation() { return recommendation; }
    }

    private static final List<InteractionRule> RULES = new ArrayList<>();

    private static class InteractionRule {
        String key1, key2, severity, description, recommendation;
        InteractionRule(String k1, String k2, String sev, String desc, String rec) {
            this.key1 = k1.toLowerCase();
            this.key2 = k2.toLowerCase();
            this.severity = sev;
            this.description = desc;
            this.recommendation = rec;
        }
    }

    static {
        RULES.add(new InteractionRule("aspirin", "warfarin", "SEVERE", "Combined antiplatelet and anticoagulant effects significantly increase internal bleeding risk.", "Avoid combination unless closely monitored by Hematologist. Check INR levels regularly."));
        RULES.add(new InteractionRule("metformin", "contrast", "SEVERE", "Risk of contrast-induced acute kidney injury leading to severe Lactic Acidosis.", "Discontinue Metformin 48 hours prior to contrast imaging procedure."));
        RULES.add(new InteractionRule("ibuprofen", "lisinopril", "MODERATE", "NSAIDs reduce antihypertensive efficacy of ACE inhibitors and increase renal toxicity.", "Monitor Blood Pressure and Serum Creatinine levels."));
        RULES.add(new InteractionRule("sildenafil", "nitroglycerin", "SEVERE", "Potentiation of organic nitrate-mediated vasodilation can cause life-threatening hypotension.", "ABSOLUTELY CONTRAINDICATED. Do not administer together under any circumstances."));
        RULES.add(new InteractionRule("amoxicillin", "methotrexate", "MODERATE", "Penicillins decrease renal clearance of Methotrexate, increasing risk of Methotrexate toxicity.", "Monitor CBC and hepatic enzyme levels closely."));
        RULES.add(new InteractionRule("paracetamol", "alcohol", "MODERATE", "Concurrent high doses of Acetaminophen and ethanol increase risk of Hepatotoxicity.", "Limit Paracetamol dosage to < 2000mg/day and advise cessation of alcohol."));
    }

    public static List<InteractionResult> checkInteractions(List<String> medicines) {
        List<InteractionResult> results = new ArrayList<>();
        if (medicines == null || medicines.size() < 2) return results;

        for (int i = 0; i < medicines.size(); i++) {
            for (int j = i + 1; j < medicines.size(); j++) {
                String medA = medicines.get(i).trim().toLowerCase();
                String medB = medicines.get(j).trim().toLowerCase();

                for (InteractionRule rule : RULES) {
                    if ((medA.contains(rule.key1) && medB.contains(rule.key2)) ||
                        (medA.contains(rule.key2) && medB.contains(rule.key1))) {
                        results.add(new InteractionResult(medicines.get(i), medicines.get(j), rule.severity, rule.description, rule.recommendation));
                    }
                }
            }
        }
        return results;
    }
}
