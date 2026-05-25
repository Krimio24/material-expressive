package com.utils;

import android.content.Context;
import android.os.Build;
import android.util.Log;

public class MaterialYouUtils {

    public static int getMaterialDynamicColor(Context context, String role, int tone) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                String resourceName = "";
                
                switch (role.toLowerCase()) {
                    case "primary":
                        resourceName = "system_accent1_" + tone;
                        break;
                    case "secondary":
                        resourceName = "system_accent2_" + tone;
                        break;
                    case "tertiary":
                        resourceName = "system_accent3_" + tone;
                        break;
                    case "neutral":
                        resourceName = "system_neutral1_" + tone;
                        break;
                    case "error":
                        resourceName = "system_accent1_" + tone; 
                        if (tone == 40) return 0xFFB3261E;
                        if (tone == 80) return 0xFFF2B8B5;
                        break;
                    default:
                        resourceName = "system_accent1_" + tone;
                        break;
                }

                int resId = context.getResources().getIdentifier(resourceName, "color", "android");
                
                if (resId != 0) {
                    return context.getColor(resId);
                }
            } catch (Exception e) {
                Log.e("MaterialYou", e.getMessage());
            }
        }

        return getFallbackColor(role, tone);
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