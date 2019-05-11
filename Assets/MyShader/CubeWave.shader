Shader "Monica/CubeWave"
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
			float wave(float2 st)
			{
				float d = distance(0.5,st);
				return (1 + sin(d * 3 - _Time.y * 3))*0.5;
			}
			float wave_mozic(float2 st,float n)
			{
				st = (floor(st*n) + 0.5) / n;
				float d = distance(0.5,st);
				return (1 + sin(d * 3 - _Time.y * 3))*0.5;
			}

			float rand(float2 st)
			{
				return frac(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453);
			}


			float box(float2 st,float size)
			{
				size = 0.5 + size * 0.5;
				st = step(st,size)*step(1.0 - st,size);

				return st.x*st.y;
			}

			float box_size(float2 st,float n)
			{
				st = (floor(st*n) + 0.5) / n;
				float offs = rand(st) * 5;
				return (1 + sin(_Time.y * 3 + offs)) * 0.5;
			}

			float box_wave(float2 uv,float n)
			{
				float2 st = frac(uv*n);
				//正方形
				float size = wave_mozic(uv,n);
				//不整合図形
				//float size = wave(uv);
				return box(st,size);
			}
			float box_wave_rnd(float2 uv,float n)
			{
				float2 st = frac(uv*n);
				//正方形
				float size = wave_mozic(uv,n)*box_size(uv,n);
				//不整合図形
				//float size = wave(uv);
				return box(st,size);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float n = 10;
			//白色パターン
			//return box_wave(i.uv,n);
			//RGBゆらし

			return float4(
				box_wave_rnd(i.uv,n),
				box_wave(i.uv,n + 0.1),
				box_wave(i.uv,n + 0.2),
				1);
			}
		ENDCG
		}
	}
}
