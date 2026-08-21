import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
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

/** Same mark as apps/web/public/icon.svg, rendered at 512 for crisp downscales. */
const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" fill="none">
  <rect width="512" height="512" rx="112" fill="#0A0B0D"/>
  <circle cx="256" cy="256" r="176" stroke="#5B8DEF" stroke-width="22"/>
  <circle cx="256" cy="256" r="28" fill="#5B8DEF"/>
  <path d="M256 96L286 216L256 256L226 216L256 96Z" fill="#5B8DEF"/>
  <path d="M256 416L226 296L256 256L286 296L256 416Z" fill="#5B8DEF" opacity="0.35"/>
  <path d="M96 256L216 226L256 256L216 286L96 256Z" fill="#5B8DEF" opacity="0.55"/>
  <path d="M416 256L296 286L256 256L296 226L416 256Z" fill="#5B8DEF" opacity="0.55"/>
</svg>`;

function renderPng(size) {
  const resvg = new Resvg(svg, {
    fitTo: { mode: "width", value: size },
  });
  return resvg.render().asPng();
}

function writePng(dir, filename, size) {
  mkdirSync(dir, { recursive: true });
  const path = join(dir, filename);
  writeFileSync(path, renderPng(size));
  console.log(`Wrote ${path} (${size}x${size})`);
}

// Web / PWA
writePng(publicDir, "icon-192.png", 192);
writePng(publicDir, "icon-512.png", 512);
writePng(publicDir, "apple-touch-icon.png", 180);
writePng(publicDir, "favicon.ico", 32);
writePng(publicDir, "favicon-32.png", 32);

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
  writePng(iosIconDir, name, size);
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
  writePng(macIconDir, name, size);
}

console.log("Done — web + iOS + macOS Compass icons.");
