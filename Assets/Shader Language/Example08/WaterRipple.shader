Shader "Unlit/WaterRipple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity("Ripple Intensity", Range(0,.5)) = 0.03
        _RippleCount("Ripple Count",float) = 12.0
        _RippleSpeed("Ripple Speed",float) = 4.0
        _EffectRange("Effect Range",Range(0,1)) = 0
        _RipplePosition("Ripple Position",vector) = (0,0,0,0) 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed _Intensity;
            float _RippleCount;
            float _RippleSpeed;
            float _EffectRange;
            float4 _RipplePosition;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 colB = tex2D(_MainTex,i.uv).xyz;
                float aspectRatio = _ScreenParams.x/_ScreenParams.y;
                float correctLength = sqrt((aspectRatio*(i.uv.x-_RipplePosition.x))*(aspectRatio*(i.uv.x-_RipplePosition.x))+(i.uv.y-_RipplePosition.y)*(i.uv.y-_RipplePosition.y));
                float cPos = length(correctLength);
                
                float2 newUV = i.uv + normalize(i.uv)*cos(cPos*100.0-_Time.y*8.0)*0.05;
    
                float3 colA = tex2D(_MainTex,newUV).xyz; 
                
                float3 colC = lerp(colA,colB,smoothstep(0.05,0.1,cPos));
            
                float3 col = lerp(colC,colB,_EffectRange);
                
                
                return fixed4(col,1);
            }
            ENDCG
        }
    }
}
