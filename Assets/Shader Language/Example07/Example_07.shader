Shader "Tutorial/Example_07(Color InterPolation)"
{
    Properties
    {
        _myTexture01("First Texture",2D)="black"{}
        _myTexture02("Second Texture",2D)="black"{}        
        _MainTex("Texture",2D)="White" {}
        _Blend("Blend",Range(0,1))=0
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
            
            sampler2D _myTexture01;
            sampler2D _myTexture02;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _myTexture01_ST;
            float4 _myTexture02_ST;
            half _Blend;
                
            struct Input
            {
                half4 Pos : POSITION;
                half2 uv : TEXCOORD0;
            };
            
            struct Output
            {
                half4 newPos : SV_POSITION;
                half2 uv : TEXCOORD0;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.newPos=UnityObjectToClipPos(i.Pos);
                float4 worldpos=mul(unity_ObjectToWorld,i.Pos);
                o.uv = mul( unity_ObjectToWorld,i.Pos); 
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float2 firstTex = TRANSFORM_TEX(o.uv,_myTexture01);
                float2 secondTex = TRANSFORM_TEX(o.uv,_myTexture02);
                float2 blendValue = TRANSFORM_TEX(o.uv,_MainTex);
                
                float4 firstColor = tex2D(_myTexture01,firstTex);
                float4 secondColor = tex2D(_myTexture02,secondTex);
                float blendColor = tex2D(_MainTex,blendValue).r;
                
                return lerp(firstColor,secondColor,blendColor);
            }
            
            ENDCG
        }
    }
    
}