package com.util;

import java.util.*;

/**
 * AI Clinical Differential Diagnosis (DDx) Matrix Engine.
 * Evaluates patient symptoms, vital signs, age, and risk factors to output probability scores.
 */
public class AIDiagnosticEngine {

    public static class DiagnosisProbability {
        private String diseaseName;
        private int probabilityPercentage;
        private String riskLevel; // LOW, MODERATE, HIGH, CRITICAL
        private String clinicalRationale;
        private String recommendedAction;

        public DiagnosisProbability(String diseaseName, int probabilityPercentage, String riskLevel, String clinicalRationale, String recommendedAction) {
            this.diseaseName = diseaseName;
            this.probabilityPercentage = probabilityPercentage;
            this.riskLevel = riskLevel;
            this.clinicalRationale = clinicalRationale;
            this.recommendedAction = recommendedAction;
        }

        public String getDiseaseName() { return diseaseName; }
        public int getProbabilityPercentage() { return probabilityPercentage; }
        public String getRiskLevel() { return riskLevel; }
        public String getClinicalRationale() { return clinicalRationale; }
        public String getRecommendedAction() { return recommendedAction; }
    }

    public static List<DiagnosisProbability> evaluateDifferentialDiagnosis(List<String> symptoms, double tempF, int spo2, int pulseRate, int age) {
        List<DiagnosisProbability> results = new ArrayList<>();
        if (symptoms == null) symptoms = new ArrayList<>();

        boolean hasFever = tempF >= 100.4;
        boolean highFever = tempF >= 102.5;
        boolean lowSpo2 = spo2 < 92;
        boolean severeHypoxia = spo2 < 88;
        boolean tachycardia = pulseRate > 100;

        Set<String> sSet = new HashSet<>();
        for (String s : symptoms) sSet.add(s.toLowerCase().trim());

        // 1. Acute Respiratory Infection / Pneumonia
        if (sSet.contains("cough") || sSet.contains("shortness of breath") || lowSpo2) {
            int score = 30;
            if (lowSpo2) score += 35;
            if (severeHypoxia) score += 20;
            if (hasFever) score += 15;
            if (sSet.contains("chest pain")) score += 10;
            score = Math.min(score, 94);

            String risk = score > 75 ? "CRITICAL" : (score > 50 ? "HIGH" : "MODERATE");
            results.add(new DiagnosisProbability("Viral/Bacterial Pneumonia", score, risk,
                "Hypoxia (SpO2: " + spo2 + "%), fever, and respiratory distress indicate alveolar inflammation.",
                score > 75 ? "Immediate Chest X-Ray & ABG Analysis. Prepare High-Flow Oxygen / ICU transfer." : "Prescribe Sputum Culture & Broad-Spectrum Antibiotics."));
        }

        // 2. Acute Coronary Syndrome / Cardiac Event
        if (sSet.contains("chest pain") || sSet.contains("dizziness") || sSet.contains("sweating")) {
            int score = 25;
            if (sSet.contains("chest pain")) score += 45;
            if (sSet.contains("shortness of breath")) score += 15;
            if (tachycardia) score += 10;
            if (age > 45) score += 10;
            score = Math.min(score, 96);

            String risk = score > 70 ? "CRITICAL" : "HIGH";
            results.add(new DiagnosisProbability("Acute Coronary Syndrome (ACS)", score, risk,
                "Substernal chest pressure correlated with age (" + age + ") and tachycardia.",
                "🚨 RED-FLAG EMERGENCY: Perform Stat 12-Lead ECG & Troponin I Test immediately!"));
        }

        // 3. Dengue / Viral Hemorrhagic Fever
        if (sSet.contains("fever") || sSet.contains("headache") || sSet.contains("joint pain")) {
            int score = 20;
            if (highFever) score += 30;
            if (sSet.contains("joint pain") || sSet.contains("body ache")) score += 25;
            if (sSet.contains("rash")) score += 15;
            score = Math.min(score, 88);

            String risk = score > 65 ? "HIGH" : "MODERATE";
            results.add(new DiagnosisProbability("Dengue Hemorrhagic Fever", score, risk,
                "High grade fever (" + tempF + "°F) accompanied by retro-orbital pain and arthralgia.",
                "Order Complete Blood Count (CBC) with Platelet Count & NS1 Antigen Test. Ensure aggressive hydration."));
        }

        // 4. Sepsis / Severe Infection Alert
        if (hasFever && tachycardia && (lowSpo2 || sSet.contains("confusion"))) {
            int score = 85;
            results.add(new DiagnosisProbability("Severe Sepsis / Septic Shock Risk", score, "CRITICAL",
                "Systemic Inflammatory Response Syndrome (SIRS) criteria met: Temp " + tempF + "°F, HR " + pulseRate + " bpm.",
                "🚨 CRITICAL ALERT: Initiate Sepsis Bundle (Blood Cultures, IV Fluids, STAT Broad-Spectrum Antibiotics)."));
        }

        // Default fallback if low match
        if (results.isEmpty()) {
            results.add(new DiagnosisProbability("Acute Upper Respiratory Infection (URI)", 45, "LOW",
                "Mild symptomatic presentation without physiological deterioration.",
                "Symptomatic management, hydration, and OPD follow-up in 48 hours."));
        }

        results.sort((a, b) -> Integer.compare(b.getProbabilityPercentage(), a.getProbabilityPercentage()));
        return results;
    }
}
