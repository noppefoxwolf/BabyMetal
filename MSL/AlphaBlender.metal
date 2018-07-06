//
//  AlphaBlender.metal
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

#include <metal_stdlib>
using namespace metal;

struct ColorInOut {
  float4 position [[ position ]];
  float2 texCoords;
};

fragment float4 alphaBlender_fragmentShader(ColorInOut in [[ stage_in ]],
                                            texture2d<float> texture1 [[ texture(0) ]],
                                            texture2d<float> texture2 [[ texture(1) ]]) {
  constexpr sampler colorSampler;
  float4 color1 = texture1.sample(colorSampler, in.texCoords);
  float4 color2 = texture2.sample(colorSampler, in.texCoords);
  
  return float4(mix(color1.rgb, color2.rgb, color2.a), color1.a);
}
