// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//使用GrabPass获取Render Texture, 模拟毛玻璃效果
//GrabPass可以对图像用法线模拟折射
//GrabPass需要小心渲染顺序
Shader "Effects/Glass"{
	Properties{
		//玻璃材质纹理
		_MainTex("Main Tex", 2D) = "white" {}
		//玻璃法线纹理
		_BumpMap("Normal Map", 2D) = "bump" {}
		//用于模拟反射的环境纹理
		_Cubemap("Environment Cubemap", Cube) = "_Skybox" {}
		//控制折射时图像的扭曲程度
		_Distortion("Distortion", Range(0, 100)) = 10
		//控制折射程度（为1只有折射，为0只有反射）
		_RefractAmount("Refract Amount", Range(0.0, 1.0)) = 1.0
	}
	SubShader{
		// We must be transparent, so other objects are drawn before this one.
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }

		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _RefractionTex
		GrabPass{ "_RefractionTex" }

		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			samplerCUBE _Cubemap;
			float _Distortion;
			fixed _RefractAmount;
			sampler2D _RefractionTex;	//GrabPass时定义
			float4 _RefractionTex_TexelSize;	//GrabPass所定义

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float4 scrPos : TEXCOORD0;
				float4 uv : TEXCOORD1;
				float4 TtoW0 : TEXCOORD2;
				float4 TtoW1 : TEXCOORD3;
				float4 TtoW2 : TEXCOORD4;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				//获取被抓取屏幕的坐标采样
				o.scrPos = ComputeGrabScreenPos(o.pos);

				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				// Get the normal in tangent space
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));

				// Compute the offset in tangent space
				//对屏幕图像的坐标采样进行偏移，模拟折射
				float2 offset = bump.xy * _Distortion * _RefractionTex_TexelSize.xy;
				i.scrPos.xy = offset * i.scrPos.z + i.scrPos.xy;
				//使用透视除法获取真正的屏幕坐标，并对_RefractionTex采样, 得到模拟的折射颜色
				fixed3 refrCol = tex2D(_RefractionTex, i.scrPos.xy / i.scrPos.w).rgb;

				// Convert the normal to world space
				bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
				fixed3 reflDir = reflect(-worldViewDir, bump);
				fixed4 texColor = tex2D(_MainTex, i.uv.xy);
				fixed3 reflCol = texCUBE(_Cubemap, reflDir).rgb * texColor.rgb;

				fixed3 finalColor = reflCol * (1 - _RefractAmount) + refrCol * _RefractAmount;

				return fixed4(finalColor, 1);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
