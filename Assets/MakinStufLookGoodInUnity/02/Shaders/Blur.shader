﻿Shader "MakingStuffLookGood/02_ImageEffects/BlurEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off //double sided mat
		ZWrite Off 
		ZTest Always 
     

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			sampler2D _MaskTex;
			sampler2D _BackgroundTexture;

			float4 box(sampler2D tex, float2 uv, float4 size)
				{
					float4 c = tex2D (tex, uv + float2(-size.x, size.y)) + tex2D (tex, uv + float2(0, size.y)) + tex2D (tex, uv + float2(size.x, size.y)) + 
							   tex2D (tex, uv + float2(-size.x, 0)) + tex2D (tex, uv + float2(0, 0)) + tex2D (tex, uv + float2(size.x, 0)) + 
							   tex2D (tex, uv + float2(-size.x, -size.y)) + tex2D (tex, uv + float2(0, -size.y)) + tex2D (tex, uv + float2(size.x, -size.y));

					return c/9;
				}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed mask = clamp (0, 1, tex2D (_MaskTex, i.uv).r * 2);
				fixed invertedMask = float4 (1, 1, 1, 1) - mask;
				fixed4 Noblur = tex2D (_MainTex, i.uv) ;
				fixed4 Maincolor = box (_MainTex, i.uv, _MainTex_TexelSize);

				fixed4 col = lerp (Maincolor, Noblur, mask);

				return col;
			}
			ENDCG
		}
	}
}
