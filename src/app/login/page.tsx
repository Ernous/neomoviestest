import type { Metadata } from 'next';
import LoginClient from './LoginClient';

export const metadata: Metadata = {
  title: 'Вход — Neo Movies',
};

export default function Page() {
  return <LoginClient />;
}
