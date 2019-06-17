//逐像素漫反射光照
Shader "Custom/Diffuse HalfLambert"{
	Properties{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
	}

	SubShader{
		Pass {
			//定义Pass在Unity光照流水线中的角色
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vertmain
			#pragma fragment fragmain
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			
			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};
			
			v2f vertmain(a2v a){
				v2f v;
				//Transform the vertex from object -> projection
				v.pos = UnityObjectToClipPos(a.vertex);
				
				//Transform the normal from object -> world
				v.worldNormal = normalize(mul(a.normal, (float3x3)unity_WorldToObject));
				
				return v;
			}
			
			fixed4 fragmain(v2f v):SV_Target{
				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				//Get the normal in world
				fixed3 worldNormal = normalize(v.worldNormal);
				
				//Get the light direction in world
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				//Cumpute diffuse term
				fixed halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
				
				fixed3 color = ambient + diffuse;
				
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}