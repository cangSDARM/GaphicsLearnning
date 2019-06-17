using UnityEngine;

/// <summary>
/// 屏幕特效基类
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectsBase : MonoBehaviour {

    void Start() {
        CheckResources();
    }

    protected void CheckResources() {
        bool isSupported = CheckSupport();

        if (isSupported == false) {
            NotSupported();
        }
    }
    
    /// <summary>
    /// Called in CheckResources to check support on this platform
    /// </summary>
    /// <returns>check pass?</returns>
    protected bool CheckSupport() {
        if (!SystemInfo.supportsImageEffects) {
            Debug.LogWarning("This platform does not support image effects.");
            return false;
        }

        return true;
    }
    
    /// <summary>
    /// Called when the platform doesn't support this effect
    /// </summary>
    protected void NotSupported() {
        enabled = false;
    }
    
    /// <summary>
    /// Called before you need to create the material used by this effect
    /// </summary>
    /// <param name="shader">this effect used shader</param>
    /// <param name="material">post-processing material</param>
    /// <returns>correct material</returns>
    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material) {
        if (shader.Equals(null) || !shader.isSupported) {
            return null;
        }

        if (material && material.shader.Equals(shader))
            return material;
        
        material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        if (material)
            return material;
        else
            return null;
    }
}
