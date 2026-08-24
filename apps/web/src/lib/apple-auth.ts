import { createRemoteJWKSet, jwtVerify } from "jose";

import { env } from "@/lib/env";

const appleJwks = createRemoteJWKSet(
  new URL("https://appleid.apple.com/auth/keys"),
);

/**
 * Verify an Apple identity token. `aud` must match APPLE_CLIENT_ID
 * (Services ID or iOS bundle id used as client id).
 */
export async function verifyAppleIdentityToken(
  identityToken: string,
): Promise<{ sub: string; email?: string }> {
  const audience = env.appleClientId;
  if (!audience) {
    throw new Error("APPLE_CLIENT_ID is not configured");
  }

  const { payload } = await jwtVerify(identityToken, appleJwks, {
    issuer: "https://appleid.apple.com",
    audience,
  });

  const sub = typeof payload.sub === "string" ? payload.sub : null;
  if (!sub) {
    throw new Error("Apple token missing sub");
  }

  return {
    sub,
    email: typeof payload.email === "string" ? payload.email : undefined,
  };
}
