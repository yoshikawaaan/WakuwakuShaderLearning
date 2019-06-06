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
			#define PI 3.14159265359
			float disc(float2 st) {
				float d = distance(st, float2(0.5, 0.5));
				float s = step(0.5, d);
				return s;
			}

			float fan_shape(float2 st, float angle) {
				float dx = 0.5 - st.x;
				float dy = 0.5 - st.y;

				float rad = atan2(dx, dy);
				rad = rad * 180 / PI;

				float n1 = floor((_Time * 1000 + angle) / (360));
				float n2 = floor((_Time * 1000) / (360));
				float offset1 = _Time * 1000 - 360 * n1;
				float offset2 = _Time * 1000 - 360 * n2;
				float s1 = step(rad, -180 + angle + offset1);
				float s2 = step(-180 + offset2, rad);
				
				return (s1*s2)*step(offset2, 360 - angle)+
					(s1 + s2)*(1-step(offset2, 360 - angle))
					- disc(st);
			}

			float sonar(float2 st) {
				float dx = 0.5 - st.x;
				float dy = 0.5 - st.y;

				float rad = atan2(dx, dy);
				rad = rad * 180 / PI;

				float d = distance(rad-180, 0)/360;

				return d+0.08;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				return fan_shape(i.uv,60)*sonar(i.uv);
				//return sonar(i.uv);
			}
			ENDCG
		}
	}
}
