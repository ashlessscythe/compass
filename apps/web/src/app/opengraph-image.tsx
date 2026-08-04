import { ImageResponse } from "next/og";

export const runtime = "edge";
export const alt = "Compass — Know where everything is.";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          height: "100%",
          width: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          background: "#0A0B0D",
          backgroundImage:
            "radial-gradient(ellipse 70% 50% at 50% 0%, rgba(91,141,239,0.35), transparent 60%)",
          color: "#F4F5F7",
          fontFamily: "sans-serif",
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            width: 96,
            height: 96,
            borderRadius: 999,
            border: "2px solid #5B8DEF",
            marginBottom: 32,
          }}
        >
          <div
            style={{
              width: 18,
              height: 18,
              borderRadius: 999,
              background: "#5B8DEF",
            }}
          />
        </div>
        <div style={{ fontSize: 84, fontWeight: 600, letterSpacing: -2 }}>Compass</div>
        <div
          style={{
            marginTop: 16,
            fontSize: 36,
            color: "#9AA3B2",
            letterSpacing: -0.5,
          }}
        >
          Know where everything is.
        </div>
      </div>
    ),
    { ...size },
  );
}
