Shader "Tutorial/Example_06(Planar Mapping)"
{
    Properties
    {
        _myColor("Tint",Color)=(1,1,1,1)
        _MainTex("Texture",2D)="White" {}
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
            
            float4 _myColor;
            sampler2D _MainTex;
            float4 _MainTex_ST;
                
            struct Input
            {
                half4 Pos : POSITION;
                half2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct Output
            {
                half4 newPos : SV_POSITION;
                half2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.newPos=UnityObjectToClipPos(i.Pos);
                float4 worldpos=mul(unity_ObjectToWorld,i.Pos);
                o.worldPos = worldpos;   
                o.normal = normalize ( mul(unity_ObjectToWorld,i.normal));
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float3 weights = o.normal;
                float2 uvFront = TRANSFORM_TEX(o.worldPos.xy,_MainTex);
                float2 uvSide = TRANSFORM_TEX(o.worldPos.yz,_MainTex);
                float2 uvTop = TRANSFORM_TEX(o.worldPos.xz,_MainTex);
                
                float4 frontCol=tex2D(_MainTex,uvFront);
                float4 sideCol=tex2D(_MainTex,uvSide);
                float4 topCol=tex2D(_MainTex,uvTop);
                
                // Makes Texture visible on both sides
                weights = abs (weights);
                // Makes Transisiton Between textures sharper
                weights = pow(weights,60);
                // Makes All Component Sum up to 1
                weights = weights/(weights.x + weights.y + weights.z);
                
                frontCol *= weights.z;
                sideCol *= weights.x;
                topCol *= weights.y;
                
                return (frontCol+sideCol+topCol);
            }
            
            ENDCG
        }
    }
    
}