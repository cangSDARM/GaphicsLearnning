Shader "Custom/Normal Map in TangentSpace"{
	Properties{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_BumpMap ("Normal Map", 2D) = "bump"{}	//没有提供任何法线纹理时, bump对应模型自带的法线信息
		_BumpScale("Bump Scale", Float) = 1.0	//控制凹凸程度. 为0时, 该法线纹理不会对光照产生任何影响
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader{

		Pass{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct v2f{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;	//xy坐标存储_MainTex的坐标, zw坐标存储_BumpMap的坐标. 写在一个里可以减少寄存器的压力
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;	//获取顶点切线方向. tangent.w是副切线方向
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				///Compute the binormal
				//float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
				//Construct a matrix which transform vectors from object to tangent
				//float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
				//Built-in matrix
				TANGENT_SPACE_ROTATION;

				//Transform the light direction from object to tangent
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				//Transform the view direction from object to tangent
				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target{
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);
				
				//get the texel in the normal Map(纹理采样)
				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				fixed3 tangentNormal;
				//if the texture's TextureType is not marked as "Normal Map"
				//	tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpScale;
				//	tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
				//or mark the texture as "Normal Map", and use the built-in function
				tangentNormal = UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
	}

	Fallback "Specular"
}
