Shader "Custom/DirectionalFlow" {
	Properties{
		…
		_WaterFogColor("Water Fog Color", Color) = (0, 0, 0, 0)
		_WaterFogDensity("Water Fog Density", Range(0, 2)) = 0.1
		_RefractionStrength("Refraction Strength", Range(0, 1)) = 0.25
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			GrabPass { "_WaterBackground" }

			CGPROGRAM
			#pragma surface surf Standard alpha finalcolor:ResetAlpha
			#pragma target 3.0

			#pragma shader_feature _DUAL_GRID

			#include "Flow.cginc"
			#include "LookingThroughWater.cginc"

			…

			struct Input {
				float2 uv_MainTex;
				float4 screenPos;
			};

			…

			void surf(Input IN, inout SurfaceOutputStandard o) {
				…
				fixed4 c = dh.z * dh.z * _Color;
				c.a = _Color.a;
				o.Albedo = c.rgb;
				o.Normal = normalize(float3(-dh.xy, 1));
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;

				o.Emission = ColorBelowWater(IN.screenPos, o.Normal) * (1 - c.a);
			}

			void ResetAlpha(Input IN, SurfaceOutputStandard o, inout fixed4 color) {
				color.a = 1;
			}

			ENDCG
	}
		//FallBack "Diffuse"
}