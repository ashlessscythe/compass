import { writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { Resvg } from "@resvg/resvg-js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const publicDir = join(__dirname, "../apps/web/public");

const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" fill="none">
  <rect width="512" height="512" rx="112" fill="#0A0B0D"/>
  <circle cx="256" cy="256" r="176" stroke="#5B8DEF" stroke-width="22"/>
  <circle cx="256" cy="256" r="28" fill="#5B8DEF"/>
  <path d="M256 96L286 216L256 256L226 216L256 96Z" fill="#5B8DEF"/>
  <path d="M256 416L226 296L256 256L286 296L256 416Z" fill="#5B8DEF" opacity="0.35"/>
  <path d="M96 256L216 226L256 256L216 286L96 256Z" fill="#5B8DEF" opacity="0.55"/>
  <path d="M416 256L296 286L256 256L296 226L416 256Z" fill="#5B8DEF" opacity="0.55"/>
</svg>`;

function render(size, filename) {
  const resvg = new Resvg(svg, {
    fitTo: { mode: "width", value: size },
  });
  const png = resvg.render().asPng();
  writeFileSync(join(publicDir, filename), png);
  console.log(`Wrote ${filename} (${size}x${size})`);
}

render(192, "icon-192.png");
render(512, "icon-512.png");
render(180, "apple-touch-icon.png");

// Minimal ICO: write 32x32 PNG as favicon.ico fallback (browsers accept PNG in .ico for modern use)
// Also write a 32px PNG named favicon for link tags; we keep favicon.ico as PNG bytes for simplicity.
const fav = new Resvg(svg, { fitTo: { mode: "width", value: 32 } }).render().asPng();
writeFileSync(join(publicDir, "favicon.ico"), fav);
writeFileSync(join(publicDir, "favicon-32.png"), fav);
console.log("Wrote favicon.ico and favicon-32.png");
