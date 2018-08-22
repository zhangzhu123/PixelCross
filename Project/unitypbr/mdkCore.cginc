half3 fromRGBM(half4 c) {
	return c.rgb * c.a;
}