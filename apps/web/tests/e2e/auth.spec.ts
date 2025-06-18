import { test, expect } from '@playwright/test'

test.describe('Authentication Flow', () => {
  test('should redirect unauthenticated users to login', async ({ page }) => {
    // Try to access protected route
    await page.goto('/protected')
    
    // Should be redirected to login
    await expect(page).toHaveURL(/.*\/auth\/login/)
  })

  test('should display login form', async ({ page }) => {
    await page.goto('/auth/login')
    
    // Check for login form elements
    await expect(page.getByRole('textbox', { name: /email/i })).toBeVisible()
    await expect(page.getByRole('textbox', { name: /password/i })).toBeVisible()
    await expect(page.getByRole('button', { name: /sign in/i })).toBeVisible()
  })

  test('should display signup form', async ({ page }) => {
    await page.goto('/auth/signup')
    
    // Check for signup form elements
    await expect(page.getByRole('textbox', { name: /email/i })).toBeVisible()
    await expect(page.getByRole('textbox', { name: /password/i })).toBeVisible()
    await expect(page.getByRole('button', { name: /sign up/i })).toBeVisible()
  })

  test('should navigate between auth forms', async ({ page }) => {
    await page.goto('/auth/login')
    
    // Click link to signup
    await page.getByRole('link', { name: /sign up/i }).click()
    await expect(page).toHaveURL(/.*\/auth\/signup/)
    
    // Click link back to login
    await page.getByRole('link', { name: /sign in/i }).click()
    await expect(page).toHaveURL(/.*\/auth\/login/)
  })

  test('should show forgot password form', async ({ page }) => {
    await page.goto('/auth/forgot-password')
    
    // Check for forgot password form
    await expect(page.getByRole('textbox', { name: /email/i })).toBeVisible()
    await expect(page.getByRole('button', { name: /reset password/i })).toBeVisible()
  })
})