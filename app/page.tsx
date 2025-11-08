import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="text-center space-y-8 p-8">
        <h1 className="text-5xl font-bold text-gray-900">
          Welcome to Your App
        </h1>
        <p className="text-xl text-gray-600 max-w-md mx-auto">
          A modern Next.js application with Supabase authentication
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <Link
            href="/login"
            className="px-8 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium"
          >
            Sign In
          </Link>
          <Link
            href="/signup"
            className="px-8 py-3 bg-white text-blue-600 rounded-lg hover:bg-gray-50 transition-colors font-medium border-2 border-blue-600"
          >
            Sign Up
          </Link>
        </div>
      </div>
    </div>
  );
}
