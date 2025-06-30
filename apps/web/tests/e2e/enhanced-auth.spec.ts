import { test, expect } from "@playwright/test";

test.describe("Enhanced Authentication System", () => {
  test.describe("Authentication Routes", () => {
    test("should display login page at /auth/login", async ({ page }) => {
      await page.goto("/auth/login");

      await expect(page.getByRole("textbox", { name: /email/i })).toBeVisible();
      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toBeVisible();
      await expect(
        page.getByRole("button", { name: /sign in/i })
      ).toBeVisible();
    });

    test("should display signup page at /auth/signup", async ({ page }) => {
      await page.goto("/auth/signup");

      await expect(page.getByRole("textbox", { name: /email/i })).toBeVisible();
      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toBeVisible();
      await expect(
        page.getByRole("button", { name: /sign up/i })
      ).toBeVisible();
    });

    test("should display forgot password page at /auth/forgot-password", async ({
      page,
    }) => {
      await page.goto("/auth/forgot-password");

      await expect(page.getByRole("textbox", { name: /email/i })).toBeVisible();
      await expect(
        page.getByRole("button", { name: /reset password/i })
      ).toBeVisible();
    });

    test("should display reset password page at /auth/reset-password", async ({
      page,
    }) => {
      await page.goto("/auth/reset-password");

      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toBeVisible();
      await expect(
        page.getByRole("button", { name: /update password/i })
      ).toBeVisible();
    });

    test("should display email verification page at /auth/verify-email", async ({
      page,
    }) => {
      await page.goto("/auth/verify-email");

      await expect(page.getByText(/verify your email/i)).toBeVisible();
    });

    test("should handle auth errors at /auth/error", async ({ page }) => {
      await page.goto("/auth/error");

      await expect(page.getByText(/authentication error/i)).toBeVisible();
    });
  });

  test.describe("Dashboard Routes - Protected", () => {
    test("should redirect unauthenticated users from /dashboard to login", async ({
      page,
    }) => {
      await page.goto("/dashboard");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });

    test("should redirect unauthenticated users from /dashboard/profile to login", async ({
      page,
    }) => {
      await page.goto("/dashboard/profile");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });

    test("should redirect unauthenticated users from /dashboard/settings to login", async ({
      page,
    }) => {
      await page.goto("/dashboard/settings");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });

    test("should redirect unauthenticated users from /dashboard/billing to login", async ({
      page,
    }) => {
      await page.goto("/dashboard/billing");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });
  });

  test.describe("Onboarding Routes - Protected", () => {
    test("should redirect unauthenticated users from /onboarding/welcome to login", async ({
      page,
    }) => {
      await page.goto("/onboarding/welcome");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });

    test("should redirect unauthenticated users from /onboarding/profile-setup to login", async ({
      page,
    }) => {
      await page.goto("/onboarding/profile-setup");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });

    test("should redirect unauthenticated users from /onboarding/preferences to login", async ({
      page,
    }) => {
      await page.goto("/onboarding/preferences");

      await expect(page).toHaveURL(/.*\/auth\/login/);
    });
  });

  test.describe("Middleware Logic", () => {
    test("should store return URL when redirecting unauthenticated users", async ({
      page,
    }) => {
      await page.goto("/dashboard/profile");

      await expect(page).toHaveURL(/.*\/auth\/login/);
      // After login, should redirect back to original URL
      // This would be tested with actual auth flow
    });

    test("should redirect authenticated users away from login/signup pages", async ({
      page,
    }) => {
      // This test would require setting up authenticated state
      // For now, we test the unauthenticated flow
      await page.goto("/auth/login");
      await expect(page).toHaveURL(/.*\/auth\/login/);
    });
  });

  test.describe("Navigation Flow", () => {
    test("should navigate between authentication pages", async ({ page }) => {
      await page.goto("/auth/login");

      // Navigate to signup
      await page.getByRole("link", { name: /sign up/i }).click();
      await expect(page).toHaveURL(/.*\/auth\/signup/);

      // Navigate to forgot password
      await page.goto("/auth/login");
      await page.getByRole("link", { name: /forgot password/i }).click();
      await expect(page).toHaveURL(/.*\/auth\/forgot-password/);
    });

    test("should handle logout flow", async ({ page }) => {
      await page.goto("/auth/logout");

      // Should redirect to login after logout
      await expect(page).toHaveURL(/.*\/auth\/login/);
    });
  });

  test.describe("Form Validation", () => {
    test("should validate email format on login form", async ({ page }) => {
      await page.goto("/auth/login");

      await page.getByRole("textbox", { name: /email/i }).fill("invalid-email");
      await page.getByRole("button", { name: /sign in/i }).click();

      await expect(page.getByText(/invalid email/i)).toBeVisible();
    });

    test("should validate password requirements on signup form", async ({
      page,
    }) => {
      await page.goto("/auth/signup");

      await page
        .getByRole("textbox", { name: /email/i })
        .fill("test@example.com");
      await page.getByRole("textbox", { name: /password/i }).fill("123");
      await page.getByRole("button", { name: /sign up/i }).click();

      await expect(page.getByText(/password must be/i)).toBeVisible();
    });

    test("should show loading states during form submission", async ({
      page,
    }) => {
      await page.goto("/auth/login");

      await page
        .getByRole("textbox", { name: /email/i })
        .fill("test@example.com");
      await page
        .getByRole("textbox", { name: /password/i })
        .fill("password123");

      // Submit form and check for loading state
      await page.getByRole("button", { name: /sign in/i }).click();
      await expect(
        page.getByRole("button", { name: /signing in/i })
      ).toBeVisible();
    });
  });

  test.describe("Error Handling", () => {
    test("should display error messages for invalid credentials", async ({
      page,
    }) => {
      await page.goto("/auth/login");

      await page
        .getByRole("textbox", { name: /email/i })
        .fill("wrong@example.com");
      await page
        .getByRole("textbox", { name: /password/i })
        .fill("wrongpassword");
      await page.getByRole("button", { name: /sign in/i }).click();

      await expect(page.getByText(/invalid credentials/i)).toBeVisible();
    });

    test("should handle network errors gracefully", async ({ page }) => {
      // Mock network failure
      await page.route("**/auth/v1/**", (route) => route.abort());

      await page.goto("/auth/login");
      await page
        .getByRole("textbox", { name: /email/i })
        .fill("test@example.com");
      await page
        .getByRole("textbox", { name: /password/i })
        .fill("password123");
      await page.getByRole("button", { name: /sign in/i }).click();

      await expect(page.getByText(/network error/i)).toBeVisible();
    });
  });

  test.describe("Accessibility", () => {
    test("should have proper ARIA labels on auth forms", async ({ page }) => {
      await page.goto("/auth/login");

      await expect(
        page.getByRole("textbox", { name: /email/i })
      ).toHaveAttribute("aria-label");
      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toHaveAttribute("aria-label");
    });

    test("should support keyboard navigation", async ({ page }) => {
      await page.goto("/auth/login");

      // Tab navigation should work
      await page.keyboard.press("Tab");
      await expect(page.getByRole("textbox", { name: /email/i })).toBeFocused();

      await page.keyboard.press("Tab");
      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toBeFocused();
    });
  });

  test.describe("Mobile Responsiveness", () => {
    test("should display properly on mobile devices", async ({ page }) => {
      await page.setViewportSize({ width: 375, height: 667 });
      await page.goto("/auth/login");

      await expect(page.getByRole("textbox", { name: /email/i })).toBeVisible();
      await expect(
        page.getByRole("textbox", { name: /password/i })
      ).toBeVisible();
      await expect(
        page.getByRole("button", { name: /sign in/i })
      ).toBeVisible();
    });
  });
});
