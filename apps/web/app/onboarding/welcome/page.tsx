'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { User } from '@supabase/supabase-js'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@workspace/ui/components/card'
import { Button } from '@workspace/ui/components/button'
import { CheckCircle, ArrowRight } from 'lucide-react'

export default function WelcomePage() {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const router = useRouter()
  const supabase = createClient()

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser()
      setUser(user)
      setLoading(false)
    }

    getUser()
  }, [supabase.auth])

  const handleContinue = () => {
    router.push('/onboarding/profile-setup')
  }

  if (loading) {
    return (
      <div className="flex min-h-svh w-full items-center justify-center">
        <div className="animate-pulse">Loading...</div>
      </div>
    )
  }

  return (
    <div className="min-h-svh bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        <Card className="border-0 shadow-xl">
          <CardHeader className="text-center pb-2">
            <div className="flex justify-center mb-4">
              <div className="rounded-full bg-green-100 p-3">
                <CheckCircle className="h-12 w-12 text-green-600" />
              </div>
            </div>
            <CardTitle className="text-2xl">Welcome to Ovet!</CardTitle>
            <CardDescription className="text-base">
              Hi {user?.email ? user.email.split('@')[0] : 'there'}! Let&apos;s get you set up.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="space-y-4">
              <div className="flex items-start space-x-3">
                <div className="rounded-full bg-blue-100 p-1 mt-1">
                  <div className="w-2 h-2 rounded-full bg-blue-600"></div>
                </div>
                <div>
                  <h3 className="font-medium">Complete your profile</h3>
                  <p className="text-sm text-muted-foreground">
                    Add your name and basic information
                  </p>
                </div>
              </div>

              <div className="flex items-start space-x-3">
                <div className="rounded-full bg-blue-100 p-1 mt-1">
                  <div className="w-2 h-2 rounded-full bg-blue-600"></div>
                </div>
                <div>
                  <h3 className="font-medium">Set your preferences</h3>
                  <p className="text-sm text-muted-foreground">
                    Customize your experience and notifications
                  </p>
                </div>
              </div>

              <div className="flex items-start space-x-3">
                <div className="rounded-full bg-blue-100 p-1 mt-1">
                  <div className="w-2 h-2 rounded-full bg-blue-600"></div>
                </div>
                <div>
                  <h3 className="font-medium">Start using Ovet</h3>
                  <p className="text-sm text-muted-foreground">
                    Access your dashboard and explore features
                  </p>
                </div>
              </div>
            </div>

            <div className="pt-4">
              <Button onClick={handleContinue} className="w-full" size="lg">
                Get Started
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </div>

            <div className="text-center">
              <p className="text-xs text-muted-foreground">
                This will only take a few minutes
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}