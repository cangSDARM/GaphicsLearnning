﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MBuA"{
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BlurAmount("Blur Amount", Float) = 1.0
	}
	SubShader{
		CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		fixed _BlurAmount;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
		};

		v2f vert(appdata_img v) {
			v2f o;

			o.pos = UnityObjectToClipPos(v.vertex);

			o.uv = v.texcoord;

			return o;
		}

		fixed4 fragRGB(v2f i) : SV_Target{
			return fixed4(tex2D(_MainTex, i.uv).rgb, _BlurAmount);
		}

		half4 fragA(v2f i) : SV_Target{
			return tex2D(_MainTex, i.uv);
		}

		ENDCG

		ZTest Always Cull Off ZWrite Off

		//用于更新渲染纹理的RGB通道, 且设置其A通道混合图像但不将其值写入渲染纹理中
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			
			ColorMask RGB

			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment fragRGB  

			ENDCG
		}

		//用于更新A通道
		Pass {
			Blend One Zero
			ColorMask A

			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment fragA

			ENDCG
		}
	}
		
	FallBack Off
}
