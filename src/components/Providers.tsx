'use client';

import { ThemeProvider } from 'styled-components';
import { theme } from '@/styles/theme';
import { SessionProvider } from 'next-auth/react';

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <SessionProvider>
      <ThemeProvider theme={theme}>{children}</ThemeProvider>
    </SessionProvider>
  );
}
