import { describe, it, expect, vi, beforeEach } from 'vitest'
import { createClient } from '@/lib/supabase/client'
import { createBrowserClient } from '@supabase/ssr'

// Mock Supabase SSR
vi.mock('@supabase/ssr', () => ({
  createBrowserClient: vi.fn(),
}))

const mockCreateBrowserClient = vi.mocked(createBrowserClient)

describe('Supabase client', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    // Set up environment variables
    process.env.NEXT_PUBLIC_SUPABASE_URL = 'https://test.supabase.co'
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'test-anon-key'
  })

  it('should create client with correct configuration', () => {
    createClient()
    
    expect(mockCreateBrowserClient).toHaveBeenCalledWith(
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