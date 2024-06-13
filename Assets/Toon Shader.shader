Shader "Custom/Toon Shader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Main Texture", 2D) = "white" {}
        [HDR] _AmbientColor("Ambient Color", Color) = (0.4, 0.4, 0.4, 1)
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
                "PassFlags" = "OnlyDirectional"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            // vertex program properties
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            // frag program properties
            float4 _Color;
            float4 _AmbientColor;

            fixed4 frag (v2f i) : SV_Target
            {
                float4 sample = tex2D(_MainTex, i.uv);
                float3 normal = normalize(i.worldNormal);
                float NdotL = dot(_WorldSpaceLightPos0, normal);
                float lightIntensity = step(0, NdotL);
                float4 light = lightIntensity * _LightColor0;

                return _Color * sample * (_AmbientColor + light);
            }
            ENDCG
        }
    }
}
