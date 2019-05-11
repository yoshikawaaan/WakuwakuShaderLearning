Shader "Monica/Orbit"
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

			float test(float2 st, float x, float y) {
				float d = distance(float2(0, 0), st);
				float a = abs(sin(_Time));
				float s = step(0.5, x);
				return s;
			}

			float4 ring(float2 st, float radius, float width)
			{
				float d = distance(0.5, st);
				return -step(/*0.26*/radius + width / 2, d) + step(/*0.24*/radius - width / 2, d);
			}
			float circle(float2 st, float x, float y)
			{
				float d = distance(float2(x, y), st);
				return step(0.1, d);
			}

			float orbit(float2 st, float speed, float size)
			{
				//speed=50 size=0.25
				float x = cos(_Time * speed)*size;
				float y = sin(_Time * speed)*size;

				return circle(st, x + 0.5, y + 0.5)*(1 - ring(st, size, 0.02));
			}

			fixed4 frag(v2f i) : SV_Target
			{

				return orbit(i.uv,50,0.4);
			}
			ENDCG
		}
	}
}
