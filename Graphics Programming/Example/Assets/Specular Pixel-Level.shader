//高光计算的插值不是线性的(有pow), 因此逐顶点会产生高光部分不平滑的效果
//高光的逐像素光照
Shader "Custom/Specular Pixel-Level"{
	Properties{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	
	SubShader{
	
		Pass{
			Tags{"LightMode"="ForwardBase"}
			
			CGPROGRAM
				#pragma vertex vertmain
				#pragma fragment fragmain
				#include "Lighting.cginc"
				
				fixed4 _Diffuse;
				fixed4 _Specular;
				float _Gloss;
				
				struct a2v{
					float4 vertex:POSITION;
					float3 normal:NORMAL;
				};
				
				struct v2f{
					float4 pos:SV_POSITION;
					fixed3 worldNormal:TEXCOORD0;
					fixed3 worldPos:TEXCOORD1;
				};
				
				v2f vertmain(a2v a){
					v2f v;
					
					//Transform the vertex from object -> projection
					v.pos = UnityObjectToClipPos(a.vertex);
					
					// Transform the normal from object -> world 
					v.worldNormal = normalize (mul (a. normal, ( float3x3) unity_WorldToObject) ) ; 
					
					//Transform the vertex from object -> world
					v.worldPos = mul(unity_ObjectToWorld, a.vertex).xyz;
					
					return v;
				}
				fixed4 fragmain(v2f v):SV_Target{
					//Get ambient term
					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
					
					fixed3 worldNormal = normalize(v.worldNormal);
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
					
					//Compute diffuse term
					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
					
					//Get the reflect direction in world
					//要求入射光线指向交点, 因此需要取反
					fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
					
					//Get the view direction in world
					//视角方向: 从顶点指向摄像机
					fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos.xyz);
					
					//Compute specular term
					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
					
					return fixed4(ambient + diffuse + specular, 1.0);
				}
			ENDCG
		}
	}
	
	Fallback "Specular"
}
