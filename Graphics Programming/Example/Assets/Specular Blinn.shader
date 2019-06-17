//高光的Blinn模型
//Blinn模型不需要反射方向, 其高光范围比Phong模型广
Shader "Custom/Specular Blinn"{
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
					
					//Get the view direction in world
					fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos.xyz);
					
					//Get the half direction in world
					fixed3 halfDir = normalize(worldLightDir + viewDir);
					
					//Compute specular term
					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
					
					return fixed4(ambient + diffuse + specular, 1.0);
				}
			ENDCG
		}
	}
	
	Fallback "Specular"
}