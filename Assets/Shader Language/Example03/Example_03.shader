Shader "Tutorial/Example_03(Basic Transparency)"
{
    Properties
    {
        _myColor("Tint",Color)=(1,1,1,1)
        _myTexture("Texture",2D)="White" {}
    }
    Subshader
    {
        // Blend mode Defines how the existing Colors and the new colors Blend with each other
        // Defined with two KeyWords
        // the first one defines the value the new color is multiplied with and the second one defines the value the old color is multiplied with. 
        // After multiplying the colors, they’re added together and the result is drawn (when opaque material Blend value is 1 0)
        // ZWriting is disabled. It writes its distance from the camera into texture to tell objects behind him not to draw over him which is not needed in Transparent material
        // object furthest away is rendered and then in order until the closest object is rendered last, but unity does that for us so we don’t have to worry about it
        ZWrite off
        Blend SrcAlpha OneMinusSrcAlpha
        
        Tags
        {
            // RenderType makes the material Transparent
            // Changing the Queue makes sure that the object is rendered later than the opaque material
            // this makes sure that Transparent material is not hidden
            // to Check it change the Queue to Geometry-1 and see the effect
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            half4 _myColor;
            sampler2D _myTexture;
            half4 _myTexture_ST;
            
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