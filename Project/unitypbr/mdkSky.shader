Shader "Unlit/mdkSky"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
	    _Tex("Cubemap(HDR RGBM)", Cube) = "grey" {}
	    _Exposure("Exposure", Range(0.0, 20.0)) = 6.0
	}
	SubShader
	{
		Tags{ "Queue" = "Background" "RenderType" = "Background" "PreviewType" = "Skybox" }
		Cull Off ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 2.0

			#include "UnityCG.cginc"
	        
			samplerCUBE _Tex;
	        half4 _Tex_HDR;

			struct appdata_t {
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float _Exposure;

            #include "mdkCore.cginc"

			v2f vert(appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				//float3 rotated = RotateAroundYInDegrees(v.vertex, _Rotation);
				o.vertex = UnityObjectToClipPos(v.vertex.xyz);
				o.texcoord = v.vertex.xyz;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half4 tex = texCUBE(_Tex, i.texcoord);
				//half3 c = DecodeHDR(tex, _Tex_HDR);
				half3 c = fromRGBM(tex) * _Exposure;
				return half4(c, 1);
			}
			ENDCG
		}
	}
}
