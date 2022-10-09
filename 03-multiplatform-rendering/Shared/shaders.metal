//
//  shaders.metal
//  Metal Rendering Multiplatform
//
//  Created by Georgi Nikoloff on 03.10.22.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]]) {
    float4 position = vertexIn.position;
    position.y -= 1.0;
    return position;
}

fragment float4 fragment_main() {
    return float4(0.0, 0.0, 1.0, 1.0);
}
