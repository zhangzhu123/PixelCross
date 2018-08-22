// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/mdkPbr"
{
	Properties
	{
		_AlbedoColor("AlbedoColor", Color) = (1,1,1,1)
		_MainTex("AlbedoTexture", 2D) = "white" {}

		_Metallic("Metallic", Range(0.0, 1.0)) = 1.0
		_MetallicTexture("MetallicTexture", 2D) = "white" {}

		_Roughness("Roughness", Range(0.0, 1.0)) = 1.0
		_RoughnessTexture("RoughnessTexture", 2D) = "white" {}

		_NormalTexture("NormalTexture", 2D) = "white" {}

		_OcclusionTexture("OcclusionTexture", 2D) = "white" {}

		_EmissiveTexture("EmissiveTexture", 2D) = "white" {}

		_IBLSpecular("IBLSpecular(HDR RGBM)", Cube) = "grey" {}
	    _IBLDiffuse("IBLDiffuse(HDR RGBM)", Cube) = "grey" {}
		_Exposure("Exposure", Range(0.0, 20.0)) = 6.0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			Name "FORWARD"
			Tags{ "LightMode" = "ForwardBase" }

	    	ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				half3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			fixed4 _AlbedoColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float _Metallic;
			float _Roughness;
			
			samplerCUBE _IBLDiffuse;
			samplerCUBE _IBLSpecular;
			float _Exposure;

            #include "mdkCore.cginc"
            #include "mdkPbrCore.cginc"

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 albedoTexture = tex2D(_MainTex, i.uv);
				half3 iblDiffuse = fromRGBM(texCUBE(_IBLDiffuse, i.worldNormal));
			    iblDiffuse = iblDiffuse * _AlbedoColor.rgb * albedoTexture * (1.0 - _Metallic) * _Exposure;

				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				half3 specularColor = half3(0.08, 0.08, 0.08);
				specularColor = lerp(specularColor, albedoTexture.rgb, _Metallic);
				//half f90 = clamp(50.0 * specularColor.g, 0.0, 1.0);
				half f90 = 0.15;

				half3 iblSpecular = computeIBLSpecularUE4(i.worldNormal, worldViewDir, _Roughness, specularColor, f90) * _Exposure;

				fixed4 col;
				col.rgb = iblDiffuse.rgb + iblSpecular.rgb;
				//col.rgb = iblSpecular.rgb;
				col.a = 1.0;

				return col;
			}
			ENDCG
		}
	}
}
