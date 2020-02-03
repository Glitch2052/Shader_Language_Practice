Shader "Tutorial/Example_04(Youtube Tutorial follow)"
{
    Properties
    {
        _myColor("Tint",Color)=(1,1,1,1)
        _myTexture("Texture",2D)="White" {}
    }
    Subshader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
                
            struct Input
            {
                half4 Pos : POSITION;
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
            };
            
            struct Output
            {
                half4 newPos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.newPos=UnityObjectToClipPos(i.Pos);
                o.uv=i.uv;
                o.normal=i.normal;
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float3 lightDir = _WorldSpaceLightPos0;                
                float3 lightColor = _LightColor0;
                
                float lightFallOff = max( 0 , dot (lightDir,o.normal));
                float3 diffuseLight=lightFallOff*lightColor;
                float3 ambientColor = float3(0.2,0.35,0.4);
                
                return float4(diffuseLight+ambientColor,1);
            }
            
            ENDCG
        }
    }
    
}