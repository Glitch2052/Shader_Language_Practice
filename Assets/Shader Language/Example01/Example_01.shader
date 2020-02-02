Shader "Tutorial/Example_01(Vertex And Fragment Shader)"
{
    Properties
    {
        _myColor("Surface Color",Color)=(1,1,1,1)
        _myTexture("Surface Texture",2D)= "White" {}
    }
    Subshader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            half4 _myColor;
            sampler2D _myTexture;
            half4 _myTexture_ST;
            
            struct Input
            {
                float4 pos : POSITION;
                half2 uv : TEXCOORD0;
            };
            
            struct Output
            {
                float4 newPos : SV_POSITION;
                half2 uv : TEXCOORD0;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.newPos=UnityObjectToClipPos(i.pos);
                o.uv=TRANSFORM_TEX(i.uv,_myTexture);
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                half4 col=tex2D(_myTexture,o.uv);
                col*=_myColor;
                return col;
            }
             
            ENDCG
        }
    }
    
}