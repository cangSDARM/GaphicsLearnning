using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetectionWithNormalAndDepthTexture : PostEffectsBase {
    public Shader edgeDetectShader;
    private Material edgeDetectMaterial = null;
    public Material material {
        get {
            edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
            return edgeDetectMaterial;
        }
    }

    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;

    public Color edgeColor = Color.black;

    public Color backgroundColor = Color.white;

    /// <summary>
    /// 值越大，描边越宽
    /// </summary>
    public float sampleDistance = 1.0f;
    /// <summary>
    /// 深度敏感度
    /// </summary>
    public float sensitivityDepth = 1.0f;
    /// <summary>
    /// 法线敏感度
    /// </summary>
    public float sensitivityNormals = 1.0f;

    void OnEnable() {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }

    /// <summary>
    /// [ImageEffectOpaque]使得在不透明物体完成Pass后立即调用OnRenderImage
    /// </summary>
    [ImageEffectOpaque]
    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            material.SetFloat("_EdgeOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);
            material.SetFloat("_SampleDistance", sampleDistance);
            material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

            Graphics.Blit(src, dest, material);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
