'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@workspace/ui/components/card'
import { Button } from '@workspace/ui/components/button'
import { Label } from '@workspace/ui/components/label'
import { Switch } from '@workspace/ui/components/switch'
import { ArrowLeft, Settings, Check } from 'lucide-react'

export default function PreferencesPage() {
  const [emailNotifications, setEmailNotifications] = useState(true)
  const [marketingEmails, setMarketingEmails] = useState(false)
  const [weeklyDigest, setWeeklyDigest] = useState(true)
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  const handleBack = () => {
    router.push('/onboarding/profile-setup')
  }

  const handleComplete = async () => {
    setIsLoading(true)
    
    try {
      // Update user preferences
      const { error } = await supabase.auth.updateUser({
        data: {
          preferences: {
            email_notifications: emailNotifications,
            marketing_emails: marketingEmails,
            weekly_digest: weeklyDigest,
          },
          onboarding_completed: true
        }
      })

      if (error) {
        console.error('Error saving preferences:', error)
        // In a real app, show error toast
      } else {
        // Onboarding complete, redirect to dashboard
        router.push('/dashboard')
      }
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-svh bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        <Card className="border-0 shadow-xl">
          <CardHeader className="text-center">
            <div className="flex justify-center mb-4">
              <div className="rounded-full bg-purple-100 p-3">
                <Settings className="h-12 w-12 text-purple-600" />
              </div>
            </div>
            <CardTitle className="text-2xl">Set Your Preferences</CardTitle>
            <CardDescription>
              Choose how you'd like to stay informed and engaged
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="email-notifications" className="text-base">
                    Email Notifications
                  </Label>
                  <p className="text-sm text-muted-foreground">
                    Important updates and account notifications
                  </p>
                </div>
                <Switch
                  id="email-notifications"
                  checked={emailNotifications}
                  onCheckedChange={setEmailNotifications}
                />
              </div>

              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="weekly-digest" className="text-base">
                    Weekly Digest
                  </Label>
                  <p className="text-sm text-muted-foreground">
                    Summary of your activity and insights
                  </p>
                </div>
                <Switch
                  id="weekly-digest"
                  checked={weeklyDigest}
                  onCheckedChange={setWeeklyDigest}
                />
              </div>

              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label htmlFor="marketing-emails" className="text-base">
                    Product Updates
                  </Label>
                  <p className="text-sm text-muted-foreground">
                    News about new features and improvements
                  </p>
                </div>
                <Switch
                  id="marketing-emails"
                  checked={marketingEmails}
                  onCheckedChange={setMarketingEmails}
                />
              </div>
            </div>

            <div className="bg-blue-50 rounded-lg p-4">
              <p className="text-sm text-blue-800">
                💡 You can always change these preferences later in your account settings.
              </p>
            </div>

            <div className="flex space-x-3 pt-4">
              <Button
                variant="outline"
                onClick={handleBack}
                className="flex-1"
              >
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back
              </Button>
              
              <Button
                onClick={handleComplete}
                disabled={isLoading}
                className="flex-1"
              >
                {isLoading ? (
                  <>
                    <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />
                    Completing...
                  </>
                ) : (
                  <>
                    <Check className="mr-2 h-4 w-4" />
                    Complete Setup
                  </>
                )}
              </Button>
            </div>

            <div className="text-center pt-2">
              <p className="text-xs text-muted-foreground">
                Step 3 of 3
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}