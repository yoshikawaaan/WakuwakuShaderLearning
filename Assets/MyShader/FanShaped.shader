Shader "Unlit/FanShape"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
			float disc(float2 st) {
				float d = distance(st, float2(0.5, 0.5));
				float s = step(0.5, d);
				return s;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float dx = 0.5 - i.uv.x;
				float dy = 0.5 - i.uv.y;

				float rad = atan2(dx,dy);

				float s = step(2,rad);

				return s - disc(i.uv);
			}
            ENDCG
        }
    }
}
