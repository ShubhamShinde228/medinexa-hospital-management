<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.Doctor" %>
<%
    Object doctObj = session.getAttribute("doctObj");
    if (doctObj == null) doctObj = session.getAttribute("doctorObj");
    if (doctObj == null) {
        response.sendRedirect("../doctor_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voice AI Hands-Free Clinical Dictation — Doctor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9ff; }
        .card-voice { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .mic-btn { width: 90px; height: 90px; border-radius: 50%; background: #0284c7; color: white; border: none; font-size: 36px; transition: all 0.3s; display: flex; align-items: center; justify-content: center; margin: 0 auto; }
        .mic-btn:hover { background: #0369a1; transform: scale(1.06); }
        .mic-recording { background: #dc3545 !important; animation: micPulse 1.2s infinite; }
        @keyframes micPulse { 0% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7); } 70% { box-shadow: 0 0 0 16px rgba(220, 53, 69, 0); } 100% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0); } }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="card-voice text-center">
        <h2 class="fw-bold text-primary mb-2"><i class="fas fa-microphone-alt me-2"></i> Hands-Free Voice Clinical Dictation</h2>
        <p class="text-muted mb-4">Speak into your microphone to dictate patient diagnosis, symptoms, and prescription instructions</p>

        <button type="button" id="micBtn" onclick="toggleDictation()" class="mic-btn shadow mb-3">
            <i class="fas fa-microphone" id="micIcon"></i>
        </button>
        <div class="fw-bold text-muted mb-4" id="dictStatus">Click Microphone to Start Voice Dictation</div>

        <div class="text-start">
            <label class="form-label fw-bold">Live Transcribed Clinical Prescription Notes:</label>
            <textarea id="transcriptionBox" class="form-control form-control-lg mb-4" rows="8" placeholder="Dictated text will appear here automatically in real time..."></textarea>
            
            <div class="d-flex justify-content-end gap-2">
                <button type="button" onclick="copyDictationText()" class="btn btn-outline-primary rounded-pill px-4 fw-bold">
                    <i class="fas fa-copy me-1"></i> Copy Notes
                </button>
                <a href="prescriptions.jsp" class="btn btn-success rounded-pill px-4 fw-bold">
                    <i class="fas fa-arrow-right me-1"></i> Go to Prescriptions
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    let recognition = null;
    let isRecording = false;

    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        recognition = new SpeechRecognition();
        recognition.continuous = true;
        recognition.interimResults = true;
        recognition.lang = 'en-US';

        recognition.onresult = function(event) {
            let finalTranscript = '';
            for (let i = event.resultIndex; i < event.results.length; ++i) {
                if (event.results[i].isFinal) {
                    finalTranscript += event.results[i][0].transcript + '. ';
                }
            }
            if (finalTranscript) {
                document.getElementById('transcriptionBox').value += finalTranscript;
            }
        };

        recognition.onerror = function(event) {
            console.error("Speech recognition error:", event.error);
            document.getElementById('dictStatus').innerText = "Dictation Error: " + event.error;
            stopRecordingUI();
        };

        recognition.onend = function() {
            if (isRecording) recognition.start(); // Auto restart continuous
        };
    } else {
        alert("Web Speech API is not supported in this browser. Please use Google Chrome or Microsoft Edge.");
    }

    function toggleDictation() {
        if (!recognition) return;
        if (isRecording) {
            recognition.stop();
            isRecording = false;
            stopRecordingUI();
        } else {
            recognition.start();
            isRecording = true;
            startRecordingUI();
        }
    }

    function startRecordingUI() {
        document.getElementById('micBtn').classList.add('mic-recording');
        document.getElementById('dictStatus').innerHTML = '<span class="text-danger">🔴 LISTENING... Speak now</span>';
    }

    function stopRecordingUI() {
        document.getElementById('micBtn').classList.remove('mic-recording');
        document.getElementById('dictStatus').innerText = "Click Microphone to Resume Voice Dictation";
    }

    function copyDictationText() {
        const txt = document.getElementById('transcriptionBox');
        txt.select();
        document.execCommand('copy');
        alert("Clinical dictation notes copied to clipboard!");
    }
</script>
</body>
</html>
