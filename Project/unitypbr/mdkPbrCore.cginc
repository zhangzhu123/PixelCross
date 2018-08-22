half3 getPrefilteredEnvMapColor( half3 normal, half3 eyeVector, half rough) {
	half NoV = dot(normal, eyeVector);
	half3 R = normalize(NoV * 2.0 * normal - eyeVector);

	half smoothness = 1.0 - rough;
	half lerpFactor = smoothness * (sqrt(smoothness) + rough);
	// The result is not normalized as we fetch in a cubemap
	R = lerp(normal, R, lerpFactor);

	half2 lodRange = half2(8, 5);

	half lod = sqrt(rough) * lodRange[1];
	
	half3 dir = R;
	lod = min(lodRange[0], lod);

	//half scale = 1.0 - exp2(lod) / _ScreenParams.x;
	//half3 absDir = abs(dir);
	//half M = max(max(absDir.x, absDir.y), absDir.z);
	//if (absDir.x != M) dir.x *= scale;
	//if (absDir.y != M) dir.y *= scale;
	//if (absDir.z != M) dir.z *= scale;
	
	half3 prefilteredColor = fromRGBM(texCUBElod(_IBLSpecular, float4(dir, lod)));
	


	//R = getSpecularDominantDir(normal, R, roughness);
	//vec3 prefilteredColor = prefilterEnvMap(rough, envTransform * R, texSpecular, lodRange, texSize);
	//float factor = clamp(1.0 + dot(R, frontNormal), 0.0, 1.0);
	//prefilteredColor *= factor * factor;
	return prefilteredColor;
}

half3 integrateBRDFApprox(half3 specular, half roughness, half NoV, half f90) {
	half4 c0 = half4(-1, -0.0275, -0.572, 0.022);
	half4 c1 = half4(1, 0.0425, 1.04, -0.04);
	half4 r = roughness * c0 + c1;
	half a004 = min(r.x * r.x, exp2(-9.28 * NoV)) * r.x + r.y;
	half2 AB = half2(-1.04, 1.04) * a004 + r.zw;
	return specular * AB.x + AB.y * f90;
}

half3 computeIBLSpecularUE4(half3 normal, half3 eyeVector, half roughness, half3 specular, half f90) {
	half rough = max(roughness, 0.0);
	half NoV = dot(normal, eyeVector);
	half3 prefilteredColor = getPrefilteredEnvMapColor(normal, eyeVector, rough);
#ifdef TEXTURE_BRDF
	return prefilteredColor * integrateBRDF(specular, rough, NoV, texBRDF, f90);
#else
	return prefilteredColor * integrateBRDFApprox(specular, rough, NoV, f90);
	//return prefilteredColor;
#endif


}