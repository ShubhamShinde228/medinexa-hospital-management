package com.feature.servlet;

import com.dao.DoctorDao;
import com.db.DBConnect;
import com.entity.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

/**
 * Intelligent Symptom-to-Doctor Recommendation Engine.
 * Analyzes selected symptoms and recommends appropriate medical specialists and doctors.
 */
@WebServlet("/symptomChecker")
public class SymptomCheckerServlet extends HttpServlet {

    private static final Map<String, String> SYMPTOM_TO_SPECIALIST_MAP = new HashMap<>();

    static {
        SYMPTOM_TO_SPECIALIST_MAP.put("chest_pain", "Cardiologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("shortness_of_breath", "Cardiologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("high_bp", "Cardiologist");
        
        SYMPTOM_TO_SPECIALIST_MAP.put("fever", "General Medicine");
        SYMPTOM_TO_SPECIALIST_MAP.put("cough", "General Medicine");
        SYMPTOM_TO_SPECIALIST_MAP.put("fatigue", "General Medicine");

        SYMPTOM_TO_SPECIALIST_MAP.put("headache", "Neurologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("dizziness", "Neurologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("seizures", "Neurologist");

        SYMPTOM_TO_SPECIALIST_MAP.put("joint_pain", "Orthopedic");
        SYMPTOM_TO_SPECIALIST_MAP.put("bone_fracture", "Orthopedic");

        SYMPTOM_TO_SPECIALIST_MAP.put("skin_rash", "Dermatologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("acne", "Dermatologist");

        SYMPTOM_TO_SPECIALIST_MAP.put("stomach_pain", "Gastroenterologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("acid_reflux", "Gastroenterologist");

        SYMPTOM_TO_SPECIALIST_MAP.put("eye_redness", "Ophthalmologist");
        SYMPTOM_TO_SPECIALIST_MAP.put("blurry_vision", "Ophthalmologist");

        SYMPTOM_TO_SPECIALIST_MAP.put("toothache", "Dentist");
        SYMPTOM_TO_SPECIALIST_MAP.put("gum_bleeding", "Dentist");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] selectedSymptoms = request.getParameterValues("symptoms");
        
        Set<String> recommendedSpecialties = new LinkedHashSet<>();
        if (selectedSymptoms != null) {
            for (String symptom : selectedSymptoms) {
                String spec = SYMPTOM_TO_SPECIALIST_MAP.get(symptom);
                if (spec != null) {
                    recommendedSpecialties.add(spec);
                }
            }
        }

        if (recommendedSpecialties.isEmpty()) {
            recommendedSpecialties.add("General Medicine");
        }

        DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
        List<Doctor> allDoctors = doctorDao.getAllDoctors();
        List<Doctor> recommendedDoctors = new ArrayList<>();

        for (Doctor doc : allDoctors) {
            if (doc.getSpecialist() != null) {
                for (String spec : recommendedSpecialties) {
                    if (doc.getSpecialist().equalsIgnoreCase(spec) || doc.getSpecialist().toLowerCase().contains(spec.toLowerCase())) {
                        recommendedDoctors.add(doc);
                        break;
                    }
                }
            }
        }

        request.setAttribute("selectedSymptoms", selectedSymptoms != null ? Arrays.asList(selectedSymptoms) : Collections.emptyList());
        request.setAttribute("recommendedSpecialties", recommendedSpecialties);
        request.setAttribute("recommendedDoctors", recommendedDoctors);

        request.getRequestDispatcher("symptom_checker.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("symptom_checker.jsp").forward(request, response);
    }
}
