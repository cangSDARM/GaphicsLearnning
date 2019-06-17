using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 使用深度纹理更新速度映射图，实现运动模糊
/// 通过前后两帧的视角*投影矩阵得到NDC坐标，通过坐标差/时间得到速度图
/// 适合于场景静止，摄像机快速移动的情况
/// </summary>
public class MotionBlurUseVeloWithDepthTexture : PostEffectsBase {
    
    public Shader motionBlurShader;
    private Material motionBlurMaterial = null;

    public Material material {
        get {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader, motionBlurMaterial);
            return motionBlurMaterial;
        }
    }

    private Camera myCamera;
    public Camera _camera {
        get {
            if (myCamera == null) {
                myCamera = GetComponent<Camera>();
            }
            return myCamera;
        }
    }

    [Range(0.0f, 1.0f)]
    public float blurSize = 0.5f;

    /// <summary>
    /// 上一帧的“速度”：视角*投影矩阵
    /// </summary>
    private Matrix4x4 previousViewProjectionMatrix;

    void OnEnable() {
        _camera.depthTextureMode |= DepthTextureMode.Depth;

        previousViewProjectionMatrix = _camera.projectionMatrix * _camera.worldToCameraMatrix;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            material.SetFloat("_BlurSize", blurSize);

            material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
            Matrix4x4 currentViewProjectionMatrix = _camera.projectionMatrix * _camera.worldToCameraMatrix;
            Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;
            material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
            previousViewProjectionMatrix = currentViewProjectionMatrix;

            Graphics.Blit(src, dest, material);
        } else {
            Graphics.Blit(src, dest);
        }
    }

}