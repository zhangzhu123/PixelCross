using UnityEngine;
using UnityEditor;
using System;
using System.Collections;

public class MdkMaterialGUI : ShaderGUI
{
    public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI (materialEditor, properties);

        Material targetMat = materialEditor.target as Material;
        // see if redify is set, and show a checkbox
        bool redify = Array.IndexOf(targetMat.shaderKeywords, "REDIFY_ON") != -1;
        EditorGUI.BeginChangeCheck();
        redify = EditorGUILayout.Toggle("Redify material", redify);
        if (EditorGUI.EndChangeCheck())
        {
            // enable or disable the keyword based on checkbox

            if (redify)
            {
                Debug.Log("Test");
                targetMat.EnableKeyword("REDIFY_ON");
            }
            else
                targetMat.DisableKeyword("REDIFY_ON");
        }

    }
}
