package com.payment;

import java.io.InputStream;
import java.util.Properties;

public class PaymentConfig {
	private static final Properties PROPERTIES = new Properties();

	static {
		try (InputStream input = PaymentConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
			if (input != null) {
				PROPERTIES.load(input);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String getKeyId() {
		return value("razorpay.key_id", "RAZORPAY_KEY_ID", "rzp_test_T6UOPTLkAiBPG7");
	}

	public static String getKeySecret() {
		return value("razorpay.key_secret", "RAZORPAY_KEY_SECRET", "yQlGVQ63dJuXAhaavMWldxzF");
	}

	public static boolean isConfigured() {
		return !getKeyId().isBlank() && !getKeySecret().isBlank();
	}

	private static String value(String propertyKey, String environmentKey, String fallback) {
		String value = PROPERTIES.getProperty(propertyKey);
		if (value == null || value.isBlank()) {
			value = System.getenv(environmentKey);
		}
		return value == null ? fallback : value.trim();
	}
}
