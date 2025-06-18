import { describe, it, expect, vi } from 'vitest'
import { NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'

// Mock Next.js
vi.mock('next/server', async () => {
  const actual = await vi.importActual('next/server')
  return {
    ...actual,
    NextResponse: {
      next: vi.fn(() => ({
        cookies: {
          set: vi.fn(),
          getAll: vi.fn(() => []),
          setAll: vi.fn(),
        },
      })),
      redirect: vi.fn(),
    },
  }
})

// Mock Supabase
vi.mock('@supabase/ssr', () => ({
  createServerClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn(),
    },
  })),
}))

describe('updateSession middleware', () => {
  it('should redirect unauthenticated users to login', async () => {
    const { createServerClient } = await import('@supabase/ssr')
    const { NextResponse } = await import('next/server')
    
    const mockSupabase = {
      auth: {
        getUser: vi.fn().mockResolvedValue({ data: { user: null } }),
      },
    }
    
    vi.mocked(createServerClient).mockReturnValue(mockSupabase as any)
    
    const request = new NextRequest('http://localhost:3000/protected', {
      method: 'GET',
    })
    
    await updateSession(request)
    
    expect(NextResponse.redirect).toHaveBeenCalledWith(
      expect.objectContaining({
        pathname: '/auth/login',
      })
    )
  })

  it('should allow authenticated users to continue', async () => {
    const { createServerClient } = await import('@supabase/ssr')
    const { NextResponse } = await import('next/server')
    
    const mockSupabase = {
      auth: {
        getUser: vi.fn().mockResolvedValue({
          data: { user: { id: 'test-user-id' } },
        }),
      },
    }
    
    vi.mocked(createServerClient).mockReturnValue(mockSupabase as any)
    
    const request = new NextRequest('http://localhost:3000/protected', {
      method: 'GET',
    })
    
    const response = await updateSession(request)
    
    expect(NextResponse.redirect).not.toHaveBeenCalled()
    expect(response).toBeDefined()
  })

  it('should not redirect on auth pages', async () => {
    const { createServerClient } = await import('@supabase/ssr')
    const { NextResponse } = await import('next/server')
    
    const mockSupabase = {
      auth: {
        getUser: vi.fn().mockResolvedValue({ data: { user: null } }),
      },
    }
    
    vi.mocked(createServerClient).mockReturnValue(mockSupabase as any)
    
    const request = new NextRequest('http://localhost:3000/auth/login', {
      method: 'GET',
    })
    
    await updateSession(request)
    
    expect(NextResponse.redirect).not.toHaveBeenCalled()
  })
})