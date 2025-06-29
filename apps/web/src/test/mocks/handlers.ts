import { http, HttpResponse } from "msw";

const SUPABASE_URL = "http://localhost:54321";

export const handlers = [
  // Mock Supabase auth endpoints
  http.get(`${SUPABASE_URL}/auth/v1/user`, () => {
    return HttpResponse.json({
      id: "mock-user-id",
      email: "test@example.com",
      user_metadata: {},
      app_metadata: {},
      aud: "authenticated",
      created_at: "2023-01-01T00:00:00.000Z",
    });
  }),

  http.post(`${SUPABASE_URL}/auth/v1/token`, async ({ request }) => {
    const body = await request.json();

    if (body && typeof body === "object" && "grant_type" in body) {
      if (body.grant_type === "password") {
        return HttpResponse.json({
          access_token: "mock-access-token",
          refresh_token: "mock-refresh-token",
          expires_in: 3600,
          token_type: "bearer",
          user: {
            id: "mock-user-id",
            email: "test@example.com",
          },
        });
      }
    }

    return HttpResponse.json({ error: "Invalid credentials" }, { status: 400 });
  }),

  http.post(`${SUPABASE_URL}/auth/v1/signup`, () => {
    return HttpResponse.json({
      user: {
        id: "mock-user-id",
        email: "test@example.com",
        email_confirmed_at: null,
      },
      session: null,
    });
  }),

  http.post(`${SUPABASE_URL}/auth/v1/logout`, () => {
    return HttpResponse.json({}, { status: 204 });
  }),
];
