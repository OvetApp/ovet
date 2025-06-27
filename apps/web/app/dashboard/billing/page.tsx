'use client'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@workspace/ui/components/card'
import { Button } from '@workspace/ui/components/button'
import { Badge } from '@workspace/ui/components/badge'
import { ArrowLeft, CreditCard, Calendar } from 'lucide-react'
import Link from 'next/link'

export default function BillingPage() {
  return (
    <div className="min-h-svh bg-gray-50 p-6">
      <div className="mx-auto max-w-4xl">
        <div className="mb-8">
          <div className="flex items-center space-x-4">
            <Button asChild variant="outline" size="sm">
              <Link href="/dashboard">
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back to Dashboard
              </Link>
            </Button>
          </div>
          <h1 className="mt-4 text-3xl font-bold text-gray-900">Billing</h1>
          <p className="text-gray-600">Manage your subscription and billing information</p>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center justify-between">
                <span className="flex items-center">
                  <CreditCard className="mr-2 h-5 w-5" />
                  Current Plan
                </span>
                <Badge variant="secondary">Free</Badge>
              </CardTitle>
              <CardDescription>
                Your current subscription plan and usage
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="rounded-lg bg-blue-50 p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="font-medium text-blue-900">Free Plan</h3>
                    <p className="text-sm text-blue-700">
                      Perfect for getting started
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-2xl font-bold text-blue-900">$0</p>
                    <p className="text-sm text-blue-700">per month</p>
                  </div>
                </div>
              </div>

              <div className="space-y-2">
                <h4 className="font-medium">Plan Features:</h4>
                <ul className="list-disc list-inside space-y-1 text-sm text-muted-foreground">
                  <li>Basic authentication</li>
                  <li>Profile management</li>
                  <li>Email support</li>
                </ul>
              </div>

              <div className="pt-4">
                <Button>Upgrade Plan</Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Calendar className="mr-2 h-5 w-5" />
                Billing History
              </CardTitle>
              <CardDescription>
                Your recent billing transactions and invoices
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="text-center py-8">
                <p className="text-muted-foreground">No billing history available</p>
                <p className="text-sm text-muted-foreground mt-1">
                  Upgrade to a paid plan to see your billing history
                </p>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Payment Method</CardTitle>
              <CardDescription>
                Manage your payment methods and billing information
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="text-center py-8">
                <p className="text-muted-foreground">No payment method on file</p>
                <p className="text-sm text-muted-foreground mt-1">
                  Add a payment method to upgrade your plan
                </p>
                <Button variant="outline" className="mt-4">
                  Add Payment Method
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Usage</CardTitle>
              <CardDescription>
                Track your usage and limits
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <div className="flex items-center justify-between text-sm">
                    <span>API Requests</span>
                    <span>0 / 1,000</span>
                  </div>
                  <div className="mt-1 h-2 bg-gray-200 rounded-full">
                    <div className="h-2 bg-blue-600 rounded-full" style={{ width: '0%' }}></div>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between text-sm">
                    <span>Storage</span>
                    <span>0 MB / 100 MB</span>
                  </div>
                  <div className="mt-1 h-2 bg-gray-200 rounded-full">
                    <div className="h-2 bg-green-600 rounded-full" style={{ width: '0%' }}></div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}