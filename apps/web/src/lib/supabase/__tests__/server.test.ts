import { describe, it, expect, vi } from "vitest";
import { createClient } from "@/lib/supabase/server";

// Mock Next.js headers
vi.mock("next/headers", () => ({
  cookies: vi.fn(),
}));

// Mock Supabase SSR
vi.mock("@supabase/ssr", () => ({
  createServerClient: vi.fn(),
}));

describe("Supabase server client", () => {
  it("should create server client with cookie configuration", async () => {
    const { cookies } = await import("next/headers");
    const { createServerClient } = await import("@supabase/ssr");

    const mockCookieStore = {
      getAll: vi.fn().mockReturnValue([]),
      set: vi.fn(),
      get: vi.fn(),
      has: vi.fn(),
      delete: vi.fn(),
      [Symbol.iterator]: vi.fn(),
      size: 0,
    };

    vi.mocked(cookies).mockResolvedValue(mockCookieStore);

    // Mock environment variables
    process.env.NEXT_PUBLIC_SUPABASE_URL = "https://test.supabase.co";
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "test-anon-key";

    await createClient();

    expect(createServerClient).toHaveBeenCalledWith(
      "https://test.supabase.co",
      "test-anon-key",
      expect.objectContaining({
        cookies: expect.objectContaining({
          getAll: expect.any(Function),
          setAll: expect.any(Function),
        }),
      }),
    );
  });

  it("should handle cookie operations correctly", async () => {
    const { cookies } = await import("next/headers");
    const { createServerClient } = await import("@supabase/ssr");

    const mockCookieStore = {
      getAll: vi.fn().mockReturnValue([{ name: "test", value: "value" }]),
      set: vi.fn(),
      get: vi.fn(),
      has: vi.fn(),
      delete: vi.fn(),
      [Symbol.iterator]: vi.fn(),
      size: 0,
    };

    vi.mocked(cookies).mockResolvedValue(mockCookieStore);

    process.env.NEXT_PUBLIC_SUPABASE_URL = "https://test.supabase.co";
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "test-anon-key";

    // Clear previous mocks
    vi.clearAllMocks();

    await createClient();

    // Get the cookie configuration that was passed to createServerClient
    const cookieConfig = vi.mocked(createServerClient).mock.calls[0]?.[2];

    // Test getAll - the wrapper function should call the mock and return its result
    const cookies_result = cookieConfig?.cookies?.getAll();
    expect(cookies_result).toEqual([{ name: "test", value: "value" }]);
    expect(mockCookieStore.getAll).toHaveBeenCalled();

    // Test setAll - the wrapper function should call set for each cookie
    cookieConfig?.cookies?.setAll?.([
      { name: "new-cookie", value: "new-value", options: {} },
    ]);
    expect(mockCookieStore.set).toHaveBeenCalledWith(
      "new-cookie",
      "new-value",
      {},
    );
  });
});
