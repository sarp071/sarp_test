import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import LogoutButton from '@/components/LogoutButton'

export default async function DashboardPage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div>
              <h1 className="text-xl font-bold text-gray-900">Dashboard</h1>
            </div>
            <LogoutButton />
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Welcome to your Dashboard
            </h2>
            <div className="space-y-4">
              <div>
                <p className="text-sm font-medium text-gray-500">Email</p>
                <p className="text-lg text-gray-900">{user.email}</p>
              </div>
              <div>
                <p className="text-sm font-medium text-gray-500">User ID</p>
                <p className="text-sm text-gray-900 font-mono">{user.id}</p>
              </div>
              <div>
                <p className="text-sm font-medium text-gray-500">Last Sign In</p>
                <p className="text-lg text-gray-900">
                  {new Date(user.last_sign_in_at || '').toLocaleString()}
                </p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
