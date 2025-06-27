'use client'

import { useEffect, useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { Loader2 } from 'lucide-react'

export default function AuthCallbackPage() {
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const router = useRouter()
  const searchParams = useSearchParams()
  const supabase = createClient()

  useEffect(() => {
    const handleAuthCallback = async () => {
      try {
        const code = searchParams.get('code')
        
        if (code) {
          const { error } = await supabase.auth.exchangeCodeForSession(code)
          
          if (error) {
            console.error('Auth callback error:', error)
            setError(error.message)
            setTimeout(() => router.push('/auth/error'), 1000)
          } else {
            // Successful authentication, redirect to dashboard or onboarding
            router.push('/onboarding/welcome')
          }
        } else {
          setError('No authorization code found')
          setTimeout(() => router.push('/auth/error'), 1000)
        }
      } catch (err) {
        console.error('Unexpected error during auth callback:', err)
        setError('An unexpected error occurred')
        setTimeout(() => router.push('/auth/error'), 1000)
      } finally {
        setIsLoading(false)
      }
    }

    handleAuthCallback()
  }, [searchParams, router, supabase.auth])

  if (error) {
    return (
      <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
        <div className="flex flex-col items-center space-y-4">
          <p className="text-sm text-red-600">Authentication failed: {error}</p>
          <p className="text-xs text-muted-foreground">Redirecting to error page...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="flex flex-col items-center space-y-4">
        <Loader2 className="h-8 w-8 animate-spin" />
        <p className="text-sm text-muted-foreground">
          {isLoading ? 'Completing sign in...' : 'Redirecting...'}
        </p>
      </div>
    </div>
  )
}