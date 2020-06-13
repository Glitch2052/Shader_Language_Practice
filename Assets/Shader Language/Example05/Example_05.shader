Shader "Tutorial/Example_05(Sprite Shader)"
{
    Properties
    {
        [HDR]_myColor("Tint",Color)=(1,1,1,1)
        _MainTex("Texture",2D)="White" {}
        _Dissolve("Noise Texture",2D)="Black"{}
        _Amount("_Dissolve Amount",Range(0,1))=0
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
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            float _Amount;
            float4 _myColor;
            sampler2D _MainTex;
            sampler2D _Dissolve;
                
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
                o.uv=i.uv;
                o.color=i.color;
                return o;
            }
            
            half4 frag(Output o) : SV_TARGET
            {
                float dissolve = tex2D(_Dissolve,o.uv).r;
                //dissolve = clamp(dissolve,0,1);
                float dissolveValue = (dissolve - (_Amount));
                clip(dissolveValue);
                
                float4 col=tex2D(_MainTex,o.uv);
                col = (col * o.color)+_myColor*step(dissolveValue,0.075);
                return col;
            }
            
            ENDCG
        }
    }
    
}