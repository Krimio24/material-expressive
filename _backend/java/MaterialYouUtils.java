package com.utils;

import android.content.Context;
import android.os.Build;
import android.util.Log;
import org.haxe.extension.Extension;

public class MaterialYouUtils {

    // Eliminamos el parámetro Context. Java se encarga de Java.
    public static int getMaterialDynamicColor(String role, int tone) {
        Context context = Extension.mainContext;

        if (context == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return -1; // Retornamos -1 para indicarle a Haxe que use su propio fallback
        }

        try {
            String resourceName = "system_neutral1_" + tone;
            role = role.toLowerCase();
            
            if (role.equals("primary")) resourceName = "system_accent1_" + tone;
            else if (role.equals("secondary")) resourceName = "system_accent2_" + tone;
            else if (role.equals("tertiary")) resourceName = "system_accent3_" + tone;
            else if (role.equals("error")) {
                if (tone == 40) return 0xFFB3261E;
                if (tone == 80) return 0xFFF2B8B5;
                resourceName = "system_accent1_" + tone;
            }

            int resId = context.getResources().getIdentifier(resourceName, "color", "android");
            
            if (resId != 0) {
                return context.getColor(resId);
            }
        } catch (Exception e) {
            Log.e("MaterialYou", "Error fetching color: " + e.getMessage());
        }

        return -1; 
    }

    private static int getFallbackColor(String role, int tone) {
        switch (role.toLowerCase()) {
            case "primary":
                if (tone <= 10) return 0xFF001D35;
                if (tone <= 40) return 0xFF0061A4;
                if (tone <= 80) return 0xFF9ECAFF;
                return 0xFFF8F9FF;
            case "secondary":
                if (tone <= 40) return 0xFF535F70;
                if (tone <= 80) return 0xFFBBC7DB;
                return 0xFFFAFAFA;
            case "tertiary":
                if (tone <= 40) return 0xFF6B5778;
                if (tone <= 80) return 0xFFD6BAE6;
                return 0xFFFAFAFA;
            case "neutral":
                if (tone <= 10) return 0xFF1A1C1E;
                if (tone <= 90) return 0xFFE2E2E6;
                if (tone >= 98) return 0xFFFCFCFF;
                return 0xFF75777A;
            case "error":
                if (tone <= 40) return 0xFFB3261E;
                if (tone <= 80) return 0xFFF2B8B5;
                return 0xFFF9DEDC;
            default:
                return 0xFF0061A4;
        }
    }
}