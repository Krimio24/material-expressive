// _backend/java/MaterialYouUtils.java

package com.utils;

import android.content.Context;
import android.os.Build;
import android.util.Log;
import org.haxe.extension.Extension;

public class MaterialYouUtils {

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
}