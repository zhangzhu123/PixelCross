# PROGRESS
### Render Pipeline Research
* custome depth

    >如果自定义阴影贴图，只能修改Unity内置着色器，但是不知道新的render pipeline会不会支持。
    
    >https://answers.unity.com/questions/937941/unity-5-shader-that-writes-into-the-depth-texture.html

* material 

    >Unity无法自动将HDR RGBA32编码成RGBM 8bits，需要手动生成。

    >https://assetstore.unity.com/packages/tools/particles-effects/skycube-hdr-panorama-converting-rendering-tools-shader-library-15528 

    >Unity可以自动生成用于IBL的Specular，Diffuse光照图，但是specular的光照图，没有明显的明亮点（无法得知使用哪种brdf生成），而diffuse的光照图，在mipmap的最后一层。

    >可以自己生成用于Specular的cubemap，用于diffuse的Spherical Harmonic参数。

* sstaa
    
    >可是直接采用Inside的Taa，需要进行性能测试。
    
    >https://docs.unity3d.com/Manual/PostProcessing-Antialiasing.html
    
    >https://github.com/playdeadgames/temporal

* render pipeline use rgbm 
    
    >https://docs.unity3d.com/ScriptReference/TextureImporterSettings-rgbm.html
    
    >https://docs.unity3d.com/ScriptReference/TextureImporterRGBMMode.html

    >unity old forward path，当开启hdr以后，所有buffer使用half类型输出。

    >如果想要自定义render path，可以使用Scriptable Render Pipelines

* postprocess
    
    >老版本后处理叫做，image effect

    >自定义postprocess，使用了Scriptable Render Pipelines

### Start
* Struct Render Frame
    * ~~Forward Render Based RGBM~~
    * Traditional Forward Render
    * ~~RGBM Encode~~
    * IBL Specular With RGBM
    * IBL Diffuse With RGBM
    * Transparent
    * ~~IBL BRDF~~
    * Material UI
    * ~~Postprcess RGBM~~

# FEATURES REFERENCE
### Light Path or Rendering Method or Render Path
* Forward Render

### Render Pipeline
* alpha
* rgbm render pipeline

### Material
* Lambertian diffuse BRDF
* Cook-Torrance microfacet specular BRDF
* Blinn-Phong
* Diamond
* Custom 

### Light
* Directional Light	
* Point Light
* Spot Light
* Hemispherical Light
* Image Based light
    * Diffuse Spherical Harmonics
    * Specular 

### Lighting Effect
* Transparency and Translucency Lighting
* Occlusion Lighting
* Normal Lighting
* Emissive Lighting

### Volumetric Effects
* Fog

### Anti-aliasing
* Fxaa
* Ssaa

### Imaging pipeline or Post-Processing
* Bloom
* Tone Mapping
* Color Balance
* Gain
* Vignette
* Depth Of Field
* Sharpen

### ENV
* Exposure
* Direction

### FX

### Parameter
* PBR
    * Workflow Metal
        * metallic (0-1)
        * roughness (0-1)
    * Workflow Specular
        * specular (rgb)
        * glossiness (0-1)
    * albedo (rgb)        
    * normal 
    * occlusion
    * emissive (rgb)
    * opacity

# FUTURE FEATURES REFERENCE
### Light Path or Rendering Method or Render Path
* Forward Render
* Deferred Render
* Filament Render (suit mobile by google)
* Forward Plus
* Deferred Plus

### Material

### Light

### Lighting Effect

### Volumetric Effects

### Anti-aliasing

### Imaging pipeline or Post-Processing



