Shader "Tutorial/Example_05(Sprite Shader)"
{
    Properties
    {
        _myColor("Tint",Color)=(1,1,1,1)
        _MainTex("Texture",2D)="White" {}
    }
    Subshader
    {
        // Tells unity not to remove inside faces 
        Cull off
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
                half4 color : COLOR;
            };
            
            struct Output
            {
                half4 newPos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half4 color : COLOR;
            };
            
            Output vert(Input i)
            {
                Output o;
                o.newPos=UnityObjectToClipPos(i.Pos);
                o.uv=TRANSFORM_TEX(i.uv,_MainTex);
                o.color=i.color;
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float4 col=tex2D(_MainTex,o.uv);
                col*=o.color;
                return col;
            }
            
            ENDCG
        }
    }
    
}