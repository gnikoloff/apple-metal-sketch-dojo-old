#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main(
                          VertexIn vIn [[stage_in]],
                          constant float &timer [[buffer(11)]])
{
    VertexOut out {
        .position = vIn.position,
        .color = vIn.color
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
  return in.color;
}
