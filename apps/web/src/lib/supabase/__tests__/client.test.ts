import { describe, it, expect, vi } from 'vitest'
import { createClient } from '@/lib/supabase/client'

// Mock Supabase SSR
vi.mock('@supabase/ssr', () => ({
  createBrowserClient: vi.fn(),
}))

describe('Supabase client', () => {
  it('should create client with correct configuration', async () => {
    const { createBrowserClient } = await import('@supabase/ssr')
    
    // Mock environment variables
    process.env.NEXT_PUBLIC_SUPABASE_URL = 'https://test.supabase.co'
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'test-anon-key'
    
    createClient()
    
    expect(createBrowserClient).toHaveBeenCalledWith(
      'https://test.supabase.co',
      'test-anon-key'
    )
  })

  it('should throw error when environment variables are missing', () => {
    delete process.env.NEXT_PUBLIC_SUPABASE_URL
    delete process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
    
    expect(() => createClient()).toThrow()
  })
})