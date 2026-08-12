package com.listner;



import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@WebListener
public class SessionListener implements HttpSessionListener {
    private static final int SESSION_TIMEOUT = 5 * 60; // 5 minutes (in seconds)

    @Override
    public void sessionCreated(HttpSessionEvent event) {
        event.getSession().setMaxInactiveInterval(SESSION_TIMEOUT);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        System.out.println("Session expired: " + event.getSession().getId());
    }
}
