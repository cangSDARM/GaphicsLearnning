using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

//GameObject菜单 Render into Cubemap
//将物体四周的东西渲染到Cubemap中
public class CreateCubmap : ScriptableWizard {
    
    public Transform renderFromPosition;
    public Cubemap cubemap;

    void OnWizardUpdate() {
        helpString = "Select transform to render from and cubemap to render into";
        isValid = (renderFromPosition != null) && (cubemap != null);
    }

    void OnWizardCreate() {
        // create temporary camera for rendering
        GameObject go = new GameObject("CubemapCamera");
        go.AddComponent<Camera>();
        // place it on the object
        go.transform.position = renderFromPosition.position;
        // render into cubemap		
        go.GetComponent<Camera>().RenderToCubemap(cubemap);

        // destroy temporary camera
        DestroyImmediate(go);
    }

    [MenuItem("GameObject/Render into Cubemap")]
    static void RenderCubemap() {
        ScriptableWizard.DisplayWizard<CreateCubmap>(
            "Render cubemap", "Render!");
    }
}
