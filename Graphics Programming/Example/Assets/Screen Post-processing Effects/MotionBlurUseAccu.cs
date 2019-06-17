using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurUseAccu : PostEffectsBase {
    public Shader motionBlurShader;
    private Material motionBlurMaterial = null;

    public Material material {
        get {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader, motionBlurMaterial);
            return motionBlurMaterial;
        }
    }

    /// <summary>
    /// 运动拖尾效果
    /// </summary>
    [Range(0.0f, 0.9f)]
    public float blurAmount = 0.5f;

    /// <summary>
    /// 之前叠加效果
    /// </summary>
    private RenderTexture accumulationTexture;

    void OnDisable() {
        DestroyImmediate(accumulationTexture);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material) {
            // Create the accumulation texture
            if (accumulationTexture || !accumulationTexture.width.Equals(src.width) || !accumulationTexture.height.Equals(src.height)) {
                DestroyImmediate(accumulationTexture);
                accumulationTexture = new RenderTexture(src.width, src.height, 0);
                accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(src, accumulationTexture);
            }

            // We are accumulating motion over frames without clear/discard
            // by design, so silence any performance warnings from Unity
            accumulationTexture.MarkRestoreExpected();

            material.SetFloat("_BlurAmount", 1.0f - blurAmount);

            Graphics.Blit(src, accumulationTexture, material);
            Graphics.Blit(accumulationTexture, dest);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
