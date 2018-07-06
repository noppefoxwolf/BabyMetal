//
//  GrayScale.metal
//  BabyMetal_Example
//
//  Created by Tomoya Hirano on 2018/07/06.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ColorInOut {
  float4 position [[ position ]];
  float2 texCoords;
};

vertex ColorInOut vertexShader(device float4 *position [[ buffer(0) ]],
                               device float2 *texCoords [[ buffer(1) ]],
                               uint    vid      [[ vertex_id ]]) {
  ColorInOut out;
  out.position = position[vid];
  out.texCoords = texCoords[vid];
  return out;
}

fragment float4 grayscale_fragmentShader(ColorInOut in [[ stage_in ]],
                               texture2d<float> texture [[ texture(0) ]]) {
  constexpr sampler colorSampler;
  float4 color = texture.sample(colorSampler, in.texCoords);
  return float4(color.r * 0.3 + color.g * 0.6 + color.b * 0.1);
}
