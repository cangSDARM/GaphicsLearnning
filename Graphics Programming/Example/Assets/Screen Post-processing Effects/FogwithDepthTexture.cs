using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 使用深度纹理的快速世界坐标重建来计算雾：实现基于高度的雾效
/// </summary>
public class FogwithDepthTexture : PostEffectsBase {
    public Shader fogShader;
    private Material fogMaterial = null;

    public Material material {
        get {
            fogMaterial = CheckShaderAndCreateMaterial(fogShader, fogMaterial);
            return fogMaterial;
        }
    }

    private Camera myCamera;
    public Camera camera_ {
        get {
            if (myCamera == null) {
                myCamera = GetComponent<Camera>();
            }
            return myCamera;
        }
    }

    private Transform myCameraTransform;
    public Transform cameraTransform {
        get {
            if (myCameraTransform == null) {
                myCameraTransform = camera_.transform;
            }

            return myCameraTransform;
        }
    }

    /// <summary>
    /// 雾的浓度
    /// </summary>
    [Range(0.0f, 3.0f)]
    public float fogDensity = 1.0f;

    public Color fogColor = Color.white;

    //雾的起始和终止高度
    public float fogStart = 0.0f;
    public float fogEnd = 2.0f;

    void OnEnable() {
        camera_.depthTextureMode |= DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            Matrix4x4 frustumCorners = Matrix4x4.identity;

            float fov = camera_.fieldOfView;
            float near = camera_.nearClipPlane;
            float aspect = camera_.aspect;

            float halfHeight = near * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
            Vector3 toRight = cameraTransform.right * halfHeight * aspect;
            Vector3 toTop = cameraTransform.up * halfHeight;

            Vector3 topLeft = cameraTransform.forward * near + toTop - toRight;
            float scale = topLeft.magnitude / near;

            topLeft.Normalize();
            topLeft *= scale;

            Vector3 topRight = cameraTransform.forward * near + toRight + toTop;
            topRight.Normalize();
            topRight *= scale;

            Vector3 bottomLeft = cameraTransform.forward * near - toTop - toRight;
            bottomLeft.Normalize();
            bottomLeft *= scale;

            Vector3 bottomRight = cameraTransform.forward * near + toRight - toTop;
            bottomRight.Normalize();
            bottomRight *= scale;

            //后期特效平面的四个角
            frustumCorners.SetRow(0, bottomLeft);
            frustumCorners.SetRow(1, bottomRight);
            frustumCorners.SetRow(2, topRight);
            frustumCorners.SetRow(3, topLeft);

            material.SetMatrix("_FrustumCornersRay", frustumCorners);

            material.SetFloat("_FogDensity", fogDensity);
            material.SetColor("_FogColor", fogColor);
            material.SetFloat("_FogStart", fogStart);
            material.SetFloat("_FogEnd", fogEnd);

            Graphics.Blit(src, dest, material);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
