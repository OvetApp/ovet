import { test, expect } from "@playwright/test";

test.describe("Navigation", () => {
  test("should load homepage", async ({ page }) => {
    await page.goto("/");

    // Should redirect to login if not authenticated
    await expect(page).toHaveURL(/.*\/auth\/login/);
  });

  test("should have proper page titles", async ({ page }) => {
    await page.goto("/auth/login");
    await expect(page).toHaveTitle(/login/i);
  });

  test("should handle 404 pages", async ({ page }) => {
    await page.goto("/non-existent-page");

    // Should either redirect to login or show 404
    const url = page.url();
    expect(url).toMatch(/(login|404)/);
  });
});
