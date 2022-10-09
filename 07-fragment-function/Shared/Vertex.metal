#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDefs.h"

struct VertexIn {
  float4 position [[attribute(0)]];
  float3 normal [[attribute(1)]];
};

vertex VertexOut vertex_main(
  VertexIn in [[stage_in]],
  constant Uniforms &uniforms [[buffer(UniformsBuffer)]])
{
  float4 position =
    uniforms.projectionMatrix * uniforms.viewMatrix
    * uniforms.modelMatrix * in.position;
  VertexOut out {
    .position = position,
    .normal = in.normal
  };
  return out;
}

constant float3 vertices[6] = {
  float3(-1,  1,  0),    // triangle 1
  float3( 1, -1,  0),
  float3(-1, -1,  0),
  float3(-1,  1,  0),    // triangle 2
  float3( 1,  1,  0),
  float3( 1, -1,  0)};

vertex VertexOut vertex_quad(uint vertexID [[vertex_id]])
{
  float4 position = float4(vertices[vertexID], 1);
  VertexOut out {
    .position = position
  };
  return out;
}

