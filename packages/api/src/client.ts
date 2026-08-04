import type { WaitlistEntry, WaitlistResponse } from "./types";

export interface CompassApiClientOptions {
  baseUrl?: string;
  fetchImpl?: typeof fetch;
}

/**
 * Thin API client used by web and future mobile clients.
 * Offline-first apps will layer local sync on top of these contracts.
 */
export class CompassApiClient {
  private readonly baseUrl: string;
  private readonly fetchImpl: typeof fetch;

  constructor(options: CompassApiClientOptions = {}) {
    this.baseUrl = options.baseUrl ?? "";
    this.fetchImpl = options.fetchImpl ?? fetch;
  }

  async joinWaitlist(
    entry: Pick<WaitlistEntry, "email" | "source">,
  ): Promise<WaitlistResponse> {
    const response = await this.fetchImpl(`${this.baseUrl}/api/waitlist`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(entry),
    });

    if (!response.ok) {
      const fallback: WaitlistResponse = {
        ok: false,
        message: "Unable to join the waitlist right now.",
      };
      try {
        return (await response.json()) as WaitlistResponse;
      } catch {
        return fallback;
      }
    }

    return (await response.json()) as WaitlistResponse;
  }
}
