import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { deflateSync } from "node:zlib";
import { Resvg } from "@resvg/resvg-js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, "..");
const publicDir = join(root, "apps/web/public");
const iosIconDir = join(
  root,
  "apps/mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset",
);
const macIconDir = join(
  root,
  "apps/mobile/macos/Runner/Assets.xcassets/AppIcon.appiconset",
);

const BG = { r: 0x0a, g: 0x0b, b: 0x0d };

/** Website mark (rounded) — fine for web/PWA. */
function markSvg({ rounded }) {
  const corner = rounded ? ' rx="112"' : "";
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" fill="none">
  <rect width="512" height="512"${corner} fill="#0A0B0D"/>
  <circle cx="256" cy="256" r="176" stroke="#5B8DEF" stroke-width="22"/>
  <circle cx="256" cy="256" r="28" fill="#5B8DEF"/>
  <path d="M256 96L286 216L256 256L226 216L256 96Z" fill="#5B8DEF"/>
  <path d="M256 416L226 296L256 256L286 296L256 416Z" fill="#5B8DEF" opacity="0.35"/>
  <path d="M96 256L216 226L256 256L216 286L96 256Z" fill="#5B8DEF" opacity="0.55"/>
  <path d="M416 256L296 286L256 256L296 226L416 256Z" fill="#5B8DEF" opacity="0.55"/>
</svg>`;
}

function renderRgba(size, { rounded }) {
  const resvg = new Resvg(markSvg({ rounded }), {
    fitTo: { mode: "width", value: size },
    background: "#0A0B0D",
  });
  const rendered = resvg.render();
  return {
    width: rendered.width,
    height: rendered.height,
    pixels: rendered.pixels,
    pngWithAlpha: rendered.asPng(),
  };
}

/** ASC rejects any alpha channel on the large app icon — emit opaque RGB PNG. */
function encodeOpaqueRgbPng(width, height, rgba) {
  const stride = width * 3 + 1;
  const raw = Buffer.alloc(stride * height);
  for (let y = 0; y < height; y++) {
    const row = y * stride;
    raw[row] = 0; // filter: None
    for (let x = 0; x < width; x++) {
      const i = (y * width + x) * 4;
      const a = rgba[i + 3] / 255;
      const o = row + 1 + x * 3;
      raw[o] = Math.round(rgba[i] * a + BG.r * (1 - a));
      raw[o + 1] = Math.round(rgba[i + 1] * a + BG.g * (1 - a));
      raw[o + 2] = Math.round(rgba[i + 2] * a + BG.b * (1 - a));
    }
  }

  const compressed = deflateSync(raw, { level: 9 });
  const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8; // bit depth
  ihdr[9] = 2; // color type RGB (no alpha)
  ihdr[10] = 0;
  ihdr[11] = 0;
  ihdr[12] = 0;

  return Buffer.concat([
    signature,
    pngChunk("IHDR", ihdr),
    pngChunk("IDAT", compressed),
    pngChunk("IEND", Buffer.alloc(0)),
  ]);
}

function pngChunk(type, data) {
  const typeBuf = Buffer.from(type, "ascii");
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length, 0);
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(
    crc32(Buffer.concat([typeBuf, data])) >>> 0,
    0,
  );
  return Buffer.concat([len, typeBuf, data, crc]);
}

function crc32(buf) {
  let c = ~0;
  for (let i = 0; i < buf.length; i++) {
    c ^= buf[i];
    for (let k = 0; k < 8; k++) {
      c = c & 1 ? (0xedb88320 ^ (c >>> 1)) : c >>> 1;
    }
  }
  return ~c;
}

function writeWebPng(dir, filename, size) {
  mkdirSync(dir, { recursive: true });
  const path = join(dir, filename);
  writeFileSync(path, renderRgba(size, { rounded: true }).pngWithAlpha);
  console.log(`Wrote ${path} (${size}x${size})`);
}

function writeAppIconPng(dir, filename, size) {
  mkdirSync(dir, { recursive: true });
  const { width, height, pixels } = renderRgba(size, { rounded: false });
  const path = join(dir, filename);
  writeFileSync(path, encodeOpaqueRgbPng(width, height, pixels));
  console.log(`Wrote ${path} (${size}x${size}, opaque RGB)`);
}

// Web / PWA
writeWebPng(publicDir, "icon-192.png", 192);
writeWebPng(publicDir, "icon-512.png", 512);
writeWebPng(publicDir, "apple-touch-icon.png", 180);
writeWebPng(publicDir, "favicon.ico", 32);
writeWebPng(publicDir, "favicon-32.png", 32);

// iOS AppIcon.appiconset (filenames match Contents.json)
const iosIcons = [
  ["Icon-App-20x20@1x.png", 20],
  ["Icon-App-20x20@2x.png", 40],
  ["Icon-App-20x20@3x.png", 60],
  ["Icon-App-29x29@1x.png", 29],
  ["Icon-App-29x29@2x.png", 58],
  ["Icon-App-29x29@3x.png", 87],
  ["Icon-App-40x40@1x.png", 40],
  ["Icon-App-40x40@2x.png", 80],
  ["Icon-App-40x40@3x.png", 120],
  ["Icon-App-60x60@2x.png", 120],
  ["Icon-App-60x60@3x.png", 180],
  ["Icon-App-76x76@1x.png", 76],
  ["Icon-App-76x76@2x.png", 152],
  ["Icon-App-83.5x83.5@2x.png", 167],
  ["Icon-App-1024x1024@1x.png", 1024],
];
for (const [name, size] of iosIcons) {
  writeAppIconPng(iosIconDir, name, size);
}

// macOS AppIcon.appiconset
const macIcons = [
  ["app_icon_16.png", 16],
  ["app_icon_32.png", 32],
  ["app_icon_64.png", 64],
  ["app_icon_128.png", 128],
  ["app_icon_256.png", 256],
  ["app_icon_512.png", 512],
  ["app_icon_1024.png", 1024],
];
for (const [name, size] of macIcons) {
  writeAppIconPng(macIconDir, name, size);
}

console.log("Done — web + iOS + macOS Compass icons.");
