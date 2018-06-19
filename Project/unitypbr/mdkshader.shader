Shader "Unlit/mdkshader"
{
	Properties
	{
		[Toggle(WORKFLOW)] _WorkFlow("WorkFlow", Int) = 1

		_MainTex ("Texture", 2D) = "white" {}

        _AlbedoColor ("Albedo Color", Color) = (1,1,1,1)
        _AlbedoTexture ("Albedo Texture", 2D) = "white" {}

        _Metallic ("Metallic", Range(0,1)) = 1
        _MetallicTexture ("Metallic Texture", 2D) = "white" {}

        _Roughness ("Roughness", Range(0,1)) = 1
        _RoughnessTexture ("Roughness Texture", 2D) = "white" {}

        _NormalTexture ("Normal Texture", 2D) = "white" {}

        _OcclusionTexture ("Occlusion Texture", 2D) = "white" {}

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [Enum(Specular Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
            #pragma shader_feature REDIFY_ON
			#pragma vertex vert
			#pragma fragment frag


			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AlbedoColor;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				#if REDIFY_ON
			        col = fixed4(0, 0.4, 0, 1);
				#else
				    col = fixed4(0.4,0,0,1);
				#endif
				// sample the texture
				// fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
    CustomEditor "MdkMaterialGUI"
}
