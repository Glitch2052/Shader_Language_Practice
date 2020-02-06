Shader "Tutorial/Example_04(Youtube Tutorial follow)"
{
    Properties
    {
        _myColor("Tint",Color)=(1,1,1,1)
        _Gloss("Gloss",float)=1
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
            
            float4 _myColor;
            float _Gloss;
            sampler2D _myTexture;
            
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
                float3 worldPos : TEXCOORD1;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.worldPos = mul ( unity_ObjectToWorld , i.Pos );
                o.newPos=UnityObjectToClipPos(i.Pos);
                o.uv=i.uv;
                o.normal=mul(unity_ObjectToWorld,i.normal);
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float design =  tex2D (_myTexture,o.uv).x;
                float waveValue = (sin(design/0.08+_Time.y*4)+1)*0.5;;
                waveValue *= design;
                return waveValue;
                float3 normal = normalize (o.normal);
                
                // Lighting
                float3 lightDir = _WorldSpaceLightPos0;                
                float3 lightColor = _LightColor0;
                
                // Direct Light
                float lightFallOff = max( 0 , dot (lightDir,normal));
                lightFallOff = step(0.6,lightFallOff);
                float3 directDiffuseLight = lightFallOff * lightColor;
                
                // Ambient Light
                float3 ambientColor = float3 (0.2,0.2,0.2);
                
                // Phong specular Light
                float3 viewDir = normalize (_WorldSpaceCameraPos-o.worldPos);
                float3 viewReflect = reflect(-viewDir,normal);
                float specularLightFallOff = max( 0 , dot (viewReflect,lightDir));
                specularLightFallOff = step (0.6,specularLightFallOff);
                specularLightFallOff=pow(specularLightFallOff,_Gloss);  // Glossy Control
                float3 directSpecular = specularLightFallOff * _myColor;
                
                // Composite
                float3 diffuseLight = directDiffuseLight + ambientColor + directSpecular;
                float3 finalLight = diffuseLight * _myColor;
                
                return float4(finalLight,1);
            }
            
            ENDCG
        }
    }
    
}