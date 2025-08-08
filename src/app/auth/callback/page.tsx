'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

export default function OAuthCallbackPage() {
  const router = useRouter();

  useEffect(() => {
    const url = new URL(window.location.href);
    const token = url.searchParams.get('token');
    if (token) {
      localStorage.setItem('token', token);
      window.dispatchEvent(new Event('auth-changed'));
      router.replace('/');
    } else {
      router.replace('/login');
    }
  }, [router]);

  return null;
}