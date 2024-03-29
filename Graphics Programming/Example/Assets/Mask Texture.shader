﻿//高光遮罩纹理
Shader "Custom/Ramp Texture"{
	Properties{
		_Color("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		_BumpMap("Bump Texture", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1
		_SpecularMask("Specular Mask", 2D) = "white"{}
		_SpecularScale("Specular Scale", Float) = 1
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader{

		Pass{
			Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;	//主纹理和法线纹理, 遮罩纹理同时使用一个 _ST
			sampler2D _BumpMap;
			float _BumpScale;
			sampler2D _SpecularMask;
			float _SpecularScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				TANGENT_SPACE_ROTATION;
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);
				
				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv));
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				//get the mask value
				//选择使用r分量计算掩码值. 其它通道可以存储别的东西
				fixed specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularScale;
				//compute specular term with the specular mask
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss) * specularMask;
				return fixed4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
	}

	Fallback "Specular"
}
