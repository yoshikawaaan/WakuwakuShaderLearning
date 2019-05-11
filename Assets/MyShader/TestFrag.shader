Shader "Monica/TestFrag"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float rot(float2 st,float speed,float size) 
			{
				float x = sin(_Time * speed)*size + 0.5;
				float y = cos(_Time * speed)*size + 0.5;

				return distance(float2(x, y), st);
				//return circle(st, x + 0.5, y + 0.5);
			}
			fixed4 frag(v2f i) : SV_Target
			{
				float r = rot(i.uv,50,0.2);
				float s = step(0.3, r);
				float c1 = step(distance(0.5, i.uv),0.18);
				float c2 = 1-step(distance(0.5, i.uv),0.22);
				float c = 1 - (c1 + c2);
				//return c*s;

				float cake = 
				return cake;
			}
			ENDCG
		}
	}
}
