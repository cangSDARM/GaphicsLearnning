// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//逐顶点漫反射光照
Shader "Custom/Diffuse Vertex-Leval"{
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
				float3 color : COLOR;
			};
			
			v2f vertmain(a2v a){
				v2f v;
				//Transform the vertex from object -> projection
				v.pos = UnityObjectToClipPos(a.vertex);
				
				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				//Transform the normal from object -> world
				//同一空间的dot才有意义
				fixed3 worldNormal = normalize(mul(a.normal, (float3x3)unity_WorldToObject));
				//Get the light direction in world
				//_LightColor0获取该Pass的光源颜色和强度信息, 不具有通用性
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				
				//Compute diffuse term
				//saturate防止dot为负值
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				
				v.color = ambient + diffuse;
				return v;
			}
			
			fixed4 fragmain(v2f v):SV_Target{
				return fixed4(v.color, 1.0);
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
