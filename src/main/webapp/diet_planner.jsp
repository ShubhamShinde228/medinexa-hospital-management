<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Clinical Nutrition & Diet Planner — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #ecfdf5; }
        .hero-diet { background: linear-gradient(135deg, #059669 0%, #047857 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-diet { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .meal-box { background: #f0fdf4; border: 1px solid #a7f3d0; border-radius: 12px; padding: 16px; margin-bottom: 12px; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-diet">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-carrot me-2"></i> AI Clinical Recovery Diet & Nutrition Planner</h1>
        <p class="fs-5 opacity-75 mb-0">Customized therapeutic clinical meal plans tailored for patient recovery</p>
    </div>
</div>

<div class="container mb-5">
    <div class="card-diet">
        <h4 class="fw-bold text-success mb-3"><i class="fas fa-utensils me-2"></i>Generate Therapeutic Patient Meal Plan</h4>
        
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label fw-semibold">Primary Medical Condition / Diagnosis</label>
                <select id="conditionSelect" class="form-select form-select-lg" onchange="generateDietPlan()">
                    <option value="">— Select Diagnosis —</option>
                    <option value="DIABETES">Type 2 Diabetes / Glycemic Control</option>
                    <option value="HYPERTENSION">Hypertension / Cardiac DASH Diet</option>
                    <option value="POST_SURGERY">Post-Surgery Wound Healing & Recovery</option>
                    <option value="RENAL">Chronic Kidney / Renal Disease Care</option>
                    <option value="IMMUNITY">General Immunity & Wellness Booster</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-semibold">Daily Caloric Target</label>
                <select id="calorieSelect" class="form-select form-select-lg" onchange="generateDietPlan()">
                    <option value="1500">1,500 kcal / day (Weight/Glycemic Control)</option>
                    <option value="1800" selected>1,800 kcal / day (Standard Maintenance)</option>
                    <option value="2200">2,200 kcal / day (Post-Op Anabolic Recovery)</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Output Meal Plan Grid -->
    <div id="dietPlanOutput" class="card-diet" style="display:none;">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h4 class="fw-bold text-success mb-1" id="planTitle">Customized 7-Day Clinical Nutrition Plan</h4>
                <small class="text-muted" id="planSubtitle"></small>
            </div>
            <button type="button" onclick="window.print()" class="btn btn-outline-success fw-bold rounded-pill px-4">
                <i class="fas fa-print me-1"></i> Print Clinical Diet Sheet
            </button>
        </div>

        <div class="row g-3">
            <div class="col-md-4">
                <div class="meal-box">
                    <h5 class="fw-bold text-success"><i class="fas fa-sun me-2"></i>Breakfast (08:00 AM)</h5>
                    <p id="breakfastText" class="mb-0 text-dark fw-semibold"></p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="meal-box">
                    <h5 class="fw-bold text-success"><i class="fas fa-cloud-sun me-2"></i>Lunch (01:00 PM)</h5>
                    <p id="lunchText" class="mb-0 text-dark fw-semibold"></p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="meal-box">
                    <h5 class="fw-bold text-success"><i class="fas fa-moon me-2"></i>Dinner (08:00 PM)</h5>
                    <p id="dinnerText" class="mb-0 text-dark fw-semibold"></p>
                </div>
            </div>
        </div>

        <div class="p-3 border border-warning rounded-3 bg-warning-subtle mt-4">
            <h6 class="fw-bold text-dark mb-1"><i class="fas fa-exclamation-triangle me-1"></i> Dietary Restrictions & Guidelines:</h6>
            <p id="restrictionText" class="mb-0 text-dark small"></p>
        </div>
    </div>
</div>

<script>
    const dietPlans = {
        DIABETES: {
            title: "Glycemic Control & Low Carb Therapy Plan",
            subtitle: "Focus: Complex carbohydrates, high soluble fiber, low glycemic index foods.",
            breakfast: "Steel-cut oats with cinnamon & chia seeds + 2 boiled egg whites + Green Tea.",
            lunch: "Brown rice / Whole wheat roti + Dal + Grilled Spinach tofu / chicken salad.",
            dinner: "Clear vegetable soup + Steamed broccoli + Grilled fish or paneer.",
            restrictions: "Strictly avoid refined sugars, white bread, sodas, and high-GI tropical fruits."
        },
        HYPERTENSION: {
            title: "DASH Low Sodium Cardiac Health Plan",
            subtitle: "Focus: Sodium < 1,500mg/day, high Potassium & Magnesium for BP regulation.",
            breakfast: "Avocado toast on multigrain bread + Handful of unsalted almonds + Skim milk.",
            lunch: "Lentil soup + Quinoa salad with cucumber & pomegranate + Baked vegetables.",
            dinner: "Mixed vegetable curry + Ragi roti + Low-fat yogurt.",
            restrictions: "Strictly limit added table salt, processed canned foods, pickles, and salty snacks."
        },
        POST_SURGERY: {
            title: "High Protein Post-Op Wound Healing Plan",
            subtitle: "Focus: Collagen synthesis, tissue repair, Vitamin C & Zinc supplementation.",
            breakfast: "3-egg omelet with spinach & tomatoes + Fresh orange juice + Whole grain toast.",
            lunch: "High protein dal / Chicken breast stew + Sweet potato mash + Sprouts salad.",
            dinner: "Paneer / Lean meat soup + Steamed asparagus + Warm turmeric milk.",
            restrictions: "Avoid empty calorie junk food; ensure minimum 1.5g protein per kg body weight."
        },
        RENAL: {
            title: "Renal Failure & Controlled Electrolyte Care Plan",
            subtitle: "Focus: Controlled Potassium, Phosphorus, and Fluid intake management.",
            breakfast: "White rice porridge / White toast with apple sauce + Cranberry juice.",
            lunch: "Leached vegetables curry + White rice + Small portion boiled egg white.",
            dinner: "Clear bottle gourd soup + Thin wheat chapati + Low potassium salad.",
            restrictions: "Strictly avoid high potassium foods (bananas, potatoes, tomatoes) and high phosphorus dairy."
        },
        IMMUNITY: {
            title: "Immune System & Micronutrient Booster Plan",
            subtitle: "Focus: Antioxidants, Zinc, Vitamin C, Vitamin D, and gut-microbiome gut health.",
            breakfast: "Greek yogurt bowl with berries, flaxseeds, and honey + Ginger lemon tea.",
            lunch: "Mixed beans & spinach curry + Steamed rice + Beetroot juice.",
            dinner: "Mushroom soup + Herb-grilled cottage cheese / fish + Garlic steamed beans.",
            restrictions: "Avoid deep fried foods, artificial colorants, and ultra-processed snacks."
        }
    };

    function generateDietPlan() {
        const cond = document.getElementById('conditionSelect').value;
        const outDiv = document.getElementById('dietPlanOutput');

        if (!cond || !dietPlans[cond]) {
            outDiv.style.display = 'none';
            return;
        }

        const data = dietPlans[cond];
        document.getElementById('planTitle').innerText = data.title;
        document.getElementById('planSubtitle').innerText = data.subtitle;
        document.getElementById('breakfastText').innerText = data.breakfast;
        document.getElementById('lunchText').innerText = data.lunch;
        document.getElementById('dinnerText').innerText = data.dinner;
        document.getElementById('restrictionText').innerText = data.restrictions;

        outDiv.style.display = 'block';
    }
</script>
</body>
</html>
