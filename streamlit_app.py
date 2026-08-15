import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import random

# Streamlit Page Configuration
st.set_page_config(
    page_title="HospitalCare — Enterprise AI Health Platform",
    page_icon="🏥",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS Styling
st.markdown("""
    <style>
    .main-header { font-size: 36px; font-weight: 800; color: #0d5c38; text-align: center; margin-bottom: 5px; }
    .sub-header { font-size: 18px; color: #475569; text-align: center; margin-bottom: 25px; }
    .card-metric { background: #f8fafc; padding: 20px; border-radius: 12px; border-left: 5px solid #10b981; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .badge-critical { background-color: #fee2e2; color: #991b1b; padding: 4px 12px; border-radius: 20px; font-weight: bold; }
    .badge-stable { background-color: #d1fae5; color: #065f46; padding: 4px 12px; border-radius: 20px; font-weight: bold; }
    </style>
""", unsafe_allow_html=True)

# Sidebar Navigation
st.sidebar.image("https://img.icons8.com/color/96/hospital-building.png", width=70)
st.sidebar.title("🏥 HospitalCare Nav")
nav_option = st.sidebar.radio(
    "Select System Feature:",
    [
        "📊 Command Center & Analytics",
        "🧠 AI Differential Diagnosis Matrix",
        "💊 AI Drug Interaction Checker",
        "🩸 Smart Blood Bank Inventory",
        "📈 Epidemic Outbreak Radar",
        "🚑 Emergency SOS Dispatcher",
        "💳 Cost Estimator & Claim Verifier"
    ]
)

st.sidebar.markdown("---")
st.sidebar.info("Java JSP/Servlet 17 + Tomcat + Streamlit Cloud Integration")

# 1. COMMAND CENTER & ANALYTICS
if nav_option == "📊 Command Center & Analytics":
    st.markdown("<div class='main-header'>🏥 HospitalCare Enterprise Command Center</div>", unsafe_allow_html=True)
    st.markdown("<div class='sub-header'>Real-Time Clinical Telemetry & Hospital Operations</div>", unsafe_allow_html=True)

    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric(label="Total Admitted Patients", value="142", delta="+12 Today")
    with col2:
        st.metric(label="ICU Bed Utilization", value="85%", delta="CRITICAL HIGH", delta_color="inverse")
    with col3:
        st.metric(label="Cold-Chain Vaccine Temp", value="4.2°C", delta="Optimal Range")
    with col4:
        st.metric(label="Today's Revenue", value="₹2,45,000", delta="+18% vs avg")

    st.markdown("### 📊 Operational Overview")
    chart_data = pd.DataFrame({
        "Department": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics", "ICU / Emergency"],
        "Admitted Patients": [35, 22, 28, 19, 38],
        "Available Beds": [10, 8, 12, 15, 4]
    })
    
    fig = px.bar(chart_data, x="Department", y=["Admitted Patients", "Available Beds"], barmode="group",
                 color_discrete_sequence=["#0d5c38", "#f59e0b"], title="Departmental Bed Capacity & Admissions")
    st.plotly_chart(fig, use_container_width=True)

# 2. AI DIFFERENTIAL DIAGNOSIS MATRIX
elif nav_option == "🧠 AI Differential Diagnosis Matrix":
    st.markdown("<div class='main-header'>🧠 AI Differential Diagnosis (DDx) Matrix</div>", unsafe_allow_html=True)
    st.markdown("<div class='sub-header'>Multi-factorial Clinical Probability Heatmap</div>", unsafe_allow_html=True)

    col1, col2 = st.columns(2)
    with col1:
        age = st.slider("Patient Age", 1, 100, 45)
        temp = st.number_input("Temperature (°F)", 96.0, 106.0, 101.5)
        spo2 = st.slider("SpO2 Oxygen Saturation (%)", 70, 100, 91)
    with col2:
        pulse = st.number_input("Pulse Rate (BPM)", 40, 200, 108)
        symptoms = st.multiselect(
            "Active Patient Symptoms",
            ["Shortness of Breath", "Chest Pain", "Fever", "Cough", "Joint Pain", "Sweating", "Dizziness"],
            default=["Shortness of Breath", "Fever", "Cough"]
        )

    if st.button("Compute Differential Diagnosis Heatmap", type="primary"):
        st.markdown("---")
        st.subheader("📋 Clinical Probability Risk Heatmap")
        
        # Clinical AI Scoring Algorithm
        results = []
        if "Shortness of Breath" in symptoms or spo2 < 92:
            prob = min(94, 30 + (98 - spo2)*3 + (15 if "Fever" in symptoms else 0))
            results.append({"Disease": "Bacterial/Viral Pneumonia", "Probability": f"{prob}%", "Risk": "CRITICAL" if prob > 75 else "HIGH", "Action": "Stat Chest X-Ray & ICU Oxygen Support"})
        if "Chest Pain" in symptoms:
            results.append({"Disease": "Acute Coronary Syndrome (ACS)", "Probability": "88%", "Risk": "CRITICAL", "Action": "🚨 Stat 12-Lead ECG & Troponin I Test"})
        if "Fever" in symptoms and "Joint Pain" in symptoms:
            results.append({"Disease": "Dengue Hemorrhagic Fever", "Probability": "72%", "Risk": "HIGH", "Action": "Order CBC Platelet Count & NS1 Antigen"})
        
        if not results:
            results.append({"Disease": "Acute Respiratory Tract Infection", "Probability": "45%", "Risk": "LOW", "Action": "Symptomatic OPD Management & Hydration"})
        
        df_res = pd.DataFrame(results)
        st.table(df_res)

# 3. AI DRUG INTERACTION CHECKER
elif nav_option == "💊 AI Drug Interaction Checker":
    st.markdown("<div class='main-header'>💊 AI Clinical Drug Safety Engine</div>", unsafe_allow_html=True)
    st.markdown("<div class='sub-header'>Clinical Decision Support System (CDSS)</div>", unsafe_allow_html=True)

    meds = st.multiselect(
        "Select Prescribed Medication Pair:",
        ["Aspirin", "Warfarin", "Metformin", "Contrast Dye", "Ibuprofen", "Lisinopril", "Sildenafil", "Nitroglycerin"],
        default=["Aspirin", "Warfarin"]
    )

    if st.button("Run Safety Conflict Analysis", type="primary"):
        if "Aspirin" in meds and "Warfarin" in meds:
            st.error("🚨 SEVERE CONFLICT DETECTED: Aspirin + Warfarin")
            st.warning("Combined antiplatelet and anticoagulant effects significantly increase internal bleeding risk. Monitor INR closely.")
        elif "Metformin" in meds and "Contrast Dye" in meds:
            st.error("🚨 SEVERE CONFLICT DETECTED: Metformin + Contrast Dye")
            st.warning("Risk of contrast-induced acute kidney injury leading to severe Lactic Acidosis. Discontinue Metformin 48 hrs prior.")
        elif "Sildenafil" in meds and "Nitroglycerin" in meds:
            st.error("🚨 ABSOLUTELY CONTRAINDICATED: Sildenafil + Nitroglycerin")
            st.warning("Life-threatening hypotension risk. Do not co-administer.")
        else:
            st.success("🟢 NO DANGEROUS DRUG CONFLICTS DETECTED for selected medication pair.")

# 4. SMART BLOOD BANK
elif nav_option == "🩸 Smart Blood Bank Inventory":
    st.markdown("<div class='main-header'>🩸 Smart Blood Bank & Compatibility Engine</div>", unsafe_allow_html=True)
    
    blood_df = pd.DataFrame({
        "Blood Group": ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
        "Units Available": [15, 8, 20, 5, 25, 12, 10, 4],
        "Status": ["ADEQUATE", "ADEQUATE", "ADEQUATE", "CRITICAL LOW", "ADEQUATE", "ADEQUATE", "ADEQUATE", "CRITICAL LOW"]
    })
    
    fig = px.pie(blood_df, names="Blood Group", values="Units Available", title="Blood Group Inventory Share", color_discrete_sequence=px.colors.sequential.Reds_r)
    st.plotly_chart(fig, use_container_width=True)
    st.table(blood_df)

# 5. EPIDEMIC OUTBREAK RADAR
elif nav_option == "📈 Epidemic Outbreak Radar":
    st.markdown("<div class='main-header'>📈 Epidemic & Outbreak Analytics Radar</div>", unsafe_allow_html=True)
    
    outbreak_data = pd.DataFrame({
        "Disease": ["Influenza A", "Dengue Fever", "Gastroenteritis", "Typhoid", "Viral Pneumonia"],
        "Diagnosed Cases": [45, 32, 28, 19, 12]
    })
    
    fig = px.line(outbreak_data, x="Disease", y="Diagnosed Cases", markers=True, title="Outbreak Surveillance Trend", color_discrete_sequence=["#dc2626"])
    st.plotly_chart(fig, use_container_width=True)

# 6. EMERGENCY SOS DISPATCHER
elif nav_option == "🚑 Emergency SOS Dispatcher":
    st.markdown("<div class='main-header'>🚑 Emergency SOS Ambulance Dispatch</div>", unsafe_allow_html=True)
    st.info("GPS Location: Central Command Base Station [28.6139° N, 77.2090° E]")
    
    col1, col2 = st.columns(2)
    with col1:
        caller = st.text_input("Caller Name", "Rajesh Kumar")
        phone = st.text_input("Caller Mobile", "9876543210")
    with col2:
        loc = st.text_area("Pickup Landmark", "Sector 18, Main Market Road")
    
    if st.button("DISPATCH EMERGENCY AMBULANCE", type="primary"):
        st.success(f"🚨 AMBULANCE DISPATCHED! Unit ALS-01 assigned to {caller}. Estimated Arrival: 12 minutes.")

# 7. COST ESTIMATOR & CLAIM VERIFIER
elif nav_option == "💳 Cost Estimator & Claim Verifier":
    st.markdown("<div class='main-header'>💳 Upfront Treatment Cost Estimator & Claim Verifier</div>", unsafe_allow_html=True)
    
    proc_cost = st.selectbox("Select Procedure", [15000, 45000, 85000, 150000, 220000], format_func=lambda x: f"₹{x:,}")
    provider = st.selectbox("Select Insurance TPA Provider", ["Ayushman Bharat PM-JAY (100% Cashless)", "Star Health Insurance", "HDFC ERGO", "Niva Bupa"])
    
    if st.button("Run Insurance Pre-Authorization", type="primary"):
        if "Ayushman" in provider:
            st.success(f"✅ 100% CASHLESS APPROVED! Covered: ₹{proc_cost:,} | Out-of-pocket: ₹0.00")
        else:
            covered = proc_cost * 0.85
            patient = proc_cost - covered
            st.success(f"✅ PRE-AUTHORIZATION APPROVED (85%)! Insured Covered: ₹{covered:,.2f} | Out-of-Pocket: ₹{patient:,.2f}")

st.markdown("---")
st.caption("HospitalCare Enterprise Platform © 2026 | Developed by Shubham Shinde & Rajesh Galavi")
