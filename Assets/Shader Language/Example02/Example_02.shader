Shader "Tutorial/Example_02(Surface Shader)"
{
    Properties
    {
        _myColor("Surface Color",Color)=(1,1,1,1)
        _myTexture("Surface Texture",2D)= "White" {}
        _metallic("Metallic",Range(0,1))=0
        _smoothness("Smoothness",Range(0,1))=0
        // HDR attribute is added to use HDR color 
        [HDR] _Emission("Emision",Color)=(0,0,0,1)
    }
    Subshader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
            CGPROGRAM
            // Added fullforwardshadows parameter to get better shadows
            // target 3.0 will tell unity to use higher precision values to get prettier lighting
            #pragma surface sur Standard fullforwardshadows
            #pragma target 3.0
            
            half4 _myColor;
            fixed _metallic;
            fixed _smoothness;
            half3 _Emission;
            sampler2D _myTexture;
                 
            struct Input
            {
                float2 uv_myTexture;
            };          
            
            // SurfaceOutputStandard is predefined struct and the output of the method is stored in that struct
            void sur(Input i, inout SurfaceOutputStandard o)
            {
                half4 col=tex2D(_myTexture,i.uv_myTexture);
                col*=_myColor;
                o.Albedo=col;
                o.Metallic=_metallic;
                o.Smoothness=_smoothness;
                o.Emission=_Emission;
            }
             
            ENDCG
        
    }
    // Fallback shader is added at the end. This allows unity to use functions of the below mentioned shader.
    // so that we dont have to implement them ourselves.
    // unity will borrow the shader pass from the below material and Add shadows to the shader 
    // FallBack shader is also helpful when the targeted hardware cant handle the abouve written shader it will run the below mentioned shader  
    FallBack "Standard"
}