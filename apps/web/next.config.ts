import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  output: "standalone",
  serverExternalPackages: ["@prisma/client"],
  transpilePackages: ["@compass/ui", "@compass/branding", "@compass/api"],
  images: {
    formats: ["image/avif", "image/webp"],
  },
  poweredByHeader: false,
};

export default nextConfig;
