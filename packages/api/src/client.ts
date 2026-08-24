import type { WaitlistEntry, WaitlistResponse } from "./types";
import type {
  AppleAuthRequest,
  AuthResponse,
  DevAuthRequest,
  SyncPullResponse,
  SyncPushRequest,
  SyncPushResponse,
  SyncStatusResponse,
} from "./sync";

export interface CompassApiClientOptions {
  baseUrl?: string;
  fetchImpl?: typeof fetch;
  /** Bearer session for sync routes. */
  sessionToken?: string | null;
}

/**
 * Thin API client used by web and mobile.
 * Offline-first apps layer local outbox sync on top of these contracts.
 */
export class CompassApiClient {
  private readonly baseUrl: string;
  private readonly fetchImpl: typeof fetch;
  private sessionToken: string | null;

  constructor(options: CompassApiClientOptions = {}) {
    this.baseUrl = (options.baseUrl ?? "").replace(/\/$/, "");
    this.fetchImpl = options.fetchImpl ?? fetch;
    this.sessionToken = options.sessionToken ?? null;
  }

  setSessionToken(token: string | null): void {
    this.sessionToken = token;
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

  async authApple(body: AppleAuthRequest): Promise<AuthResponse> {
    return this.postJson<AuthResponse>("/api/auth/apple", body);
  }

  async authDev(body: DevAuthRequest): Promise<AuthResponse> {
    return this.postJson<AuthResponse>("/api/auth/dev", body);
  }

  async syncPush(body: SyncPushRequest): Promise<SyncPushResponse> {
    return this.postJson<SyncPushResponse>("/api/sync/push", body, true);
  }

  async syncPull(since: string): Promise<SyncPullResponse> {
    const q = encodeURIComponent(since);
    return this.getJson<SyncPullResponse>(`/api/sync/pull?since=${q}`, true);
  }

  async syncStatus(): Promise<SyncStatusResponse> {
    return this.getJson<SyncStatusResponse>("/api/sync/status", true);
  }

  private authHeaders(json = true): HeadersInit {
    const headers: Record<string, string> = {};
    if (json) {
      headers["Content-Type"] = "application/json";
    }
    if (this.sessionToken) {
      headers.Authorization = `Bearer ${this.sessionToken}`;
    }
    return headers;
  }

  private async postJson<T>(
    path: string,
    body: unknown,
    authed = false,
  ): Promise<T> {
    const response = await this.fetchImpl(`${this.baseUrl}${path}`, {
      method: "POST",
      headers: this.authHeaders(true),
      body: JSON.stringify(body),
    });
    if (authed && response.status === 401) {
      throw new Error("Sync session expired");
    }
    return (await response.json()) as T;
  }

  private async getJson<T>(path: string, authed = false): Promise<T> {
    const response = await this.fetchImpl(`${this.baseUrl}${path}`, {
      method: "GET",
      headers: this.authHeaders(false),
    });
    if (authed && response.status === 401) {
      throw new Error("Sync session expired");
    }
    return (await response.json()) as T;
  }
}
