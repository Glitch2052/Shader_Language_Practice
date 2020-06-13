using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RippleEffect : MonoBehaviour
{
    public Material rippleMat;
    public Pointer pointer;
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        rippleMat.SetVector("_RipplePosition",new Vector4(Input.mousePosition.x/Screen.width,Input.mousePosition.y/Screen.height,0,0));
        Graphics.Blit(src, dest, rippleMat);
    }
}
