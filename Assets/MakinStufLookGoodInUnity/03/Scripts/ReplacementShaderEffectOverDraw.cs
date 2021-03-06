﻿using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShaderEffectOverDraw : MonoBehaviour
{
    public Shader ReplacementShader;
    public Color OverDrawColor;
    void OnValidate()
    {
        Shader.SetGlobalColor("_OverDrawColor", OverDrawColor);
    }
    void OnEnable ()
    {
        if (ReplacementShader != null)
            GetComponent<Camera>().SetReplacementShader(ReplacementShader, "");
    }

    void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}